#ifndef I2C_EEPROM
#define I2C_EEPROM

#include "TCPIP Stack/TCPIP.h"
#include "Main.h"
#include "deeprom.h"

#define I2C_SPEED 400000ul

extern void InitI2cEeprom(void);

extern char EEPROM_WriteByte(BYTE,BYTE);
extern char EEPROM_ReadByte(BYTE);
extern void EEPROM_ReadMAC (BYTE *mac);
extern BYTE EEPROM_READ_TEST(void);
extern BYTE EEPROM_WriteArray (BYTE StartIndex, BYTE* Data, BYTE DataLength);
extern void EEPROM_ReadArray (BYTE StartIndex, BYTE* Data, BYTE DataLength);

#endif


