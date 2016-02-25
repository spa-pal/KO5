/*********************************************************************
 *
 *  UART <-> TCP Bridge Example
 *  Module for Microchip TCP/IP Stack
 *   -Transmits all incoming TCP bytes on a socket out the UART 
 *    module, all incoming UART bytes out of the TCP socket.
 *   -Reference: None (hopefully AN833 in the future)
 *
 *********************************************************************
 * FileName:        UART2TCPBridge.c
 * Dependencies:    TCP.h
 * Processor:       PIC18, PIC24F, PIC24H, dsPIC30F, dsPIC33F, PIC32
 * Compiler:        Microchip C32 v1.05 or higher
 *                  Microchip C30 v3.12 or higher
 *                  Microchip C18 v3.30 or higher
 *                  HI-TECH PICC-18 PRO 9.63PL2 or higher
 * Company:         Microchip Technology, Inc.
 *
 * Software License Agreement
 *
 * Copyright (C) 2002-2009 Microchip Technology Inc.  All rights
 * reserved.
 *
 * Microchip licenses to you the right to use, modify, copy, and
 * distribute:
 * (i)  the Software when embedded on a Microchip microcontroller or
 *      digital signal controller product ("Device") which is
 *      integrated into Licensee's product; or
 * (ii) ONLY the Software driver source files ENC28J60.c, ENC28J60.h,
 *      ENCX24J600.c and ENCX24J600.h ported to a non-Microchip device
 *      used in conjunction with a Microchip ethernet controller for
 *      the sole purpose of interfacing with the ethernet controller.
 *
 * You should refer to the license agreement accompanying this
 * Software for additional information regarding your rights and
 * obligations.
 *
 * THE SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT
 * WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT
 * LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * MICROCHIP BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF
 * PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
 * BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE
 * THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER
 * SIMILAR COSTS, WHETHER ASSERTED ON THE BASIS OF CONTRACT, TORT
 * (INCLUDING NEGLIGENCE), BREACH OF WARRANTY, OR OTHERWISE.
 *
 *
 * Author               Date        Comment
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Howard Schlunder     06/12/07    Original
 ********************************************************************/
#ifndef __UART2TCPCEAPHLAN_H
#define __UART2TCPCEAPHLAN_H

//#define CHEAPLAN_TCP_UART_BRIDGE

#if defined (CHEAPLAN_TCP_UART_BRIDGE) 

    #define SIMPLE_BRIDGE   0
    #define TX              1
    
    #define UART_MODE       (CheapLanConfig.UartMode & 0x01)    
    #define RTS_CTS_EN      (CheapLanConfig.UartMode & 0x02)
    
    #define INACTIVE_TIME   (TICK_SECOND * 20ul)            // Время неактивности
    
 
  
    #if !defined(STACK_USE_TCP)
        #define STACK_USE_TCP
    #endif
    
    
    
    void UART2TCPBridgeInit(UINT32 BAUD_RATE);
    void SendDataToUartTx(BYTE *Data, UINT16 DataLength);
    void UART2TCPBridgeTask(void);
    void RefreshBridgePort(void);
    void UART2TCPBridgeISR(void);
#endif // #if defined (CHEAPLAN_TCP_UART_BRIDGE)

#endif

