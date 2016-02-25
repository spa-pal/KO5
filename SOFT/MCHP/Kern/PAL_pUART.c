#include "PAL_pUART.h"
#include "DeviceData.h"

#include "compiler.h"

char            puart_rx_buffer [PUART_RX_BUFFER_SIZE];
char            ptx_buffer      [pTX_BUFFER_SIZE];
signed   short  puart_rx_wr_index,puart_rx_rd_index,puart_rx_counter,puart_rx_wr_index_;
unsigned short  ptx_wr_index,ptx_rd_index,ptx_counter;
char            data_temp,control_temp;
char            puart_data_temp;
char            bPUART_RXIN;
char            PUIB[64];
short 			puart_silent_cnt;
char 			bPUART_STROB_OLD,bPUART_STROB;

//-----------------------------------------------
void puart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5)
{
    char i,t=0;
//char *ptr=&data1;
    char UOB0[16]; 
    UOB0[0]=data0;
    UOB0[1]=data1;
    UOB0[2]=data2;
    UOB0[3]=data3;
    UOB0[4]=data4;
    UOB0[5]=data5;

    for (i=0;i<num;i++)
    {
        t^=UOB0[i];
    }    
    UOB0[num]=num;
    t^=UOB0[num];
    UOB0[num+1]=t;
    UOB0[num+2]=END;

    for (i=0;i<num+3;i++)
    {
        pputchar(UOB0[i]);
    }       
}

//-----------------------------------------------
void uart_out_adr (char *ptr, char len)
{
    char temp11,t,i11;

    t=0;

    for (i11=0;i11<len;i11++)
    {
        temp11=ptr[i11];
        t^=temp11;
        pputchar(temp11);
    }

    temp11=len;
    t^=temp11;
    pputchar(temp11);

    pputchar(t);

    pputchar(0x0a);   
}

//-----------------------------------------------
void pputchar(char c)
{
//while (ptx_counter == pTX_BUFFER_SIZE);
//if (ptx_counter /*|| ((LPC_UART0->LSR & 0x60)==0)*/)
    {
        ptx_buffer[ptx_wr_index]=c;
        if (++ptx_wr_index >= pTX_BUFFER_SIZE) ptx_wr_index=0;
        //++ptx_counter;
    }
//else LPC_UART0->THR=c;
}


#define LED1_TRIS   TRISBbits.TRISB0
#define LED1_PORT   LATBbits.LATB0

//-----------------------------------------------
void puart_tx_drv(void)
{
    static char puart_cnt;
    char temp_tx; 
//if(puart_cnt > 3) puart_cnt=0;
//((ptx_buffer[ptx_rd_index])
//ptx_buffer[0]=0xaa;
//ptx_rd_index=0;
    temp_tx=ptx_buffer[ptx_rd_index];
    if (ptx_rd_index!=ptx_wr_index)
    {
        TRISE&=0xf0;    
        LATE=(LATE&0xf0)|(puart_cnt&0x03)|(((temp_tx>>(puart_cnt*2))&0x03)<<2);

        puart_cnt++;
        if (puart_cnt>=4)
        {
            puart_cnt=0;
            ptx_rd_index++;
            if (ptx_rd_index >= pTX_BUFFER_SIZE) ptx_rd_index=0;
        }
    }



//LED1_TRIS=0;
//LED1_PORT^=1; 
}


//-----------------------------------------------
void puart_rx_drv(void)
{
TRISBbits.TRISB0=1;
TRISBbits.TRISB1=0;
TRISBbits.TRISB2=1;
TRISBbits.TRISB3=1;
if(PORTBbits.RB0==1)
	{
	LATBbits.LATB1=1;
	if(puart_silent_cnt<110)puart_silent_cnt++;
	if(puart_silent_cnt==100)
		{
		//puart_silent_cnt=100;

        
        puart_rx_wr_index=0;
        puart_rx_wr_index_=0;
        puart_data_temp=0;
		}
	bPUART_STROB=1;		
	}	
else
	{
	LATBbits.LATB1=0;
	puart_silent_cnt=0;
	
	bPUART_STROB=0;	
	}
	
//	               TRISBbits.TRISB1=0;
//                LATBbits.LATB1 ^= 1;

if(bPUART_STROB_OLD!=bPUART_STROB)
	{
    char pin_temp;
    

        
    pin_temp     = PORTB&0x0f;
    data_temp    = (pin_temp & 0x0c) >> 2;
    
    //puart_data_temp=0;
    puart_data_temp  |= (data_temp << (puart_rx_wr_index_ * 2));
    
    puart_rx_wr_index_++;
    
    if (puart_rx_wr_index_ == 0x04)
    	{
	    puart_rx_wr_index_=0;


        	
        puart_rx_buffer[puart_rx_wr_index]=puart_data_temp;
        bPUART_RXIN=1;
        puart_rx_wr_index++;
        if (puart_rx_wr_index >= PUART_RX_BUFFER_SIZE)
        	{
            puart_rx_wr_index=0;
         	}
        if (puart_data_temp==0x0a)
            {
	    
            }
        puart_data_temp=0;
        }
    }

bPUART_STROB_OLD=bPUART_STROB;
}


//-----------------------------------------------
void puart_rx_init(void)
{
    TRISB |= 0b00001101;
    TRISB &= 0b00001101;
    INTCON2bits.RBPU=1;
//INTCON2bits.INTEDG0=0;
//INTCONbits.INT0IE=1;
    //INTCON2bits.INTEDG1=0;
    //INTCON3bits.INT1IP=0;
    //INTCON3bits.INT1IE=1;
}

//-----------------------------------------------
void puart_uart_in(void)
{
    signed char temp,i,count;

    if ((puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-1)])==END)
    {
/*  if(puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-1)]==0x0a)
    {

    }*/ 


        temp=puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-3)];
        if (temp<=100)
        {
            if (puart_control_check(puart_index_offset(puart_rx_wr_index,-1)))
            {
                puart_rx_rd_index=puart_index_offset(puart_rx_wr_index,-3-temp);
                //PUIB[0]=puart_rx_rd_index;



                for (i=0;i<temp;i++)
                {
                    PUIB[i]=puart_rx_buffer[puart_index_offset(puart_rx_rd_index,i)];
                } 
                puart_rx_rd_index=puart_rx_wr_index;


                //PUIB[0]=33;
                puart_uart_in_an();


            }
        }
    }
}

//-----------------------------------------------
signed short puart_index_offset (signed short index,signed short offset)
{
    index=index+offset;
    if (index>=PUART_RX_BUFFER_SIZE) index-=PUART_RX_BUFFER_SIZE;
    if (index<0) index+=PUART_RX_BUFFER_SIZE;
    return index;
}

//-----------------------------------------------
char puart_control_check(char index)
{
    signed char i=0,ii=0,iii;

    if (puart_rx_buffer[index]!=END) return 0;

    ii=puart_rx_buffer[puart_index_offset(index,-2)];
    iii=0;
    for (i=0;i<=ii;i++)
    {
        iii^=puart_rx_buffer[puart_index_offset(index,-2-ii+i)];
    }
    if (iii!=puart_rx_buffer[puart_index_offset(index,-1)]) return 0;

    return 1;
}

//-----------------------------------------------
void puart_uart_in_an(void) 
{
    char temp_char,r1;

    //DeviceData.AlarmTemp2Level++;

    //DeviceData.AlarmTemp1Level = PUIB[0];
TRISFbits.TRISF1=0;   
        LATFbits.LATF1 ^= 1;

    if (PUIB[0] == 0x33)
    	{
        DeviceData.LogIn1 = (PUIB[1]>>0)&(0x01);
        DeviceData.LogIn2 = (PUIB[1]>>1)&(0x01);
        DeviceData.LogIn3 = (PUIB[1]>>2)&(0x01);
        DeviceData.LogIn4 = (PUIB[1]>>3)&(0x01);
        DeviceData.LogIn5 = (PUIB[1]>>4)&(0x01);
        DeviceData.LogIn6 = (PUIB[1]>>5)&(0x01);
        DeviceData.LogIn1StatOfAv = (PUIB[2]>>0)&(0x01);
        DeviceData.LogIn2StatOfAv = (PUIB[2]>>1)&(0x01);
        DeviceData.LogIn3StatOfAv = (PUIB[2]>>2)&(0x01);
        DeviceData.LogIn4StatOfAv = (PUIB[2]>>3)&(0x01);
        DeviceData.LogIn5StatOfAv = (PUIB[2]>>4)&(0x01);
        DeviceData.LogIn6StatOfAv = (PUIB[2]>>5)&(0x01);
        DeviceData.LogIn1Av = (PUIB[3]>>0)&(0x01);
        DeviceData.LogIn2Av = (PUIB[3]>>1)&(0x01);
        DeviceData.LogIn3Av = (PUIB[3]>>2)&(0x01);
        DeviceData.LogIn4Av = (PUIB[3]>>3)&(0x01);
        DeviceData.LogIn5Av = (PUIB[3]>>4)&(0x01);
        DeviceData.LogIn6Av = (PUIB[3]>>5)&(0x01);  
        DeviceData.LogIn1TrapSendAv = (PUIB[4]>>0)&(0x01);
        DeviceData.LogIn2TrapSendAv = (PUIB[4]>>1)&(0x01);
        DeviceData.LogIn3TrapSendAv = (PUIB[4]>>2)&(0x01);
        DeviceData.LogIn4TrapSendAv = (PUIB[4]>>3)&(0x01);
        DeviceData.LogIn5TrapSendAv = (PUIB[4]>>4)&(0x01);
        DeviceData.LogIn6TrapSendAv = (PUIB[4]>>5)&(0x01);
        DeviceData.LogIn1TrapSendNoAv = (PUIB[5]>>0)&(0x01);
        DeviceData.LogIn2TrapSendNoAv = (PUIB[5]>>1)&(0x01);
        DeviceData.LogIn3TrapSendNoAv = (PUIB[5]>>2)&(0x01);
        DeviceData.LogIn4TrapSendNoAv = (PUIB[5]>>3)&(0x01);
        DeviceData.LogIn5TrapSendNoAv = (PUIB[5]>>4)&(0x01);
        DeviceData.LogIn6TrapSendNoAv = (PUIB[5]>>5)&(0x01);
        DeviceData.EnergyMeterAddress = (WORD)PUIB[6];
        DeviceData.EnergyMeterAddress+= ((WORD)PUIB[7])<<8;
        DeviceData.TotalEnergy = (UINT32)PUIB[8];
        DeviceData.TotalEnergy+=((DWORD)PUIB[9])<<8;
        DeviceData.TotalEnergy+=((DWORD)PUIB[10])<<16;
        DeviceData.TotalEnergy+=((DWORD)PUIB[11])<<24;  
        DeviceData.CurrentEnergy=(WORD)PUIB[12];
        DeviceData.CurrentEnergy+=((WORD)PUIB[13])<<8;
        DeviceData.ImpulseEnergyMeter = (UINT32)PUIB[18];
        DeviceData.ImpulseEnergyMeter+=((DWORD)PUIB[19])<<8;
        DeviceData.ImpulseEnergyMeter+=((DWORD)PUIB[20])<<16;
        DeviceData.ImpulseEnergyMeter+=((DWORD)PUIB[21])<<24;
        DeviceData.ImpEnergyMeterImpulsPerKwth=(WORD)PUIB[22];
        DeviceData.ImpEnergyMeterImpulsPerKwth+=((WORD)PUIB[23])<<8;
        DeviceData.ImpEnergyMeterTotal = (UINT32)PUIB[24];
        DeviceData.ImpEnergyMeterTotal+=((DWORD)PUIB[25])<<8;
        DeviceData.ImpEnergyMeterTotal+=((DWORD)PUIB[26])<<16;
        DeviceData.ImpEnergyMeterTotal+=((DWORD)PUIB[27])<<24;
        DeviceData.SerialNum = (UINT32)PUIB[28];
        DeviceData.SerialNum+=((UINT32)PUIB[29])<<8;
        DeviceData.SerialNum+=((UINT32)PUIB[30])<<16;
        DeviceData.SerialNum+=((UINT32)PUIB[31])<<24;
        DeviceData.DeviceInfoResetCounter =  (UINT32)PUIB[32];
        DeviceData.DeviceInfoResetCounter += ((UINT32)PUIB[33])<<8;
        //DeviceData.DeviceInfoResetCounter =  (UINT32)PUIB[16];
        //DeviceData.DeviceInfoResetCounter += ((UINT32)PUIB[17])<<8;
        DeviceData.intTemperature =  (UINT16)PUIB[34];
        DeviceData.intTemperature += ((UINT16)PUIB[35])<<8;
        //DeviceData.IntTemperature=-6;

		DeviceData.intTemperAlarm1Level =  (INT16)PUIB[36];
		DeviceData.intTemperAlarm1Level += ((INT16)PUIB[37])<<8;
        //DeviceData.AlarmTemp1Level=-7;
       DeviceData.intTemperAlarm2Level =  (UINT16)PUIB[38];
       DeviceData.intTemperAlarm2Level += ((UINT16)PUIB[39])<<8;
		//PUIB[40]=100;
        //DeviceData.AlarmTemp2Level=-8; 
		DeviceData.intTemperAlarm1Logic = (UINT8)(PUIB[40]&0x03);
		DeviceData.intTemperAlarm2Logic = (UINT8)((PUIB[40]>>2)&0x03); 
		DeviceData.intTemperAlarm1TrapSendAv = (UINT8)((PUIB[40]>>4)&0x01);
		DeviceData.intTemperAlarm1TrapSendNoAv = (UINT8)((PUIB[40]>>5)&0x01);
		DeviceData.intTemperAlarm2TrapSendAv = (UINT8)((PUIB[40]>>6)&0x01);
		DeviceData.intTemperAlarm2TrapSendNoAv = (UINT8)((PUIB[40]>>7)&0x01);
		DeviceData.intTemperAlarm1Status = (UINT8)(PUIB[41]&0x01);
		DeviceData.intTemperAlarm2Status = (UINT8)((PUIB[41]>>1)&0x01);
		DeviceData.extTemperAlarm1Status = (UINT8)((PUIB[41]>>2)&0x01);
		DeviceData.extTemperAlarm2Status = (UINT8)((PUIB[41]>>3)&0x01);
        DeviceData.Hummidity =  (UINT16)PUIB[42];
        DeviceData.Hummidity += ((UINT16)PUIB[43])<<8;
        DeviceData.HummidityLevel =  (UINT16)PUIB[44];
        DeviceData.HummidityLevel += ((UINT16)PUIB[45])<<8;
        DeviceData.HummidityLogic=(UINT8)((PUIB[46])&0x03);
        //DeviceData.HummidityLevel=2345;
        DeviceData.HummidityTrapSendAv = (UINT8)((PUIB[46]>>2)&0x01);
        DeviceData.HummidityTrapSendNoAv = (UINT8)((PUIB[46]>>3)&0x01);
        DeviceData.HummidityStatus = (UINT8)((PUIB[46]>>4)&0x01);
        DeviceData.extTemperature =  (UINT16)PUIB[47];
        DeviceData.extTemperature += ((UINT16)PUIB[48])<<8;
        //DeviceData.ExtTemperature=15;
       	DeviceData.extTemperAlarm1Level =  (UINT16)PUIB[49];
       	DeviceData.extTemperAlarm1Level += ((UINT16)PUIB[50])<<8;
        //DeviceData.AlarmTemp1Level=-7;
       	DeviceData.extTemperAlarm2Level =  (UINT16)PUIB[51];
       	DeviceData.extTemperAlarm2Level += ((UINT16)PUIB[52])<<8;
		DeviceData.extTemperAlarm1Logic = (UINT8)(PUIB[53]&0x03);
		DeviceData.extTemperAlarm2Logic = (UINT8)((PUIB[53]>>2)&0x03); 
		DeviceData.extTemperAlarm1TrapSendAv = (UINT8)((PUIB[53]>>4)&0x01);
		DeviceData.extTemperAlarm1TrapSendNoAv = (UINT8)((PUIB[53]>>5)&0x01);
		DeviceData.extTemperAlarm2TrapSendAv = (UINT8)((PUIB[53]>>6)&0x01);
		DeviceData.extTemperAlarm2TrapSendNoAv = (UINT8)((PUIB[53]>>7)&0x01);
    	}
    
 	else if (PUIB[0] == 100)
    	{
	    char device_group,device_num,device_alarm;
	    short trap_argument;
	    
	    device_group=(PUIB[1]>>5)&0x07;
	    device_num=(PUIB[1]>>2)&0x07;
	    device_alarm=(PUIB[1]>>0)&0x03;
	    trap_argument=PUIB[2]+(PUIB[3]*256);
	    	
	    if(device_group==1)
	    	{
		    if(device_num==1)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 1 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 1 Alarm Clear");	
			    }
		    else if(device_num==2)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 2 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 2 Alarm Clear");	
			    }
		    else if(device_num==3)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 3 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 3 Alarm Clear");	
			    }
		    else if(device_num==4)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 4 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 4 Alarm Clear");	
			    }
		    else if(device_num==5)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 5 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 5 Alarm Clear");	
			    }
		    else if(device_num==6)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 6 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"LogIn 6 Alarm Clear");	
			    }
			}
	    if(device_group==3)
	    	{
		    if(device_num==1)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Internal Temperuture Level 1 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Internal Temperuture Level 1 Alarm Clear");	
			    }
			else if(device_num==2)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Internal Temperuture Level 2 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Internal Temperuture Level 2 Alarm Clear");	
			    }
		    else if(device_num==3)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"External Temperuture Level 1 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"External Temperuture Level 1 Alarm Clear");	
			    }
			else if(device_num==4)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"External Temperuture Level 2 Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"External Temperuture Level 2 Alarm Clear");	
			    }

			}
	    else if(device_group==4)
	    	{
		    if(device_num==1)
		    	{
			    if(device_alarm==1)			SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Hummidity Sensor Alarm");
			    else if(device_alarm==0)	SNMPSendSpaSibTrapAll(PUIB[1], trap_argument, (ROM BYTE*)"Hummidity Sensor Alarm Clear");
			    }
			}

			
					
     	//SNMPSendSpaSibTrapAll(3, 3, (ROM BYTE*)"Log in 1 is closed");
     	
     	//SNMPSendSpaSibTrap(0,  5, 5, (ROM BYTE*)"Log in 3 is closed");
     
     	//DeviceData.SpecTrapValue2++;
    	}    
}
