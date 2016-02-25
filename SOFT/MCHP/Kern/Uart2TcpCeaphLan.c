#include "TCPIPConfig.h"
#include "TCPIP Stack/TCPIP.h"
#include "HardwareProfile.h"
#include "UART2TCPCEAPHLAN.h"
#include "TxProtocol.h"

#if defined (CHEAPLAN_TCP_UART_BRIDGE)

extern CHEAPLAN_CONFIG CheapLanConfig;

// Флаг изменения порта из веб интерфейса
BYTE BridgePortWasChanged;


// Ring buffers for transfering data to and from the UART ISR:
//  - (Head pointer == Tail pointer) is defined as an empty FIFO
//  - (Head pointer == Tail pointer - 1), accounting for wraparound,
//    is defined as a completely full FIFO.  As a result, the max data 
//    in a FIFO is the buffer size - 1.

//#pragma udata uartbuf
static BYTE vUARTRXFIFO[64];
static BYTE vUARTTXFIFO[64];
static BYTE vTxCommandFIFO[50];
//#pragma udata

static volatile BYTE *RXHeadPtr = vUARTRXFIFO, *RXTailPtr = vUARTRXFIFO;
static volatile BYTE *TXHeadPtr = vUARTTXFIFO, *TXTailPtr = vUARTTXFIFO;


// FIFO буфер и указатели для парсинга TX команды. Данные копируются в FIFO из функции прерывания UART RX, 
// Обрабатываются и буфер этот очищаться должен

static  volatile BYTE  *TxCommandRXHeadPtr = vTxCommandFIFO, *TxCommandRXTailPtr = vTxCommandFIFO;

BYTE    UartResponseFlag = 0;
BYTE    *pUartResponceData;
BYTE    UartRespBufferLength = 0;

TX_STATUS TxPrUartStat;



void UART2TCPBridgeInit(UINT32 BAUD_RATE)
{
    UINT32 BAUD_ERROR = 0;
    UINT32 CLOSEST_SPBRG_VALUE = ((GetPeripheralClock()+2ul*BAUD_RATE)/BAUD_RATE/4-1);
    UINT32 BAUD_ACTUAL = (GetPeripheralClock()/(CLOSEST_SPBRG_VALUE+1));
    UINT32 BAUD_ERROR_PRECENT = 0;

    UART_CTS = 1;
    UART_RTS = 0;

    UART_CTS_TRIS = 1;  // CTS - вход
    UART_RTS_TRIS = 0;  // RTS - выход


    // Initilize UART
    TXSTA = 0x20;
    RCSTA = 0x90;
    
    if (BAUD_ACTUAL > BAUD_RATE)
        BAUD_ERROR = (BAUD_ACTUAL-BAUD_RATE);
    else
        BAUD_ERROR = (BAUD_RATE-BAUD_ACTUAL);
    
    BAUD_ERROR_PRECENT = ((BAUD_ERROR * 100 + BAUD_RATE / 2)/BAUD_RATE);
    
    if(BAUD_ERROR_PRECENT > 2)
    {
        // Use high speed (Fosc/4) 16-bit baud rate generator
        BAUDCONbits.BRG16 = 1;
        TXSTAbits.BRGH = 1;
        SPBRGH = ((GetPeripheralClock()+BAUD_RATE/2)/BAUD_RATE-1)>>8 & 0xFF;
        SPBRG = ((GetPeripheralClock()+BAUD_RATE/2)/BAUD_RATE-1) & 0xFF;
    }
    else
    {
        // See if we can use the high baud (Fosc/16) 8-bit rate setting
        if (((GetPeripheralClock()+2*BAUD_RATE)/BAUD_RATE/4 - 1) <= 255)
        {
            SPBRG = (GetPeripheralClock()+2*BAUD_RATE)/BAUD_RATE/4 - 1;
            TXSTAbits.BRGH = 1;
        }
        else    // Use the low baud rate 8-bit setting
            SPBRG = (GetPeripheralClock()+8*BAUD_RATE)/BAUD_RATE/16 - 1;
    }
    
    // Use high priority interrupt
    IPR1bits.TXIP = 1;
}


// Сигнализирует о необходимости обновления номера TCP порта для моста Ethernet-UART
void RefreshBridgePort()
{
    BridgePortWasChanged = 1;
}


/** 
 * Отпрака данных в UART
 * 
 * Используется для вклинивания в работу моста,
 * если используется установка параметров по UART
 * 
 */
void SendDataToUartTx(BYTE *Data, UINT16 DataLength)
{
    pUartResponceData = Data;                   // Указатель на данные, которые надо отправить
    UartRespBufferLength = DataLength;      // Количество данных
    UartResponseFlag = 1;                   // Флаг, запускающий передачу в буфер ТХ из задачи UART2TCPBridgeTask
}


/*********************************************************************
 * Function:        void UART2TCPBridgeTask(void)
 *
 * PreCondition:    Stack is initialized()
 ********************************************************************/
void UART2TCPBridgeTask(void)
{
    static enum _BridgeState
    {
        SM_HOME = 0,
        SM_SOCKET_OBTAINED
    } BridgeState = SM_HOME;

    static TCP_SOCKET MySocket = INVALID_SOCKET;
    static volatile DWORD  t_break = 0;     // Хранит временной отсчет, использующийся для разрыва неактивного соединения

    WORD wMaxPut, wMaxGet, w;
    BYTE *RXHeadPtrShadow, *RXTailPtrShadow;
    BYTE *TXHeadPtrShadow, *TXTailPtrShadow;
    
    // Теневые указатели на буфер TX команды
    BYTE *TxCommandRXHeadPtrShadow, *TxCommandRXTailPtrShadow;

    BYTE i;

    static BOOL PrevSoketStatus = 0;


    switch(BridgeState)
    {
        case SM_HOME:

            // Обнуляем структуру статуса
            memset((void*)&TxPrUartStat, 0x00, sizeof(TxPrUartStat));

            MySocket = TCPOpen(0, TCP_OPEN_SERVER, CheapLanConfig.Uart2TcpPort, TCP_PURPOSE_UART_2_TCP_BRIDGE);
            
            // Abort operation if no TCP socket of type TCP_PURPOSE_UART_2_TCP_BRIDGE is available
            // If this ever happens, you need to go add one to TCPIPConfig.h
            if(MySocket == INVALID_SOCKET)
                break;

            // Eat the first TCPWasReset() response so we don't 
            // infinitely create and reset/destroy client mode sockets
            TCPWasReset(MySocket);

            // We have a socket now, advance to the next state
            BridgeState = SM_SOCKET_OBTAINED;
            break;

        case SM_SOCKET_OBTAINED:
            // Reset all buffers if the connection was lost
            if(TCPWasReset(MySocket))
            {
                // Optionally discard anything in the UART FIFOs
                RXHeadPtr = (volatile BYTE *)vUARTRXFIFO;
                RXTailPtr = (volatile BYTE *)vUARTRXFIFO;
                TXHeadPtr = (volatile BYTE *)vUARTTXFIFO;
                TXTailPtr = (volatile BYTE *)vUARTTXFIFO;
            }

            if (PrevSoketStatus == 0 && TCPIsConnected(MySocket))
            {
                t_break = TickGet();            // Запоминаем временной отсчет открытия сокета

                // Optionally discard anything in the UART FIFOs
                RXHeadPtr = (volatile BYTE *)vUARTRXFIFO;
                RXTailPtr = (volatile BYTE *)vUARTRXFIFO;
                TXHeadPtr = (volatile BYTE *)vUARTTXFIFO;
                TXTailPtr = (volatile BYTE *)vUARTTXFIFO;
            }
            PrevSoketStatus = TCPIsConnected(MySocket);

            // Контролируем время неактивности, если оно отличается от 0 и есть соединение
            if(CheapLanConfig.BreakTime != 0 &&(TickGet() - t_break) >= (TICK_SECOND * CheapLanConfig.BreakTime) && 
                TCPIsConnected(MySocket))
            {
                TCPDisconnect(MySocket);
            }

            // Изменение настроек порта - сбрасываем сокет
            if(BridgePortWasChanged)
            {
                TCPDisconnect(MySocket);
                TCPClose(MySocket);
                MySocket = INVALID_SOCKET;          
                BridgeState = SM_HOME;
                BridgePortWasChanged = 0;
                break;
            }
        
        
            // Make sure to clear UART errors so they don't block all future operations
            if(RCSTAbits.OERR)
            {
                RCSTAbits.CREN = 0;
                RCSTAbits.CREN = 1;
            }
            if(RCSTAbits.FERR)
            {
                BYTE dummy = RCREG;
            }
            

            // Read FIFO pointers into a local shadow copy.  Some pointers are volatile 
            // (modified in the ISR), so we must do this safely by disabling interrupts
            RXTailPtrShadow = (BYTE*)RXTailPtr;
            TXHeadPtrShadow = (BYTE*)TXHeadPtr;
            TxCommandRXTailPtrShadow = (BYTE*)TxCommandRXTailPtr;
            
            PIE1bits.RCIE = 0;
            PIE1bits.TXIE = 0;
            
            RXHeadPtrShadow = (BYTE*)RXHeadPtr;
            TXTailPtrShadow = (BYTE*)TXTailPtr;
            TxCommandRXHeadPtrShadow = (BYTE*)TxCommandRXHeadPtr;
        
            PIE1bits.RCIE = 1;
            if(TXHeadPtrShadow != TXTailPtrShadow)
                PIE1bits.TXIE = 1;


            // Это для буфера TX команды
            wMaxGet = TxCommandRXHeadPtrShadow - TxCommandRXTailPtrShadow;

            if(TxCommandRXHeadPtrShadow < TxCommandRXTailPtrShadow)
                wMaxGet += sizeof(vTxCommandFIFO);

            // Проверяем поступающие из UART данные
            if(wMaxGet && UART_MODE == 1)
            {
                w = vTxCommandFIFO + sizeof(vTxCommandFIFO) - TxCommandRXTailPtrShadow;

                // Если данные перекрывают верхнюю границу FIFO буфера и продолжаются с начала буфера
                if(wMaxGet >= w)
                {
                    for(i = 0; i < w; i++ )
                        TxCommandHandling(&TxPrUartStat, *(TxCommandRXTailPtrShadow + i)); 
                    
                    for(i = 0; i < wMaxGet - w; i++ )
                        TxCommandHandling(&TxPrUartStat, *(vTxCommandFIFO + i));
                }
                else 
                    for(i = 0; i < wMaxGet; i++ )
                        TxCommandHandling(&TxPrUartStat, *(TxCommandRXTailPtrShadow + i));

                TxCommandParse(&TxPrUartStat, I_UART);                  // Парсим TX команды

                TxCommandRXTailPtrShadow = TxCommandRXHeadPtrShadow;
            }
            
            //
            // Transmit pending data that has been placed into the UART RX FIFO (in the ISR)
            //
            wMaxPut = TCPIsPutReady(MySocket);              // Get TCP  TX FIFO space
            wMaxGet = RXHeadPtrShadow - RXTailPtrShadow;    // Get UART RX FIFO byte count

            if(RXHeadPtrShadow < RXTailPtrShadow)
                wMaxGet += sizeof(vUARTRXFIFO);

            // Если есть что посылать из UARTа
            if(wMaxGet)
            {
                t_break = TickGet();                    // Продляем жизни соединению
            }

            if(wMaxPut > wMaxGet)                   // Calculate the lesser of the two
                wMaxPut = wMaxGet;

            // Только если есть соединение, тогда отсылаем данные в Ethernet
            if(TCPIsConnected(MySocket))
            {
                if(wMaxPut)                         // See if we can transfer anything
                {
                    w = vUARTRXFIFO + sizeof(vUARTRXFIFO) - RXTailPtrShadow;
                    if(wMaxPut >= w)
                    {
                        TCPPutArray(MySocket, RXTailPtrShadow, w);
                        RXTailPtrShadow = vUARTRXFIFO;
                        wMaxPut -= w;
                    }
                    TCPPutArray(MySocket, RXTailPtrShadow, wMaxPut);
                    RXTailPtrShadow += wMaxPut;
                }
            }
            

            //
            // Transfer received TCP data into the UART TX FIFO for future transmission (in the ISR)
            //

            // Если никаких запросов со стороны UART не было, и сокет соединен - передаем данные из TCP
            if(!UartResponseFlag && TCPIsConnected(MySocket))
            {
                wMaxGet = TCPIsGetReady(MySocket);                  // Get TCP RX FIFO byte count
                wMaxPut = TXTailPtrShadow - TXHeadPtrShadow - 1;    // Get UART TX FIFO free space
                if(TXHeadPtrShadow >= TXTailPtrShadow)
                    wMaxPut += sizeof(vUARTTXFIFO);
    
                if(wMaxPut > wMaxGet)                               // Calculate the lesser of the two
                    wMaxPut = wMaxGet;

                // Если есть что посылать из Ethernet
                if(wMaxGet)
                {
                    t_break = TickGet();                                // Продляем жизни соединению
                }

    
                if(wMaxPut)                                         // See if we can transfer anything
                {
                    w = vUARTTXFIFO + sizeof(vUARTTXFIFO) - TXHeadPtrShadow;
                    if(wMaxPut >= w)
                    {
                        TCPGetArray(MySocket, TXHeadPtrShadow, w);
                        TXHeadPtrShadow = vUARTTXFIFO;
                        wMaxPut -= w;
                    }
                    TCPGetArray(MySocket, TXHeadPtrShadow, wMaxPut);
                    TXHeadPtrShadow += wMaxPut;
                }
            }
            else if(UartResponseFlag)
            {
                // Очищаем буферы сдвигом указателей на голову и хвост в начло FIFO
                TXTailPtrShadow = TXHeadPtrShadow = vUARTTXFIFO;  

                wMaxPut = sizeof(vUARTTXFIFO) - 1;

                if(wMaxPut > UartRespBufferLength)                              // Calculate the lesser of the two
                    wMaxPut = UartRespBufferLength;
    
                // Заполняем FIFO, предполагая, что размер FIFO больше чем размер данных!
                if(wMaxPut)                                         
                {
                    for(i = 0; i < wMaxPut; i++)
                        *(TXHeadPtrShadow + i) = *(pUartResponceData + i); 

                    TXHeadPtrShadow += wMaxPut;
                }
            }

            // Write local shadowed FIFO pointers into the volatile FIFO pointers.
            
            PIE1bits.RCIE = 0;
            PIE1bits.TXIE = 0;
            
            RXTailPtr = (volatile BYTE*)RXTailPtrShadow;
            TXHeadPtr = (volatile BYTE*)TXHeadPtrShadow;

            // Обновляем указатель на хвост буфера TX
            TxCommandRXTailPtr = (volatile BYTE*)TxCommandRXHeadPtrShadow;


            // Если был запрос из UART - то поменялся так же и указатель на хвост
            if(UartResponseFlag == 1)
            {
                UartResponseFlag = 0;
                TXTailPtr = (volatile BYTE*)TXTailPtrShadow;
            }

        
            PIE1bits.RCIE = 1;
            if(TXHeadPtrShadow != TXTailPtrShadow)
                PIE1bits.TXIE = 1;
                
            break;
    }
}

  
/*********************************************************************
 * Function:        void UART2TCPBridgeISR(void)
 *
 * PreCondition:    UART interrupt has occured
 *
 * Note:            This function is supposed to be called in the ISR 
 *                  context.
 ********************************************************************/
void UART2TCPBridgeISR(void)
{
    // NOTE: All local variables used here should be declared static
    static BYTE i;

    // Store a received byte, if pending, if possible
    if(PIR1bits.RCIF)
    {
        // Get the byte
        i = RCREG;

        // Clear the interrupt flag so we don't keep entering this ISR
        PIR1bits.RCIF = 0;

        // Copy the byte into the local FIFO, if it won't cause an overflow
        if(RXHeadPtr != RXTailPtr - 1)
        {
            if((RXHeadPtr != vUARTRXFIFO + sizeof(vUARTRXFIFO)) || (RXTailPtr != vUARTRXFIFO))
            {
                *RXHeadPtr++ = i;
                if(RXHeadPtr >= vUARTRXFIFO + sizeof(vUARTRXFIFO))
                    RXHeadPtr = (volatile BYTE*)vUARTRXFIFO;
            }
        }

        // Загружам буфер TX команды 
        if(TxCommandRXHeadPtr != TxCommandRXTailPtr - 1  && UART_MODE == 1)
        {
            if((TxCommandRXHeadPtr != vTxCommandFIFO + sizeof(vTxCommandFIFO)) || (TxCommandRXTailPtr != vTxCommandFIFO))
            {
                *TxCommandRXHeadPtr++ = i;
                if(TxCommandRXHeadPtr >= vTxCommandFIFO + sizeof(vTxCommandFIFO))
                    TxCommandRXHeadPtr = (volatile BYTE*)vTxCommandFIFO;
            }
        }
    }

    // Transmit a byte, if pending, if possible
    if(PIR1bits.TXIF)      
    {
        // Буфер передачи не пуст      нет управления     есть управление и передача разрешена
        if((TXHeadPtr != TXTailPtr) && ( RTS_CTS_EN == 0 || (RTS_CTS_EN != 0 && UART_CTS == 0)) )
        {
            TXREG = *TXTailPtr++;
            if(TXTailPtr >= vUARTTXFIFO + sizeof(vUARTTXFIFO))
                TXTailPtr = (volatile BYTE*)vUARTTXFIFO;
        }
        else    // Disable the TX interrupt if we are done so that we don't keep entering this ISR
        {
            PIE1bits.TXIE = 0;
        }
    }
}

#endif //#if defined (CHEAPLAN_TCP_UART_BRIDGE)


