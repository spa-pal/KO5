/*********************************************************************
 *
 *  Main Application Entry Point and TCP/IP Stack
 *  Module for CheapLAN
 *   
 *********************************************************************
 * FileName:        Main.c
 * Dependencies:    TCPIP.h
 * Processor:       PIC18, PIC24F, PIC24H, dsPIC30F, dsPIC33F, PIC32
 * Compiler:        Microchip C32 v1.11b or higher
 *                  Microchip C30 v3.24 or higher
 *                  Microchip C18 v3.36 or higher
 * Company:         Triada-TV/CDT, Inc.
 *
 *********************************************************************
*/

#define THIS_IS_STACK_APPLICATION

#include "TCPIP Stack/TCPIP.h"
#include "Main.h"
#include "I2cEEPROM.h"
#include "UdpSet.h"
#include "HTTPApp.h"
#include "DeviceData.h"
#include "ParamList.h"
#include "PAL_pUART.h"


APP_CONFIG      AppConfig;                          // Declare AppConfig structure 
HDWR_RST_STATUS ResetStatus;                        // Статус аппартного сброса IP кнопкой, для отображения на Web интерфейсе


DWORD time_temp;
char time_cnt0,time_cnt1,time_cnt2,time_cnt3,time_cnt4;
char b1000Hz, b100Hz, b10Hz, b5Hz, b2Hz, b1Hz;
char trap_cnt;
short cnt_cnt_cnt=0;
//===================== FUNCTION PROTOTIPES ======================================================

static void InitAppConfig(void);    // Инициализация конфигурации приложения
static void InitializeBoard(void);  // Инициализация платы
static void PollResetButon(void);   // Проверка кнопки сброса IP
       void SetMyIP(void);          // Временный сброс IP
       void FailSafeHandler(void);  // Обработка события ошибки генератора
       void RestoreSettings(void);   // Изменение настроек 

//================== INTERRUPT SERVICE ROUTINES ==================================================
//
// PIC18 Interrupt Service Routines
// 
// NOTE: Several PICs, including the PIC18F4620 revision A3 have a RETFIE FAST/MOVFF bug
// The interruptlow keyword is used to work around the bug when using C18
#if defined(__18CXX)
    #if defined(HI_TECH_C)
        void interrupt low_priority LowISR(void)
    #else
        #pragma interruptlow LowISR
        
        void LowISR(void)
    #endif
        {
        
            TickUpdate();
                
            if (INTCON3bits.INT1IF)
            {
                INTCON3bits.INT1IF=0;
                INTCON2bits.INTEDG1^=1;
        
        //          DeviceData.LogIn1++;    
                {
                    char pin_temp;
                    pin_temp     = PORTB&0x0f;
                    data_temp    = (pin_temp & 0x0c) >> 2;
                    control_temp = 0;
                    control_temp = (pin_temp & 0x03) >> 1;
                    if (pin_temp & 0x01)
                        control_temp |= 0x02;
                    puart_data_temp  |= (data_temp << (control_temp * 2));
                    if (control_temp == 0x03)
                    {
                        //DeviceData.LogIn1++;  
                        puart_rx_buffer[puart_rx_wr_index]=puart_data_temp;
                        bPUART_RXIN=1;
                        puart_rx_wr_index++;
                        if (puart_rx_wr_index >= PUART_RX_BUFFER_SIZE)
                        {
                            puart_rx_wr_index=0;
                        }
                        if (puart_data_temp==0x0a)
                        {
                        }
                        puart_data_temp=0;
                    }
                }
            }
        }
    
    #if defined(HI_TECH_C)
        void interrupt HighISR(void)
    #else
        #pragma interruptlow HighISR
        void HighISR(void)
    #endif
        {/*
        if(INTCONbits.INT0IF)
            {
            INTCONbits.INT0IF=0;
        //  INTCON2bits.INTEDG0^=1;
                
                {
                char pin_temp;
                pin_temp=PORTB&0x0f;
                data_temp=(pin_temp&0x0c)>>2;
                control_temp=(pin_temp&0x03);
                puart_data_temp|=(data_temp<<(control_temp*2));
                if(control_temp==0x03)
                    {
                    puart_rx_buffer[puart_rx_wr_index]=puart_data_temp;
                    bPUART_RXIN=1;
                    puart_rx_wr_index++;
                    if (puart_rx_wr_index >= PUART_RX_BUFFER_SIZE)
                        {
                        puart_rx_wr_index=0;
                        }
                    if(puart_data_temp==0x0a)
                        {
                        }
                    puart_data_temp=0;
                    }
                }
            }*/
        }

    #if !defined(HI_TECH_C)
        #pragma code lowVector=0x18
        void LowVector(void){_asm goto LowISR _endasm}
        #pragma code highVector=0x8
        void HighVector(void){_asm goto HighISR _endasm}
        #pragma code // Return to default code section
    #endif

// C30 and C32 Exception Handlers
// If your code gets here, you either tried to read or write
// a NULL pointer, or your application overflowed the stack
// by having too many local variables or parameters declared.
#elif defined(__C30__)
    void _ISR __attribute__((__no_auto_psv__)) _AddressError(void)
    {
        Nop();
        Nop();
    }
    void _ISR __attribute__((__no_auto_psv__)) _StackError(void)
    {
        Nop();
        Nop();
    }
    
#elif defined(__C32__)
    void _general_exception_handler(unsigned cause, unsigned status)
    {
        Nop();
        Nop();
    }
#endif



//============================ MAIN APPLICATION ENTRY POINT ================================
#if defined(__18CXX)
void main(void)
#else
int main(void)
#endif
{
static DWORD dwLastIP = 0;
static DWORD t_but = 0;         // для периода опроса кнопки
static DWORD t_chsett = 0;      // для измерения времени изменения настроек
static DWORD t_trap = 0;        // для посылки трапов
static BOOL  SuspendFlag = 0;
    
DeviceDataInit();
    
InitializeBoard();  // Initialize application specific hardware
TickInit();         // Initialize stack-related hardware components

#if defined(STACK_USE_MPFS) || defined(STACK_USE_MPFS2)
MPFSInit();
#endif

InitAppConfig();    // Init Stack and application related NV variables into AppConfig
StackInit();        // Init core stack layers (MAC, ARP, TCP, UDP) and application modules (HTTP, SNMP, etc.)

SpaSibSNMPInit((UDP_PORT)DeviceData.SNMPReadPort);   // Наша, доработанная ф-я инициализации UDP сокета для SNMP read - можно менять порты
    

    // Now that all items are initialized, begin the co-operative
    // multitasking loop.  This infinite loop will continuously 
    // execute all stack-related tasks, as well as your own
    // application's functions.  Custom functions should be added
    // at the end of this loop.
    // Note that this is a "co-operative mult-tasking" mechanism
    // where every task performs its tasks (whether all in one shot
    // or part of it) and returns so that other tasks can do their
    // job.
    // If a task needs very long time to do its job, it must be broken
    // down into smaller pieces so that other tasks can have CPU time.

puart_rx_init();
ptx_rd_index=0;
ptx_wr_index=0;
puart_out(3,66,30,0,0,0,0);

while(1)
{
    ClrWdt();   // Сброс собаки

    if (TickGet() - time_temp >= TICK_SECOND/1000ul)
    {
        time_temp = TickGet();
        b1000Hz=1;
        time_cnt0++;
        if (time_cnt0>=10)
        {
            time_cnt0=0;
            b100Hz=1;

            time_cnt2++;
            if (time_cnt2>=20)
            {
                time_cnt2=0;
                b5Hz=1;
            }

            time_cnt3++;
            if (time_cnt3>=50)
            {
                time_cnt3=0;
                b2Hz=1;
            }

            time_cnt4++;
            if (time_cnt4>=100)
            {
                time_cnt4=0;
                b1Hz=1;
            }
        }

        time_cnt1++;
        if (time_cnt1>=100)
        {
            time_cnt1=0;
            b10Hz=1;
        }
    }
    
    // Каждые 100 мс поллим кнопку
    if(TickGet() - t_but >= TICK_SECOND/10ul)
    {
        t_but = TickGet();
        PollResetButon();
    }

    // Если нужно обновить настройки из WEB интерфейса
    if(HTTPNeedToChangeNetSett() || SNMPNeedToChangeNetSett())
    {
        t_chsett = TickGet();   // Запускаем таймер 
        SuspendFlag = TRUE;     // Откладываем смену параметров
    }

    if(SuspendFlag)
    {
        if(TickGet() - t_chsett >= TICK_SECOND*2/3ul)
        {
            RestoreSettings();       // По истечение времени - меняем настройки
            SpaSibSNMPInit((UDP_PORT)DeviceData.SNMPReadPort);
            SuspendFlag = FALSE;
        }
    }

    // This task performs normal stack task including checking
    // for incoming packet, type of packet and calling
    // appropriate stack entity to process it.
    StackTask();

    // This tasks invokes each of the core stack application tasks
    StackApplications();

    #if defined(STACK_USE_SNMP_SERVER) && !defined(SNMP_TRAP_DISABLED)
  
    // Сбрасываем флаг, сигнализирующий о неверном community, если не сбросить, то однажды 
    // введя неверное з-е community "потеряем" устройство по SNMP до перезагрузки оного
    // Раньше этот флаг сбрасывался в ф-и отсылки трапа о кривом community (SNMPSendTrap()) 
    gSendTrapFlag = FALSE;      

    // Задача посылки трапов
    SNMPSpaSibTrapTask();   

    // Посылаем трапы каждые 5 сек.
    if(TickGet() - t_trap >= TICK_SECOND*5ul)
    {
        t_trap = TickGet();
        //SNMPSendSpaSibTrap(0,  1, 1, (ROM BYTE*)SNMP_TRAP_MESS_TEST1);   
        //SNMPSendSpaSibTrap(0,  2, 2, (ROM BYTE*)SNMP_TRAP_MESS_HUGE_ONE);   
        //SNMPSendSpaSibTrap(0,  3, 3, (ROM BYTE*)"Russian lng doesnt satisfy the \"octet string\" demands");   
    }
        
            
    #endif      


    #if !defined(STACK_USE_ANNOUNCE)
    DiscoveryTask();    // Find CheapLAN through UDP functionality, overrides stack's DiscoveryTask from announce.c
    #endif


    // If the local IP address has changed (ex: due to DHCP lease change)
    // write the new IP address to the LCD display, UART, and Announce 
    // service
    if(dwLastIP != AppConfig.MyIPAddr.Val)
    {
        dwLastIP = AppConfig.MyIPAddr.Val;
        // Наше уведомление по UDP
        AnnounceIP();
        //      Gratuitous_ARP();   // Посылаем ARP уведомление. Это наша ф-я, добавленная в стек
    }
        
  puart_rx_drv();

        if (b1000Hz)
        {
            b1000Hz=0;
            //TRISE&=0xf0;  
            //LATE^=0x0f; 
        }


        puart_tx_drv();

        if (bPUART_RXIN==1)
        {
            bPUART_RXIN=0;
            puart_uart_in();

        }

        if (b100Hz)
        {
            b100Hz=0;   

        }

        if (b10Hz)
        {
            b10Hz=0; 
   //     TRISFbits.TRISF1=0;   
   //     cnt_cnt_cnt++;
    //    if(cnt_cnt_cnt<20)LATFbits.LATF1 = 1;
    //    else LATFbits.LATF1 ^= 1;
        }

        if (b5Hz)
        {
            b5Hz=0;
            //puart_out (5,1,2,3,4,5,6);

        }

        if (b2Hz)
        {
            b2Hz=0; 

        }

        if (b1Hz)
        {
            b1Hz=0; 


            //DeviceData.AlarmTemp2Level = 60;
            trap_cnt++;
            if (trap_cnt>=1)
            {
                trap_cnt=0;
                TRISFbits.TRISF2=0;
                LATFbits.LATF2 ^= 1;
            }
        }  
    }
}



/*
 *****************************************************************************
 *  Function:
 *    static void InitializeBoard(void)
 *
 *  Description:
 *    This routine initializes the hardware.  It is a generic initialization
 *    routine using definitions in HardwareProfile.h to determine 
 *    specific initialization.
 *
 *  Precondition:
 *    None
 *
 *  Remarks:
 *    None
 ****************************************************************************
*/
static void InitializeBoard(void)
{   
    ResetButton_TRIS = 1; // IP reset I/O pin as input

    // Enable 4x/5x/96MHz PLL on PIC18F87J10, PIC18F97J60, PIC18F87J50, etc.
    OSCTUNE = 0x40;

    ADCON0 = 0x00;          // ADOFF
    ADCON1 = 0x0F;          // All I/O is digital

    INTCON2bits.RBPU = 0;   // Enable internal PORTB pull-ups

    IPR2bits.OSCFIP = 1;                // Clock Fail-Safe interrupt has high priority 
    PIE2bits.OSCFIE = 1;                // Enable Clock Fail-Safe interrupt
    
    RCONbits.IPEN   = 1;    // Enable interrupt priorities
    INTCONbits.GIEH = 1;    // Enable Interrupts
    INTCONbits.GIEL = 1;

    TEST_LED_TRIS   = 0;    // Тестовый светодиодик на 33 ноге
    TEST_LED_PORT   = 0;

    // Включаем собаку
    WDTCONbits.SWDTEN = 1;

    #if defined(MAC_I2C_EEPROM)
        InitI2cEeprom();
    #endif      
    
    PORTCbits.RC2 = 1;
    TRISCbits.TRISC2 = 1;
}

// Восстановить настройки из EEPROM
void RestoreSettings(void)
{   
    // Обновляем настройки из памяти
    SettingsInit(&SettingsTable);
    
    
    // Шиворот-на-выворот
    DeviceData.IPAddress.v[0]  = AppConfig.MyIPAddr.v[3]; 
    DeviceData.IPAddress.v[1]  = AppConfig.MyIPAddr.v[2]; 
    DeviceData.IPAddress.v[2]  = AppConfig.MyIPAddr.v[1]; 
    DeviceData.IPAddress.v[3]  = AppConfig.MyIPAddr.v[0]; 
    
    DeviceData.NetMask.v[0]  = AppConfig.MyMask.v[3]; 
    DeviceData.NetMask.v[1]  = AppConfig.MyMask.v[2]; 
    DeviceData.NetMask.v[2]  = AppConfig.MyMask.v[1]; 
    DeviceData.NetMask.v[3]  = AppConfig.MyMask.v[0]; 
    
    DeviceData.DefGatw.v[0]  = AppConfig.MyGateway.v[3]; 
    DeviceData.DefGatw.v[1]  = AppConfig.MyGateway.v[2]; 
    DeviceData.DefGatw.v[2]  = AppConfig.MyGateway.v[1]; 
    DeviceData.DefGatw.v[3]  = AppConfig.MyGateway.v[0];


    // Если DHCP
    if(AppConfig.Flags.bIsDHCPEnabled)
    {
        // Сбрасываем DHCP
        DHCPInit(0);
    }
}




// Установка текущего IP
void SetMyIP(void)
{
    ResetStatus.IsReset = 1;                                        // Устанавливаем флаг сброса за текущую сессию
    ResetStatus.OldDhcpStatus = AppConfig.Flags.bIsDHCPEnabled;     //Сохраняем статус DHCP

    //Сохраняем старый IP
    ResetStatus.OldIP.Val = AppConfig.MyIPAddr.Val;

    AppConfig.MyIPAddr.v[0] = MY_DEFAULT_IP_ADDR_BYTE1;      
    AppConfig.MyIPAddr.v[1] = MY_DEFAULT_IP_ADDR_BYTE2;                                  
    AppConfig.MyIPAddr.v[2] = MY_DEFAULT_IP_ADDR_BYTE3;                                  
    AppConfig.MyIPAddr.v[3] = MY_DEFAULT_IP_ADDR_BYTE4;
                                
    AppConfig.DefaultIPAddr.Val = AppConfig.MyIPAddr.Val;

    AppConfig.MyMask.v[0] = 255;
    AppConfig.MyMask.v[1] = 255;
    AppConfig.MyMask.v[2] = 255;
    AppConfig.MyMask.v[3] = 0;

    AppConfig.DefaultMask.Val =  AppConfig.MyMask.Val;

    AppConfig.MyGateway.Val =           MY_DEFAULT_GATE_BYTE1       | 
                                        MY_DEFAULT_GATE_BYTE2<<8ul  | 
                                        MY_DEFAULT_GATE_BYTE3<<16ul | 
                                        MY_DEFAULT_GATE_BYTE4<<24ul;

    AppConfig.PrimaryDNSServer.Val =    MY_DEFAULT_PRIMARY_DNS_BYTE1        | 
                                        MY_DEFAULT_PRIMARY_DNS_BYTE2<<8ul   | 
                                        MY_DEFAULT_PRIMARY_DNS_BYTE3<<16ul  | 
                                        MY_DEFAULT_PRIMARY_DNS_BYTE4<<24ul;
    AppConfig.SecondaryDNSServer.Val =  MY_DEFAULT_SECONDARY_DNS_BYTE1       | 
                                        MY_DEFAULT_SECONDARY_DNS_BYTE2<<8ul  | 
                                        MY_DEFAULT_SECONDARY_DNS_BYTE3<<16ul |
                                        MY_DEFAULT_SECONDARY_DNS_BYTE4<<24ul;
    
    AppConfig.Flags.bIsDHCPEnabled = 0; // Выключаем DHCP
    
    // Шиворот на выворот
    DeviceData.IPAddress.v[0]  = AppConfig.MyIPAddr.v[3]; 
    DeviceData.IPAddress.v[1]  = AppConfig.MyIPAddr.v[2]; 
    DeviceData.IPAddress.v[2]  = AppConfig.MyIPAddr.v[1]; 
    DeviceData.IPAddress.v[3]  = AppConfig.MyIPAddr.v[0]; 
    
    DeviceData.NetMask.v[0]  = AppConfig.MyMask.v[3]; 
    DeviceData.NetMask.v[1]  = AppConfig.MyMask.v[2]; 
    DeviceData.NetMask.v[2]  = AppConfig.MyMask.v[1]; 
    DeviceData.NetMask.v[3]  = AppConfig.MyMask.v[0]; 
    
    DeviceData.DefGatw.v[0]  = AppConfig.MyGateway.v[3]; 
    DeviceData.DefGatw.v[1]  = AppConfig.MyGateway.v[2]; 
    DeviceData.DefGatw.v[2]  = AppConfig.MyGateway.v[1]; 
    DeviceData.DefGatw.v[3]  = AppConfig.MyGateway.v[0];
    
}




// Проверяем состояние кнопки "Сброс IP"
void PollResetButon(void)
{
    static BYTE ShortPushFlag        = 0;
    static BYTE LongPushFlag         = 0;   
    static BYTE ResetIpShortPushTime = 0;   // Время коротрокого нажатия на кнопку в тиках 100 мс
    static BYTE ResetIpLongPushTime  = 0;   // Время долгого нажатия на кнопку в тиках 100 мс


    if(ResetButton_IN == 0)             // Если кнопка нажата
    {                                           
        if(ResetIpShortPushTime == 20 && ShortPushFlag == 0)    // 2 секунды
        {
            ShortPushFlag = 1;
            ECON2bits.ETHEN = 0;    // Выключить Ethernet!
            LATA = 0;               // Выключаем диоды
            TRISA &= ~0b00000011;   // Настраиваем порты светодиодов на выходы
            ResetIpShortPushTime = 0;   
            SetMyIP();                          // Устанавливаем текущий IP     
        }

        if(ResetIpLongPushTime == 50 && LongPushFlag == 0)          // 5 секунд
        {
            LongPushFlag = 1;
            ResetIpLongPushTime = 0;            // Устанавливаем постоянный IP
            SettingsSetDefaul(&SettingsTable);  // Установка всех сохраняемых параметров по умолчанию
            SettingsSave(&SettingsTable);
        }
        if(ShortPushFlag == 1 && LongPushFlag == 0)
            LATAbits.LATA0 ^= 1;

        if(LongPushFlag == 1)
            LATAbits.LATA1 ^= 1;                    // Моргаем светодиодом B

        
            ++ResetIpShortPushTime;
            ++ResetIpLongPushTime;  
    }
    else
    {
        ECON2bits.ETHEN = 1;                    // Включаем Ethernet!

        ResetIpShortPushTime = ShortPushFlag = 0;
        ResetIpLongPushTime = LongPushFlag = 0;
    }    
}


// Запрос состояния флагов аппаратног сброса IP
HDWR_RST_STATUS GetHarwareResetStatus()
{
    return ResetStatus;
}




/*********************************************************************
 * Function:        void InitAppConfig(void)
 *
 * PreCondition:    MPFSInit() is already called.
 *
 * Input:           None
 *
 * Output:          Write/Read non-volatile config variables.
 *
 * Side Effects:    None
 *
 * Overview:        None
 *
 * Note:            None
 ********************************************************************/
// MAC Address Serialization using a MPLAB PM3 Programmer and 
// Serialized Quick Turn Programming (SQTP). 
// The advantage of using SQTP for programming the MAC Address is it
// allows you to auto-increment the MAC address without recompiling 
// the code for each unit.  To use SQTP, the MAC address must be fixed
// at a specific location in program memory.  Uncomment these two pragmas
// that locate the MAC address at 0x1FFF0.  Syntax below is for MPLAB C 
// Compiler for PIC18 MCUs. Syntax will vary for other compilers.
//#pragma romdata MACROM=0x1FFF0
static ROM BYTE SerializedMACAddress[6] = {MY_DEFAULT_MAC_BYTE1, MY_DEFAULT_MAC_BYTE2, MY_DEFAULT_MAC_BYTE3, MY_DEFAULT_MAC_BYTE4, MY_DEFAULT_MAC_BYTE5, MY_DEFAULT_MAC_BYTE6};
//#pragma romdata



static void InitAppConfig(void)
{
	    BYTE dt = 0;
        BYTE k = 0;
        // Start out zeroing all AppConfig bytes to ensure all fields are 
        // deterministic for checksum generation
        memset((void*)&AppConfig,      0x00, sizeof(AppConfig));
        
        AppConfig.Flags.bIsDHCPEnabled = FALSE;
        AppConfig.Flags.bInConfigMode = TRUE;
        memcpypgm2ram((void*)&AppConfig.MyMACAddr, (ROM void*)SerializedMACAddress, sizeof(AppConfig.MyMACAddr));
//      {
//          _prog_addressT MACAddressAddress;
//          MACAddressAddress.next = 0x157F8;
//          _memcpy_p2d24((char*)&AppConfig.MyMACAddr, MACAddressAddress, sizeof(AppConfig.MyMACAddr));
//      }
        AppConfig.MyIPAddr.Val = MY_DEFAULT_IP_ADDR_BYTE1 | MY_DEFAULT_IP_ADDR_BYTE2<<8ul | MY_DEFAULT_IP_ADDR_BYTE3<<16ul | MY_DEFAULT_IP_ADDR_BYTE4<<24ul;
        AppConfig.DefaultIPAddr.Val = AppConfig.MyIPAddr.Val;
        AppConfig.MyMask.Val = MY_DEFAULT_MASK_BYTE1 | MY_DEFAULT_MASK_BYTE2<<8ul | MY_DEFAULT_MASK_BYTE3<<16ul | MY_DEFAULT_MASK_BYTE4<<24ul;
        AppConfig.DefaultMask.Val = AppConfig.MyMask.Val;
        AppConfig.MyGateway.Val = MY_DEFAULT_GATE_BYTE1 | MY_DEFAULT_GATE_BYTE2<<8ul | MY_DEFAULT_GATE_BYTE3<<16ul | MY_DEFAULT_GATE_BYTE4<<24ul;
        AppConfig.PrimaryDNSServer.Val = MY_DEFAULT_PRIMARY_DNS_BYTE1 | MY_DEFAULT_PRIMARY_DNS_BYTE2<<8ul  | MY_DEFAULT_PRIMARY_DNS_BYTE3<<16ul  | MY_DEFAULT_PRIMARY_DNS_BYTE4<<24ul;
        AppConfig.SecondaryDNSServer.Val = MY_DEFAULT_SECONDARY_DNS_BYTE1 | MY_DEFAULT_SECONDARY_DNS_BYTE2<<8ul  | MY_DEFAULT_SECONDARY_DNS_BYTE3<<16ul  | MY_DEFAULT_SECONDARY_DNS_BYTE4<<24ul;
    

// SNMP Community String configuration
    #if defined(STACK_USE_SNMP_SERVER)
        {
            BYTE i;
            static ROM char * ROM cReadCommunities[] = SNMP_READ_COMMUNITIES;
            static ROM char * ROM cWriteCommunities[] = SNMP_WRITE_COMMUNITIES;
            ROM char * strCommunity;
            
            for(i = 0; i < SNMP_MAX_COMMUNITY_SUPPORT; i++)
            {
                // Get a pointer to the next community string
                strCommunity = cReadCommunities[i];
                if(i >= sizeof(cReadCommunities)/sizeof(cReadCommunities[0]))
                    strCommunity = "";
    
                // Ensure we don't buffer overflow.  If your code gets stuck here, 
                // it means your SNMP_COMMUNITY_MAX_LEN definition in TCPIPConfig.h 
                // is either too small or one of your community string lengths 
                // (SNMP_READ_COMMUNITIES) are too large.  Fix either.
                if(strlenpgm(strCommunity) >= sizeof(AppConfig.readCommunity[0]))
                    while(1);
                
                // Copy string into AppConfig
                strcpypgm2ram((char*)AppConfig.readCommunity[i], strCommunity);
    
                // Get a pointer to the next community string
                strCommunity = cWriteCommunities[i];
                if(i >= sizeof(cWriteCommunities)/sizeof(cWriteCommunities[0]))
                    strCommunity = "";
    
                // Ensure we don't buffer overflow.  If your code gets stuck here, 
                // it means your SNMP_COMMUNITY_MAX_LEN definition in TCPIPConfig.h 
                // is either too small or one of your community string lengths 
                // (SNMP_WRITE_COMMUNITIES) are too large.  Fix either.
                if(strlenpgm(strCommunity) >= sizeof(AppConfig.writeCommunity[0]))
                    while(1);
    
                // Copy string into AppConfig
                strcpypgm2ram((char*)AppConfig.writeCommunity[i], strCommunity);
            }
        }
    #endif




        // Load the default NetBIOS Host Name
        memcpypgm2ram(AppConfig.NetBIOSName, (ROM void*)MY_DEFAULT_HOST_NAME, 16);
        FormatNetBIOSName(AppConfig.NetBIOSName);

        
        // Очистка структуры статуса аппаратного сброса
        ResetStatus.IsReset = 0;
        ResetStatus.OldDhcpStatus = 0;
        ResetStatus.OldIP = AppConfig.DefaultIPAddr;
        
        // Восстанавливаем MAC адрес из памяти
        if(!EEPROM_READ_TEST())
            EEPROM_ReadMAC(&AppConfig.MyMACAddr.v[0]);

        /*
        // Очистка памяти перед восстановлением
        for(k = 0; k < 128; k++)
            EEPROM_WriteArray(k, &dt, 1);
        */
        
        // Восстанавливаем все остальное из памяти
        RestoreSettings();   
}



 
/******************************************************************
 * Вызывается для отложенной смены настроек. Содержимое переменной 
 * с новыми настройками идет прямо в EEPROM. Текущий же регистр 
 * AppConfig не изменяется. Его можно из менить позднее по 
 * таймеру и спец. флагу в главном цикле. 
 *  
 * Область применения - изменение IP адреса из Web или SNMP, когда 
 * надо отправить подтверждение на старых настройках, а затем 
 * обновить их
 *  
 * 
 * @author _ (01.10.2012)
 * 
 * @param pAppConfig  - указатель на новую переменую с настройками 
 *                    
 ******************************************************************/
void SaveAppConfig(APP_CONFIG *pAppConfig)
{
    APP_CONFIG tmpAppConfig;
    
    if(pAppConfig != NULL)
    {
        memcpy((void*)&tmpAppConfig, (void*)(&AppConfig), sizeof(APP_CONFIG));
        memcpy((void*)&AppConfig, (void*)(pAppConfig), sizeof(APP_CONFIG));
        SettingsSave(&SettingsTable);
        memcpy((void*)&AppConfig, (void*)(&tmpAppConfig), sizeof(APP_CONFIG));
    }
}
    








// Прерывание по ошибке генерации
void FailSafeHandler(void)
{
    BYTE i = 0; 
    BYTE j = 50;

    PIR2bits.OSCFIF = 0;    // Сбрасываем флаг

    ECON2bits.ETHEN = 0;    // Выключить Ethernet!
    LATA = 0;               // Выключаем диоды
    TRISA &= ~0b00000011;   // Настраиваем порты светодиодов на выходы

    while(j--)
    {
        LATAbits.LATA0 ^= 1;    // Моргаем диодом
    
        for(i = 0; i < 75; i++)
            Nop();

        ClrWdt();
    }

    Reset();                // Сбрасываем проц
}


// Ошибка I2C - сработал таймаут
void I2C_Fail_Timeout()
{
    UINT32 t = 0;
    BYTE j = 50;            // Сколько ждать перед сбросом проца
    
    ECON2bits.ETHEN = 0;    // Выключить Ethernet!
    LATA = 0;               // Выключаем диоды
    TRISA &= ~0b00000011;   // Настраиваем порты светодиодов на выходы

    while(j)
    {
        // 200 ms - период мигания диодами
        if(TickGet() - t >= TICK_SECOND/5ul )
        {
            t = TickGet();

            LATAbits.LATA0 ^= 1;    // Моргаем диодами
            LATAbits.LATA1 ^= 1;

            j--;
        }

        ClrWdt();

        Nop();
        Nop();
        Nop();  // Для уменьшения энергопотребления
        Nop();
        Nop();
    }

    Reset();                // Сбрасываем проц
}
