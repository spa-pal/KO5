/*********************************************************************
 *
 *  Hardware specific definitions for:
 *    - CheapLAN
 *    - PIC18F67J60
 *    - Internal 10BaseT Ethernet
 *
 *********************************************************************
 * FileName:        HardwareProfile.h
 * Dependencies:    Compiler.h
 * Processor:       PIC18
 * Compiler:        Microchip C18 v3.36 or higher
 * Company:         Triada-TV/CDT
 *
 * Author               Date        Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Vadim Zaytsev        27/12/2010  Special for CheapLAN
 ********************************************************************/
#ifndef HARDWARE_PROFILE_H
#define HARDWARE_PROFILE_H

#include "Compiler.h"


// Set configuration fuses (but only in Main.c where THIS_IS_STACK_APPLICATION is defined)
#if defined(THIS_IS_STACK_APPLICATION)
    #pragma config WDT=ON, FOSC2=ON, FOSC=HSPLL, ETHLED=ON, FCMEN=ON, STVR=ON, WDTPS = 1024

    // Automatically set Extended Instruction Set fuse based on compiler setting
    #if defined(__EXTENDED18__)
        #pragma config XINST=ON
    #else
        #pragma config XINST=OFF
    #endif
#endif


// Clock frequency values
// These directly influence timed events using the Tick module.  They also are used for UART and SPI baud rate generation.
#define GetSystemClock()        (41666667ul)            // Hz
#define GetInstructionClock()   (GetSystemClock()/4)    // Normally GetSystemClock()/4 for PIC18, GetSystemClock()/2 for PIC24/dsPIC, and GetSystemClock()/1 for PIC32.  Might need changing if using Doze modes.
#define GetPeripheralClock()    (GetSystemClock()/4)    // Normally GetSystemClock()/4 for PIC18, GetSystemClock()/2 for PIC24/dsPIC, and GetSystemClock()/1 for PIC32.  Divisor may be different if using a PIC32 since it's configurable.


// String parameters
#define SOFT_VER            "v1.0."
#define HARD_VER            "v1.0"

#if defined(__18F66J60)
    #define MCU_VER         "66J60" 
#elif defined(__18F67J60)
    #define MCU_VER         "67J60"
#else 
    #error "Check MCU type. It should be PIC18F66J60 or PIC18F67J60"                                        
#endif


// Hardware I/O pin mappings
#define ResetButton_TRIS    (TRISDbits.TRISD0)
#define ResetButton_IN      (PORTDbits.RD0)

// Ethernet TPIN+/- polarity swap circuitry (PICDEM.net 2 Rev 6)
//#define ETH_RX_POLARITY_SWAP_TRIS (TRISGbits.TRISG0)
//#define ETH_RX_POLARITY_SWAP_IO       (LATGbits.LATG0)


// 25LC256 I/O pins
/*
#define EEPROM_CS_TRIS      (TRISDbits.TRISD7)
#define EEPROM_CS_IO        (LATDbits.LATD7)
#define EEPROM_SCK_TRIS     (TRISCbits.TRISC3)
#define EEPROM_SDI_TRIS     (TRISCbits.TRISC4)
#define EEPROM_SDO_TRIS     (TRISCbits.TRISC5)
#define EEPROM_SPI_IF       (PIR1bits.SSP1IF)
#define EEPROM_SSPBUF       (SSP1BUF)
#define EEPROM_SPICON1      (SSP1CON1)
#define EEPROM_SPICON1bits  (SSP1CON1bits)
#define EEPROM_SPICON2      (SSP1CON2)
#define EEPROM_SPISTAT      (SSP1STAT)
#define EEPROM_SPISTATbits  (SSP1STATbits)
*/


// 24AA02E48 I/O pins
#define MAC_I2C_EEPROM              1
#define MAC_I2C_EEPROM_SCL_TRIS     (TRISBbits.TRISB3)
#define MAC_I2C_EEPROM_SDA_TRIS     (TRISBbits.TRISB4)

// USING DEEPROM
#if !defined(MAC_I2C_EEPROM)
    #define DEEPROM                 1
#endif

/*
#define ETH_LED_A_PORT
#define ETH_LED_B_PORT

#define ETH_LED_A_TRIS
#define ETH_LED_B_TRIS
*/

#define TEST_LED_TRIS   TRISCbits.TRISC2
#define TEST_LED_PORT   LATCbits.LATC2

#define UART_CTS        PORTBbits.RB7
#define UART_CTS_TRIS   TRISBbits.TRISB7

#define UART_RTS        PORTBbits.RB7
#define UART_RTS_TRIS   TRISBbits.TRISB6


// UART mapping functions for consistent API names across 8-bit and 16 or 
// 32 bit compilers.  For simplicity, everything will use "UART" instead 
// of USART/EUSART/etc.
#define BusyUART()          BusyUSART()
#define CloseUART()         CloseUSART()
#define ConfigIntUART(a)    ConfigIntUSART(a)
#define DataRdyUART()       DataRdyUSART()
#define OpenUART(a,b,c)     OpenUSART(a,b,c)
#define ReadUART()          ReadUSART()
#define WriteUART(a)        WriteUSART(a)
#define getsUART(a,b,c)     getsUSART(b,a)
#define putsUART(a)         putsUSART(a)
#define getcUART()          ReadUSART()
#define putcUART(a)         WriteUSART(a)
#define putrsUART(a)        putrsUSART((far rom char*)a)

#endif // #ifndef HARDWARE_PROFILE_H
