//#define ATMEL
//#define ST

#include "stm8s.h"
#include "main.h"
#include "cmd.c"
#include "PAL_uart.h"
#include <iostm8s105.h>
#include "power_cnt.h"

//#define CS_ON	GPIOC->ODR&=~(1<<3);
//#define CS_OFF	GPIOC->ODR|=(1<<3);
//#define ST_CS_ON	GPIOB->ODR&=~(1<<5);
//#define ST_CS_OFF	GPIOB->ODR|=(1<<5);


char t0_cnt0=0,t0_cnt1=0,t0_cnt2=0,t0_cnt3=0,t0_cnt4=0;
@near short main_cnt;
signed short sample_cnt;
char tx_buffer[TX_BUFFER_SIZE]={0};
signed char tx_counter;
signed char tx_wr_index,tx_rd_index;
char rx_buffer[RX_BUFFER_SIZE]={0};
signed short rx_counter;
signed char rx_wr_index,rx_rd_index;
char sample;
char but_drv_cnt=0;

char rs_data[7];
//unsigned int file_lengt_in_pages,current_page,last_page,current_byte_in_buffer;
//unsigned long file_lengt;
char rx_status;
char rx_data;
//signed short rele_cnt;
char rx_offset;
//unsigned char pwm_fade_in=0;
unsigned short adcw[3];
const char rele_cnt_const[]={10,25,50};
//char memory_manufacturer='S';
char adc_cnt_zero[3];
short adc_gorb_cnt[3];
unsigned long adc_sigma[3];
unsigned short adc_sigma_res[3];
///_Bool bSTART;
///_Bool bBUFF_LOAD;
///_Bool bBUFF_READ_H;
///_Bool bBUFF_READ_L;
_Bool b100Hz, b10Hz, b5Hz, b2Hz, b1Hz,bPUART_TX;
//_Bool play;
_Bool bOUT_FREE;
_Bool bRXIN;
_Bool rx_buffer_overflow;
//@near char dumm[100];
@near char buff[30];
@near char UIB[8];

@eeprom enum_log_in_stat_of_av ee_log_in_stat_of_av[8];
@eeprom enum_log_in_trap_send ee_log_in_trap_send_av[8],ee_log_in_trap_send_no_av[8];
@near signed char log_in_cnt[8];
@near enum_log_in_stat log_in_stat[8];
@near enum_log_in_av_stat log_in_av_stat[8],log_in_av_stat_old[8];
@near char PUIB[32];
@near char ppp_cnt;
@eeprom short ee_reset_cnt;
@near short ee_reset_cnt_=333;

const long __serial  @0x8100;
long _serial=98765;



//-----------------------------------------------
//Работа с АЦП
@near char adc_plazma;
@near char adc_ch;
@near char adc_cnt;
@near short adc_buff[2][16];
@near short adc_buff_[2];
@near short adc_plazma_short;

//-----------------------------------------------
//Работа со счетчиком
signed long power_summary=0;
signed short power_current=0;
char power_cnt_adrl,power_cnt_adrh;
@eeprom signed short ee_power_cnt_adr /*__at 0x4040*/;
@near long power_summary_impuls_cnt;
@eeprom long ee_power_summary_impuls_cnt;
@near long power_summary_impuls;
@eeprom short ee_impuls_per_kwatt;
@near short impuls_cnt;

//-----------------------------------------------
//Температура
@near signed short T1;
@near signed short T2;
@eeprom signed short ee_T1_koef,ee_T2_koef;
@eeprom signed short ee_T1_porog1,ee_T1_porog2;
@eeprom signed short ee_T2_porog1,ee_T2_porog2;
@eeprom enum_temper_logic ee_T1_logic1,ee_T1_logic2,ee_T2_logic1,ee_T2_logic2;
@eeprom enum_temper_trap_send ee_T1_trap_send_av_1,ee_T1_trap_send_no_av_1,ee_T1_trap_send_av_2,ee_T1_trap_send_no_av_2,
						ee_T2_trap_send_av_1,ee_T2_trap_send_no_av_1,ee_T2_trap_send_av_2,ee_T2_trap_send_no_av_2;
@near char T1_status1,T1_status2,T1_status1_old,T1_status2_old;
@near char T2_status1,T2_status2,T2_status1_old,T2_status2_old; 
@near short T1_porog1_cnt,T1_porog2_cnt,T2_porog1_cnt,T2_porog2_cnt;

//-----------------------------------------------
//Влажность
@near signed short H1;
@eeprom signed short ee_H1_porog;
//@near enum_hummidity_av_stat hummidity_av_stat;
@eeprom enum_hummidity_trap_send ee_hummidity_trap_send_av,ee_hummidity_trap_send_no_av; 
@near signed char hummidity_alarm_cnt;
@near enum_hummidity_alarm_stat hummidity_alarm_stat,hummidity_alarm_stat_old;
@eeprom enum_hummidity_alarm_logic ee_H1_logic;

@near char data_for_stend[8];
@near char data_for_stend_char;
@near short data_for_stend_short0,data_for_stend_short1;
@near char power_cnt_block=5;
char bTRANSMIT_TO_STEND;
@near char tx_stat_cnt;

char pavl;
//-----------------------------------------------
void gran_char(signed char *adr, signed char min, signed char max)
{
if (*adr<min) *adr=min;
if (*adr>max)  *adr=max; 
}

//-----------------------------------------------
void t2_init(void){
	TIM2->PSCR = 0;
	TIM2->ARRH= 0x00;
	TIM2->ARRL= 0xff;
	TIM2->CCR1H= 0x00;	
	TIM2->CCR1L= 200;
	TIM2->CCR2H= 0x00;	
	TIM2->CCR2L= 200;
	TIM2->CCR3H= 0x00;	
	TIM2->CCR3L= 200;
	
	//TIM2->CCMR1= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCMR2= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCMR3= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCER1= /*TIM2_CCER1_CC1E | TIM2_CCER1_CC1P |*/ TIM2_CCER1_CC2E | TIM2_CCER1_CC2P; //OC1, OC2 output pins enabled
	//TIM2->CCER2= TIM2_CCER2_CC3E | TIM2_CCER2_CC3P; //OC1, OC2 output pins enabled
	TIM2->CCER2= TIM2_CCER2_CC3E /*| TIM2_CCER2_CC3P*/; //OC1, OC2 output pins enabled
	
	TIM2->CR1=(TIM2_CR1_CEN | TIM2_CR1_ARPE);	
	
}

//-----------------------------------------------
void t4_init(void){
	TIM4->PSCR = 7;
	TIM4->ARR= 125;
	TIM4->IER|= TIM4_IER_UIE;					// enable break interrupt
	
	TIM4->CR1=(TIM4_CR1_URS | TIM4_CR1_CEN | TIM4_CR1_ARPE);	
	
}


//-----------------------------------------------
void adc_init(void){
	GPIOB->DDR&=~(1<<0);
	GPIOB->CR1&=~(1<<0);
	GPIOB->CR2&=~(1<<0);
	ADC1->TDRL|=(1<<0);

	GPIOB->DDR&=~(1<<1);
	GPIOB->CR1&=~(1<<1);
	GPIOB->CR2&=~(1<<1);
	ADC1->TDRL|=(1<<1);
	
/*	GPIOB->DDR&=~(1<<2);
	GPIOB->CR1&=~(1<<2);
	GPIOB->CR2&=~(1<<2);
	ADC1->TDRL|=(1<<2);	*/
	
	ADC1->CR2=0x08;
	ADC1->CR1=0x40;
	ADC1->CSR=0x20+adc_ch;
	
	ADC1->CR1|=1;
ADC1->CR1|=1;
}


//-----------------------------------------------
long delay_ms(short in)
{
long i,ii,iii;

i=((long)in)*100UL;

for(ii=0;ii<i;ii++)
	{
		iii++;
	}

}
//-----------------------------------------------
void for_stend_out(char flags,short data0,short data1)
{
data_for_stend[0]=0xAB;

data_for_stend[1]=flags;

data_for_stend[2]=(char)data0;
data_for_stend[3]=(char)(data0/256);
data_for_stend[4]=(char)data1;
data_for_stend[5]=(char)(data1/256);
data_for_stend[6]=0xBA;

uart_out_adr(data_for_stend,7);

}

//-----------------------------------------------
void impuls_meter(void)
{
if(!(GPIOC->IDR&(1<<4)))
	{
	impuls_cnt++;
	if(impuls_cnt>200)impuls_cnt=0;
	//power_summary_impuls_cnt++;
	}
else 
	{
	
	if((impuls_cnt>2)&&(impuls_cnt<90))
		{
		power_summary_impuls_cnt++;
		if((power_summary_impuls_cnt%10)==0)ee_power_summary_impuls_cnt=power_summary_impuls_cnt;
		


		}

	impuls_cnt=0;
	}
power_summary_impuls=power_summary_impuls_cnt/ee_impuls_per_kwatt;
}

//-----------------------------------------------
void matemat(void)
{
signed long tempSL;

tempSL=(signed long)adc_buff_[1];
tempSL*=(signed long)ee_T1_koef;
tempSL/=2500L;
tempSL-=273L;
T1=(signed short)tempSL;			//температура внутреннего датчика
//T1=-5;

tempSL=(signed long)(adc_buff_[0]>>2);
tempSL*=(signed long)ee_T2_koef;
tempSL/=2500L;
tempSL-=273L;
T2=(signed short)tempSL;			//температура внешнего датчика
//T2=-11;

tempSL=(signed long)adc_buff_[0];
tempSL*=(signed long)4;
tempSL/=(signed long)5;
H1=(signed short)tempSL;

}

//-----------------------------------------------
void uart_init (void)
{
//Порт D.6 - RX
GPIOD->DDR&=~(1<<6);
GPIOD->CR1|=(1<<6);
GPIOD->CR2&=~(1<<6);

//Порт D.5 - TX
GPIOD->DDR|=(1<<5);
GPIOD->CR1|=(1<<5);
GPIOD->CR2&=~(1<<5);	

//Порт D.7 - PV
GPIOD->DDR|=(1<<7);
GPIOD->CR1|=(1<<7);
GPIOD->CR2&=~(1<<7);
GPIOD->ODR|=(1<<7);		//Сразу в 1
	
//Порт D.4 - DE
GPIOD->DDR|=(1<<4);
GPIOD->CR1|=(1<<4);
GPIOD->CR2&=~(1<<4);
	
UART2->CR1&=~UART2_CR1_M;					
UART2->CR3|= (0<<4) & UART2_CR3_STOP;	
UART2->BRR2= 0x03;
UART2->BRR1= 0x68;
UART2->CR2|= UART2_CR2_TEN | UART2_CR2_REN | UART2_CR2_RIEN/*| UART2_CR2_TIEN*/ ;	
}

//-----------------------------------------------
void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7){
	char i=0,t=0,UOB[12];
	
	
	UOB[0]=data0;
	UOB[1]=data1;
	UOB[2]=data2;
	UOB[3]=data3;
	UOB[4]=data4;
	UOB[5]=data5;
	UOB[6]=data6;
	UOB[7]=data7;	
	for (i=0;i<num;i++)
		{
		t^=UOB[i];
		}    
	UOB[num]=num;
	t^=UOB[num];
	UOB[num+1]=t;
	UOB[num+2]=END;
	
	
	
	for (i=0;i<num+3;i++)
		{
		putchar(UOB[i]);
		} 

	bOUT_FREE=0;	  	
}

//-----------------------------------------------
void uart_out_adr_block (unsigned long adress,char *ptr, char len)
{
//char UOB[100]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
char temp11,t,i11;

t=0;
temp11=CMND;
t^=temp11;
putchar(temp11);

temp11=10;
t^=temp11;
putchar(temp11);

temp11=adress%256;//(*((char*)&adress));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+1));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+2));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+3));
t^=temp11;
putchar(temp11);


for(i11=0;i11<len;i11++)
	{
	temp11=ptr[i11];
	t^=temp11;
	putchar(temp11);
	}
	
temp11=(len+6);
t^=temp11;
putchar(temp11);

putchar(t);

putchar(0x0a);
	
bOUT_FREE=0;	   
}
//-----------------------------------------------
void uart_in_an(void) {
	char temp_char,r1;

	if(UIB[0]==CMND) {
		 

		
	 if(UIB[1]==2) {
		char temp;
		//GPIOD->ODR^=(1<<4);

		//uart_out (3,CMND,2,temp,0,0,0);    
		} 
	
		
	else if(UIB[1]==3)
		{
		char temp;

		//uart_out (2,CMND,3,temp,0,0,0);    
		}				
		
	else if(UIB[1]==4)
		{
		char temp;

		//uart_out (2,CMND,3,temp,0,0,0);    
		}				

	else if(UIB[1]==10)
		{

		
		uart_out_adr_block (0,buff,64);
		delay_ms(100);    
		uart_out_adr_block (64,&buff[64],64);
		delay_ms(100);    
		uart_out_adr_block (128,&buff[128],64);
		delay_ms(100);    
		uart_out_adr_block (192,&buff[192],64);
		delay_ms(100);    
		}				

	else if(UIB[1]==11)
		{
		char temp;
		unsigned i;
//		DF_page_to_buffer(2,0);
		
		for(i=0;i<256;i++)buff[i]=0;

		}	
		
	else if(UIB[1]==12)
		{
		char temp;
		unsigned i;

		
		for(i=0;i<256;i++)buff[i]=0;
		
		if(UIB[3]==1)
			{
			buff[0]=0x00;
			buff[1]=0x11;
			buff[2]=0x22;
			buff[3]=0x33;
			buff[4]=0x44;
			buff[5]=0x55;
			buff[6]=0x66;
			buff[7]=0x77;
			buff[8]=0x88;
			buff[9]=0x99;
			buff[10]=0;
			buff[11]=0;
			}

		else if(UIB[3]==2)
			{
			buff[0]=0x00;
			buff[1]=0x10;
			buff[2]=0x20;
			buff[3]=0x30;
			buff[4]=0x40;
			buff[5]=0x50;
			buff[6]=0x60;
			buff[7]=0x70;
			buff[8]=0x80;
			buff[9]=0x90;
			buff[10]=0;
			buff[11]=0;
			}

		else if(UIB[3]==3)
			{
			buff[0]=0x98;
			buff[1]=0x87;
			buff[2]=0x76;
			buff[3]=0x65;
			buff[4]=0x54;
			buff[5]=0x43;
			buff[6]=0x32;
			buff[7]=0x21;
			buff[8]=0x10;
			buff[9]=0x00;
			buff[10]=0;
			buff[11]=0;
			}

		}
		
	

	else if(UIB[1]==20)
		{
		char temp;
		unsigned i;
          
/*		file_lengt=0;
		file_lengt+=UIB[5];
		file_lengt<<=8;
		file_lengt+=UIB[4];
		file_lengt<<=8;
		file_lengt+=UIB[3];
		file_lengt_in_pages=file_lengt;
		file_lengt<<=8;
		file_lengt+=UIB[2];*/
		
		//file_lengt=UIB[2];
		//+(UIB[3]*256)+(UIB[4]*65536)+(UIB[5]*65536*256);
		//file_lengt_in_pages=file_lengt/256U;
///		current_page=0;
//		current_byte_in_buffer=0;
///		current_buffer=1;

		//uart_out (4,CMND,21,22/*current_page%256*/,23/*current_page/256/*/,0,0);
			
		}





}
}





//-----------------------------------------------
void gpio_init(void){
/*	GPIOB->DDR=0xff;
	GPIOB->CR1=0xff;
	GPIOB->CR2=0;
	GPIOB->ODR=0;
	*/
	///GPIOD->DDR|=(1<<2);
	///GPIOD->CR1|=(1<<2);
	///GPIOD->CR2&=~(1<<2);
	///GPIOD->ODR&=~(1<<2);
	GPIOD->DDR|=(1<<2);
	GPIOD->CR1|=(1<<2);
	GPIOD->CR2|=(1<<2);
	GPIOD->ODR&=~(1<<2);

	GPIOD->DDR|=(1<<4);
	GPIOD->CR1|=(1<<4);
	GPIOD->CR2&=~(1<<4);

	GPIOC->DDR&=~(1<<4);
	GPIOC->CR1&=~(1<<4);
	GPIOC->CR2&=~(1<<4);
	
	

}





//-----------------------------------------------
void uart_in(void)
{
char temp,i,count;
//#asm("cli")
//disableInterrupts();
if(rx_buffer_overflow)
	{
	rx_wr_index=0;
	rx_rd_index=0;
	rx_counter=0;
	rx_buffer_overflow=0;
	}    
	
if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
	{
	//rx_offset++;
	//GPIOD->ODR^=(1<<4);
	//uart_out (3,CMND,1,33,mdr1/**(((char*)&temp_L)+1)*/,mdr2/**(((char*)&temp_L)+2)*/,mdr3/**(((char*)&temp_L)+3)*/);
	temp=rx_buffer[index_offset(rx_wr_index,-3)];
    	if(temp<100) 
    		{
		
    		if(control_check(index_offset(rx_wr_index,-1)))
    			{///uart_out (3,CMND,1,33,mdr1/**(((char*)&temp_L)+1)*/,mdr2/**(((char*)&temp_L)+2)*/,mdr3/**(((char*)&temp_L)+3)*/);
			//GPIOD->ODR^=(1<<4);
    			rx_rd_index=index_offset(rx_wr_index,-3-temp);
    			for(i=0;i<temp;i++)
				{
				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
				} 
			rx_rd_index=rx_wr_index;
			rx_counter=0;
			
			/*if(UIB[1]==21)
				{
					char i;
				for(i=0;i<64;i++)
					{
						UIB[2+i]=rx_offset;
					}
				}*/
			uart_in_an();
/**/
    			}
 	
    		} 
    	}	

//#asm("sei") 
//enableInterrupts();
}

//-----------------------------------------------
signed short index_offset (signed short index,signed short offset)
{
index=index+offset;
if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
if(index<0) index+=RX_BUFFER_SIZE;
return index;
}

//-----------------------------------------------
char control_check(char index)
{
char i=0,ii=0,iii;

if(rx_buffer[index]!=END) return 0;

ii=rx_buffer[index_offset(index,-2)];
iii=0;
for(i=0;i<=ii;i++)
	{
	iii^=rx_buffer[index_offset(index,-2-ii+i)];
	}
if (iii!=rx_buffer[index_offset(index,-1)]) return 0;	

return 1;

}

//-----------------------------------------------
void data_out_hndl(void)
{
//data_out[1] - состояние логических входов(побитно)
//data_out[2] - состояние логических входов принятые за аварийные(побитно),(установочные)
//data_out[3] - состояние аварийности логических входов(побитно)
//data_out[4] - посылка трапа по наступлению аварии логических входов(побитно),(установочные)
//data_out[5] - посылка трапа по снятию аварии логических входов(побитно),(установочные)

data_out[0]=0x33;
//data_out[1]=0x03;

//Состояния логических входов
if(log_in_stat[0]==lisON)data_out[1]|=(1<<0);
else data_out[1]&=~(1<<0);

if(log_in_stat[1]==lisON)data_out[1]|=(1<<1);
else data_out[1]&=~(1<<1);

if(log_in_stat[2]==lisON)data_out[1]|=(1<<2);
else data_out[1]&=~(1<<2);

if(log_in_stat[3]==lisON)data_out[1]|=(1<<3);
else data_out[1]&=~(1<<3);

if(log_in_stat[4]==lisON)data_out[1]|=(1<<4);
else data_out[1]&=~(1<<4);

if(log_in_stat[5]==lisON)data_out[1]|=(1<<5);
else data_out[1]&=~(1<<5);

//состояние логических входов принятые за аварийные
if(ee_log_in_stat_of_av[0]==lisoaON)data_out[2]|=(1<<0);
else data_out[2]&=~(1<<0);

if(ee_log_in_stat_of_av[1]==lisoaON)data_out[2]|=(1<<1);
else data_out[2]&=~(1<<1);

if(ee_log_in_stat_of_av[2]==lisoaON)data_out[2]|=(1<<2);
else data_out[2]&=~(1<<2);

if(ee_log_in_stat_of_av[3]==lisoaON)data_out[2]|=(1<<3);
else data_out[2]&=~(1<<3);

if(ee_log_in_stat_of_av[4]==lisoaON)data_out[2]|=(1<<4);
else data_out[2]&=~(1<<4);

if(ee_log_in_stat_of_av[5]==lisoaON)data_out[2]|=(1<<5);
else data_out[2]&=~(1<<5);

//data_out[2]=0x55;

//Состояния аварийности логических входов

if(log_in_av_stat[0]==liasON)data_out[3]|=(1<<0);
else data_out[3]&=~(1<<0);

if(log_in_av_stat[1]==liasON)data_out[3]|=(1<<1);
else data_out[3]&=~(1<<1);

if(log_in_av_stat[2]==liasON)data_out[3]|=(1<<2);
else data_out[3]&=~(1<<2);

if(log_in_av_stat[3]==liasON)data_out[3]|=(1<<3);
else data_out[3]&=~(1<<3);

if(log_in_av_stat[4]==liasON)data_out[3]|=(1<<4);
else data_out[3]&=~(1<<4);

if(log_in_av_stat[5]==liasON)data_out[3]|=(1<<5);
else data_out[3]&=~(1<<5);

//Включенность-выключенность отсылки трапов по возникновению аварий логических входов
if(ee_log_in_trap_send_av[0]==litsON)data_out[4]|=(1<<0);
else data_out[4]&=~(1<<0);

if(ee_log_in_trap_send_av[1]==litsON)data_out[4]|=(1<<1);
else data_out[4]&=~(1<<1);

if(ee_log_in_trap_send_av[2]==litsON)data_out[4]|=(1<<2);
else data_out[4]&=~(1<<2);

if(ee_log_in_trap_send_av[3]==litsON)data_out[4]|=(1<<3);
else data_out[4]&=~(1<<3);

if(ee_log_in_trap_send_av[4]==litsON)data_out[4]|=(1<<4);
else data_out[4]&=~(1<<4);

if(ee_log_in_trap_send_av[5]==litsON)data_out[4]|=(1<<5);
else data_out[4]&=~(1<<5);

if(ee_log_in_trap_send_av[6]==litsON)data_out[4]|=(1<<6);
else data_out[4]&=~(1<<6);

//Включенность-выключенность отсылки трапов по снятию аварий логических входов
if(ee_log_in_trap_send_no_av[0]==litsON)data_out[5]|=(1<<0);
else data_out[5]&=~(1<<0);

if(ee_log_in_trap_send_no_av[1]==litsON)data_out[5]|=(1<<1);
else data_out[5]&=~(1<<1);

if(ee_log_in_trap_send_no_av[2]==litsON)data_out[5]|=(1<<2);
else data_out[5]&=~(1<<2);

if(ee_log_in_trap_send_no_av[3]==litsON)data_out[5]|=(1<<3);
else data_out[5]&=~(1<<3);

if(ee_log_in_trap_send_no_av[4]==litsON)data_out[5]|=(1<<4);
else data_out[5]&=~(1<<4);

if(ee_log_in_trap_send_no_av[5]==litsON)data_out[5]|=(1<<5);
else data_out[5]&=~(1<<5);

if(ee_log_in_trap_send_no_av[6]==litsON)data_out[5]|=(1<<6);
else data_out[5]&=~(1<<6);



//Адресс счетчика (2 байта)
data_out[6]=(char)(ee_power_cnt_adr);
data_out[7]=(char)(ee_power_cnt_adr>>8);
//Потребленная энергия(4 байта)
//power_summary=12345678UL;
data_out[8]=(char)(power_summary);
data_out[9]=(char)(power_summary>>8);
data_out[10]=(char)(power_summary>>16);
data_out[11]=(char)(power_summary>>24);
//Потребляемая энергия(2 байта)
//power_current=9876;
data_out[12]=(char)(power_current);
data_out[13]=(char)(power_current>>8);
//Отладочная информация 4 байта
data_out[14]=adc_plazma;//adc_buff_[0]>>4;
data_out[15]=(char)adc_buff_[0]>>2;
//adc_plazma_short=1234;
data_out[16]=(char)(adc_plazma_short);
data_out[17]=(char)(adc_plazma_short>>8);
//Информация об импульсном счетчике

data_out[18]=(char)(power_summary_impuls_cnt);
data_out[19]=(char)(power_summary_impuls_cnt>>8);
data_out[20]=(char)(power_summary_impuls_cnt>>16);
data_out[21]=(char)(power_summary_impuls_cnt>>24);

data_out[22]=(char)(ee_impuls_per_kwatt);
data_out[23]=(char)(ee_impuls_per_kwatt>>8);

data_out[24]=(char)(power_summary_impuls);
data_out[25]=(char)(power_summary_impuls>>8);
data_out[26]=(char)(power_summary_impuls>>16);
data_out[27]=(char)(power_summary_impuls>>24);

//Серийный номер устройства
data_out[28]=(char)(__serial);
data_out[29]=(char)(__serial>>8);
data_out[30]=(char)(__serial>>16);
data_out[31]=(char)(__serial>>24);

//Счетчик сбросов
data_out[32]=(char)(ee_reset_cnt);
data_out[33]=(char)(ee_reset_cnt>>8);

//T1=-13;
//Температура внутреннего датчика
data_out[34]=(char)(T1);
data_out[35]=(char)(T1>>8);

//if(ee_T1_porog1!=-28)ee_T1_porog1=-28;
//if(ee_T1_porog2!=-29)ee_T1_porog2=-29;
//Температура внутреннего датчика пороги 
data_out[36]=(char)(ee_T1_porog1);
data_out[37]=(char)(ee_T1_porog1>>8);
data_out[38]=(char)(ee_T1_porog2);
data_out[39]=(char)(ee_T1_porog2>>8);
//Логика работы порогов по внутренней температуре
data_out[40]=ee_T1_logic1&0x03;
data_out[40]+=(ee_T1_logic2&0x03)<<2;
//Включенность выключенность отсылки трапов по внутренней температуре
data_out[40]+=(ee_T1_trap_send_av_1&0x01)<<4;
data_out[40]+=(ee_T1_trap_send_no_av_1&0x01)<<5;
data_out[40]+=(ee_T1_trap_send_av_2&0x01)<<6;
data_out[40]+=(ee_T1_trap_send_no_av_2&0x01)<<7;
//Статус аварийности температуры
data_out[41]=T1_status1&0x01;
data_out[41]+=(T1_status2&0x01)<<1;
data_out[41]+=(T2_status1&0x01)<<2;
data_out[41]+=(T2_status2&0x01)<<3;
//H1=3456;
//Показания датчика влажности
data_out[42]=(char)(H1);
data_out[43]=(char)(H1>>8);

//if(ee_H1_porog!=2345)ee_H1_porog=2345;
//Порог срабатывания по влажности
data_out[44]=(char)(ee_H1_porog);
data_out[45]=(char)(ee_H1_porog>>8);

//if(ee_H1_logic!=1)ee_H1_logic=1;
//Логика работы порога по влажности
data_out[46]=ee_H1_logic&0x03;
//Включенность-выключенность отсылки трапов по возникновению  и снятию аварии датчика влажности
data_out[46]+=(ee_hummidity_trap_send_av&0x01)<<2;
data_out[46]+=(ee_hummidity_trap_send_no_av&0x01)<<3;
//Статус аварийности датчика влажности
data_out[46]+=(hummidity_alarm_stat&0x01)<<4;


//Температура внешнего датчика
data_out[47]=(char)(T2);
data_out[48]=(char)(T2>>8);

//if(ee_T2_porog1!=-18)ee_T2_porog1=-18;
//if(ee_T2_porog2!=-19)ee_T2_porog2=-19;
//Температура внешнего датчика пороги 
data_out[49]=(char)(ee_T2_porog1);
data_out[50]=(char)(ee_T2_porog1>>8);
data_out[51]=(char)(ee_T2_porog2);
data_out[52]=(char)(ee_T2_porog2>>8);

//Логика работы порогов по внешней температуре
data_out[53]=ee_T2_logic1&0x03;
data_out[53]+=(ee_T2_logic2&0x03)<<2;
//Включенность выключенность отсылки трапов по внешней температуре
data_out[53]+=(ee_T2_trap_send_av_1&0x01)<<4;
data_out[53]+=(ee_T2_trap_send_no_av_1&0x01)<<5;
data_out[53]+=(ee_T2_trap_send_av_2&0x01)<<6;
data_out[53]+=(ee_T2_trap_send_no_av_2&0x01)<<7;



/*
//Включенность-выключенность отсылки трапов по возникновению  и снятию аварии датчика влажности
if(ee_hummidity_trap_send_av==htsON)data_out[42]|=(1<<0);
else data_out[42]&=~(1<<0);

if(ee_hummidity_trap_send_no_av==htsON)data_out[42]|=(1<<1);
else data_out[42]&=~(1<<1);*/

}

//-----------------------------------------------
void trap_send(char par1,short par2)
{
//par1 - старшие 3 бита - тип ус-ва, вызвавшего трап
	//1(<<5) - логические входы
	//3(<<5) - датчики температуры
	//4(<<5) - датчик влажности
//par1 - биты 4,3,2 (счет с нуля) - номер ус-ва, вызвавшего трап(всегда с 1)
//par1 - бит 0 - снятие(0), возникновение(1) аварии
//par2 - данные на передачу, показания датчика

puart_out (4,100,par1,(char)par2,(char)(par2>>8),0,0);
}


//-----------------------------------------------
void hummidity_drv(void)
{
char i,temp,temp1;


if(ee_H1_logic==hlOFF)
	{
	hummidity_alarm_stat=hasOFF;
	hummidity_alarm_cnt=0;
	}
else if(ee_H1_logic==hlNT)
	{
	if(H1>(ee_H1_porog+3))hummidity_alarm_cnt++;
	else if(H1<(ee_H1_porog-3))hummidity_alarm_cnt--;
	}
else if(ee_H1_logic==hlNB)
	{
	if(H1>(ee_H1_porog+3))hummidity_alarm_cnt--;
	else if(H1<(ee_H1_porog-3))hummidity_alarm_cnt++;
	}
/*if(H1_porog_cnt>100)H1_porog_cnt=100;
if(H1_porog_cnt<0)H1_porog_cnt=0;

if(H1_porog_cnt>95)T1_status1=1;
if(H1_porog_cnt<5)T1_status1=0;*/

/*if(H1>ee_H1_porog)hummidity_alarm_cnt++;
else hummidity_alarm_cnt--;*/

gran_char(&hummidity_alarm_cnt,-30,30);
if(hummidity_alarm_cnt<-28)hummidity_alarm_stat=hasOFF;
else if (hummidity_alarm_cnt>28)hummidity_alarm_stat=hasON;
	

if(hummidity_alarm_stat_old!=hummidity_alarm_stat)
	{
	if((hummidity_alarm_stat==hasON) && (ee_hummidity_trap_send_av==htsON)) trap_send((4<<5)+(1<<2)+1,H1);
	else if((hummidity_alarm_stat==hasOFF) && (ee_hummidity_trap_send_no_av==htsON))trap_send((4<<5)+(1<<2)+0,H1);
	}

hummidity_alarm_stat_old=hummidity_alarm_stat;

}



//-----------------------------------------------
void temper_drv(void)
{

//по внутренней температуре
if(ee_T1_logic1==tlOFF)
	{
	T1_status1=0;
	T1_porog1_cnt=0;
	}
else if(ee_T1_logic1==tlNW)
	{
	if(T1>(ee_T1_porog1+1))T1_porog1_cnt++;
	else if(T1<(ee_T1_porog1-1))T1_porog1_cnt--;
	}
else if(ee_T1_logic1==tlNC)
	{
	if(T1>(ee_T1_porog1+1))T1_porog1_cnt--;
	else if(T1<(ee_T1_porog1-1))T1_porog1_cnt++;
	}
if(T1_porog1_cnt>100)T1_porog1_cnt=100;
if(T1_porog1_cnt<0)T1_porog1_cnt=0;

if(T1_porog1_cnt>95)T1_status1=1;
if(T1_porog1_cnt<5)T1_status1=0;


if(ee_T1_logic2==tlOFF)
	{
	T1_status2=0;
	T1_porog2_cnt=0;
	}
else if(ee_T1_logic2==tlNW)
	{
	if(T1>(ee_T1_porog2+1))T1_porog2_cnt++;
	else if(T1<(ee_T1_porog2-1))T1_porog2_cnt--;
	}
else if(ee_T1_logic2==tlNC)
	{
	if(T1>(ee_T1_porog2+1))T1_porog2_cnt--;
	else if(T1<(ee_T1_porog2-1))T1_porog2_cnt++;
	}
if(T1_porog2_cnt>100)T1_porog2_cnt=100;
if(T1_porog2_cnt<0)T1_porog2_cnt=0;

if(T1_porog2_cnt>95)T1_status2=1;
if(T1_porog2_cnt<5)T1_status2=0;


if(T1_status1_old!=T1_status1)
	{
	if((T1_status1==1)&&(ee_T1_trap_send_av_1==ttsON))
		{
		trap_send((3<<5)+(1<<2)+1,T1);
		}
	else if((T1_status1==0)&&(ee_T1_trap_send_no_av_1==ttsON))
		{
		trap_send((3<<5)+(1<<2)+0,T1);
		}
	}

if(T1_status2_old!=T1_status2)
	{
	if((T1_status2==1)&&(ee_T1_trap_send_av_2==ttsON))
		{
		trap_send((3<<5)+(2<<2)+1,T1);
		}
	else if((T1_status2==0)&&(ee_T1_trap_send_no_av_2==ttsON))
		{
		trap_send((3<<5)+(2<<2)+0,T1);
		}
	}

T1_status1_old=T1_status1;
T1_status2_old=T1_status2;



//по внешней температуре
if(ee_T2_logic1==tlOFF)
	{
	T2_status1=0;
	T2_porog1_cnt=0;
	}
else if(ee_T2_logic1==tlNW)
	{
	if(T2>(ee_T2_porog1+1))T2_porog1_cnt++;
	else if(T2<(ee_T2_porog1-1))T2_porog1_cnt--;
	}
else if(ee_T2_logic1==tlNC)
	{
	if(T2>(ee_T2_porog1+1))T2_porog1_cnt--;
	else if(T2<(ee_T2_porog1-1))T2_porog1_cnt++;
	}
if(T2_porog1_cnt>100)T2_porog1_cnt=100;
if(T2_porog1_cnt<0)T2_porog1_cnt=0;

if(T2_porog1_cnt>95)T2_status1=1;
if(T2_porog1_cnt<5)T2_status1=0;


if(ee_T2_logic2==tlOFF)
	{
	T2_status2=0;
	T2_porog2_cnt=0;
	}
else if(ee_T2_logic2==tlNW)
	{
	if(T2>(ee_T2_porog2+1))T2_porog2_cnt++;
	else if(T2<(ee_T2_porog2-1))T2_porog2_cnt--;
	}
else if(ee_T2_logic2==tlNC)
	{
	if(T2>(ee_T2_porog2+1))T2_porog2_cnt--;
	else if(T2<(ee_T2_porog2-1))T2_porog2_cnt++;
	}
if(T2_porog2_cnt>100)T2_porog2_cnt=100;
if(T2_porog2_cnt<0)T2_porog2_cnt=0;

if(T2_porog2_cnt>95)T2_status2=1;
if(T2_porog2_cnt<5)T2_status2=0;


if(T2_status1_old!=T2_status1)
	{
	if((T2_status1==1)&&(ee_T2_trap_send_av_1==ttsON))
		{
		trap_send((3<<5)+(3<<2)+1,T2);
		}
	else if((T2_status1==0)&&(ee_T2_trap_send_no_av_1==ttsON))
		{
		trap_send((3<<5)+(3<<2)+0,T2);
		}
	}

if(T2_status2_old!=T2_status2)
	{
	if((T2_status2==1)&&(ee_T2_trap_send_av_2==ttsON))
		{
		trap_send((3<<5)+(4<<2)+1,T2);
		}
	else if((T2_status2==0)&&(ee_T2_trap_send_no_av_2==ttsON))
		{
		trap_send((3<<5)+(4<<2)+0,T2);
		}
	}

T2_status1_old=T2_status1;
T2_status2_old=T2_status2;




}




//-----------------------------------------------
void log_in_drv(void)
{
char i,temp,temp1;


GPIOB->DDR&=~(1<<2);
GPIOB->CR1|=(1<<2);
GPIOB->CR2&=~(1<<2);	

GPIOB->DDR&=~(1<<3);
GPIOB->CR1|=(1<<3);
GPIOB->CR2&=~(1<<3);

GPIOC->DDR&=~(1<<1);
GPIOC->CR1|=(1<<1);
GPIOC->CR2&=~(1<<1);

GPIOC->DDR&=~(1<<2);
GPIOC->CR1|=(1<<2);
GPIOC->CR2&=~(1<<2);

GPIOC->DDR&=~(1<<3);
GPIOC->CR1|=(1<<3);
GPIOC->CR2&=~(1<<3);

GPIOC->DDR&=~(1<<4);
GPIOC->CR1|=(1<<4);
GPIOC->CR2&=~(1<<4);

temp=0;
if(!(GPIOB->IDR&(1<<2))) temp|=(1<<0);
if(!(GPIOB->IDR&(1<<3))) temp|=(1<<1);
if(!(GPIOC->IDR&(1<<1))) temp|=(1<<2);
if(!(GPIOC->IDR&(1<<2))) temp|=(1<<3);
if(!(GPIOC->IDR&(1<<3))) temp|=(1<<4);
if(!(GPIOC->IDR&(1<<4))) temp|=(1<<5);


for(i=0;i<8;i++)
	{
	if(temp&(1<<i))log_in_cnt[i]++;
	else log_in_cnt[i]--;
	gran_char(&log_in_cnt[i],-10,10);
	if(log_in_cnt[i]<-7)log_in_stat[i]=lisOFF;
	else if (log_in_cnt[i]>7)log_in_stat[i]=lisON;
	}

for(i=0;i<8;i++)
	{
	if( 
		( (log_in_stat[i]==lisON) && (ee_log_in_stat_of_av[i]==lisoaON) )
		||
		( (log_in_stat[i]==lisOFF) && (ee_log_in_stat_of_av[i]==lisoaOFF) )
	  )	log_in_av_stat[i]=liasON;
	else log_in_av_stat[i]=liasOFF;
	}

for(i=0;i<8;i++)
	{
	if(log_in_av_stat_old[i]!=log_in_av_stat[i])
		{
		//trap_send(1,3,i);
		if((log_in_av_stat[i]==liasON) && (ee_log_in_trap_send_av[i]==litsON)) trap_send((1<<5)+((i+1)<<2)+1,log_in_stat[i]);
		else if((log_in_av_stat[i]==liasOFF) && (ee_log_in_trap_send_no_av[i]==litsON)) trap_send((1<<5)+((i+1)<<2)+0,log_in_stat[i]);
		}
	}

for(i=0;i<8;i++)
	{
	log_in_av_stat_old[i]=log_in_av_stat[i];
	}
temp=0;
for(i=0;i<6;i++)
	{
	if(log_in_stat[i]==lisON)temp|=(1<<i);
	}
data_for_stend_char=temp;	

}


//***********************************************
//***********************************************
//***********************************************
//***********************************************
@far @interrupt void TIM4_UPD_Interrupt (void) 
{

			//GPIOB->DDR|=(1<<3);
			//GPIOB->CR1|=(1<<3);
			//GPIOB->CR2&=~(1<<3);	
			//GPIOB->ODR|=(1<<3);	
bPUART_TX=1;

if(tx_stat_cnt)
	{
	tx_stat_cnt--;
	if(tx_stat_cnt==0)tx_stat=tsOFF;
	
	}
	if(++t0_cnt0>=10){
    		t0_cnt0=0;
    		b100Hz=1;

		if(++t0_cnt1>=10){
			t0_cnt1=0;
			b10Hz=1;
		}
		
		if(++t0_cnt2>=20){
			t0_cnt2=0;
			b5Hz=1;
		}
		
		if(++t0_cnt4>=50)
			{
			t0_cnt4=0;
			b2Hz=1;
			}
		
		if(++t0_cnt3>=100){
			t0_cnt3=0;
			b1Hz=1;
		}
	}

	TIM4->SR1&=~TIM4_SR1_UIF;			// disable break interrupt
	
	//ADC1->CR1|=1;
//GPIOD->ODR^=(1<<0);	
			//GPIOB->DDR|=(1<<3);
			//GPIOB->CR1|=(1<<3);
			//GPIOB->CR2&=~(1<<3);	
			//GPIOB->ODR&=~(1<<3);

if(tx_wd_cnt)
	{
	tx_wd_cnt--;

	}
else 
	{
	GPIOD->ODR&=~(1<<4);
	}


	return;
}

//***********************************************
@far @interrupt void UARTTxInterrupt (void) 
{
if (tx_counter)
	{
   	--tx_counter;
	UART2->DR=tx_buffer[tx_rd_index];
	if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
      
    	tx_wd_cnt=3;
	}
else 
	{
	//GPIOD->ODR&=~(1<<4);	
	tx_stat_cnt=3;
	//tx_stat=tsOFF;

		bOUT_FREE=1;
		UART2->CR2&= ~UART1_CR2_TIEN;
	}

}

//***********************************************
@far @interrupt void UARTRxInterrupt (void) 
{
@near char temp,rx_status,rx_data;

rx_status=UART2->SR;
rx_data=UART2->DR;

if (rx_status & (UART1_SR_RXNE))
{

temp=rx_data;
if(tx_stat==tsOFF)
	{
	gran_char(&rx_wr_index,0,RX_BUFFER_SIZE); 
	rx_buffer[rx_wr_index]=temp;
	if(rx_read_power_102m_phase==0)
	  	{
		if(temp==0xc0)
			{
			//sleep_plazma++;
			if(rx_wr_index>1)
				{
				@near signed char i_,begin_i;
				for(i_=rx_wr_index-1;i_>=0;i_--)
					{
					if(rx_buffer[i_]==0xc0)
						{
						begin_i=i_;
						sleep_len=rx_wr_index-begin_i+1;
						//sleep_plazma=sleep_len;
						for(i_=0;i_<=(rx_wr_index-begin_i);i_++)
							{
							sleep_buff[i_]=rx_buffer[begin_i+i_];
							}
						sleep_in=1;
						rx_wr_index=0;
						
						break;
						}
					}
				}
			}
		}
	else if(rx_read_power_102m_phase==1)
		{
		if((rx_buffer[rx_wr_index]==0x0a)&&(rx_buffer[6]==0xc5))
			{
			rx_read_power_102m_phase=2;
			}
		}
	else if(rx_read_power_102m_phase==3)
		{
		if((rx_buffer[rx_wr_index]==0x03)&&(rx_buffer[0]==0x81))
			{
			rx_read_power_102m_phase=4;
			}
		}
	else if(rx_read_power_102m_phase==4)
		{
		//if((rx_buffer[rx_wr_index]==0x03)&&(rx_buffer[0]==0x81))
			{
			rx_read_power_102m_phase=5;
			}
		}
	else if(rx_read_power_102m_phase==6)
		{
		if(((rx_buffer[rx_wr_index]&0x7f)=='(')/*&&(rx_buffer[0]==0x81)*/)
			{
			rx_read_power_102m_phase=7;
			}
		}	
	else if(rx_read_power_102m_phase==7)
		{
		if(((rx_buffer[rx_wr_index]&0x7f)==')')/*&&(rx_buffer[0]==0x81)*/)
			{
			rx_read_power_102m_phase=8;
			}
		}
		
	else if(rx_read_power_102m_phase==8)
		{
		if(((rx_buffer[rx_wr_index]&0x7f)==0x03)/*&&(rx_buffer[0]==0x81)*/)
			{
			rx_read_power_102m_phase=9;
			}
		}
	else if(rx_read_power_102m_phase==9)
		{
		//if((rx_buffer[rx_wr_index]==0x03)&&(rx_buffer[0]==0x81))
			{
			rx_read_power_102m_phase=10;
			}
		}		
		if(temp==0xca)
			{
			char temp_rx_wr_index;
			
			temp_rx_wr_index=rx_wr_index;
			temp_rx_wr_index-=5;
			if(temp_rx_wr_index<0) temp_rx_wr_index+=RX_BUFFER_SIZE;
			if(rx_buffer[temp_rx_wr_index]==0xac)
				{
				bTRANSMIT_TO_STEND=1;
				power_cnt_block=30;
				}
			/*temp_rx_wr_index++;
				if(temp_rx_wr_index>=RX_BUFFER_SIZE1) temp_rx_wr_index-=RX_BUFFER_SIZE1;
				KO5_flags=rx_buffer1[temp_rx_wr_index];
	
				temp_rx_wr_index++;
				if(temp_rx_wr_index>=RX_BUFFER_SIZE1) temp_rx_wr_index-=RX_BUFFER_SIZE1;
				temp_data_l=rx_buffer1[temp_rx_wr_index];
	
				temp_rx_wr_index++;
				if(temp_rx_wr_index>=RX_BUFFER_SIZE1) temp_rx_wr_index-=RX_BUFFER_SIZE1;
				temp_data_h=rx_buffer1[temp_rx_wr_index];
	
				KO5_data= (short)(temp_data_h*256) + (short)(temp_data_l);*/
	
			}
		

	rx_wr_index++;

	}
}


}

//***********************************************
@far @interrupt void ADC_EOC_Interrupt (void) {

signed long temp_adc;


		GPIOA->DDR|=(1<<1);
		GPIOA->CR1|=(1<<1);
		GPIOA->CR2&=~(1<<1);	
		GPIOA->ODR|=(1<<1);

ADC1->CSR&=~(1<<7);

temp_adc=(((signed long)(ADC1->DRH))*256)+((signed long)(ADC1->DRL));

//temp_adc=4000;
//temp_adc=720;


adc_buff[adc_ch][adc_cnt]=temp_adc;

//adc_plazma=ADC1->DR;
//if(adc_ch==0)adc_plazma_short=temp_adc;

adc_ch++;
if(adc_ch>=2)
	{


	adc_plazma++;
	adc_ch=0;
	adc_cnt++;
	if(adc_cnt>=16)
		{
		adc_cnt=0;
		}
	}

if((adc_cnt&0x03)==0)
	{
	signed long tempSS;
	char i;
	tempSS=0;
		

	
	for(i=0;i<16;i++)
		{
		tempSS+=(signed long)adc_buff[adc_ch][i];
		}
	if(adc_ch==0)adc_buff_[adc_ch]=(signed short)(tempSS>>2);
	else adc_buff_[adc_ch]=(signed short)(tempSS>>4);
	}

//adc_buff_[adc_ch]=adc_ch*10;

//GPIOD->ODR&=~(1<<0);

//ADC1->CR1&=~(1<<0);

adc_plazma_short=adc_buff_[1];

/*
adcw[0]=(ADC1->DB0RL)+((ADC1->DB0RH)*256);
adcw[1]=(ADC1->DB1RL)+((ADC1->DB1RH)*256);
adcw[2]=(ADC1->DB2RL)+((ADC1->DB2RH)*256);*/




GPIOD->ODR|=(1<<0);


	
		GPIOA->ODR&=~(1<<1);
}

//***********************************************
@far @interrupt void PORTD_Interrupt (void)
{
char pin_temp;




pin_temp=GPIOD->IDR&0x0f;
//pin_temp&=0xf3;
//pin_temp|=0x04;
data_temp=(pin_temp&0x0c)>>2;
control_temp=(pin_temp&0x03);

//puart_data_temp&=(0x03<<(control_temp*2));
puart_data_temp|=(data_temp<<(control_temp*2));
//puart_data_temp|=(0x01<<(control_temp));
//puart_data_temp=0x0a;
if(control_temp==0x03)
	{
//puart_data_temp=0x0a;
//UART2->DR=puart_data_temp;
	puart_rx_buffer[puart_rx_wr_index]=puart_data_temp;
	bPUART_RXIN=1;
	puart_rx_wr_index++;
	if (puart_rx_wr_index >= PUART_RX_BUFFER_SIZE)
		{
		puart_rx_wr_index=0;


		}
	if(puart_data_temp==0x0a)
		{

		}
	puart_data_temp=0;
	}

	
 
}


//===============================================
//===============================================
//===============================================
//===============================================
main(){
	CLK->CKDIVR=0;
	FLASH_DUKR=0xae;
	FLASH_DUKR=0x56;
//ee_power_cnt_adr=1185;
//ee_impuls_per_kwatt=3579;
ee_reset_cnt++;
if(ee_reset_cnt>=10000)ee_reset_cnt=0;

	//delay_ms(100);
	//delay_ms(100);
	t4_init();
	
//	t2_init();
	

	
	//GPIOD->DDR|=(1<<5);
	//GPIOD->CR1=0xff;
	//GPIOD->CR2=0;
//	dumm[1]++;

	p_uart_rx_init();
	p_uart_tx_init();	
	uart_init();

	power_summary_impuls_cnt=ee_power_summary_impuls_cnt;

		//ee_H1_porog=321;

	if(ee_T1_koef>1035)ee_T1_koef=1035;
	if(ee_T1_koef<1005)ee_T1_koef=1005;
			
	adc_init();

	enableInterrupts();	
	//ee_power_cnt_adr=12345;

/*ee_T1_logic1=2;
ee_T1_logic2=3;
ee_T2_logic1=2;
ee_T2_logic2=3;*/
	
while (1)
	{
	if(bTRANSMIT_TO_STEND)
		{
		for_stend_out(data_for_stend_char,adc_buff_[1]/*data_for_stend_short0*/,adc_buff_[0]/*data_for_stend_short1*/);	
		bTRANSMIT_TO_STEND=0;	
		}
     if(sleep_in) 
		{
          sleep_in=0;
          sleep_an();
          }
	if(bPUART_RXIN)
		{
		bPUART_RXIN=0;
		puart_uart_in();
		}
	if(bPUART_TX)
		{
		bPUART_TX=0;
		puart_tx_drv();
		}		
		//GPIOC->DDR|=(1<<5);
		//GPIOC->CR1|=(1<<5);
		//GPIOC->CR2&=~(1<<5);
		//GPIOC->ODR^=(1<<5);
	
		//uart_out (4,CMND,21,22/*current_page%256*/,23/*current_page/256/*/,0,0);
				//delay_ms(50);
		if(bRXIN)	{
			bRXIN=0;
			
			//uart_in();
		} 	
		
		
	if(b100Hz)
		{
		b100Hz=0;

		


		impuls_meter();
read_power_102m_drv();		
      	}  
      	
	if(b10Hz)
		{
		b10Hz=0;
			
		log_in_drv();
		//uart_out (7,CMND,rs_data[0],rs_data[1],rs_data[2],rs_data[3],rs_data[4],rs_data[5],0);	
		hummidity_drv();
		temper_drv();
		/*GPIOA->DDR|=(1<<1);
		GPIOA->CR1|=(1<<1);
		GPIOA->CR2&=~(1<<1);	
		GPIOA->ODR^=(1<<1);*/
		adc_init();
      	}
      	
	if(b2Hz)
		{
		b2Hz=0;
		
		matemat();

		data_out_hndl();
		
		puart_out_adr (data_out,60);
		
		//for_stend_out(abc_char++,abc_short+=13);

		}
      	
	if(b1Hz)
		{
		b1Hz=0;
		
		pavl++;
		
		if(main_cnt<1000) main_cnt++;
	
		ee_reset_cnt_++;
		
		GPIOF->DDR|=(1<<4);
		GPIOF->CR1|=(1<<4);
		GPIOF->CR2&=~(1<<4);	
		
		if(main_cnt<7)GPIOF->ODR&=~(1<<4);
		else GPIOF->ODR^=(1<<4);	
			
		if(power_cnt_block)power_cnt_block--;
		else
			{

			if(!ppp_cnt)
				{
				power_cnt_adrl=(char)ee_power_cnt_adr;
				power_cnt_adrh=(char)(ee_power_cnt_adr>>8);
				//read_summary_power();
				ppp_cnt=1;
				}
			else if(ppp_cnt==1)
				{
				//read_current_power();
				ppp_cnt=2;
				}
			
			else if(ppp_cnt==2)
				{
				read_power_102m();
				ppp_cnt=3;
				}
			else 
				{
				ppp_cnt=0;
				}			
			
			}	
//trap_send((1<<5)+((0+1)<<2)+1,log_in_stat[0]);
		//trap_send((3<<5)+(1<<2)+1,T1);
      	}
	
	}
}