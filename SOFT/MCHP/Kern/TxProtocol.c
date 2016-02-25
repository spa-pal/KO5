#include "TCPIP Stack/TCPIP.h"
#include "TxProtocol.h"
#include "HardwareProfile.h"
#include "UART2TCPCEAPHLAN.h"
#include "UdpSet.h"
#include "Main.h"


//extern  CHEAPLAN_CONFIG CheapLanConfig;         // Здесь все настройки устройства для сохранения в EEPROM
extern  APP_CONFIG AppConfig;
    
BYTE    TxSendBuffer[TX_SEND_BUF_SIZE];


// ===================== ФОРМИРОВАНИЕ И ОТПРАВКА ОТВЕТА НА TX ЗАПРОС =======================

void TxSend(BYTE ID, BYTE *DATA,  BYTE DataLength, UINT8 Interface)           
{
    BYTE i = 0;
    BYTE k = 0;

    TxSendBuffer[i++] = 'T';
    TxSendBuffer[i++] = 'X';
    TxSendBuffer[i++] = (Hex2ASCII(CHEAPLAN_TX_ADDRESS >> 4));      
    TxSendBuffer[i++] = (Hex2ASCII(CHEAPLAN_TX_ADDRESS));               
    TxSendBuffer[i++] = (Hex2ASCII(ID >> 4));       
    TxSendBuffer[i++] = (Hex2ASCII(ID));                

    for (k = 0; k < DataLength; k++)
    {
        TxSendBuffer[i++] = Hex2ASCII(*DATA >> 4);
        TxSendBuffer[i++] = Hex2ASCII(*DATA++);
    } 
     
    TxSendBuffer[i++] = '\r';
    TxSendBuffer[i++] = '\n';


    // Собственно отправка в заданный интерфейс
    switch(Interface)
    {
        //case I_UART: SendDataToUartTx(TxSendBuffer, i); break;
        case I_UDP:  SendDataToUdpTx (TxSendBuffer, i); break;

        default: break;
    }   
}


void TxSendIpAddr(UINT8 Interface)
{
    TxSend(GET_IP_ID, AppConfig.MyIPAddr.v, 4, Interface);
}


void TxSendMask(UINT8 Interface)
{
    TxSend(GET_MASK_ID, AppConfig.MyMask.v, 4, Interface);
}

void TxSendMAC(UINT8 Interface)
{
    TxSend(GET_MAC_ID, AppConfig.MyMACAddr.v, 6, Interface);
}

void TxSendDHCP(UINT8 Interface)
{
    BYTE *dhcp;

    *dhcp = AppConfig.Flags.bIsDHCPEnabled ? 1 : 0; 
    
    TxSend(GET_DHCP_ID, dhcp, 1, Interface);
}

void TxSendIpMaskDHCP(UINT8 Interface)
{
    BYTE tmp[9];

    tmp[0] = AppConfig.MyIPAddr.v[0];
    tmp[1] = AppConfig.MyIPAddr.v[1];
    tmp[2] = AppConfig.MyIPAddr.v[2];
    tmp[3] = AppConfig.MyIPAddr.v[3];
                      
    tmp[4] = AppConfig.MyMask.v[0];
    tmp[5] = AppConfig.MyMask.v[1];
    tmp[6] = AppConfig.MyMask.v[2];
    tmp[7] = AppConfig.MyMask.v[3];

    tmp[8] = AppConfig.Flags.bIsDHCPEnabled ? 1 : 0;
    
    TxSend(GET_IP_MASK_DHCP_ID, tmp, 9, Interface);
}


void TxSendGateway(UINT8 Interface)
{
    TxSend(GET_GATEWAY_ID, AppConfig.MyGateway.v, 4, Interface);
}


// Подготовка данных о настройках Ethernet
void PrepareEthernetInfo(BYTE *Tmp, UINT16 *index)
{
    memcpy((void *)(Tmp + *index), (void *)AppConfig.MyIPAddr.v, 4);            *index +=4;
    memcpy((void *)(Tmp + *index), (void *)AppConfig.MyMask.v, 4);              *index +=4;
    memcpy((void *)(Tmp + *index), (void *)AppConfig.MyGateway.v, 4);           *index +=4;
    memcpy((void *)(Tmp + *index), (void *)AppConfig.PrimaryDNSServer.v, 4);    *index +=4;
    memcpy((void *)(Tmp + *index), (void *)AppConfig.SecondaryDNSServer.v, 4);  *index +=4;
    memcpy((void *)(Tmp + *index), (void *)AppConfig.MyMACAddr.v, 6);           *index +=6;

    Tmp[*index] = AppConfig.Flags.bIsDHCPEnabled;                       *index +=1;
}



void TxSendOK(BYTE ID, UINT8 Interface)
{
    BYTE *OkData;
    
    *OkData = 0;
    TxSend(ID, OkData, 1, Interface);
}


void TxSendFault(BYTE ID, BYTE FaultID, UINT8 Interface)
{
    BYTE FaultData[2];
    
    FaultData[0] = ERROR_ID;
    FaultData[1] = FaultID;

    TxSend(ID, FaultData, 2, Interface);
}

void TxSendFaultParameter(BYTE ID, UINT16 Error, UINT8 Interface)
{
    BYTE FaultData[4];
    
    FaultData[0] = ERROR_ID;
    FaultData[1] = PRE;
    FaultData[2] = Error >> 8;
    FaultData[3] = Error;

    TxSend(ID, FaultData, 4, Interface);
}


//=============================================== УСТАНОВКА ===========================================
BOOL SetIp(TX_STATUS* Stat, UINT8 Interface)
{
    if(Stat->TxDT[0] == 127)                // Если IP начинается со 127
        return FALSE;
    
    if(Stat->TxDT[0] < 1 || Stat->TxDT[0] > 223)    // Если IP начинается с 0 или с 224 и выше
        return FALSE;

    if(Stat->TxDT[3] == 255)                // Если IP заканивается на 255 - мультикаст
        return FALSE;

    TxSendOK(SET_IP_ID, Interface);

    // Если все верно, копируем новый IP
    memcpy((void *)(AppConfig.DefaultIPAddr.v), (void *)(Stat->TxDT), 4);

    AppConfig.MyIPAddr.Val = AppConfig.DefaultIPAddr.Val;
    AppConfig.Flags.bIsDHCPEnabled = 0;
            
    // Сохраняем настройки в EEPROM
    SaveAppConfig(&AppConfig);

    return TRUE;
}



BOOL SetMask(TX_STATUS* Stat)
{
    memcpy((void *)(AppConfig.DefaultMask.v), (void *)(Stat->TxDT), 4);
    AppConfig.MyMask.Val = AppConfig.DefaultMask.Val;

    // Сохраняем настройки в EEPROM
    SaveAppConfig(&AppConfig);
    return TRUE;
}


BOOL SetGateway(TX_STATUS* Stat)
{
    if(Stat->TxDT[0] == 127)                // Если IP начинается со 127
        return FALSE;
    
    if(Stat->TxDT[0] < 1 || Stat->TxDT[0] > 223)    // Если IP начинается с 0 или с 224 и выше
        return FALSE;

    if(Stat->TxDT[3] == 255)                // Если IP заканивается на 255 - мультикаст
        return FALSE;

    // Если все верно, копируем новый IP шлюза
    memcpy((void *)(AppConfig.MyGateway.v), (void *)(Stat->TxDT), 4);

    AppConfig.Flags.bIsDHCPEnabled = 0;
            
    // Сохраняем настройки в EEPROM
    SaveAppConfig(&AppConfig);

    return TRUE;
}



BOOL SetMac(TX_STATUS* Stat)
{
    #if !defined(MAC_I2C_EEPROM)

        memcpy((void *)(AppConfig.MyMACAddr.v), (void *)(Stat->TxDT), 6);
        
        // Сохраняем настройки в EEPROM
        SaveAppConfig(&AppConfig);
    
        return TRUE;

    #endif

    return FALSE;
}




// Подготовка данных о настройках Ethernet
UINT16 CheckAndSetEthernetData(BYTE *Tmp, UINT16 *index)
{
    UINT16 Error = 0;
    APP_CONFIG TempConfig;

    memcpy((void *)TempConfig.MyIPAddr.v,           (void *)(Tmp + *index),  4);    *index +=4;
    memcpy((void *)TempConfig.MyMask.v,             (void *)(Tmp + *index),  4);    *index +=4;
    memcpy((void *)TempConfig.MyGateway.v,          (void *)(Tmp + *index),  4);    *index +=4;

    TempConfig.Flags.bIsDHCPEnabled = Tmp[*index];                                  *index +=1;


    // Проверка на введенный IP
    if(
       TempConfig.MyIPAddr.v[0] == 127 ||   // Если IP начинается со 127
       TempConfig.MyIPAddr.v[0]  < 1   ||   // Если IP начинается с 0 или с 224 и выше
       TempConfig.MyIPAddr.v[0]  > 223 ||
       TempConfig.MyIPAddr.v[3] == 255      // Если IP заканчивается на 255 - мультикаст
       )
        Error |= 0x0001;                    // 0 бит - ошибка установки IP
    

    // Проверка на введенный шлюз
    if(
       TempConfig.MyGateway.v[0] == 127 ||  // Если IP начинается со 127
       TempConfig.MyGateway.v[0]  < 1   ||  // Если IP начинается с 0 или с 224 и выше
       TempConfig.MyGateway.v[0]  > 223 ||
       TempConfig.MyGateway.v[3] == 255     // Если IP заканчивается на 255 - мультикаст
       )
        Error |= 0x0004;                    // 2 бит - ошибка установки Шлюза

    if(Error == 0)
    {
        AppConfig.MyIPAddr.Val          = TempConfig.MyIPAddr.Val;         
        AppConfig.MyMask.Val            = TempConfig.MyMask.Val;           
        AppConfig.MyGateway.Val         = TempConfig.MyGateway.Val;  
    }
    return Error;
}


  



/*
 ****************************************************************************************
 *
 *                              Побайтовая обработка TX пакета
 *
 *      Аргументы:      Stat        - указатель на структуру статусных данных 
 *                                   (хранит текущее состояние обработчика пакета)
 *                      CurrentByte - текущий байт данных из буфера приемника
 *                      TxDT        - указатель на массив для данных ТХ пакета
 *                      MaxLength   - длина массива данных TX пакета
 *
 *      Описание:       Функция байт за байтом обрабатывает ТХ пакет, заполняя
 *                      статусную структуру и массив данных. 
 *
 ****************************************************************************************
*/ 
void TxCommandHandling(TX_STATUS* Stat, UINT8 CurrentByte)
{
    if(CurrentByte != ' ')                                  // Игнорируем пробелы               
    {
        // Нашли заголовок, сбрасываем все что было 
        if(Stat->PreviousByte == 'T' && (CurrentByte == 'X' ||  CurrentByte == 'S'))    
        {
            Stat->TxDtLength= 0;
            Stat->TxCntr    = 0;
            Stat->TxStartID = 1;                // Устанавливаем признак начала пакета
            Stat->TxAD      = 0;
            Stat->TxID      = 0;
            Stat->TxDone    = 0;
        }
        
        // Если где-то после старта обнаружили символы завершения
        else if(Stat->TxStartID && (CurrentByte == '\r' || CurrentByte == '\n')) 
        {
            if( Stat->TxCntr >= 4 )                        // Если как минимум приняты AD и ID
                Stat->TxDtLength = (Stat->TxCntr - 4) / 2; // Определяем к-во байт данных
            else
                Stat->TxDtLength = 0;

            Stat->TxCntr     = 0;        
            Stat->TxStartID  = 0;
            Stat->TxDone     = 1;        // Признак успешного конца пакета
        }
        
        // Если находимся "внутри" ТХ пакета
        else if (Stat->TxStartID)                                   
        {   
            // Если буфер данных ТХ пакета переполнился (не пришли символы завершения)
            if (Stat->TxCntr >= TX_RECEIVE_MAX_DATA_BYTES * 2UL )
            {
                Stat->TxCntr    = 0;    
                Stat->TxStartID = 0;            // Сбрасываем обработку этого пакета
                return;
            }
            
            // Счетчик байт указывает на AD в принимаемом пакете
            if      (Stat->TxCntr == 0)  Stat->TxAD  = ASCII2Hex(CurrentByte) << 4;                     
            else if (Stat->TxCntr == 1)  Stat->TxAD |= ASCII2Hex(CurrentByte);
                        

            // Счетчик байт указывает на ID в принимаемом пакете
            else if(Stat->TxCntr == 2)   Stat->TxID  = ASCII2Hex(CurrentByte) << 4;                                             
            else if(Stat->TxCntr == 3)   Stat->TxID |= ASCII2Hex(CurrentByte);
                                        

            // Счетчик байт указывает на DATA в принимаемом пакете
            else if(!(Stat->TxCntr % 2))
                Stat->TxDT[Stat->TxCntr/2 - 2]  = ASCII2Hex(CurrentByte) << 4;
            else 
                Stat->TxDT[Stat->TxCntr/2 - 2] |= ASCII2Hex(CurrentByte);   

            Stat->TxCntr++;
        }
    }
    // Текущий байт данных в следущем вызове ф-и будет предыдущим
    Stat->PreviousByte = CurrentByte;
}



void TxCommandParse(TX_STATUS* Stat, UINT8 Interface)
{
    UINT16 ErrorParamrter = 0;
    IP_ADDR TempIp;

    if(Stat->TxDone)
    {
        Stat->TxDone = 0;

        if(Stat->TxAD == CHEAPLAN_TX_ADDRESS)
        {
        
            // Если это запрос по UDP то в запросе д.б. IP адрес адресата, то есть наш
            if(Interface == I_UDP)
            {
                // Если количество даных меньше 4 - то есть не может быть в нем IP
                if(Stat->TxDtLength < 4)
                    return;

                memcpy((void*)(TempIp.v),  (void*)(Stat->TxDT), 4);

                if(TempIp.Val != AppConfig.MyIPAddr.Val)
                    return;

                // Смещаем указатель на данные
                memcpy((void*)(Stat->TxDT),  (void*)((Stat->TxDT) + 4), (Stat->TxDtLength - 4) );
                    
                Stat->TxDtLength -= 4;   // Уменьшаем количество данных
            }
            switch(Stat->TxID)
            {
                // GET
                case GET_IP_ID:             TxSendIpAddr(Interface);            break;
                case GET_MASK_ID:           TxSendMask(Interface);              break;
                case GET_MAC_ID:            TxSendMAC(Interface);               break;
                case GET_DHCP_ID:           TxSendDHCP(Interface);              break;
                case GET_IP_MASK_DHCP_ID:   TxSendIpMaskDHCP(Interface);        break;
                case GET_GATEWAY_ID:        TxSendGateway(Interface);           break;
              
                
                //SET
                case SET_IP_ID:
                    if(Stat->TxDtLength == 4)
                    {   
                        if(!SetIp(Stat, Interface)) 
                            TxSendFault(SET_IP_ID, PRE, Interface);
                    }
                    else
                        TxSendFault(SET_IP_ID, DTE, Interface);

                    break;

                case SET_MASK_ID:
                    if(Stat->TxDtLength == 4)
                    {   
                        SetMask(Stat);
                        TxSendOK(SET_MASK_ID, Interface);
                    }
                    else
                        TxSendFault(SET_MASK_ID, DTE, Interface);

                    break;


                case SET_GATEWAY_ID:
                    if(Stat->TxDtLength == 4)
                    {   
                        if(SetGateway(Stat))    TxSendOK(SET_GATEWAY_ID, Interface);
                        else                    TxSendFault(SET_GATEWAY_ID, PRE, Interface);
                    }
                    else
                        TxSendFault(SET_GATEWAY_ID, DTE, Interface);

                    break;


                case SET_MAC_ID:
                    if(Stat->TxDtLength == 6)
                    {   
                        #if defined(MAC_I2C_EEPROM)
                            TxSendFault(SET_MAC_ID, ACE, Interface);
                        #else
                            if(SetMac(Stat)) TxSendOK(SET_MAC_ID, Interface);
                            else             TxSendFault(SET_MAC_ID, PRE, Interface);           
                        #endif                  
                    }
                    else
                        TxSendFault(SET_MAC_ID, DTE, Interface);

                    break;
            }
        }
    }
}

// Преобразование ASCII в HEX
BYTE ASCII2Hex(BYTE Ascii)
{
    Ascii = (Ascii & 0x4F);     
    if(Ascii & 0b01000000)                  
    {
        Ascii++;
        Ascii = Ascii | 0b00001000;
    }

    return (Ascii & 0x0F);              
}

// Преобразование HEX в ASCII
BYTE Hex2ASCII(BYTE Hex)
{
    BYTE Ascii;
    Hex = Hex & 0x0F;
    if(Hex <= 0x09)
        Ascii = (Hex|0x30);

    else
    {
        Hex = Hex - 9;
        Ascii = (Hex|0x40);
    }
    return Ascii;
}

