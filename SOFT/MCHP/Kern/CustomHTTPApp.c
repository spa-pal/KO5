#define __CUSTOMHTTPAPP_C

#include "TCPIPConfig.h"

#if defined(STACK_USE_HTTP2_SERVER)

#include "TCPIP Stack/TCPIP.h"
#include "Main.h"               // Needed for SaveAppConfig() prototype
#include "I2cEEPROM.h"
#include "HTTPApp.h"

/****************************************************************************
  Section:
    Function Prototypes and Memory Globalizers
  ***************************************************************************/
#if defined(HTTP_USE_POST)
    #if defined(STACK_USE_HTTP_APP_RECONFIG)
        extern APP_CONFIG       AppConfig;
        static HTTP_IO_RESULT HTTPPostConfig(void);
    #endif
#endif

// Sticky status message variable.
// This is used to indicated whether or not the previous POST operation was 
// successful.  The application uses these to store status messages when a 
// POST operation redirects.  This lets the application provide status messages
// after a redirect, when connection instance data has already been lost.
static BOOL lastSuccess = FALSE;

// Stick status message variable.  See lastSuccess for details.
static BOOL lastFailure = FALSE;

// Флаг, сигнализирующий о необходимости редиректа Web страницы
// Указывает, что надо прописать скрипт редиректа при помощи cgi 
// чтобы браузер перезалил страницу через заданное время, когда
// контроллер уже обновил настройки (обычно хватает 1 сек)
static BOOL NeedRedirect = 0;   
static BOOL NeedRefreshNetworkSett = 0; 


void HTTPPrintIP(IP_ADDR ip);




/****************************************************************************
  Section:
    GET Form Handlers
  ***************************************************************************/
  
/*****************************************************************************
  Function:
    HTTP_IO_RESULT HTTPExecuteGet(void)
    
  Internal:
    See documentation in the TCP/IP Stack API or HTTP2.h for details.
  ***************************************************************************/
HTTP_IO_RESULT HTTPExecuteGet(void)
{
    return HTTP_IO_DONE;
}


/****************************************************************************
  Section:
    POST Form Handlers
  ***************************************************************************/
#if defined(HTTP_USE_POST)

/*****************************************************************************
  Function:
    HTTP_IO_RESULT HTTPExecutePost(void)
    
  Internal:
    See documentation in the TCP/IP Stack API or HTTP2.h for details.
  ***************************************************************************/
HTTP_IO_RESULT HTTPExecutePost(void)
{
    // Resolve which function to use and pass along
    BYTE filename[20];
    
    // Load the file name
    // Make sure BYTE filename[] above is large enough for your longest name
    MPFSGetFilename(curHTTP.file, filename, sizeof(filename));
    
#if defined(STACK_USE_HTTP_APP_RECONFIG)
    if(!memcmppgm2ram(filename, "index.htm", 9))
        return HTTPPostConfig();
#endif

    return HTTP_IO_DONE;
}


/*****************************************************************************
  Function:
    static HTTP_IO_RESULT HTTPPostConfig(void)

  Summary:
    Processes the configuration form on config/index.htm

  Description:
    Accepts configuration parameters from the form, saves them to a
    temporary location in RAM, then eventually saves the data to EEPROM or
    external Flash.
    
    When complete, this function redirects to config/reboot.htm, which will
    display information on reconnecting to the board.

    This function creates a shadow copy of the AppConfig structure in 
    RAM and then overwrites incoming data there as it arrives.  For each 
    name/value pair, the name is first read to curHTTP.data[0:5].  Next, the 
    value is read to newAppConfig.  Once all data has been read, the new
    AppConfig is saved back to EEPROM and the browser is redirected to 
    reboot.htm.  That file includes an AJAX call to reboot.cgi, which 
    performs the actual reboot of the machine.
    
    If an IP address cannot be parsed, too much data is POSTed, or any other 
    parsing error occurs, the browser reloads config.htm and displays an error 
    message at the top.

  Precondition:
    None

  Parameters:
    None

  Return Values:
    HTTP_IO_DONE - all parameters have been processed
    HTTP_IO_NEED_DATA - data needed by this function has not yet arrived
  ***************************************************************************/
#if defined(STACK_USE_HTTP_APP_RECONFIG)

APP_CONFIG      newAppConfig;

static HTTP_IO_RESULT HTTPPostConfig(void)
{
    BYTE *ptr;
    BYTE i;

    // Check to see if the browser is attempting to submit more data than we 
    // can parse at once.  This function needs to receive all updated 
    // parameters and validate them all before committing them to memory so that
    // orphaned configuration parameters do not get written (for example, if a 
    // static IP address is given, but the subnet mask fails parsing, we 
    // should not use the static IP address).  Everything needs to be processed 
    // in a single transaction.  If this is impossible, fail and notify the user.
    // As a web devloper, if you add parameters to AppConfig and run into this 
    // problem, you could fix this by to splitting your update web page into two 
    // seperate web pages (causing two transactional writes).  Alternatively, 
    // you could fix it by storing a static shadow copy of AppConfig someplace 
    // in memory and using it instead of newAppConfig.  Lastly, you could 
    // increase the TCP RX FIFO size for the HTTP server.  This will allow more 
    // data to be POSTed by the web browser before hitting this limit.
    if(curHTTP.byteCount > TCPIsGetReady(sktHTTP) + TCPGetRxFIFOFree(sktHTTP))
        goto ConfigFailure;
    
    // Ensure that all data is waiting to be parsed.  If not, keep waiting for 
    // all of it to arrive.
    if(TCPIsGetReady(sktHTTP) < curHTTP.byteCount)
        return HTTP_IO_NEED_DATA;
    

    memcpy((void*)&newAppConfig,      (void*)&AppConfig,      sizeof(APP_CONFIG));     
   

    
    // Start out assuming that DHCP is disabled.  This is necessary since the 
    // browser doesn't submit this field if it is unchecked (meaning zero).  
    // However, if it is checked, this will be overridden since it will be 
    // submitted.
    newAppConfig.Flags.bIsDHCPEnabled = 0;

    // Read all browser POST data
    while(curHTTP.byteCount)
    {
        // Read a form field name
        if(HTTPReadPostName(curHTTP.data, 6) != HTTP_READ_OK)
            goto ConfigFailure;
            
        // Read a form field value
        if(HTTPReadPostValue(curHTTP.data + 6, sizeof(curHTTP.data)-6-2) != HTTP_READ_OK)
            goto ConfigFailure;
            
        // Parse the value that was read
        if(!strcmppgm2ram((char*)curHTTP.data, (ROM char*)"ip"))
        {// Read new static IP Address
            if(!StringToIPAddress(curHTTP.data+6, &newAppConfig.MyIPAddr)               ||
                                                   newAppConfig.MyIPAddr.v[0] == 127    || // Если IP начинается со 127     
                                                   newAppConfig.MyIPAddr.v[0] < 1       || // Если IP начинается с 0
                                                   newAppConfig.MyIPAddr.v[0] > 223     || // или с 224 и выше      
                                                   newAppConfig.MyIPAddr.v[3] == 255       // Если IP заканчивается на 255
                                  )
                goto ConfigFailure;
                
            newAppConfig.DefaultIPAddr.Val = newAppConfig.MyIPAddr.Val;     // Для сохранения текущего адреса и default адреса
            AppConfig.DefaultIPAddr.Val = newAppConfig.DefaultIPAddr.Val;   
        }   
        else if(!strcmppgm2ram((char*)curHTTP.data, (ROM char*)"gw"))
        {// Read new gateway address
            if(!StringToIPAddress(curHTTP.data+6, &newAppConfig.MyGateway)              ||
                                                   newAppConfig.MyGateway.v[0] == 127   || // Если IP начинается со 127     
                                                   newAppConfig.MyGateway.v[0] < 1      || // Если IP начинается с 0
                                                   newAppConfig.MyGateway.v[0] > 223    || // или с 224 и выше      
                                                   newAppConfig.MyGateway.v[3] == 255      // Если IP заканчивается на 255
               )
                goto ConfigFailure;
        }
        else if(!strcmppgm2ram((char*)curHTTP.data, (ROM char*)"sub"))
        {// Read new static subnet
            if(!StringToIPAddress(curHTTP.data+6, &newAppConfig.MyMask))
                goto ConfigFailure;

            newAppConfig.DefaultMask.Val = newAppConfig.MyMask.Val;
        }
        else if(!strcmppgm2ram((char*)curHTTP.data, (ROM char*)"mac"))
        {
            // Read new MAC address
            WORD w;
            BYTE i;

            ptr = curHTTP.data+6;

            for(i = 0; i < 12u; i++)
            {// Read the MAC address
                
                // Skip non-hex bytes
                while( *ptr != 0x00u && !(*ptr >= '0' && *ptr <= '9') && !(*ptr >= 'A' && *ptr <= 'F') && !(*ptr >= 'a' && *ptr <= 'f') )
                    ptr++;

                // MAC string is over, so zeroize the rest
                if(*ptr == 0x00u)
                {
                    for(; i < 12u; i++)
                        curHTTP.data[i] = '0';
                    break;
                }
                
                // Save the MAC byte
                curHTTP.data[i] = *ptr++;
            }
            
            // Read MAC Address, one byte at a time
            for(i = 0; i < 6u; i++)
            {
                ((BYTE*)&w)[1] = curHTTP.data[i*2];
                ((BYTE*)&w)[0] = curHTTP.data[i*2+1];
                newAppConfig.MyMACAddr.v[i] = hexatob(*((WORD_VAL*)&w));
            }
        }
        else if(!strcmppgm2ram((char*)curHTTP.data, (ROM char*)"host"))
        {// Read new hostname
            FormatNetBIOSName(&curHTTP.data[6]);
            memcpy((void*)newAppConfig.NetBIOSName, (void*)curHTTP.data+6, 16);
        }
    }

    // Сохраняем настройки в EEPROM
    SaveAppConfig(&newAppConfig);
    
    
    // Редирект на текущую страницу, т.к. настройки сохранены, но пока не применены
    strcpypgm2ram((char*)curHTTP.data, "index.htm");

    // Заставим задачу HTTP2 обновить страницу
    curHTTP.httpStatus = HTTP_REDIRECT; 


    if(
        AppConfig.MyIPAddr.Val              != newAppConfig.MyIPAddr.Val                                || 
        AppConfig.MyMask.Val                != newAppConfig.MyMask.Val                                  ||
        AppConfig.MyGateway.Val             != newAppConfig.MyGateway.Val                               ||
        memcmp((void*)(AppConfig.MyMACAddr.v), (void*)(newAppConfig.MyMACAddr.v), sizeof(AppConfig.MyMACAddr))        
      )
    {
        // При обновлении страницы должен быть прописан html код редиректа на страницу с новыми настройками 
        NeedRedirect = NeedRefreshNetworkSett = TRUE;    
    }
    
    return HTTP_IO_DONE;


ConfigFailure:
    lastFailure = TRUE;
    strcpypgm2ram((char*)curHTTP.data, "index.htm");
    curHTTP.httpStatus = HTTP_REDIRECT;     

    return HTTP_IO_DONE;
}

#endif  // #if defined(STACK_USE_HTTP_APP_RECONFIG)


// Запрос новых сетевых настроек
BOOL HTTPNeedToChangeNetSett()
{
    // Если надо обновить настройки сети и указатели корректны
    if(NeedRefreshNetworkSett)
    {
        NeedRefreshNetworkSett = 0;
        return 1;               // Новые настройки есть
    }

    return 0;                   // Новых настроек нет
}   


#endif //(use_post)


/****************************************************************************
  Section:
    Dynamic Variable Callback Functions
  ***************************************************************************/

/*****************************************************************************
  Function:
    void HTTPPrint_varname(void)
    
  Internal:
    See documentation in the TCP/IP Stack API or HTTP2.h for details.
  ***************************************************************************/
// ============================== ДАТА/ВРЕМЯ СБОРКИ ===========================
void HTTPPrint_builddate(void)
{
    curHTTP.callbackPos = 0x01;
    if(TCPIsPutReady(sktHTTP) < strlenpgm((ROM char*)__DATE__" "__TIME__))
        return;
    
    curHTTP.callbackPos = 0x00;
    TCPPutROMString(sktHTTP, (ROM void*)__DATE__" "__TIME__);
}

// ========================== ВЕРСИЯ АППАРАТНОЙ ЧАСТИ =========================
void HTTPPrint_HardwareVer(void)
{
    TCPPutROMString(sktHTTP, (ROM void*)HARD_VER);
}

// ================================ ВЕРСИЯ ПО =================================
void HTTPPrint_SoftwareVer(void)
{
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

    TCPPutROMString(sktHTTP, (ROM void*)SOFT_VER);  // Старшая часть версии                                             
    TCPPutString(sktHTTP, Tmp);                     // Младшая, часть с датой
}

// ============================== ТИП КОНТРОЛЛЕРА =============================
void HTTPPrint_McuType(void)
{
    TCPPutROMString(sktHTTP, (ROM void*)MCU_VER);
}

// =========================== ВЕРСИЯ СТЕКА TCP/IP ===========================
void HTTPPrint_StackVer(void)
{
    TCPPutROMString(sktHTTP, (ROM void*)TCPIP_STACK_VERSION);
}



// ========================== ПОМОШНИК ВЫВОДА АДРЕСОВ ==========================
void HTTPPrintIP(IP_ADDR ip)
{
    BYTE digits[4];
    BYTE i;
    
    for(i = 0; i < 4u; i++)
    {
        if(i)
            TCPPut(sktHTTP, '.');
        uitoa(ip.v[i], digits);
        TCPPutString(sktHTTP, digits);
    }
}

// ================================ ИМЯ ХОСТА ==================================
void HTTPPrint_config_hostname(void)
{
    TCPPutString(sktHTTP, AppConfig.NetBIOSName);
    return;
}


// ================================ IP АДРЕС  ==================================
void HTTPPrint_config_ip(void)
{
    HTTPPrintIP(AppConfig.MyIPAddr);
    return;
}

// ================================== ШЛЮЗ  ====================================
void HTTPPrint_config_gw(void)
{
    HTTPPrintIP(AppConfig.MyGateway);
    return;
}

// ============================== МАСКА ПОДСЕТИ  ===============================
void HTTPPrint_config_subnet(void)
{
    HTTPPrintIP(AppConfig.MyMask);
    return;
}

// ================================ MAC АДРЕС ==================================
void HTTPPrint_config_mac(void)
{
    BYTE i;
    
    if(TCPIsPutReady(sktHTTP) < 18u)
    {//need 17 bytes to write a MAC
        curHTTP.callbackPos = 0x01;
        return;
    }   
    
    // Write each byte
    for(i = 0; i < 6u; i++)
    {
        if(i)
            TCPPut(sktHTTP, ':');
        TCPPut(sktHTTP, btohexa_high(AppConfig.MyMACAddr.v[i]));
        TCPPut(sktHTTP, btohexa_low(AppConfig.MyMACAddr.v[i]));
    }
    
    // Indicate that we're done
    curHTTP.callbackPos = 0x00;
    return;
}

// ====================== ЗАПРЕТ РЕДАКТИРОВАНИЯ MAC АДРЕСА =======================
void HTTPPrint_macdis()
{
    // Если есть в системе EEPROM с MAC адресом - его нельзя редактировать
    #if defined (MAC_I2C_EEPROM)
        TCPPutROMString(sktHTTP, (ROM BYTE*)"disabled");
}


// ===================== БЫЛ ЛИ СБРОШЕН IP АППАРАТНО ======================
void HTTPPrint_IsResetIp(void)
{
    if(GetHarwareResetStatus().IsReset)
        TCPPutROMString(sktHTTP, (ROM BYTE*)"checked");
}

// ================== СТАРЫЙ IP ДО АППАРАТНОГО СБРОСА ======================
void HTTPPrint_OldIP(void)
{
    HDWR_RST_STATUS tmp = GetHarwareResetStatus();
    if(tmp.IsReset)
        HTTPPrintIP(tmp.OldIP);
}


// ===================== СООБЩЕНИЕ О СМЕНЕ УСТАНОВОК =======================
void HTTPPrint_setup(void)
{
    if(NeedRedirect)
    {
        TCPPutROMString(sktHTTP, (ROM BYTE*)"<tr><align=\"center\"><td><h4>Выполняется установка...</h4></td></tr>");
        NeedRedirect = FALSE;
    }
}


// ===================== РЕДИРЕКТ ПРИ ИЗМЕНЕНИИ НАСТРОЕК ===================
void HTTPPrint_Site(void)
{   
    BYTE i = 0;
    BYTE Tmp[17];
    
    // Сбрасываем этот флаг в HTTPPrint_setup
    if(NeedRedirect)
    {
        // Если включили DHCP, то редирект на NetBios name
        if(AppConfig.Flags.bIsDHCPEnabled == 0 && newAppConfig.Flags.bIsDHCPEnabled == 1)
        {
            TCPPutROMString(sktHTTP, (ROM BYTE*)"<meta http-equiv=\"refresh\" content=\"3; url=http://");
            
            memcpy((void*)Tmp, (void*)newAppConfig.NetBIOSName, 16);
            Tmp[16] = 0x00; // Force null termination
            for(i = 0; i < 16u; i++)
            {
                if(Tmp[i] == ' ')
                    Tmp[i] = 0x00;
            } 
            TCPPutString(sktHTTP, (BYTE*)Tmp);  
            TCPPutROMString(sktHTTP, (ROM BYTE*)"\">");
        }
        else
        {
            // Редирект на новый IP  с задержкой 2 с
            TCPPutROMString(sktHTTP, (ROM BYTE*)"<meta http-equiv=\"refresh\" content=\"2; url=http://");
            HTTPPrintIP(AppConfig.DefaultIPAddr);
            TCPPutROMString(sktHTTP, (ROM BYTE*)"\">");
        }
    }
}


#endif
