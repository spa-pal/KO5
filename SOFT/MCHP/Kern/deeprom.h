/*********************************************************************
 *
 *                  Headers for Data EEPROM Emulation
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


#ifndef __DEEPROM_H
#define __DEEPROM_H

#include "GenericTypeDefs.h"


BYTE DEEPROM_WriteArray (BYTE* Data, BYTE DataLength);
void DEEPROM_ReadArray  (BYTE StartIndex, BYTE* Data, BYTE DataLength);
void DEEPROM_Erase(void);

#endif
