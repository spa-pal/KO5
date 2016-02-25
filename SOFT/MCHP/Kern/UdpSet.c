/* 
 ********************************************************************
 *
 *  Этот файл перекрывает стековский Announce, расширяя его функционал
 *  установкой рабочих параметров по UDP
 * 
 ********************************************************************
*/

#include "TCPIPConfig.h"
#include "TCPIP Stack/TCPIP.h"
#include "UdpSet.h"
#include "Main.h"


void SendVersionData(void); // Формирует UDP посылку о версиях

// Включаем UDP
#if !defined(STACK_USE_UDP)
    #define STACK_USE_UDP
#endif

// The announce port
#define ANNOUNCE_PORT   30303

extern NODE_INFO remoteNode;


/*********************************************************************
 * Function:        void AnnounceIP(void)
 *
 * Summary:         Transmits an Announce packet.
 *
 * PreCondition:    Stack is initialized()
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        AnnounceIP opens a UDP socket and transmits a
 *                  broadcast packet to port 30303.  If a computer is
 *                  on the same subnet and a utility is looking for
 *                  packets on the UDP port, it will receive the
 *                  broadcast.  For this application, it is used to
 *                  announce the change of this board's IP address.
 *                  The messages can be viewed with the MCHPDetect.exe
 *                  program.
 *
 * Note:            A UDP socket must be available before this
 *                  function is called.  It is freed at the end of
 *                  the function.  MAX_UDP_SOCKETS may need to be
 *                  increased if other modules use UDP sockets.
 ********************************************************************/
void AnnounceIP(void)
{
    UDP_SOCKET  MySocket;
    BYTE        i;

    // Open a UDP socket for outbound broadcast transmission
    MySocket = UDPOpen(2860, NULL, ANNOUNCE_PORT);

    // Abort operation if no UDP sockets are available
    // If this ever happens, incrementing MAX_UDP_SOCKETS in
    // StackTsk.h may help (at the expense of more global memory
    // resources).
    if(MySocket == INVALID_UDP_SOCKET)
        return;

    // Make certain the socket can be written to
    while(!UDPIsPutReady(MySocket));

    // Begin sending our MAC address in human readable form.
    // The MAC address theoretically could be obtained from the
    // packet header when the computer receives our UDP packet,
    // however, in practice, the OS will abstract away the useful
    // information and it would be difficult to obtain.  It also
    // would be lost if this broadcast packet were forwarded by a
    // router to a different portion of the network (note that
    // broadcasts are normally not forwarded by routers).
    UDPPutArray((BYTE*)AppConfig.NetBIOSName, sizeof(AppConfig.NetBIOSName)-1);
    UDPPut('\r');
    UDPPut('\n');

    // Convert the MAC address bytes to hex (text) and then send it
    i = 0;
    while(1)
    {
        UDPPut(btohexa_high(AppConfig.MyMACAddr.v[i]));
        UDPPut(btohexa_low(AppConfig.MyMACAddr.v[i]));
        if(++i == 6u)
            break;
        UDPPut('-');
    }

    UDPPut('\r');
    UDPPut('\n');

    // Отправляем информацию о версиях
    SendVersionData();

    // Send the packet
    UDPFlush();

    // Close the socket so it can be used by other modules
    UDPClose(MySocket);
}

/*********************************************************************
 * Function:        void DiscoveryTask(void)
 *
 * Summary:         Announce callback task.
 *
 * PreCondition:    Stack is initialized()
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Recurring task used to listen for Discovery
 *                  messages on the specified ANNOUNCE_PORT.  These
 *                  messages can be sent using the Microchip Device
 *                  Discoverer tool. If one is received, this
 *                  function will transmit a reply.
 *
 * Note:            A UDP socket must be available before this
 *                  function is called.  It is freed at the end of
 *                  the function.  MAX_UDP_SOCKETS may need to be
 *                  increased if other modules use UDP sockets.
 ********************************************************************/
void DiscoveryTask(void)
{
    static enum {
        DISCOVERY_HOME = 0,
        DISCOVERY_LISTEN,
        DISCOVERY_REQUEST_RECEIVED,
        DISCOVERY_DISABLED
    } DiscoverySM = DISCOVERY_HOME;

    static UDP_SOCKET   MySocket;
    WORD                i;
    WORD   DataAmountInSocket = 0;
    BYTE   ByteFromUdpRx = 0;
    BOOL   DiscoveryFlag = 0;

    switch(DiscoverySM)
    {
        case DISCOVERY_HOME:

         

            // Open a UDP socket for inbound and outbound transmission
            // Since we expect to only receive broadcast packets and
            // only send unicast packets directly to the node we last
            // received from, the remote NodeInfo parameter can be anything
            MySocket = UDPOpen(ANNOUNCE_PORT, NULL, ANNOUNCE_PORT);

            if(MySocket == INVALID_UDP_SOCKET)
                return;
            else
                DiscoverySM++;
            break;

        case DISCOVERY_LISTEN:

            // Получаем количество данных в буфере приема UDP
            DataAmountInSocket = UDPIsGetReady(MySocket);

            // Do nothing if no data is waiting
            if(!DataAmountInSocket)
                return;

            // Отправляем все данные из UDP на разбор побайтово
            for (i = 0; i < DataAmountInSocket; i++)
            {
                UDPGet(&ByteFromUdpRx);
               
                if(ByteFromUdpRx == 'W')
                    DiscoveryFlag = 1;
            }
            UDPDiscard();                               // Очистка входного буфера
   
            
            // We received a discovery request, reply when we can
            DiscoverySM++;

          
            // No break needed.  If we get down here, we are now ready for the DISCOVERY_REQUEST_RECEIVED state

        case DISCOVERY_REQUEST_RECEIVED:
            if(!UDPIsPutReady(MySocket))
                return;

            // Если была принята команда поиска CheapLAN
            if(DiscoveryFlag)
            {
                // Begin sending our MAC address in human readable form.
                // The MAC address theoretically could be obtained from the
                // packet header when the computer receives our UDP packet,
                // however, in practice, the OS will abstract away the useful
                // information and it would be difficult to obtain.  It also
                // would be lost if this broadcast packet were forwarded by a
                // router to a different portion of the network (note that
                // broadcasts are normally not forwarded by routers).
                UDPPutArray((BYTE*)AppConfig.NetBIOSName, sizeof(AppConfig.NetBIOSName)-1);
                UDPPut('\r');
                UDPPut('\n');
    
                // Convert the MAC address bytes to hex (text) and then send it
                i = 0;
                while(1)
                {
                    UDPPut(btohexa_high(AppConfig.MyMACAddr.v[i]));
                    UDPPut(btohexa_low(AppConfig.MyMACAddr.v[i]));
                    if(++i == 6u)
                        break;
                    UDPPut('-');
                }
                UDPPut('\r');
                UDPPut('\n');

                // Отправляем информацию о версиях
                SendVersionData();

                // Send the packet
                UDPFlush(); 
                
                DiscoveryFlag = 0;      
            }

          // Listen for other discovery requests
            DiscoverySM = DISCOVERY_LISTEN;
            break;

        case DISCOVERY_DISABLED:
            break;
    }
}


// Отправка ответа по UDP, вызывается из парсигна
void SendDataToUdpTx(BYTE *Data, UINT16 DataLength)
{
    UDPPutArray(Data, DataLength);
    UDPFlush();
} 


void SendVersionData(void)
{
    // ---- Вычисление даты сборки----------------------
    BYTE Tmp[] = {0x30,0x30,0x30,0x30,0x30,0x30,0};

    // День
    Tmp[0] = __DATE__ [4] == ' ' ? '0' : __DATE__ [4];
    Tmp[1] = __DATE__ [5]; 

    // Месяц
    Tmp[2] = (MONTH) < 10 ? '0' : (MONTH)/10 + 0x30;
    Tmp[3] = (MONTH) - (MONTH/10)*10 + 0x30; 

    // Год
    Tmp[4] = __DATE__ [9];
    Tmp[5] = __DATE__ [10]; 

    UDPPutROMString((ROM BYTE*)"HW ");
    UDPPutROMString((ROM void*)HARD_VER);

    UDPPutROMString((ROM BYTE*)"; SW ");
    UDPPutROMString((ROM void*)SOFT_VER);
    UDPPutString(Tmp);

    UDPPutROMString((ROM BYTE*)"; STK ");
    UDPPutROMString((ROM void*)TCPIP_STACK_VERSION);

    UDPPutROMString((ROM BYTE*)"; MCU ");
    UDPPutROMString((ROM void*)MCU_VER);

    UDPPutROMString((ROM BYTE*)"\r\n");
}

