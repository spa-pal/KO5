#ifndef _DEVICE_DATA_
#define _DEVICE_DATA_


#include "GenericTypeDefs.h"
#include "compiler.h"
#include "TCPIP Stack/TCPIP.h"


#define DEV_LOCATION_LEN    32u     // Длина строки места расположения устройства
#define SP_TRAP_MESS_LEN    32u     // Длина строки сообщения последнего трапа
#define COMMAND_LEN         32u     // Длина команды
#define COMMUNITY_LEN       16u     // Длина Community


// ======================= СООБЩЕНИЯ В SNMP ТРАПАХ===================================

#define SNMP_TRAP_MESS_DUMMY        ""
#define SNMP_TRAP_MESS_TEST1        "SNMP test message 1"
#define SNMP_TRAP_MESS_TEST2        "SNMP test message 2"
#define SNMP_TRAP_MESS_HUGE_ONE     "This message is very huge, even tremendous, gigantic I would say. It's significantly longer that 60 symbols!"

// ==================================================================================

// Данные об устройстве
typedef struct
{
    UINT8*  DeviceLocation;       //
    UINT8*  SpecTrapMess; 
    UINT8*  Command; 
    
    UINT32  SerialNum;
    UINT32  TotalEnergy;
    
    UINT16  DeviceInfoResetCounter;
    
    UINT16  CurrentEnergy;
    UINT16  EnergyMeterAddress;                     // 2
    UINT16  intTemperature;
    UINT16  extTemperature;
    INT16  intTemperAlarm1Level;                        // 1
    UINT16  intTemperAlarm2Level;                        // 1
    UINT16  extTemperAlarm1Level;                        // 1
    UINT16  extTemperAlarm2Level;                        // 1
    UINT16	intTemperAlarm1Logic;
    UINT16	intTemperAlarm2Logic;
    UINT16	extTemperAlarm1Logic;
    UINT16	extTemperAlarm2Logic;
    UINT16	intTemperAlarm1Status;
    UINT16	intTemperAlarm2Status;
    UINT16 	extTemperAlarm1Status;
    UINT16 	extTemperAlarm2Status;
    UINT16 	intTemperAlarm1TrapSendAv;
    UINT16 	intTemperAlarm1TrapSendNoAv;
    UINT16 	intTemperAlarm2TrapSendAv;
    UINT16 	intTemperAlarm2TrapSendNoAv;
    UINT16 	extTemperAlarm1TrapSendAv;
    UINT16 	extTemperAlarm1TrapSendNoAv;
    UINT16 	extTemperAlarm2TrapSendAv;
    UINT16 	extTemperAlarm2TrapSendNoAv;
    UINT8  	LogIn1;
    UINT8  	LogIn2;
    UINT8  	LogIn3;
    UINT8  	LogIn4;
    UINT8  	LogIn5;
    UINT8  	LogIn6;
    UINT8  	LogIn1Av;
    UINT8  	LogIn2Av;
    UINT8  	LogIn3Av;
    UINT8  	LogIn4Av;
    UINT8  	LogIn5Av;
    UINT8  	LogIn6Av;
          
    UINT32  SpecTrapValue0;
    UINT32  SpecTrapValue1;
    UINT32  SpecTrapValue2;
    
    UINT32  ImpulseEnergyMeter;
    UINT32  ImpEnergyMeterTotal;
    UINT16  ImpEnergyMeterImpulsPerKwth;            // 2
    IP_ADDR IPAddress;                              // 4
    IP_ADDR NetMask;                                // 4
    IP_ADDR DefGatw;                                // 4
    UINT16  SNMPReadPort;                           // 2
    UINT16  SNMPWritePort;                          // 2
    
    IP_ADDR SNMPTrapServer1;                        // 4 
    IP_ADDR SNMPTrapServer2;                        // 4
    IP_ADDR SNMPTrapServer3;                        // 4
    IP_ADDR SNMPTrapServer4;                        // 4
    IP_ADDR SNMPTrapServer5;                        // 4
    UINT8  	LogIn1StatOfAv;
    UINT8  	LogIn2StatOfAv;
    UINT8 	LogIn3StatOfAv;
    UINT8  	LogIn4StatOfAv;
    UINT8  	LogIn5StatOfAv;
    UINT8  	LogIn6StatOfAv;
    UINT8   LogIn1TrapSendAv;
    UINT8   LogIn2TrapSendAv;
    UINT8   LogIn3TrapSendAv;
    UINT8   LogIn4TrapSendAv;
    UINT8   LogIn5TrapSendAv;
    UINT8   LogIn6TrapSendAv;
    UINT8   LogIn1TrapSendNoAv;
    UINT8   LogIn2TrapSendNoAv;
    UINT8   LogIn3TrapSendNoAv;
    UINT8   LogIn4TrapSendNoAv;
    UINT8   LogIn5TrapSendNoAv;
    UINT8   LogIn6TrapSendNoAv;
    UINT16  Hummidity;
    UINT16  HummidityLevel;
    UINT8	HummidityStatus;
    UINT8	HummidityLogic;
    UINT8   HummidityTrapSendAv;
    UINT8   HummidityTrapSendNoAv;
    
}DEVICE_DATA_T;

// Данные об устройстве доступны глобально
extern DEVICE_DATA_T DeviceData;


extern UINT8   ArrayDeviceLocation   []; 
extern UINT8   ArraySpecTrapMess     []; 
extern UINT8   ArrayCommand          [];      





void DeviceDataInit(void);      // Инициализация данных устройства

#endif
