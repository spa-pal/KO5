/* Список параметров, объявления значений параметров по умолчанию */
 
#include "compiler.h"
#include "GenericTypeDefs.h" 
#include "ParamList.h"
#include "TCPIP Stack/TCPIP.h"
#include "DeviceData.h"
 

// Настройки TCP/IP стека по умолчанию. Сюда копировать default данные при инициализации

// MyIPAddr - IP address
const IP_ADDR  IpAddr_def   =   MY_DEFAULT_IP_ADDR_BYTE1                 | 
                                MY_DEFAULT_IP_ADDR_BYTE2        << 8ul   | 
                                MY_DEFAULT_IP_ADDR_BYTE3        << 16ul  | 
                                MY_DEFAULT_IP_ADDR_BYTE4        << 24ul;

// MyMask   - Subnet mask
const IP_ADDR  NetMask_def  =   MY_DEFAULT_MASK_BYTE1                    | 
                                MY_DEFAULT_MASK_BYTE2           << 8ul   | 
                                MY_DEFAULT_MASK_BYTE3           << 16ul  | 
                                MY_DEFAULT_MASK_BYTE4           << 24ul;

// MyGateway - Default Gateway
const IP_ADDR  DefGw_def    =   MY_DEFAULT_GATE_BYTE1                    | 
                                MY_DEFAULT_GATE_BYTE2           << 8ul   | 
                                MY_DEFAULT_GATE_BYTE3           << 16ul  | 
                                MY_DEFAULT_GATE_BYTE4           << 24ul;


const IP_ADDR SNMPTrapServer1_def = 0x00000000;
const IP_ADDR SNMPTrapServer2_def = 0x00000000;
const IP_ADDR SNMPTrapServer3_def = 0x00000000;
const IP_ADDR SNMPTrapServer4_def = 0x00000000;
const IP_ADDR SNMPTrapServer5_def = 0x00000000;
const UINT16  SNMPReadPort_def    = 161;                          
const UINT16  SNMPWritePort_def   = 162;    
const UINT8   SNMPReadCommunityName_def[] = "public\0\0\0\0\0\0\0\0\0";  
const UINT8   DeviceLocation_def[]    = "Not specified\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
const UINT8   SNMPWriteCommunityName_def[] = "private\0\0\0\0\0\0\0\0";






