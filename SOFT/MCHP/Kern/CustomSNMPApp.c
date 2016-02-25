/*********************************************************************
 *
 *  Application to Demo SNMP Server
 *  Support for SNMP module in Microchip TCP/IP Stack
 *   - Implements the SNMP application
 *
 *********************************************************************
 * FileName:        CustomSNMPApp.c
 * Dependencies:    TCP/IP stack
 * Processor:       PIC18, PIC24F, PIC24H, dsPIC30F, dsPIC33F, PIC32
 * Compiler:        Microchip C32 v1.05 or higher
 *                  Microchip C30 v3.12 or higher
 *                  Microchip C18 v3.30 or higher
 *                  HI-TECH PICC-18 PRO 9.63PL2 or higher
 * Company:         Microchip Technology, Inc.
 *
 * Software License Agreement
 *
 * Copyright (C) 2002-2009 Microchip Technology Inc.  All rights
 * reserved.
 *
 * Microchip licenses to you the right to use, modify, copy, and
 * distribute:
 * (i)  the Software when embedded on a Microchip microcontroller or
 *      digital signal controller product ("Device") which is
 *      integrated into Licensee's product; or
 * (ii) ONLY the Software driver source files ENC28J60.c, ENC28J60.h,
 *      ENCX24J600.c and ENCX24J600.h ported to a non-Microchip device
 *      used in conjunction with a Microchip ethernet controller for
 *      the sole purpose of interfacing with the ethernet controller.
 *
 * You should refer to the license agreement accompanying this
 * Software for additional information regarding your rights and
 * obligations.
 *
 * THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
 * WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT
 * LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * MICROCHIP BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF
 * PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
 * BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE
 * THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER
 * SIMILAR COSTS, WHETHER ASSERTED ON THE BASIS OF CONTRACT, TORT
 * (INCLUDING NEGLIGENCE), BREACH OF WARRANTY, OR OTHERWISE.
 *
 *
 * Author               Date      Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * E. Wood              4/26/08   Moved from MainDemo.c
 * Amit Shirbhate       09/24/08  SNMPv2c Support added.
 * Hrisikesh Sahu       04/15/10  SNMPv2 trap format support.
 ********************************************************************/
#define __CUSTOMSNMPAPP_C

#include "TCPIPConfig.h"

#if defined(STACK_USE_SNMP_SERVER)

    #include "TCPIP Stack/TCPIP.h"
    #include "Main.h"
    #include "TCPIP Stack/SNMP.h"
    #include "TCPIP Stack/SNMPv3.h"
    #include "DeviceData.h"
    #include "ParamList.h"
    #include "PAL_pUART.h"

/****************************************************************************
  Section:
    Global Variables
  ***************************************************************************/
/*This Macro is used to provide maximum try for a failure Trap server address  */
    #define MAX_TRY_TO_SEND_TRAP (3)

BYTE gSendTrapFlag                  =   FALSE;                  //global flag to send Trap
BYTE gOIDCorrespondingSnmpMibID     =   ENT_SPA_SIB;
BYTE gGenericTrapNotification       =   ENTERPRISE_SPECIFIC;
BYTE gSpecificTrapNotification      =   SPA_SIB_TRAP_ID;        // Vendor specific trap code

BYTE    gSetTrapSendFlag = FALSE;

/*Initialize trap table with no entries.*/
TRAP_INFO trapInfo = { TRAP_TABLE_SIZE };

static DWORD SNMPGetTimeStamp(void);

// ================================== SPA-SIB EXTENSION =================================
// размер FIFO д.б. кратен степени двойки! если ставить больше 16 м.б проблемы с банками в ОЗУ 
//(размер массива не вмещается в 256 байт = 1 банк), 
// тогда нужно будет править скрипт линкера как это сделано для DeviceData
#define TRAP_BUFF_SIZE  16u 
#define TRAP_BUFF_MASK  (TRAP_BUFF_SIZE - 1)


typedef struct
{
            UINT8    trapSrvIndx;    // Индекс адресата трапа
            SNMP_VAL val1;           // Значение 1
            SNMP_VAL val2;           // Значение 2
      ROM   BYTE*    message;        // Указатель на строку сообщения   
}TRAP_VAR;


static TRAP_VAR TxTrapBuffer[TRAP_BUFF_SIZE];      // FIFO буфер трапов
static volatile BYTE TXHeadPtr = 0;                // Указатель на голову 
static volatile BYTE TXTailPtr = 0;                // Указатель на хвост

static BOOL TxFifoIsFull();
static BOOL TxFifoIsEmpty();

static BOOL TxFifoIsFull()
{
    return(((TXHeadPtr + 1) % TRAP_BUFF_SIZE ) == TXTailPtr);
}

static BOOL TxFifoIsEmpty()
{
    return(TXHeadPtr == TXTailPtr);
}


BOOL SNMPNeedRefreshNetworkSett = FALSE;

// Проверка - надо ли менять сетевые настройки - проверяется в главном цикле постоянно
BOOL SNMPNeedToChangeNetSett()
{
    // Если надо обновить настройки сети и указатели корректны
    if(SNMPNeedRefreshNetworkSett)
    {
        SNMPNeedRefreshNetworkSett = 0;
        return 1;               // Новые настройки есть
    }

    return 0;                   // Новых настроек нет
}   



// ======================================================================================


#if !defined(SNMP_TRAP_DISABLED)
    #if defined(SNMP_STACK_USE_V2_TRAP) || defined(SNMP_V1_V2_TRAP_WITH_SNMPV3)

/***************************************************************************************
 *  
 *                                    ПОСЫЛКА ТРАПОВ
 *  
 *  Производится проверка валидности IP-адресов приемников трапов в 5 ячейках и при валидности
 *  адреса ему отправляется трап функцией SNMPSendSpaSibTrap
 *  
 * @author _ (01.10.2012)
 * 
 * @param val1          - Значение переменной 1, OID = DisplaySpecialsTrapValue0
 * @param val2          - Значение переменной 2, OID = DisplaySpecialsTrapValue1 
 * @param *message      - Указатель на строку, расположенную в ПЗУ: (ROM BYTE*)"Sample str"
 ***************************************************************************************/
void SNMPSendSpaSibTrapAll(UINT32 _val1, UINT32 _val2, ROM UINT8 *_message)
{
if(!(
	(DeviceData.SNMPTrapServer1.v[0]==0)&&
	(DeviceData.SNMPTrapServer1.v[1]==0)&&
	(DeviceData.SNMPTrapServer1.v[2]==0)&&
	(DeviceData.SNMPTrapServer1.v[3]==0)
	))
	{
	SNMPSendSpaSibTrap(0,_val1, _val2, _message );
	}
if(!(
	(DeviceData.SNMPTrapServer2.v[0]==0)&&
	(DeviceData.SNMPTrapServer2.v[1]==0)&&
	(DeviceData.SNMPTrapServer2.v[2]==0)&&
	(DeviceData.SNMPTrapServer2.v[3]==0)
	))
	{
	SNMPSendSpaSibTrap(1,_val1, _val2, _message );	
	}
if(!(
	(DeviceData.SNMPTrapServer3.v[0]==0)&&
	(DeviceData.SNMPTrapServer3.v[1]==0)&&
	(DeviceData.SNMPTrapServer3.v[2]==0)&&
	(DeviceData.SNMPTrapServer3.v[3]==0)
	))
	{
	SNMPSendSpaSibTrap(2,_val1, _val2, _message );	
	}
if(!(
	(DeviceData.SNMPTrapServer4.v[0]==0)&&
	(DeviceData.SNMPTrapServer4.v[1]==0)&&
	(DeviceData.SNMPTrapServer4.v[2]==0)&&
	(DeviceData.SNMPTrapServer4.v[3]==0)
	))
	{
	SNMPSendSpaSibTrap(3,_val1, _val2, _message );	
	}
if(!(
	(DeviceData.SNMPTrapServer5.v[0]==0)&&
	(DeviceData.SNMPTrapServer5.v[1]==0)&&
	(DeviceData.SNMPTrapServer5.v[2]==0)&&
	(DeviceData.SNMPTrapServer5.v[3]==0)
	))
	{
	SNMPSendSpaSibTrap(4,_val1, _val2, _message );	
	}	
}	


/***************************************************************************************
 *  
 *                                    ПОСЫЛКА ТРАПОВ
 *  
 *  Данные складируются в фифо буфер передачи и запускается процесс отправки
 *  
 * @author _ (01.10.2012)
 * 
 * @param remHostId     - ID адресата (номер ячейки, в которой указан IP адрес клиента)
 * @param val1          - Значение переменной 1, OID = DisplaySpecialsTrapValue0
 * @param val2          - Значение переменной 2, OID = DisplaySpecialsTrapValue1 
 * @param *message      - Указатель на строку, расположенную в ПЗУ: (ROM BYTE*)"Sample str"
 ***************************************************************************************/
void SNMPSendSpaSibTrap(UINT8 remHostId, UINT32 val1, UINT32 val2, ROM UINT8 *message)
{
    TRAP_VAR trapVar;
    
    if(message == NULL || ECON2bits.ETHEN == 0)
        return;
    
    trapVar.trapSrvIndx = remHostId;    // Индекс адресата
    trapVar.val1.dword = val1;          // Значение переменной 1
    trapVar.val2.dword = val2;          // Значение переменной 2
    trapVar.message    = message;       // Указатель на текстовую строку с сообщением

    if(TxFifoIsFull())
        TXTailPtr = ((TXTailPtr + 1) & TRAP_BUFF_MASK);

    TxTrapBuffer[TXHeadPtr++] = trapVar;
    TXHeadPtr &= TRAP_BUFF_MASK;
}


/***************************************************************************************
 *  
 *                                 ЗАДАЧА ОТСЫЛКИ ТРАПОВ
 *  
 *      Забирает параметры из буфера и пытается передать адресатам.
 *   Ф-я должна вызываться в главном цикле
 * 
 * @author _ (01.10.2012)
 ***************************************************************************************/
void SNMPSpaSibTrapTask(void)
{
    static BYTE     timeLock = FALSE;
    IP_ADDR         remHostIPAddress,* remHostIpAddrPtr;
    IP_ADDR         remHostTmp;
    SNMP_VAL        val;
    static DWORD    TimerRead;
    static TRAP_VAR trapVar;
    static BYTE     retry = 0;
    
    BYTE tmpMess[60];    // От длины массива зависит длина сообщения в трапе. Не рекомендуется ставить больше 60

    static enum 
    {
        SM_HOME,
        SM_PREPARE,
        SM_NOTIFY_WAIT 
    } smState = SM_PREPARE;


    switch (smState)
    {
        case SM_HOME:
            
            // Если буфер отправки пуст, делать нечего
            if(TxFifoIsEmpty())
                return;
            
             SNMPNotifyInfo.trapIDVar = ENT_SPA_SIB;

            trapVar = TxTrapBuffer[TXTailPtr++];       // Извлекаем из ФИФО
            TXTailPtr &= TRAP_BUFF_MASK;

            // Извлекаем IP адрес
            switch (trapVar.trapSrvIndx)
            {
                case 0: remHostTmp.Val = DeviceData.SNMPTrapServer1.Val; break;
                case 1: remHostTmp.Val = DeviceData.SNMPTrapServer2.Val; break;
                case 2: remHostTmp.Val = DeviceData.SNMPTrapServer3.Val; break;
                case 3: remHostTmp.Val = DeviceData.SNMPTrapServer4.Val; break;
                case 4: remHostTmp.Val = DeviceData.SNMPTrapServer5.Val; break;
                    
                default: return;
            }
           
            // Swap
            remHostIPAddress.v[0] = remHostTmp.v[3];
            remHostIPAddress.v[1] = remHostTmp.v[2];
            remHostIPAddress.v[2] = remHostTmp.v[1];
            remHostIPAddress.v[3] = remHostTmp.v[0]; 
            
            remHostIpAddrPtr = &remHostIPAddress;
           
            gGenericTrapNotification   = ENTERPRISE_SPECIFIC;    // 0x06          
            gSpecificTrapNotification  = SPA_SIB_TRAP_ID;        // 0x03
            gSetTrapSendFlag           = TRUE;                   // Отправить более одной переменной - флаг = TRUE

            smState = SM_HOME;
            
        case SM_PREPARE:

            if (timeLock == (BYTE)FALSE)
            {
                TimerRead = TickGet();  //пошел отсчет таймаута
                timeLock  = TRUE;
            }

            SNMPNotifyPrepare(remHostIpAddrPtr, &AppConfig.readCommunity[0][0],
                              strlen(&AppConfig.readCommunity[0][0]),
                              ENT_SPA_SIB,                                      // Agent ID Var
                              gSpecificTrapNotification,                        // Notification code.
                              SNMPGetTimeStamp());
            smState++;
            break;

        case SM_NOTIFY_WAIT:

            if (SNMPIsNotifyReady(remHostIpAddrPtr, DeviceData.SNMPWritePort))
            {
                
                SNMPNotify(DISPLAY_SPECIAL_STRAP_VALUE_0, trapVar.val1, 0);
                SNMPNotify(DISPLAY_SPECIAL_STRAP_VALUE_1, trapVar.val2, 0);
                
                gSetTrapSendFlag = FALSE; // Если далее будет отправка последней переменной - сбрасываем флаг
                
                // Безопасное копирование строки из ROM в RAM
                if(strlenpgm(trapVar.message) < sizeof(tmpMess))
                    strcpypgm2ram(tmpMess, trapVar.message);
                else
                {
                    memcpypgm2ram((void *)tmpMess, (rom void*)trapVar.message, sizeof(tmpMess) - 1);
                    tmpMess[sizeof(tmpMess) - 1] = '\0';
                }
                
                val.dword = (PTR_BASE)tmpMess;
                SNMPNotify(DISPLAY_SPECIAL_STRAP_MESSAGE, val, 0);  // Отправляем строку
               
                smState = SM_HOME;
                retry = 0;
                timeLock = FALSE;
                UDPDiscard();
                break;
            }
    }   

    // Все попытки вышли
    if (retry == (BYTE)MAX_TRY_TO_SEND_TRAP)
    {
        UDPDiscard();
        retry = 0;
        smState             = SM_HOME;
        timeLock            = FALSE;
        return;
    }

    //Тут ловим таймаут 
    else if((TickGet()-TimerRead)>(TICK_SECOND))
    {
        UDPDiscard();
        retry++; 
        smState         = SM_PREPARE;
        timeLock        = FALSE;
    }
}
    #endif

/*********************************************************************
  Function:
     BYTE SNMPValidateCommunity(BYTE* community)
 
  Summary:          
     Validates community name for access control. 
 
  Description:      
     This function validates the community name for the mib access to NMS.
     The snmp community name received in the request pdu is validated for
     read and write community names. The agent gives an access to the mib
     variables only if the community matches with the predefined values.
     This routine also sets a gloabal flag to send trap if authentication
     failure occurs.
  
  PreCondition:
     SNMPInit is already called.
 
  parameters:
     community - Pointer to community string as sent by NMS.
 
  Returns:          
     This routine returns the community validation result as 
     READ_COMMUNITY or WRITE_COMMUNITY or INVALID_COMMUNITY 
 
  Remarks:
     This is a callback function called by module. User application must 
     implement this function and verify that community matches with 
     predefined value. This validation occurs for each NMS request.
 ********************************************************************/
BYTE SNMPValidateCommunity(BYTE * community)
{
    BYTE i;
    BYTE *ptr;

    /*
    If the community name is encrypted in the request from the Manager,
    agent required to decrypt it to match with the community it is
    configured for. The response from the agent should contain encrypted community 
    name using the same encryption algorithm which Manager used while
    making the request.
    */      

    // Validate that community string is a legal size
    if (strlen((char*)community) <= SNMP_COMMUNITY_MAX_LEN)
    {
        // Search to see if this is a write community.  This is done before 
        // searching read communities so that full read/write access is 
        // granted if a read and write community name happen to be the same.
        for (i = 0; i < SNMP_MAX_COMMUNITY_SUPPORT; i++)
        {
           	ptr = AppConfig.writeCommunity[i];

            if (ptr == NULL)
                continue;
            if (*ptr == 0x00u)
                continue;
            if (strncmp((char*)community, (char*)ptr, SNMP_COMMUNITY_MAX_LEN) == 0)
                return WRITE_COMMUNITY;
        }

        // Did not find in write communities, search read communities
        for (i = 0; i < SNMP_MAX_COMMUNITY_SUPPORT; i++)
        {
            ptr = AppConfig.readCommunity[i];
            if (ptr == NULL)
                continue;
            if (*ptr == 0x00u)
                continue;
            if (strncmp((char*)community, (char*)ptr, SNMP_COMMUNITY_MAX_LEN) == 0)
                return READ_COMMUNITY;
        }
    }

    // Could not find any matching community, set up to send a trap
    gSpecificTrapNotification=VENDOR_TRAP_DEFAULT;
    gGenericTrapNotification=AUTH_FAILURE;
    gSendTrapFlag=TRUE;
    return INVALID_COMMUNITY;

}

/*********************************************************************
  Function:
    BOOL SNMPIsValidSetLen(SNMP_ID var, BYTE len,BYTE index)

  Summary:  
    Validates the set variable data length to data type.
    
  Description:
    This routine is used to validate the dyanmic variable data length
    to the variable data type. It is used when SET request is processed.
    This is a callback function called by module. User application
    must implement this function.
    
  PreCondition:
    ProcessSetVar() is called.
 
  Parameters:  
    var -   Variable id whose value is to be set
    len -   Length value that is to be validated.
    index -   instance of a OID
  Return Values:  
    TRUE  - if given var can be set to given len
    FALSE - if otherwise.
 
  Remarks:
    This function will be called for only dynamic variables that are
    defined as ASCII_STRING and OCTET_STRING (i.e. data length greater
    than 4 bytes)
 ********************************************************************/
BOOL SNMPIsValidSetLen(SNMP_ID var, BYTE len,BYTE index)
{
    switch (var)
    {
        case DISPLAY_DEVICE_LOCATION:
            if ( len < (BYTE)DEV_LOCATION_LEN+1 )
                return TRUE;
            break;
            
        case COMMAND:
            if ( len < (BYTE)COMMAND_LEN+1 )
                return TRUE;
            break;
            
        case DISPLAY_SPECIAL_STRAP_MESSAGE:
            if ( len < (BYTE)SP_TRAP_MESS_LEN+1 )
                return TRUE;
            break;
            
            
        case DISPLAY_SNMP_SETTINGS_READ_COMMUNITY_NAME:
            if ( len < (BYTE)TRAP_COMMUNITY_MAX_LEN+1 )
                return TRUE;
            break;
            


        case DISPLAY_SNMP_SETTINGS_WRITE_COMMUNITY_NAME:
            if ( len < (BYTE)TRAP_COMMUNITY_MAX_LEN+1 )
                return TRUE;
            break;            
    }
    return FALSE;
}

/*********************************************************************
  Function:  
    BOOL SNMPSetVar(SNMP_ID var, SNMP_INDEX index,
                                   BYTE ref, SNMP_VAL val)
 
  Summary:
    This routine Set the mib variable with the requested value.
 
  Description:
    This is a callback function called by module for the snmp
    SET request.User application must modify this function 
    for the new variables address.

  Precondition:
    ProcessVariables() is called.
    
  Parameters:        
    var -   Variable id whose value is to be set

    ref -   Variable reference used to transfer multi-byte data
            0 if first byte is set otherwise nonzero value to indicate
            corresponding byte being set.
            
    val -   Up to 4 byte data value.
            If var data type is BYTE, variable
               value is in val->byte
            If var data type is WORD, variable
               value is in val->word
            If var data type is DWORD, variable
               value is in val->dword.
            If var data type is IP_ADDRESS, COUNTER32,
               or GAUGE32, value is in val->dword
            If var data type is OCTET_STRING, ASCII_STRING
               value is in val->byte; multi-byte transfer
               will be performed to transfer remaining
               bytes of data.
 
  Return Values:  
    TRUE    -   if it is OK to set more byte(s).
    FALSE   -   if otherwise.
 
  Remarks: 
    This function may get called more than once depending on number 
    of bytes in a specific set request for given variable.
    only dynamic read-write variables needs to be handled.
********************************************************************/
BOOL SNMPSetVar(SNMP_ID var, SNMP_INDEX index, BYTE ref, SNMP_VAL val)
{
    APP_CONFIG newAppConfig;
    static BOOL ArrayStartIndexFlag = FALSE;
    
    switch (var)
    {
        case DISPLAY_DEVICE_LOCATION:

            if ( ref ==  SNMP_END_OF_VAR )
            {
                SettingsSave(&SettingsTable);
                return TRUE;
            }   
            
            if ( ref ==  SNMP_START_OF_VAR )
                memset((void*)(DeviceData.DeviceLocation), 0x00, DEV_LOCATION_LEN);

            // Copy given value into local buffer.
            DeviceData.DeviceLocation[ref] = val.byte;
 
            return TRUE;
            
            break;


        case DISPLAY_DEVICE_INFO_RESET_COUNTER:
            DeviceData.DeviceInfoResetCounter = val.word;
            puart_out(4,55,22,val.v[0],val.v[1],0,0);
            return TRUE;
            
        case DIPSLAY_ENERGY_METER_ADDRESS:
            DeviceData.EnergyMeterAddress = val.word;
            puart_out(4,55,19,val.v[0],val.v[1],0,0);
            return TRUE;
            
            
		case DISPLAY_INT_TEMPERATURE_ALARM_1_LEVEL:
	    	DeviceData.intTemperAlarm1Level = val.word;
	    	puart_out(4,55,25,val.v[0],val.v[1],0,0);
	        return TRUE;
					

        case DISPLAY_INT_TEMPERATURE_ALARM_2_LEVEL:
			DeviceData.intTemperAlarm2Level = val.word;
          	puart_out(4,55,26,val.v[0],val.v[1],0,0);
            return TRUE;
			            
        case DISPLAY_INT_TEMPERATURE_ALARM_1_LOGIC:
        	if((val.v[0]==0)||(val.v[0]==1)||(val.v[0]==2))
        		{
	        	DeviceData.intTemperAlarm1Logic = val.v[0];
	        	puart_out(3,55,27,val.v[0],0,0,0);
	        	return TRUE;
	        	}
	        return FALSE;	
 
        case DISPLAY_INT_TEMPERATURE_ALARM_2_LOGIC:
        	if((val.v[0]==0)||(val.v[0]==1)||(val.v[0]==2))
        		{
	        	DeviceData.intTemperAlarm2Logic = val.v[0];
	        	puart_out(3,55,28,val.v[0],0,0,0);
	        	return TRUE;
	        	}
	        return FALSE;           
            
        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.intTemperAlarm1TrapSendAv = val.v[0];
            	puart_out(3,55,29,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 
            
        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.intTemperAlarm1TrapSendNoAv = val.v[0];
            	puart_out(3,55,30,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 

        case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.intTemperAlarm2TrapSendAv = val.v[0];
            	puart_out(3,55,31,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 
        
		case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.intTemperAlarm2TrapSendNoAv = val.v[0];
            	puart_out(3,55,32,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LEVEL:
			DeviceData.extTemperAlarm1Level = val.word;
            puart_out(4,55,50,val.v[0],val.v[1],0,0);
            return TRUE;
			
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LEVEL:
			DeviceData.extTemperAlarm2Level = val.word;
            puart_out(4,55,51,val.v[0],val.v[1],0,0);
            return TRUE;
			
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LOGIC:
        	if((val.v[0]==0)||(val.v[0]==1)||(val.v[0]==2))
        		{
	        	DeviceData.extTemperAlarm1Logic = val.v[0];
	        	puart_out(3,55,52,val.v[0],0,0,0);
	        	return TRUE;
	        	}
	        return FALSE;	
 
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LOGIC:
        	if((val.v[0]==0)||(val.v[0]==1)||(val.v[0]==2))
        		{
	        	DeviceData.extTemperAlarm2Logic = val.v[0];
	        	puart_out(3,55,53,val.v[0],0,0,0);
	        	return TRUE;
	        	}
	        return FALSE;           
            
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.extTemperAlarm1TrapSendAv = val.v[0];
            	puart_out(3,55,54,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 
            
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.extTemperAlarm1TrapSendNoAv = val.v[0];
            	puart_out(3,55,55,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.extTemperAlarm2TrapSendAv = val.v[0];
            	puart_out(3,55,56,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 
        
		case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.extTemperAlarm2TrapSendNoAv = val.v[0];
            	puart_out(3,55,57,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 

        case DISPLAY_HUMIDITY_SENSOR_VALUE:
            DeviceData.HummidityLevel = val.word;
            puart_out(4,55,33,val.v[0],val.v[1],0,0);
            return TRUE;

        case DISPLAY_ALARM_HUMIDITY_LOGIC:
            if((val.v[0]==0)||(val.v[0]==1)||(val.v[0]==2))
        		{
            	DeviceData.HummidityLogic = val.v[0];
            	puart_out(3,55,34,val.v[0],0,0,0);
            	return TRUE;
            	} 
            return FALSE; 

        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_AV:
        	if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.HummidityTrapSendAv = val.v[0];
            	puart_out(3,55,35,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 
        
        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_NO_AV:
            if((val.v[0]==0)||(val.v[0]==1))
        		{
            	DeviceData.HummidityTrapSendNoAv = val.v[0];
            	puart_out(3,55,36,val.v[0],0,0,0);
            	return TRUE;
          		} 
            return FALSE; 















        
        case COMMAND:
            
            if (ref ==  SNMP_END_OF_VAR)
            	{
                if (
                   (DeviceData.Command[0]=='R')&&
                   (DeviceData.Command[1]=='A')&&
                   (DeviceData.Command[2]=='T')&&
                   (DeviceData.Command[3]=='S')
                   )
                	{
                    DeviceData.SNMPTrapServer1.Val=0;
                    DeviceData.SNMPTrapServer2.Val=0;
                    DeviceData.SNMPTrapServer3.Val=0;
                    DeviceData.SNMPTrapServer4.Val=0;
                    DeviceData.SNMPTrapServer5.Val=0;
                    SettingsSave(&SettingsTable);   
                	}
                else if (
                        (DeviceData.Command[0]=='D')&&
                        (DeviceData.Command[1]=='T')&&
                        (DeviceData.Command[2]=='1')&&
                        (DeviceData.Command[3]=='K')
                        )
                	{
                    if (DeviceData.Command[4]=='+')
                    	{
                        if (DeviceData.Command[5]=='+')
                        	{
                            puart_out(3,55,23,3,0,0,0); 
                        	}
                        else
                        	{
                            puart_out(3,55,23,1,0,0,0);
                        	}           
                    	}
                    if (DeviceData.Command[4]=='-')
                    	{
                        if (DeviceData.Command[5]=='-')
                        	{
                            puart_out(3,55,23,4,0,0,0); 
                        	}
                        else
                        	{
                            puart_out(3,55,23,2,0,0,0);
                        	}           
                    	}
                	}
                else if (
                        (DeviceData.Command[0]=='D')&&
                        (DeviceData.Command[1]=='T')&&
                        (DeviceData.Command[2]=='2')&&
                        (DeviceData.Command[3]=='K')
                        )
                	{
                    if (DeviceData.Command[4]=='+')
                    	{
                        if (DeviceData.Command[5]=='+')
                        	{
                            puart_out(3,55,24,3,0,0,0); 
                        	}
                        else
                        	{
                            puart_out(3,55,24,1,0,0,0);
                        	}           
                    	}
                    if (DeviceData.Command[4]=='-')
                    	{
                        if (DeviceData.Command[5]=='-')
                        	{
                            puart_out(3,55,24,4,0,0,0); 
                        	}
                        else
                        	{
                            puart_out(3,55,24,2,0,0,0);
                        	}           
                    	}
                	}
 
                return TRUE;
            }
                
            
            if ( ref ==  SNMP_START_OF_VAR )
                memset((void*)(DeviceData.Command), 0x00, COMMAND_LEN);

            // Copy given value into local buffer.
            DeviceData.Command[ref] = val.byte;
 
            return TRUE;
            
            break;
            
            
        case DISPLAY_IMPULSE_ENERGYMETER:
            DeviceData.ImpulseEnergyMeter = val.dword;
            puart_out(6,55,21,val.v[0],val.v[1],val.v[2],val.v[3]);
            return TRUE;
            
            
        case DISPLAY_IMPULSE_NERGYMETER_IMPULS_PERKWTH:
            DeviceData.ImpEnergyMeterImpulsPerKwth = val.word;
            puart_out(4,55,20,val.v[0],val.v[1],0,0);
            return TRUE;
            
            
        case DISPLAY_ETHERNET_SETTINGS_IPADDRESS:
            memcpy((void*)&newAppConfig, (void*)&AppConfig, sizeof(APP_CONFIG));
            newAppConfig.MyIPAddr.v[0] = val.v[3];
            newAppConfig.MyIPAddr.v[1] = val.v[2];
            newAppConfig.MyIPAddr.v[2] = val.v[1];
            newAppConfig.MyIPAddr.v[3] = val.v[0];
            SaveAppConfig(&newAppConfig);
            SNMPNeedRefreshNetworkSett = TRUE;  // запускаем отложенную смену IP
            return TRUE;
            
        
        case DISPLAY_ETHERNET_SETTINGS_NETMASK:
            DeviceData.NetMask.Val = val.dword;

            AppConfig.MyMask.v[0] = val.v[3];
            AppConfig.MyMask.v[1] = val.v[2];
            AppConfig.MyMask.v[2] = val.v[1];
            AppConfig.MyMask.v[3] = val.v[0];
            SettingsSave(&SettingsTable);
            return TRUE;
            
            
        case DISPLAY_ETHERNET_SETTINGS_DEFGATW:
            DeviceData.DefGatw.Val = val.dword;
            
            AppConfig.MyGateway.v[0] = val.v[3];
            AppConfig.MyGateway.v[1] = val.v[2];
            AppConfig.MyGateway.v[2] = val.v[1];
            AppConfig.MyGateway.v[3] = val.v[0];
            SettingsSave(&SettingsTable);
            return TRUE;
            
            
            
        case DISPLAY_SNMP_SETTINGS_READ_PORT:
            DeviceData.SNMPReadPort = val.word;
            SettingsSave(&SettingsTable);
            SNMPNeedRefreshNetworkSett = TRUE;  // запускаем отложенную смену Порта для чтения
            return TRUE;
            
            
        case DISPLAY_SNMP_SETTINGS_WRITE_PORT:
            DeviceData.SNMPWritePort = val.word;
            SettingsSave(&SettingsTable);
            return TRUE;
            

                       
        //case DISPLAY_SNMP_SETTINGS_COMMUNITY_NAME:
        case DISPLAY_SNMP_SETTINGS_READ_COMMUNITY_NAME:

            if ( ref ==  SNMP_END_OF_VAR )
            {
                if(ArrayStartIndexFlag)
                {
                    ArrayStartIndexFlag = FALSE;
                    SaveAppConfig(&newAppConfig);
                    SNMPNeedRefreshNetworkSett = TRUE;  // запускаем отложенную смену community
                }
                return TRUE;
            }
            
            if ( ref ==  SNMP_START_OF_VAR )
            {
                memcpy((void*)&newAppConfig, (void*)&AppConfig, sizeof(APP_CONFIG));
                memset((void*)(&newAppConfig.readCommunity[0][0]), 0x00, SNMP_COMMUNITY_MAX_LEN + 1);
                ArrayStartIndexFlag = TRUE;
            }
            
            // Copy given value into local buffer.
            newAppConfig.readCommunity[0][ref] = val.byte;
 
            return TRUE;
            
            break;

        case DISPLAY_SNMP_SETTINGS_WRITE_COMMUNITY_NAME:

            if ( ref ==  SNMP_END_OF_VAR )
            {
                if(ArrayStartIndexFlag)
                {
                    ArrayStartIndexFlag = FALSE;
                    SaveAppConfig(&newAppConfig);
                    SNMPNeedRefreshNetworkSett = TRUE;  // запускаем отложенную смену community
                }
                return TRUE;
            }
             
            if ( ref ==  SNMP_START_OF_VAR )
            {
                memcpy((void*)&newAppConfig, (void*)&AppConfig, sizeof(APP_CONFIG));
                memset((void*)(&newAppConfig.writeCommunity[0][0]), 0x00, SNMP_COMMUNITY_MAX_LEN + 1);
                ArrayStartIndexFlag = TRUE;
            }
            
            // Copy given value into local buffer.
            newAppConfig.writeCommunity[0][ref] = val.byte;
 
            return TRUE;
            
            break;

            

            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER1:
            DeviceData.SNMPTrapServer1.Val = val.dword;
            SettingsSave(&SettingsTable);
            return TRUE;

            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER2:
            DeviceData.SNMPTrapServer2.Val = val.dword;
            SettingsSave(&SettingsTable);
            return TRUE;

        
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER3:
            DeviceData.SNMPTrapServer3.Val = val.dword;
            SettingsSave(&SettingsTable);
            return TRUE;
            
            
            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER4:
            DeviceData.SNMPTrapServer4.Val = val.dword;
            SettingsSave(&SettingsTable);
            return TRUE;
            
            
           
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER5:
            DeviceData.SNMPTrapServer5.Val = val.dword;
            SettingsSave(&SettingsTable);
            return TRUE;

            
        case DISPLAY_LOGIN_1_STAT_OF_AV:
            if ((val.word==0)||(val.word==1))
            {
                DeviceData.LogIn1StatOfAv = val.word;
                puart_out(4,55,1,val.v[0],val.v[1],0,0);
                return TRUE;
            }
            else return FALSE;  

        case DISPLAY_LOGIN_2_STAT_OF_AV:
            DeviceData.LogIn2StatOfAv = val.word;
            puart_out(4,55,2,val.v[0],val.v[1],0,0);
            return TRUE;

        case DISPLAY_LOGIN_3_STAT_OF_AV:
            DeviceData.LogIn3StatOfAv = val.word;
            puart_out(4,55,3,val.v[0],val.v[1],0,0);
            return TRUE;            

        case DISPLAY_LOGIN_4_STAT_OF_AV:
            DeviceData.LogIn1StatOfAv = val.word;
            puart_out(4,55,4,val.v[0],val.v[1],0,0);
            return TRUE;
         
        case DISPLAY_LOGIN_5_STAT_OF_AV:
            DeviceData.LogIn1StatOfAv = val.word;
            puart_out(4,55,5,val.v[0],val.v[1],0,0);
            return TRUE;
            

        case DISPLAY_LOGIN_6_STAT_OF_AV:
            DeviceData.LogIn1StatOfAv = val.word;
            puart_out(4,55,6,val.v[0],val.v[1],0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_AV:
            DeviceData.LogIn1TrapSendAv = val.v[0];
            puart_out(3,55,7,val.v[0],0,0,0);
            return TRUE;

        case DISPLAY_LOGIN_2_TRAP_SEND_OF_AV:
            DeviceData.LogIn2TrapSendAv = val.v[0];
            puart_out(3,55,8,val.v[0],0,0,0);
            return TRUE;

        case DISPLAY_LOGIN_3_TRAP_SEND_OF_AV:
            DeviceData.LogIn3TrapSendAv = val.v[0];
            puart_out(3,55,9,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_4_TRAP_SEND_OF_AV:
            DeviceData.LogIn4TrapSendAv = val.v[0];
            puart_out(3,55,10,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_5_TRAP_SEND_OF_AV:
            DeviceData.LogIn5TrapSendAv = val.v[0];
            puart_out(3,55,11,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_6_TRAP_SEND_OF_AV:
            DeviceData.LogIn6TrapSendAv = val.v[0];
            puart_out(3,55,12,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_NO_AV:
            DeviceData.LogIn1TrapSendNoAv = val.v[0];
            puart_out(3,55,13,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_2_TRAP_SEND_OF_NO_AV:
            DeviceData.LogIn2TrapSendNoAv = val.v[0];
            puart_out(3,55,14,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_3_TRAP_SEND_OF_NO_AV:
            DeviceData.LogIn3TrapSendNoAv = val.v[0];
            puart_out(3,55,15,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_4_TRAP_SEND_OF_NO_AV:
            DeviceData.LogIn4TrapSendNoAv = val.v[0];
            puart_out(3,55,16,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_5_TRAP_SEND_OF_NO_AV:
            DeviceData.LogIn5TrapSendNoAv = val.v[0];
            puart_out(3,55,17,val.v[0],0,0,0);
            return TRUE;
            
        case DISPLAY_LOGIN_6_TRAP_SEND_OF_NO_AV:    
            DeviceData.LogIn6TrapSendNoAv = val.v[0];
            puart_out(3,55,18,val.v[0],0,0,0);
            return TRUE;
            
        }
    return FALSE;
}


/*********************************************************************
  Function:        
    BOOL SNMPGetExactIndex(SNMP_ID var,SNMP_INDEX index)

  Summary:
    To search for exact index node in case of a Sequence variable.
    
  Description:    
    This is a callback function called by SNMP module.
    SNMP user must implement this function in user application and 
    provide appropriate data when called.  This function will only
    be called for OID variable of type sequence.
    
  PreCondition: 
    None
 
  Parameters:
    var     -   Variable id as per mib.h (input)
    index      -     Index of variable (input)
 
  Return Values:
    TRUE    -    If the exact index value exists for given variable at given
                 index.
    FALSE   -    Otherwise.
 
  Remarks:
      Only sequence index needs to be handled in this function.
 ********************************************************************/
BOOL SNMPGetExactIndex(SNMP_ID var, SNMP_INDEX index)
{
    // У нас нет табличных данных 
    return FALSE;
}


/*********************************************************************
  Function:        
    BOOL SNMPGetNextIndex(SNMP_ID var,SNMP_INDEX* index)

  Summary:
    To search for next index node in case of a Sequence variable.
    
  Description:    
    This is a callback function called by SNMP module.
    SNMP user must implement this function in user application and 
    provide appropriate data when called.  This function will only
    be called for OID variable of type sequence.
    
  PreCondition: 
    None
 
  Parameters:
    var     -   Variable id whose value is to be returned
    index   -   Next Index of variable that should be transferred
 
  Return Values:
    TRUE    -    If a next index value exists for given variable at given
                 index and index parameter contains next valid index.
    FALSE   -    Otherwise.
 
  Remarks:
      Only sequence index needs to be handled in this function.
 ********************************************************************/
BOOL SNMPGetNextIndex(SNMP_ID var, SNMP_INDEX* index)
{
    // У нас нет табличных данных
    return FALSE;
}

/*********************************************************************
  Function:
    BOOL SNMPIdRecrdValidation(PDU_INFO * pduPtr,OID_INFO *var,BYTE * oidValuePtr,BYTE oidLen)
                                   
  Summary:
    Used to validate the support of Var ID for A perticular SNMP Version.

  Description:
    This is a callback function called by SNMP module. SNMP user must 
    implement this function as per SNMP version. One need to add the new SNMP
    MIB IDs hereas per SNMP version.
    e.g - SYS_UP_TIME (250) is common for V1/V2/V3
    ENGINE_ID - is the part of V3, So put the all the SNMPv3 var ids within 
    Macro STACK_USE_SNMPV3_SERVER.      
  PreCondition:
    None
 
  parameters:
    var     -   Variable rec whose record id need to be validated
    oidValuePtr - OID Value
    oidLen - oidValuePtr length
    
  Return Values:
    TRUE    -   If a Var ID exists .
        FALSE   -   Otherwise.
 
  Remarks:
    None.
 ********************************************************************/
BOOL SNMPIdRecrdValidation(PDU_INFO * pduPtr,OID_INFO *var,BYTE * oidValuePtr,BYTE oidLen)
{
    int i=0,j=0;
    int len=0;
    BOOL flag=FALSE;
    BYTE size=0;

    if (var == NULL)
        return FALSE;

    if (!var->nodeInfo.Flags.bIsIDPresent)
    {
        if (oidValuePtr == NULL)
            return FALSE;

        for (i=0; i< SNMP_MAX_NON_REC_ID_OID; i++)
        {
            if ((pduPtr->snmpVersion != SNMP_V3) && 
                (gSnmpNonMibRecInfo[i].version == SNMP_V3))
                continue;

            size = strlen(gSnmpNonMibRecInfo[i].oidstr);
            if ( size <= oidLen)
                len = size;
            else
                continue;

            // find the first unmatching byte
            while (len--)
            {
                if (gSnmpNonMibRecInfo[i].oidstr[j] != oidValuePtr[j])
                {
                    flag = FALSE;
                    j=0;
                    break;
                } else
                {
                    flag = TRUE;
                    j++;
                }
            }
            if (flag == TRUE)
            {
                return TRUE;
            }
        }           
        return FALSE;
    }
    switch (var->id)
    {
        case ENT_SPA_SIB:
        case DISPLAY_DEVICE_SERIAL:
        case DISPLAY_DEVICE_LOCATION:
        case DISPLAY_DEVICE_INFO_RESET_COUNTER: 
        case DIPSLAY_TOTAL_ENERGY:
        case DIPSLAY_CURRENT_ENERGY:
        case DIPSLAY_ENERGY_METER_ADDRESS: 
 
        case DISPLAY_INT_TEMPERATURE:
        case DISPLAY_INT_TEMPERATURE_ALARM_1_LEVEL:
        case DISPLAY_INT_TEMPERATURE_ALARM_1_LOGIC:
        case DISPLAY_INT_TEMPERATURE_ALARM_2_LEVEL:
        case DISPLAY_INT_TEMPERATURE_ALARM_2_LOGIC:
        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_AV: 
        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
        case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_AV: 
        case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
		case DISPLAY_INT_TEMPERATURE_ALARM_1_STATUS:
		case DISPLAY_INT_TEMPERATURE_ALARM_2_STATUS:
        case DISPLAY_EXT_TEMPERATURE:
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LEVEL:
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LOGIC:
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LEVEL:
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LOGIC:
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_AV: 
        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_AV: 
        case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
		case DISPLAY_EXT_TEMPERATURE_ALARM_1_STATUS:
		case DISPLAY_EXT_TEMPERATURE_ALARM_2_STATUS:  
        case DISPLAY_LOGIN_1:
        case DISPLAY_LOGIN_2:
        case DISPLAY_LOGIN_3:
        case DISPLAY_LOGIN_4:
        case DISPLAY_LOGIN_5:
        case DISPLAY_LOGIN_6:
        case DISPLAY_LOGIN_1_AV:
        case DISPLAY_LOGIN_2_AV:
        case DISPLAY_LOGIN_3_AV:
        case DISPLAY_LOGIN_4_AV:
        case DISPLAY_LOGIN_5_AV:
        case DISPLAY_LOGIN_6_AV:
        case DISPLAY_SPECIAL_STRAP_MESSAGE: 
        case DISPLAY_SPECIAL_STRAP_VALUE_0:     
        case DISPLAY_SPECIAL_STRAP_VALUE_1:         
        case DISPLAY_SPECIAL_STRAP_VALUE_2:     
        case COMMAND:
        case DISPLAY_IMPULSE_ENERGYMETER:           
        case DISPLAY_IMPULSE_NERGYMETER_TOTAL_ENERGY:
        case DISPLAY_IMPULSE_NERGYMETER_IMPULS_PERKWTH:
        case DISPLAY_ETHERNET_SETTINGS_IPADDRESS:   
        case DISPLAY_ETHERNET_SETTINGS_NETMASK: 
        case DISPLAY_ETHERNET_SETTINGS_DEFGATW: 
        case DISPLAY_SNMP_SETTINGS_READ_PORT:       
        case DISPLAY_SNMP_SETTINGS_WRITE_PORT:      
        case DISPLAY_SNMP_SETTINGS_READ_COMMUNITY_NAME:
        case DISPLAY_SNMP_SETTINGS_WRITE_COMMUNITY_NAME:  
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER1:    
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER2:        
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER3:    
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER4:    
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER5:
        case DISPLAY_LOGIN_1_STAT_OF_AV:    
        case DISPLAY_LOGIN_2_STAT_OF_AV:
        case DISPLAY_LOGIN_3_STAT_OF_AV:
        case DISPLAY_LOGIN_4_STAT_OF_AV:
        case DISPLAY_LOGIN_5_STAT_OF_AV:
        case DISPLAY_LOGIN_6_STAT_OF_AV:
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_2_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_3_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_4_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_5_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_6_TRAP_SEND_OF_AV:
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_NO_AV:
        case DISPLAY_LOGIN_2_TRAP_SEND_OF_NO_AV:
        case DISPLAY_LOGIN_3_TRAP_SEND_OF_NO_AV:
        case DISPLAY_LOGIN_4_TRAP_SEND_OF_NO_AV:
        case DISPLAY_LOGIN_5_TRAP_SEND_OF_NO_AV:
        case DISPLAY_LOGIN_6_TRAP_SEND_OF_NO_AV:
        //case DISPLAY_HUMMIDITY:
        case DISPLAY_HUMIDITY_SENSOR_VALUE:
        case DISPLAY_ALARM_HUMIDITY_STATUS:
        case DISPLAY_ALARM_HUMIDITY_LOGIC:
        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_AV:
        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_NO_AV:
        return TRUE;
    }
    return FALSE;
}

/*********************************************************************
  Function:
    BOOL SNMPGetVar(SNMP_ID var, SNMP_INDEX index,BYTE* ref, SNMP_VAL* val)
                                   
  Summary:
    Used to Get/collect OID variable information.

  Description:
    This is a callback function called by SNMP module. SNMP user must 
    implement this function in user application and provide appropriate
    data when called.
    
  PreCondition:
    None
 
  parameters:
    var     -   Variable id whose value is to be returned
    index   -   Index of variable that should be transferred
    ref     -   Variable reference used to transfer
                multi-byte data
                It is always SNMP_START_OF_VAR when very
                first byte is requested.
                Otherwise, use this as a reference to
                keep track of multi-byte transfers.
    val     -   Pointer to up to 4 byte buffer.
                If var data type is BYTE, transfer data
                  in val->byte
                If var data type is WORD, transfer data in
                  val->word
                If var data type is DWORD, transfer data in
                  val->dword
                If var data type is IP_ADDRESS, transfer data
                  in val->v[] or val->dword
                If var data type is COUNTER32, TIME_TICKS or
                  GAUGE32, transfer data in val->dword
                If var data type is ASCII_STRING or OCTET_STRING
                  transfer data in val->byte using multi-byte
                  transfer mechanism.
 
  Return Values:
    TRUE    -   If a value exists for given variable at given index.
    FALSE   -   Otherwise.
 
  Remarks:
    None.
 ********************************************************************/
BOOL SNMPGetVar(SNMP_ID var, SNMP_INDEX index, BYTE* ref, SNMP_VAL* val)
{
    BYTE myRef;

    myRef = *ref;

    switch (var)
    {
        case DISPLAY_DEVICE_SERIAL:
            {
                val->dword = DeviceData.SerialNum;
                return TRUE;
            }    

        case DISPLAY_DEVICE_LOCATION:

            // Если пустая строка
            if ( DeviceData.DeviceLocation[0] == '\0' )
                *ref = SNMP_END_OF_VAR;
            else
            {
                val->byte = DeviceData.DeviceLocation[myRef++];
                
                if ( myRef >= DEV_LOCATION_LEN || DeviceData.DeviceLocation[myRef] == '\0' )
                    *ref = SNMP_END_OF_VAR;
                else
                    *ref = myRef;
            }
            return TRUE;
            
            break;

        case DISPLAY_DEVICE_INFO_RESET_COUNTER:
            val->word = DeviceData.DeviceInfoResetCounter;
            return TRUE;

        case DIPSLAY_TOTAL_ENERGY:
            val->dword = DeviceData.TotalEnergy;
            return TRUE;

        case DIPSLAY_CURRENT_ENERGY:
            val->word = DeviceData.CurrentEnergy;
            return TRUE;

        case DIPSLAY_ENERGY_METER_ADDRESS:
            val->word = DeviceData.EnergyMeterAddress;
            return TRUE;


        case DISPLAY_INT_TEMPERATURE:
			val->word = DeviceData.intTemperature;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_1_LEVEL:
            val->word = DeviceData.intTemperAlarm1Level;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_2_LEVEL:
            val->word = DeviceData.intTemperAlarm2Level;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_1_LOGIC:
            val->word = DeviceData.intTemperAlarm1Logic;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_2_LOGIC:
            val->word = DeviceData.intTemperAlarm2Logic;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_AV:
            val->word = DeviceData.intTemperAlarm1TrapSendAv;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
            val->word = DeviceData.intTemperAlarm1TrapSendNoAv;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_AV:
            val->word = DeviceData.intTemperAlarm2TrapSendAv;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
            val->word = DeviceData.intTemperAlarm2TrapSendNoAv;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_1_STATUS:
            val->word = DeviceData.intTemperAlarm1Status;
            return TRUE;

        case DISPLAY_INT_TEMPERATURE_ALARM_2_STATUS:
            val->word = DeviceData.intTemperAlarm2Status;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE:
			val->word = DeviceData.extTemperature;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LEVEL:
            val->word = DeviceData.extTemperAlarm1Level;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LEVEL:
            val->word = DeviceData.extTemperAlarm2Level;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_LOGIC:
            val->word = DeviceData.extTemperAlarm1Logic;
			 
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_LOGIC:
            val->word = DeviceData.extTemperAlarm2Logic;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_AV:
            val->word = DeviceData.extTemperAlarm1TrapSendAv;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_TRAP_SEND_NO_AV:
            val->word = DeviceData.extTemperAlarm1TrapSendNoAv;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_AV:
            val->word = DeviceData.extTemperAlarm2TrapSendAv;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_TRAP_SEND_NO_AV:
            val->word = DeviceData.extTemperAlarm2TrapSendNoAv;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_1_STATUS:
            val->word = DeviceData.extTemperAlarm1Status;
            return TRUE;

        case DISPLAY_EXT_TEMPERATURE_ALARM_2_STATUS:
            val->word = DeviceData.extTemperAlarm2Status;
            return TRUE;


        case DISPLAY_HUMIDITY_SENSOR_VALUE:
        val->word = DeviceData.Hummidity;
            return TRUE;
        
        case DISPLAY_ALARM_HUMIDITY_LEVEL:
        val->word = DeviceData.HummidityLevel;
            return TRUE;    
                    
        case DISPLAY_ALARM_HUMIDITY_LOGIC:
            val->byte = DeviceData.HummidityLogic;
           	return TRUE;
           	
        case DISPLAY_ALARM_HUMIDITY_STATUS:
        	val->byte = DeviceData.HummidityStatus;
            return TRUE;

        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_AV:
        	val->byte = DeviceData.HummidityTrapSendAv;
            return TRUE;
        
        case DISPLAY_ALARM_HUMIDITY_TRAP_SEND_NO_AV:
			val->byte = DeviceData.HummidityTrapSendNoAv;
            return TRUE; 
            
        case DISPLAY_LOGIN_1:
        
            val->word = DeviceData.LogIn1;
            return TRUE;
            
            
        case DISPLAY_LOGIN_2:
            val->word = DeviceData.LogIn2;
            return TRUE;
            
            
        case DISPLAY_LOGIN_3:
            val->word = DeviceData.LogIn3;
            return TRUE;
            
            
        case DISPLAY_LOGIN_4:
            val->word = DeviceData.LogIn4;
            return TRUE;

        case DISPLAY_LOGIN_5:
            val->word = DeviceData.LogIn5;
            return TRUE;
            
            
        case DISPLAY_LOGIN_6:
            val->word = DeviceData.LogIn6;
            return TRUE;

        case DISPLAY_LOGIN_1_AV:
        	//	DeviceData.LogIn1Av=33;
            val->word = DeviceData.LogIn1Av;
            return TRUE;
            
            
        case DISPLAY_LOGIN_2_AV:
            val->word = DeviceData.LogIn2Av;
            return TRUE;
            
            
        case DISPLAY_LOGIN_3_AV:
            val->word = DeviceData.LogIn3Av;
            return TRUE;
            
            
        case DISPLAY_LOGIN_4_AV:
            val->word = DeviceData.LogIn4Av;
            return TRUE;

        case DISPLAY_LOGIN_5_AV:
            val->word = DeviceData.LogIn5Av;
            return TRUE;
            
            
        case DISPLAY_LOGIN_6_AV:
            val->word = DeviceData.LogIn6Av;
            return TRUE;


        case DISPLAY_SPECIAL_STRAP_MESSAGE:
            
            // Если пустая строка
            if ( DeviceData.SpecTrapMess[0] == '\0' )
                *ref = SNMP_END_OF_VAR;
            else
            {
                val->byte = DeviceData.SpecTrapMess[myRef++];

                if ( myRef >= SP_TRAP_MESS_LEN || DeviceData.SpecTrapMess[myRef] == '\0' )
                    *ref = SNMP_END_OF_VAR;
                else
                    *ref = myRef;
            }
            return TRUE;
            
            break;
            
            
        case DISPLAY_SPECIAL_STRAP_VALUE_0:
            val->dword = DeviceData.SpecTrapValue0;
            return TRUE;
            
        case DISPLAY_SPECIAL_STRAP_VALUE_1:
            val->dword = DeviceData.SpecTrapValue1;
            return TRUE;
            
            
        case DISPLAY_SPECIAL_STRAP_VALUE_2:
            val->dword = DeviceData.SpecTrapValue2;
            return TRUE;
            
            
        case COMMAND:
            
            // Если пустая строка
            if ( DeviceData.Command[0] == '\0' )
                *ref = SNMP_END_OF_VAR;
            else
            {
                val->byte = DeviceData.Command[myRef++];

                if ( myRef >= COMMAND_LEN || DeviceData.Command[myRef] == '\0' )
                    *ref = SNMP_END_OF_VAR;
                else
                    *ref = myRef;
            }
            return TRUE;
            
            break;
            
            
        case DISPLAY_IMPULSE_ENERGYMETER:
            val->dword = DeviceData.ImpulseEnergyMeter;
            return TRUE;
            
            
        case DISPLAY_IMPULSE_NERGYMETER_TOTAL_ENERGY:
            val->dword = DeviceData.ImpEnergyMeterTotal;
            return TRUE;
            
            
        case DISPLAY_IMPULSE_NERGYMETER_IMPULS_PERKWTH:
            val->dword = DeviceData.ImpEnergyMeterImpulsPerKwth;
            return TRUE;
            
            
        case DISPLAY_ETHERNET_SETTINGS_IPADDRESS:
            val->dword = DeviceData.IPAddress.Val;
            return TRUE;
            
            
        case DISPLAY_ETHERNET_SETTINGS_NETMASK:
            val->dword = DeviceData.NetMask.Val;
            return TRUE;    

        
        case DISPLAY_ETHERNET_SETTINGS_DEFGATW:
            val->dword = DeviceData.DefGatw.Val;
            return TRUE;
            
        
        case DISPLAY_SNMP_SETTINGS_READ_PORT:
            val->dword = DeviceData.SNMPReadPort;
            return TRUE;
            
            
        case DISPLAY_SNMP_SETTINGS_WRITE_PORT:
            val->dword = DeviceData.SNMPWritePort;
            return TRUE;
            
            
        case DISPLAY_SNMP_SETTINGS_READ_COMMUNITY_NAME:
            
            // Если пустая строка
            if ( AppConfig.readCommunity[0][0] == '\0' )
                *ref = SNMP_END_OF_VAR;
            else
            {
                val->byte = AppConfig.readCommunity[0][myRef++];

                if ( myRef >= SNMP_COMMUNITY_MAX_LEN || AppConfig.readCommunity[0][myRef] == '\0' )
                    *ref = SNMP_END_OF_VAR;
                else
                    *ref = myRef;
            }
            return TRUE;
            
            break;


        case DISPLAY_SNMP_SETTINGS_WRITE_COMMUNITY_NAME:
            
            // Если пустая строка
            if ( AppConfig.writeCommunity[0][0] == '\0' )
                *ref = SNMP_END_OF_VAR;
            else
            {
                val->byte = AppConfig.writeCommunity[0][myRef++];

                if ( myRef >= SNMP_COMMUNITY_MAX_LEN || AppConfig.writeCommunity[0][myRef] == '\0' )
                    *ref = SNMP_END_OF_VAR;
                else
                    *ref = myRef;
            }
            return TRUE;
            
            break;
            
                        
            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER1:
            val->dword = DeviceData.SNMPTrapServer1.Val;
            return TRUE;
            
            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER2:
            val->dword = DeviceData.SNMPTrapServer2.Val;
            return TRUE;    
            
            
            
        case DISPLAY_SNMP_SETTINGS_TRAP_SERVER3:
            val->dword = DeviceData.SNMPTrapServer3.Val;
            return TRUE;
            
            
            
     	case DISPLAY_SNMP_SETTINGS_TRAP_SERVER4:
            val->dword = DeviceData.SNMPTrapServer4.Val;
            return TRUE;
            
                  
       	case DISPLAY_SNMP_SETTINGS_TRAP_SERVER5:
            val->dword = DeviceData.SNMPTrapServer5.Val;
            return TRUE; 
            


        case DISPLAY_LOGIN_1_STAT_OF_AV:
         	val->word = DeviceData.LogIn1StatOfAv;
            return TRUE;        

        case DISPLAY_LOGIN_2_STAT_OF_AV:
            val->word = DeviceData.LogIn2StatOfAv;
            return TRUE;        

        case DISPLAY_LOGIN_3_STAT_OF_AV:
            val->word = DeviceData.LogIn3StatOfAv;
            return TRUE;        

        case DISPLAY_LOGIN_4_STAT_OF_AV:
            val->word = DeviceData.LogIn4StatOfAv;
            return TRUE;        

        case DISPLAY_LOGIN_5_STAT_OF_AV:
            val->word = DeviceData.LogIn5StatOfAv;
            return TRUE;        

        case DISPLAY_LOGIN_6_STAT_OF_AV:
            val->word = DeviceData.LogIn6StatOfAv;
            return TRUE;        

        //Включенность-выключенность отсылки трапов по возникновению аварий логических входов            
            
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn1TrapSendAv;
            return TRUE;

        case DISPLAY_LOGIN_2_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn2TrapSendAv;
            return TRUE;

        case DISPLAY_LOGIN_3_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn3TrapSendAv;
            return TRUE;

        case DISPLAY_LOGIN_4_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn4TrapSendAv;
            return TRUE;

        case DISPLAY_LOGIN_5_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn5TrapSendAv;
            return TRUE;

        case DISPLAY_LOGIN_6_TRAP_SEND_OF_AV:
            val->word = DeviceData.LogIn6TrapSendAv;
            return TRUE;
            
        //Включенность-выключенность отсылки трапов по снятию аварий логических входов            
            
        case DISPLAY_LOGIN_1_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn1TrapSendNoAv;
            return TRUE;

        case DISPLAY_LOGIN_2_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn2TrapSendNoAv;
            return TRUE;

        case DISPLAY_LOGIN_3_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn3TrapSendNoAv;
            return TRUE;

        case DISPLAY_LOGIN_4_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn4TrapSendNoAv;
            return TRUE;

        case DISPLAY_LOGIN_5_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn5TrapSendNoAv;
            return TRUE;

        case DISPLAY_LOGIN_6_TRAP_SEND_OF_NO_AV:
            val->word = DeviceData.LogIn6TrapSendNoAv;
            return TRUE;
        

        }
    
   
    
    return FALSE;
}


/*********************************************************************
  Function:
    static DWORD SNMPGetTimeStamp(void)
                                   
  Summary:
    Obtains the current Tick value for the SNMP time stamp.

  Description:
    This function retrieves the absolute time measurements for 
    SNMP time stamp.Use TickGet and TickGetDiv64K to collect all 48bits
    of the internal Tick Timer.

  PreCondition:
    None
 
  parameters:
    None
 
  Return Values:
    timeStamp - DWORD timevalue
 
  Remarks:
    None.
 ********************************************************************/
static DWORD SNMPGetTimeStamp(void)
{

    DWORD_VAL dwvHigh, dwvLow;
    DWORD dw;
    DWORD timeStamp;

    //TimeStamp
    // Get all 48 bits of the internal Tick timer
    do
    {
        dwvHigh.Val = TickGetDiv64K();
        dwvLow.Val = TickGet();
    } while (dwvHigh.w[0] != dwvLow.w[1]);
    dwvHigh.Val = dwvHigh.w[1];

    // Find total contribution from lower DWORD
    dw = dwvLow.Val/(DWORD)TICK_SECOND;
    timeStamp = dw*100ul;
    dw = (dwvLow.Val - dw*(DWORD)TICK_SECOND)*100ul;        // Find fractional seconds and convert to 10ms ticks
    timeStamp += (dw+((DWORD)TICK_SECOND/2ul))/(DWORD)TICK_SECOND;

    // Itteratively add in the contribution from upper WORD
    while (dwvHigh.Val >= 0x1000ul)
    {
        timeStamp += (0x100000000000ull*100ull+(TICK_SECOND/2ull))/TICK_SECOND;
        dwvHigh.Val -= 0x1000;
    }   
    while (dwvHigh.Val >= 0x100ul)
    {
        timeStamp += (0x010000000000ull*100ull+(TICK_SECOND/2ull))/TICK_SECOND;
        dwvHigh.Val -= 0x100;
    }   
    while (dwvHigh.Val >= 0x10ul)
    {
        timeStamp += (0x001000000000ull*100ull+(TICK_SECOND/2ull))/TICK_SECOND;
        dwvHigh.Val -= 0x10;
    }   
    while (dwvHigh.Val)
    {
        timeStamp += (0x000100000000ull*100ull+(TICK_SECOND/2ull))/TICK_SECOND;
        dwvHigh.Val--;
    }

    return timeStamp;
}

#endif  //#if defined(STACK_USE_SNMP_SERVER)
