/*********************************************************************
 *
 *                  Data EEPROM Emulation
 *
 *********************************************************************
 * FileName:        Main.h
 * Dependencies:    Compiler.h
 * Processor:       PIC18, PIC24F, PIC24H, dsPIC30F, dsPIC33F, PIC32
 * Compiler:        Microchip C32 v1.05 or higher
 *					Microchip C30 v3.12 or higher
 *					Microchip C18 v3.30 or higher
 *					HI-TECH PICC-18 PRO 9.63PL2 or higher
 * Company:         Triada-TV/CDT
 *
 *
 * Author               Date    Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Vadim Zaytsev	28/12/2010  Copied from Main.c
 ********************************************************************/

#include "TCPIP Stack/TCPIP.h"
#include "deeprom.h"

#if defined(DEEPROM)

	#define	DEEPROM_ADDR				0x2000UL 
	#define DEEPROM_CLUSTER_SIZE		0x40
	
	
	#pragma romdata EEPROM_SECTOR = DEEPROM_ADDR
	const rom char EEPROM[1024];
	#pragma romdata
	
	void DEEPROM_Write(void);


	
	BYTE DEEPROM_WriteArray (BYTE* Data, BYTE DataLength)
	{
		BYTE 		write_byte=0,flag=0;
		DWORD_VAL 	flash_addr;
		BYTE 		i = 0;
		BYTE 		Unmatch_flag = 0;
		UINT32 		startaddr = DEEPROM_ADDR;

		for (i = 0; i < DataLength; i++)
			if (EEPROM[i] != *(Data + i))
				Unmatch_flag = 1;
	
		if(!Unmatch_flag)
			return 1;
		
		DEEPROM_Erase();

		flash_addr.Val = DEEPROM_ADDR;

		startaddr /= DEEPROM_CLUSTER_SIZE ;	//Allign the starting address block
		startaddr *= DEEPROM_CLUSTER_SIZE ;
		startaddr += DEEPROM_CLUSTER_SIZE ;
		
		write_byte = startaddr - flash_addr.Val;
		
		while(DataLength)
		{
			TBLPTRU = flash_addr.byte.UB;						//Load the address to Address pointer registers
			TBLPTRH = flash_addr.byte.HB;	
			TBLPTRL	= flash_addr.byte.LB;
			
			
			while(write_byte--)
			{
				TABLAT = *Data++;
				_asm  TBLWTPOSTINC 	_endasm
				if(--DataLength==0)	
					break;
			}

			TBLPTRU = flash_addr.byte.UB;						//Load the address to Address pointer registers
			TBLPTRH = flash_addr.byte.HB;	
			TBLPTRL	= flash_addr.byte.LB;

			//*********** Flash write sequence ***********************************
			EECON1bits.WREN = 1;
			if(INTCONbits.GIE)
			{
				INTCONbits.GIE = 0;
				flag=1;
			}		  
			EECON2 = 0x55;
			EECON2 = 0xAA;
			EECON1bits.WR =1;
			EECON1bits.WREN = 0 ; 
			if(flag)
			{
				INTCONbits.GIE = 1;	
				flag=0;
			}
			write_byte = DEEPROM_CLUSTER_SIZE;
			flash_addr.Val = flash_addr.Val + DEEPROM_CLUSTER_SIZE;
		}	

				// Проверка записи
			for (i = 0; i < DataLength; i++)
				if (EEPROM[i] != *(Data + i)) // Если ошибка - выходим с флагом ошибки
					return 0;
	
		return 1;
	}	
		


	



	void DEEPROM_ReadArray (BYTE StartIndex, BYTE* Data, BYTE DataLength)
	{
		
		BYTE i;

		for (i = StartIndex; i < DataLength + StartIndex; i++)
			*(Data + i - StartIndex) = EEPROM[i];
	}	
	
	
	
	void DEEPROM_Erase(void)
	{
		unsigned char flag=0;
		DWORD_VAL flash_addr;
		
		flash_addr.Val = DEEPROM_ADDR;
			
		TBLPTRU = flash_addr.byte.UB;						//Load the address to Address pointer registers
		TBLPTRH = flash_addr.byte.HB;	
		TBLPTRL	= flash_addr.byte.LB;
		//*********Flash Erase sequence*****************
		EECON1bits.WREN = 1;
		EECON1bits.FREE = 1;
		if(INTCONbits.GIE)
		{
			INTCONbits.GIE = 0;
			flag=1;
		}
		EECON2 = 0x55;
		EECON2 = 0xAA;
		EECON1bits.WR = 1;
		if(flag)
			INTCONbits.GIE = 1;
			
	}	

#endif

