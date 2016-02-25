#include "stm8s.h"
#include <iostm8s105.h>
#include "pal_uart.h"
#include "main.h"
#include "power_cnt.h"

#define END				0x0a


char puart_data_temp;
@near char puart_rx_buffer[PUART_RX_BUFFER_SIZE];
@near char puart_tx_buffer[PUART_TX_BUFFER_SIZE];
@near char puart_rx_wr_index,puart_rx_rd_index;
@near char puart_tx_wr_index,puart_tx_rd_index;
char bPUART_RXIN;
@near char data_temp,control_temp;
@near char data_out[100];
//-----------------------------------------------
void p_uart_rx_init(void)
{
//младший разряд шины управления - вход с подтяжкой и прерыванием
GPIOD->DDR&=~(1<<0);
GPIOD->CR1|=(1<<0);
GPIOD->CR2|=(1<<0);	

//старший разряд шины управления - вход с подтяжкой без прерывания
GPIOD->DDR&=~(1<<1);
GPIOD->CR1|=(1<<1);
GPIOD->CR2&=~(1<<1);

//младший разряд шины данных - вход с подтяжкой без прерывания
GPIOD->DDR&=~(1<<2);
GPIOD->CR1|=(1<<2);
GPIOD->CR2&=~(1<<2);	

//старший разряд шины данных - вход с подтяжкой без прерывания
GPIOD->DDR&=~(1<<3);
GPIOD->CR1|=(1<<3);
GPIOD->CR2&=~(1<<3);

EXTI->CR1=0xc0; 	//прерывание по любому фронту на порт D	

}

//-----------------------------------------------
void puart_uart_in(void)
{
char temp,i,count;

if((puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-1)])==END)
	{
			
	temp=puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-3)];
    	if(temp<100) 
    		{
		if(puart_control_check(puart_index_offset(puart_rx_wr_index,-1)))
    			{
    			puart_rx_rd_index=puart_index_offset(puart_rx_wr_index,-3-temp);
    			for(i=0;i<temp;i++)
				{
				PUIB[i]=puart_rx_buffer[puart_index_offset(puart_rx_rd_index,i)];
				} 
			puart_rx_rd_index=puart_rx_wr_index;
			
			puart_uart_in_an();

    			}
    		} 
    	}	
}

//-----------------------------------------------
signed short puart_index_offset (signed short index,signed short offset)
{
index=index+offset;
if(index>=PUART_RX_BUFFER_SIZE) index-=PUART_RX_BUFFER_SIZE; 
if(index<0) index+=PUART_RX_BUFFER_SIZE;
return index;
}

//-----------------------------------------------
char puart_control_check(char index)
{
char i=0,ii=0,iii;

if(puart_rx_buffer[index]!=END) return 0;

ii=puart_rx_buffer[puart_index_offset(index,-2)];
iii=0;
for(i=0;i<=ii;i++)
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
if((PUIB[0]==1)&&(PUIB[1]==2))
	{

	}
else if(PUIB[0]==55)
	{		FLASH_DUKR=0xae;
		FLASH_DUKR=0x56;
	//Установка аварийных состояний логических входов
	if(PUIB[1]==1)
		{
		ee_log_in_stat_of_av[0]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==2)
		{
		ee_log_in_stat_of_av[1]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==3)
		{
		ee_log_in_stat_of_av[2]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==4)
		{
		ee_log_in_stat_of_av[3]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==5)
		{
		ee_log_in_stat_of_av[4]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==6)
		{
		ee_log_in_stat_of_av[5]=PUIB[2]+(PUIB[3]*256);
		}

	//Включение-выключение отсылки трапов по возникновению аварий логических входов
	else if(PUIB[1]==7)
		{
		ee_log_in_trap_send_av[0]=PUIB[2];
		}
	else if(PUIB[1]==8)
		{
		ee_log_in_trap_send_av[1]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==9)
		{
		ee_log_in_trap_send_av[2]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==10)
		{
		ee_log_in_trap_send_av[3]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==11)
		{
		ee_log_in_trap_send_av[4]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==12)
		{
		ee_log_in_trap_send_av[5]=PUIB[2]+(PUIB[3]*256);
		}

	//Включение-выключение отсылки трапов по снятию аварий логических входов
	else if(PUIB[1]==13)
		{
		ee_log_in_trap_send_no_av[0]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==14)
		{
		ee_log_in_trap_send_no_av[1]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==15)
		{
		ee_log_in_trap_send_no_av[2]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==16)
		{
		ee_log_in_trap_send_no_av[3]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==17)
		{
		ee_log_in_trap_send_no_av[4]=PUIB[2]+(PUIB[3]*256);
		}
	else if(PUIB[1]==18)
		{
		ee_log_in_trap_send_no_av[5]=PUIB[2]+(PUIB[3]*256);
		}
	//Установка адреса счетчика (2 байта)
	else if(PUIB[1]==19)
		{
		ee_power_cnt_adr=PUIB[2]+(PUIB[3]*256);
		}
	//Установка коэффициента импульсов для счетчика эл.эн.
	else if(PUIB[1]==20)
		{
		ee_impuls_per_kwatt=PUIB[2]+(PUIB[3]*256);
		}
	//Установка смчетчика импульсов для счетчика эл.эн.
	else if(PUIB[1]==21)
		{
		power_summary_impuls_cnt=(((long)PUIB[5])<<24)+(((long)PUIB[4])<<16)+(((long)PUIB[3])<<8)+(PUIB[2]);
		ee_power_summary_impuls_cnt=power_summary_impuls_cnt;
		}
	//Установка счетчика сбросов 
	else if(PUIB[1]==22)
		{
		ee_reset_cnt=PUIB[2]+(PUIB[3]*256);
		}
	//Калибровка 1-го датчика температуры (внутреннего)
	else if(PUIB[1]==23)
		{
		if(PUIB[2]==1)
			{
			ee_T1_koef+=2;
			}
		else if(PUIB[2]==2)
			{
			ee_T1_koef-=2;
			}
		else if(PUIB[2]==3)
			{
			ee_T1_koef+=15;
			}
		else if(PUIB[2]==4)
			{
			ee_T1_koef-=15;
			}
		if(ee_T1_koef>1035)ee_T1_koef=1035;
		if(ee_T1_koef<1005)ee_T1_koef=1005;
		}
	//Калибровка 2-го датчика температуры (внешнего)	
	else if(PUIB[1]==24)
		{
		if(PUIB[2]==1)
			{
			ee_T2_koef+=2;
			}
		else if(PUIB[2]==2)
			{
			ee_T2_koef-=2;
			}
		else if(PUIB[2]==3)
			{
			ee_T2_koef+=15;
			}
		else if(PUIB[2]==4)
			{
			ee_T2_koef-=15;
			}
		if(ee_T2_koef>1035)ee_T2_koef=1035;
		if(ee_T2_koef<1005)ee_T2_koef=1005;
		}		
	//Установка порога 1 по внутренней температуре
	else if(PUIB[1]==25)
		{
		ee_T1_porog1=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
		}
	//Установка порога 2 по внутренней температуре
	else if(PUIB[1]==26)
		{
		ee_T1_porog2=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
		}
	//Установка логики порога 1 по внутренней температуре
	else if(PUIB[1]==27)
		{
		ee_T1_logic1=(PUIB[2]&0x03);
		}
	//Установка логики порога 2 по внутренней температуре
	else if(PUIB[1]==28)
		{
		ee_T1_logic2=(PUIB[2]&0x03);
		}
	//Включение-выключение отсылки трапов по аварии внутренней температуры по 1 порогу
	else if(PUIB[1]==29)
		{
		ee_T1_trap_send_av_1=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по снятию аварии внутренней температуры по 1 порогу
	else if(PUIB[1]==30)
		{
		ee_T1_trap_send_no_av_1=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по аварии внутренней температуры по 2 порогу
	else if(PUIB[1]==31)
		{
		ee_T1_trap_send_av_2=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по снятию аварии внутренней температуры по 2 порогу
	else if(PUIB[1]==32)
		{
		ee_T1_trap_send_no_av_2=(PUIB[2]&0x01);
		}
	//Установка порога по влажности
	else if(PUIB[1]==33)
		{
		ee_H1_porog=PUIB[2]+(PUIB[3]*256);
		}
	//Установка логики по влажности
	else if(PUIB[1]==34)
		{
		ee_H1_logic=PUIB[2];
		}
	//Включение-выключение отсылки трапов по возникновению аварии по влажности
	else if(PUIB[1]==35)
		{
		ee_hummidity_trap_send_av=PUIB[2];
		}
	//Включение-выключение отсылки трапов по снятию аварии по влажности
	else if(PUIB[1]==36)
		{
		ee_hummidity_trap_send_no_av=PUIB[2];
		}

	//Установка порога 1 по внешней температуре
	else if(PUIB[1]==50)
		{
		ee_T2_porog1=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
		}
	//Установка порога 2 по внешней температуре
	else if(PUIB[1]==51)
		{
		ee_T2_porog2=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
		}
	//Установка логики порога 1 по внешней температуре
	else if(PUIB[1]==52)
		{
		ee_T2_logic1=(PUIB[2]&0x03);
		}
	//Установка логики порога 2 по внешней температуре
	else if(PUIB[1]==53)
		{
		ee_T2_logic2=(PUIB[2]&0x03);
		}		
	//Включение-выключение отсылки трапов по аварии внешней температуры по 1 порогу
	else if(PUIB[1]==54)
		{
		ee_T2_trap_send_av_1=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по снятию аварии внешней температуры по 1 порогу
	else if(PUIB[1]==55)
		{
		ee_T2_trap_send_no_av_1=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по аварии внешней температуры по 2 порогу
	else if(PUIB[1]==56)
		{
		ee_T2_trap_send_av_2=(PUIB[2]&0x01);
		}

	//Включение-выключение отсылки трапов по снятию внешней внутренней температуры по 2 порогу
	else if(PUIB[1]==57)
		{
		ee_T2_trap_send_no_av_2=(PUIB[2]&0x01);
		}
	}
}

//-----------------------------------------------
void p_uart_tx_init(void)
{
//младший разряд шины управления - выход полный
GPIOC->DDR|=(1<<5);
GPIOC->CR1|=(1<<5);
GPIOC->CR2&=~(1<<5);	

//старший разряд шины управления - вход неподвешенный
GPIOC->DDR&=~(1<<6);
GPIOC->CR1&=~(1<<6);
GPIOC->CR2&=~(1<<6);

//младший разряд шины данных - выход полный
GPIOC->DDR|=(1<<7);
GPIOC->CR1|=(1<<7);
GPIOC->CR2&=~(1<<7);	

//старший разряд шины данных - выход полный
GPIOE->DDR|=(1<<5);
GPIOE->CR1|=(1<<5);
GPIOE->CR2&=~(1<<5);


}

//-----------------------------------------------
void puart_tx_drv(void)
{
static char puart_cnt;
char temp_tx; 
char puart_cnt__=0;
temp_tx=puart_tx_buffer[puart_tx_rd_index];
//puart_cnt__=(puart_cnt>>1);
//if(puart_cnt&0x01)puart_cnt__|=0x02;

//temp_tx=0x5A;
/*if(puart_tx_rd_index!=puart_tx_wr_index)
	{
	GPIOC->ODR=(GPIOC->ODR&0x1f)|((puart_cnt__&0x03)<<5)|(((temp_tx>>(puart_cnt*2))&0x03)<<7);
	GPIOE->ODR=(((temp_tx>>(puart_cnt*2))&0x03)<<4);
	
	puart_cnt++;
	if(puart_cnt>=4)
		{
		puart_cnt=0;
		puart_tx_rd_index++;
		if(puart_tx_rd_index >= PUART_TX_BUFFER_SIZE) puart_tx_rd_index=0;
		}	
	}*/



if(puart_tx_rd_index!=puart_tx_wr_index)
	{
	if( ( ((GPIOC->ODR)&(1<<5)) && ((GPIOC->IDR)&(1<<6)) ) || ( (!((GPIOC->ODR)&(1<<5))) && (!((GPIOC->IDR)&(1<<6))) ) )
		{
		if((temp_tx>>(puart_cnt*2))&0x01)GPIOC->ODR|=(1<<7);
		else GPIOC->ODR&=~(1<<7);
		if((temp_tx>>((puart_cnt*2)+1))&0x01)GPIOE->ODR|=(1<<5);
		else GPIOE->ODR&=~(1<<5);

		if(puart_cnt&0x01)GPIOC->ODR|=(1<<5);
		else GPIOC->ODR&=~(1<<5);
		puart_cnt++;
		if(puart_cnt>=4)
			{
			puart_cnt=0;
			puart_tx_rd_index++;
			if(puart_tx_rd_index >= PUART_TX_BUFFER_SIZE) puart_tx_rd_index=0;
			}
		}
	}
else 
	{
	GPIOC->ODR|=(1<<5);
	}
}



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
void puart_out_adr (char *ptr, char len)
{
char temp11,t,i11;

t=0;

for(i11=0;i11<len;i11++)
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
puart_tx_buffer[puart_tx_wr_index]=c;
if (++puart_tx_wr_index >= PUART_TX_BUFFER_SIZE) puart_tx_wr_index=0;

}


#define LED1_TRIS 	TRISBbits.TRISB0
#define LED1_PORT	LATBbits.LATB0





