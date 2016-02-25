#include "TCPIP Stack/TCPIP.h"
#include "I2cEEPROM.h"
#include "Main.h"

// Function prototipes
void WaitSSP(void);
void SendStart(void);
void SendStop(void);
void SendRestart(void);
char SendByte(BYTE);
char ReceiveByte(void);
void SendNack(void);
void SendAck(void);

//initialise the MSSP module
void InitI2cEeprom()
{
	MAC_I2C_EEPROM_SCL_TRIS	=   1;
	MAC_I2C_EEPROM_SDA_TRIS	=   1;
	SSPCON1					=	0b00101000;
	SSPCON2					=	0;
	SSPSTAT					=	0b10000000;
	SSPADD					=	GetPeripheralClock() / I2C_SPEED;	//Fosc/(4*baud)
	PIR1bits.SSPIF			=	0;
	PIR2bits.BCLIF			=	0;
}

//Wait for the module to finish it's last action.
void WaitSSP()
{
	UINT32 t = TickGet();

	while (PIR1bits.SSPIF == 0)
	{
		// 100 ms таймаут
		if(TickGet() - t >= TICK_SECOND/10ul)
		{	
			I2C_Fail_Timeout();				
		}

		Nop();
		Nop();	// Для уменьшения энергопотребления
		Nop();		
	}

	
	PIR1bits.SSPIF = 0;
}

//send start bit
void SendStart()
{
	SSPCON2bits.SEN = 1;
	WaitSSP();
}

//Send stop bit.
void SendStop()
{
	SSPCON2bits.PEN=1;
	WaitSSP();
}

//Send restart bit
void SendRestart()
{
	SSPCON2bits.RSEN = 1;
	WaitSSP();
}

//Send byte and return ack bit - 1=Ack  0=NAck
char SendByte(BYTE Byte)
{
	SSPBUF=Byte;
	WaitSSP();
	return(!SSPCON2bits.ACKSTAT);
}

//Get a byte from the slave
char ReceiveByte()
{
	SSPCON2bits.RCEN = 1;
	WaitSSP();
	return(SSPBUF);
}

//Send a Not Acknowledge (NAck) to the slave
void SendNack()
{
	SSPCON2bits.ACKDT=1;
	SSPCON2bits.ACKEN=1;
	WaitSSP();
}

//Send an Acknowledge (Ack) to the slave
void SendAck()
{
	SSPCON2bits.ACKDT=0;
	SSPCON2bits.ACKEN=1;
	WaitSSP();
}

//Sends the start and device address.
//If the device is busy then it resends until accepted.
void SendID(BYTE DeviceID)
{
	SendStart();
	if (SendByte(DeviceID)==1)
		return;
	do
	{
		SendRestart();
	}
	while (SendByte(DeviceID)==0);
}

//Write a byte to 24AA02E48
BYTE EEPROM_WriteByte(BYTE Address, BYTE Byte)
{
	SendID(0b10100000);
	if (SendByte(Address)==0)
		return(0);
	if (SendByte(Byte)==0)
		return(0);
	SendStop();
	return(1);
}

//Read a byte from a 24AA02E48
BYTE EEPROM_ReadByte(BYTE Address)
{
	char Byte;
	SendID(0b10100000);
	if (SendByte(Address)==0)
		return(0);
	SendRestart();
	if (SendByte(0b10100001)==0)
		return(0);
	Byte=ReceiveByte();
	SendNack();
	SendStop();
	return(Byte);
}


// Читаем MAC адрес
void EEPROM_ReadMAC (BYTE *mac)
{
	BYTE c;

	// 6 байт MAC адреса лежат в верхних ячейках памяти (0xFA...0xFF) для 24AA02E48
	for (c = 0; c < 6; c++)
		*(mac + c) = EEPROM_ReadByte(c + 0xFA);	
}	


// Тест чтения
BYTE EEPROM_READ_TEST()
{
	// Читаем и сравниваем первые три байта MAC адреса, они константа для микрочипа
	if(EEPROM_ReadByte(0xFA) == 0x00)	return 0; 
	if(EEPROM_ReadByte(0xFB) == 0x04)	return 0;
	if(EEPROM_ReadByte(0xFC) == 0xA3)	return 0;

	return 1;
}


BYTE EEPROM_WriteArray (BYTE StartIndex, BYTE* Data, BYTE DataLength)
{
	BYTE i = 0;
	
	// Запись 
	for (i = StartIndex; i < DataLength + StartIndex; i++)	
		EEPROM_WriteByte(i, *(Data + i - StartIndex));		
	
	// Проверка
	for (i = StartIndex; i < DataLength + StartIndex; i++)
		if(*(Data + i - StartIndex) != EEPROM_ReadByte(i))
			return 0;

	return 1;
}	
	
	

void EEPROM_ReadArray (BYTE StartIndex, BYTE* Data, BYTE DataLength)
{
	BYTE i;

	for (i = StartIndex; i < DataLength +StartIndex ; i++)
		*(Data + i - StartIndex) = EEPROM_ReadByte(i);	
}	
