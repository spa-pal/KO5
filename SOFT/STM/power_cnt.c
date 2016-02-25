#include "stm8s.h"
#include <iostm8s105.h>
#include "main.h"
#include "power_cnt.h"

const unsigned char crc8tab[256] = {
0x00, 0xb5, 0xdf, 0x6a, 0x0b, 0xbe, 0xd4, 0x61, 0x16, 0xa3, 0xc9, 0x7c, 0x1d, 0xa8, 0xc2, 0x77,
0x2c, 0x99, 0xf3, 0x46, 0x27, 0x92, 0xf8, 0x4d, 0x3a, 0x8f, 0xe5, 0x50, 0x31, 0x84, 0xee, 0x5b,
0x58, 0xed, 0x87, 0x32, 0x53, 0xe6, 0x8c, 0x39, 0x4e, 0xfb, 0x91, 0x24, 0x45, 0xf0, 0x9a, 0x2f,
0x74, 0xc1, 0xab, 0x1e, 0x7f, 0xca, 0xa0, 0x15, 0x62, 0xd7, 0xbd, 0x08, 0x69, 0xdc, 0xb6, 0x03,
0xb0, 0x05, 0x6f, 0xda, 0xbb, 0x0e, 0x64, 0xd1, 0xa6, 0x13, 0x79, 0xcc, 0xad, 0x18, 0x72, 0xc7,
0x9c, 0x29, 0x43, 0xf6, 0x97, 0x22, 0x48, 0xfd, 0x8a, 0x3f, 0x55, 0xe0, 0x81, 0x34, 0x5e, 0xeb,
0xe8, 0x5d, 0x37, 0x82, 0xe3, 0x56, 0x3c, 0x89, 0xfe, 0x4b, 0x21, 0x94, 0xf5, 0x40, 0x2a, 0x9f,
0xc4, 0x71, 0x1b, 0xae, 0xcf, 0x7a, 0x10, 0xa5, 0xd2, 0x67, 0x0d, 0xb8, 0xd9, 0x6c, 0x06, 0xb3,
0xd5, 0x60, 0x0a, 0xbf, 0xde, 0x6b, 0x01, 0xb4, 0xc3, 0x76, 0x1c, 0xa9, 0xc8, 0x7d, 0x17, 0xa2,
0xf9, 0x4c, 0x26, 0x93, 0xf2, 0x47, 0x2d, 0x98, 0xef, 0x5a, 0x30, 0x85, 0xe4, 0x51, 0x3b, 0x8e,
0x8d, 0x38, 0x52, 0xe7, 0x86, 0x33, 0x59, 0xec, 0x9b, 0x2e, 0x44, 0xf1, 0x90, 0x25, 0x4f, 0xfa,
0xa1, 0x14, 0x7e, 0xcb, 0xaa, 0x1f, 0x75, 0xc0, 0xb7, 0x02, 0x68, 0xdd, 0xbc, 0x09, 0x63, 0xd6,
0x65, 0xd0, 0xba, 0x0f, 0x6e, 0xdb, 0xb1, 0x04, 0x73, 0xc6, 0xac, 0x19, 0x78, 0xcd, 0xa7, 0x12,
0x49, 0xfc, 0x96, 0x23, 0x42, 0xf7, 0x9d, 0x28, 0x5f, 0xea, 0x80, 0x35, 0x54, 0xe1, 0x8b, 0x3e,
0x3d, 0x88, 0xe2, 0x57, 0x36, 0x83, 0xe9, 0x5c, 0x2b, 0x9e, 0xf4, 0x41, 0x20, 0x95, 0xff, 0x4a,
0x11, 0xa4, 0xce, 0x7b, 0x1a, 0xaf, 0xc5, 0x70, 0x07, 0xb2, 0xd8, 0x6d, 0x0c, 0xb9, 0xd3, 0x66 };


char tx_wd_cnt=100;

unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
//char rx_buffer1[RX_BUFFER_SIZE1];
//char tx_buffer1[TX_BUFFER_SIZE1];

tx_stat_enum tx_stat=tsOFF;

char sleep_buff[50];
char sleep_in;
char sleep_len;
char sleep_plazma;


//char power_cnt_adrl,power_cnt_adrh;

@near char rx_read_power_102m_phase;

//-----------------------------------------------
char power_cnt_crc(char* adr, char len)
{
char r,j;


r=0;
for(j=1;j<len;j++)
	{
	r=crc8tab[r^adr[j]];
	}
    
/*
adr++;
r=*adr;

for(j=2;j<len;j++)
	{
     adr++;
	r=((*adr)^crc8tab[r]);
	}
*/

return r;	
} 


//-----------------------------------------------
void uart_out_adr(char *ptr, char len)
{
@near char UOB[110];
@near char i,t=0;

for(i=0;i<len;i++)
	{
	UOB[i]=ptr[i];
	}
	

GPIOD->ODR|=(1<<4);

tx_stat=tsON;

for (i=0;i<len;i++)
	{
	putchar(UOB[i]);
	}   
}

//-----------------------------------------------
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
///#asm("cli")
if (tx_counter || ((UART2->SR & UART2_SR_TXE)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else UART2->DR=c;

UART2->CR2|= UART2_CR2_TIEN;
}


//-----------------------------------------------
void read_power_102m(void)
{
char command_with_crc[20];

command_with_crc[0]=0xaf;  // /
command_with_crc[1]=0x3f;  // ?
command_with_crc[2]=0x21;  // !
command_with_crc[3]=0x8d;  // CR
command_with_crc[4]=0x0a;  // LF

uart_out_adr(command_with_crc,5);

//rx_wr_index=0;
rx_read_power_102m_phase=1;
rx_wr_index=0;	
}

//-----------------------------------------------
void read_power_102m_drv(void)
{
if (rx_read_power_102m_phase==2)
	{
	char command_with_crc[20];

	command_with_crc[0]=0x06;  //  
	command_with_crc[1]=0x30;  // 0
	command_with_crc[2]=0x35;  // 5
	command_with_crc[3]=0xb1;  // 1
	command_with_crc[4]=0x8d;  // CR
	command_with_crc[5]=0x0a;  // LF

	uart_out_adr(command_with_crc,6);

	rx_wr_index=0;
	rx_read_power_102m_phase=3;
	}
	
if (rx_read_power_102m_phase==5)
	{
	char command_with_crc[20];

	command_with_crc[0]=0x81;  //  
	command_with_crc[1]=0xD2;  // R
	command_with_crc[2]=0xb1;  // 1
	command_with_crc[3]=0x82;  // 
	command_with_crc[4]=0xC5;  // E 
	command_with_crc[5]=0xD4;  // T
	command_with_crc[6]=0x30;  // 0
	command_with_crc[7]=0x50;  // P
	command_with_crc[8]=0xC5;  // E 
	command_with_crc[9]=0x28;  // (
	command_with_crc[10]=0xA9;  // )
	command_with_crc[11]=0x03;  // 
	command_with_crc[12]=0xb7;  // bcc

	uart_out_adr(command_with_crc,13);

	rx_wr_index=0;
	rx_read_power_102m_phase=6;
	}
	
/*if (rx_read_power_102m_phase==10)
	{
	char command_with_crc[20];

	command_with_crc[0]=0x06;  //  
	command_with_crc[1]=0x30;  // 0
	command_with_crc[2]=0x35;  // 5
	command_with_crc[3]=0xb1;  // 1
	command_with_crc[4]=0x8d;  // CR
	command_with_crc[5]=0x0a;  // LF

	uart_out_adr(command_with_crc,6);

	rx_wr_index=0;
	rx_read_power_102m_phase=11;
	}*/	
	
	
if (rx_read_power_102m_phase==10)
	{
	char command_with_crc[20];

	command_with_crc[0]=0x81;  //  
	command_with_crc[1]=0xD2;  // R
	command_with_crc[2]=0xb1;  // 1
	command_with_crc[3]=0x82;  // 
	command_with_crc[4]=0x50;  // P 
	command_with_crc[5]=0xCF;  // O
	command_with_crc[6]=0xd7;  // W
	command_with_crc[7]=0xc5;  // E
	command_with_crc[8]=0x50;  // P 
	command_with_crc[9]=0x28;  // (
	command_with_crc[10]=0xA9;  // )
	command_with_crc[11]=0x03;  // 
	command_with_crc[12]=0xe4;  // bcc

	uart_out_adr(command_with_crc,13);

	rx_wr_index=0;
	rx_read_power_102m_phase=11;
	}
}

//-----------------------------------------------
void read_current_power(void)
{
char command_with_crc[20],command_with_crc_with_sleep[20],len;

command_with_crc[0]=0xc0;
command_with_crc[1]=0x48;
command_with_crc[2]=power_cnt_adrl;
command_with_crc[3]=power_cnt_adrh;
command_with_crc[4]=0;
command_with_crc[5]=0;

command_with_crc[6]=0;
command_with_crc[7]=0;
command_with_crc[8]=0;
command_with_crc[9]=0;

command_with_crc[10]=0xd0;

command_with_crc[11]=0x01;
command_with_crc[12]=0x32;

command_with_crc[13]=power_cnt_crc(command_with_crc,13);
command_with_crc[14]=0xc0;


len=sleep_coding(command_with_crc,command_with_crc_with_sleep,15);

uart_out_adr(command_with_crc_with_sleep,len);
rx_read_power_102m_phase=0;

}


//-----------------------------------------------
void read_summary_power(void)
{
char command_with_crc[20],command_with_crc_with_sleep[20],len;

command_with_crc[0]=0xc0;
command_with_crc[1]=0x48;
command_with_crc[2]=power_cnt_adrl;
command_with_crc[3]=power_cnt_adrh;
command_with_crc[4]=0;
command_with_crc[5]=0;

command_with_crc[6]=0;
command_with_crc[7]=0;
command_with_crc[8]=0;
command_with_crc[9]=0;

command_with_crc[10]=0xd1;

command_with_crc[11]=0x01;
command_with_crc[12]=0x31;

command_with_crc[13]=0x00;

command_with_crc[14]=power_cnt_crc(command_with_crc,14);
command_with_crc[15]=0xc0;


len=sleep_coding(command_with_crc,command_with_crc_with_sleep,16);

uart_out_adr(command_with_crc_with_sleep,len);
rx_read_power_102m_phase=0;

}


//-----------------------------------------------
char sleep_coding(char* adr_src,char* adr_dst,char str_len)
{
char i,new_len;

new_len=str_len;

*adr_dst=*adr_src;
adr_dst++;
adr_src++;

for(i=1;i<(str_len-1);i++)
     {
     if(*adr_src==0xc0)
          {
          *adr_dst=0xdb;
          adr_dst++;
          *adr_dst=0xdc;
          adr_dst++;
          new_len++;
          }
     else if(*adr_src==0xdb)
          {
          *adr_dst=0xdb;
          adr_dst++;
          *adr_dst=0xdd;
          adr_dst++;
          new_len++;
          }
     else
          {
          *adr_dst=*adr_src;
          adr_dst++;
          }
     adr_src++;
     }

*adr_dst=*adr_src;

return new_len;
}

//-----------------------------------------------
void sleep_an(void)
{
char i;
@near char sleep_pure_buff[50];
char *ptr;
char len_;

ptr = sleep_pure_buff;
len_=sleep_len;

//uart_plazma[0]=sleep_len;

sleep_plazma=sleep_buff[0];

for(i=0;i<sleep_len;i++)
     {
     if(sleep_buff[i]==0xdb)
          {
          if(sleep_buff[i+1]==0xdc)
               {
               *ptr=0x0c;
               i++;
               ptr++;
               len_--;
//sleep_plazma++;
               }
          else if(sleep_buff[i+1]==0xdd)
               {
               *ptr=0xdb;
               i++;
               ptr++;
//sleep_plazma++;
               len_--;
               }
          }
     else 
          {
          *ptr=sleep_buff[i];
          ptr++;
//sleep_plazma++;
          }
     }

//sleep_plazma=37;//sleep_buff[0];

//uart_plazma[0]=sleep_pure_buff[len_-2];
//sleep_plazma=sleep_pure_buff[0];
//uart_plazma[0]=power_cnt_crc(sleep_pure_buff,len_-2);
if(sleep_pure_buff[len_-2]==power_cnt_crc(sleep_pure_buff,len_-2))
     {

     if   (
          (sleep_pure_buff[1]==0x48)&&
          (sleep_pure_buff[2]==0)&&
          (sleep_pure_buff[3]==0)&&
          (sleep_pure_buff[4]==power_cnt_adrl)&&
          (sleep_pure_buff[5]==power_cnt_adrh)
          )

          {

          if   (
               (sleep_pure_buff[7]==0x01)&&
               (sleep_pure_buff[8]==0x32)
               )

               {
               //uart_plazma[0]++;
               power_current=(((short)sleep_pure_buff[9]) + (((short)sleep_pure_buff[10])<<8))*10 ;
               }

          else if   (
               (sleep_pure_buff[7]==0x01)&&
               (sleep_pure_buff[8]==0x31)
               )

               {
               //uart_plazma[0]++;
               power_summary= (
                              ((unsigned)sleep_pure_buff[9]) + 
                              (((unsigned)sleep_pure_buff[10])<<8)+ 
                              (((unsigned)sleep_pure_buff[11])<<16)+ 
                              (((unsigned)sleep_pure_buff[12])<<32)
                              ) ;
               }

          }
     
     }


}
