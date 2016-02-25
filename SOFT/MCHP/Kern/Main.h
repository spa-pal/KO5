/*********************************************************************
 *
 *                  Headers for CheapLAN App
 *
 *********************************************************************
 * FileName:        Main.h
 * Dependencies:    Compiler.h
 * Processor:       PIC18, PIC24F, PIC24H, dsPIC30F, dsPIC33F, PIC32
 * Compiler:        Microchip C32 v1.05 or higher
 *                  Microchip C30 v3.12 or higher
 *                  Microchip C18 v3.30 or higher
 *                  HI-TECH PICC-18 PRO 9.63PL2 or higher
 * Company:         Triada-TV/CDT
 *
 *
 * Author               Date    Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Vadim Zaytsev    28/12/2010  Copied from Main.c
 ********************************************************************/
#ifndef _MAIN_H
#define _MAIN_H


void SaveAppConfig(APP_CONFIG *pAppConfig);



#define YEAR ((((__DATE__ [7] - '0') * 10 + (__DATE__ [8] - '0')) * 10 \
+ (__DATE__ [9] - '0')) * 10 + (__DATE__ [10] - '0'))

#define YEAR_M (__DATE__ [7] - '0')  * 10 + (__DATE__ [ 8] - '0') 
#define YEAR_L (__DATE__ [9] - '0')  * 10 + (__DATE__ [10] - '0')

#define MONTH (__DATE__ [2] == 'n' ? (__DATE__ [1] == 'a' ? 1 : 6) \
: __DATE__ [2] == 'b' ? 2 \
: __DATE__ [2] == 'r' ? (__DATE__ [0] == 'M' ? 3 : 4) \
: __DATE__ [2] == 'y' ? 5 \
: __DATE__ [2] == 'l' ? 7 \
: __DATE__ [2] == 'g' ? 8 \
: __DATE__ [2] == 'p' ? 9 \
: __DATE__ [2] == 't' ? 10 \
: __DATE__ [2] == 'v' ? 11 : 12)

#define DAY ((__DATE__ [4] == ' ' ? 0 : __DATE__ [4] - '0') * 10 \
+ (__DATE__ [5] - '0'))

#define DATE_AS_INT (((YEAR - 2000) * 12 + MONTH) * 31 + DAY)


// Define a header structure for validating the AppConfig data structure in EEPROM/Flash
typedef struct
{
    unsigned short wConfigurationLength;    // Number of bytes saved in EEPROM/Flash (sizeof(APP_CONFIG))
    unsigned short wOriginalChecksum;       // Checksum of the original AppConfig defaults as loaded from ROM (to detect when to wipe the EEPROM/Flash record of AppConfig due to a stack change, such as when switching from Ethernet to Wi-Fi)
    unsigned short wCurrentChecksum;        // Checksum of the current EEPROM/Flash data.  This protects against using corrupt values if power failure occurs while writing them and helps detect coding errors in which some other task writes to the EEPROM in the AppConfig area.
} NVM_VALIDATION_STRUCT;


typedef struct
{
    struct
    {
        unsigned char               : 6;
        unsigned char LedAShortLow  : 1;
        unsigned char LedBShortLow  : 1;
    } LedsErrors;
    
    struct
    {
        unsigned char             : 3;
        unsigned char RxShortLow  : 1;
        unsigned char RxAShortHi  : 1;
        unsigned char TxShortLow  : 1;
        unsigned char TxShortHi   : 1;
        unsigned char RxAShortTx  : 1;
    } UartErrors; 

    struct
    {
        unsigned char : 1;
        unsigned char SclNoPullUp   : 1;
        unsigned char SdaNoPullUp   : 1;

        unsigned char SclShortLow   : 1;
        unsigned char SdaShortLow   : 1;

        unsigned char SclAShortHi   : 1;
        unsigned char SdaShortHi    : 1;

        unsigned char SclAShortSda  : 1;
    } I2cErrors; 
      
} HARD_ERR;


typedef struct
{
    DWORD_VAL   OldIP;              // IP адрес до сброса
    BYTE        OldDhcpStatus;      // статус DHCP до сброса
    BYTE        IsReset;            // Флаг сброса 
} HDWR_RST_STATUS;


HDWR_RST_STATUS GetHarwareResetStatus(void);            // Запрос структуры состояния аппаратного сброса IP
void            I2C_Fail_Timeout(void);

void SNMPSendTrap(void);


#endif // _MAIN_H
