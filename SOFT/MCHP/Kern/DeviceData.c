#include "GenericTypeDefs.h"
#include "compiler.h"
#include "TCPIP Stack/TCPIP.h"
#include "TCPIPConfig.h"
#include "Main.h"
#include "TCPIP Stack/SNMP.h"
#include "TCPIP Stack/SNMPv3.h"
#include "DeviceData.h"

#pragma udata uartbuf
UINT8   ArrayDeviceLocation   [DEV_LOCATION_LEN] = "default\0";      
UINT8   ArraySpecTrapMess     [SP_TRAP_MESS_LEN] = "Not specified\0";
UINT8   ArrayCommand          [COMMAND_LEN]      = "Not specified\0";      
              

DEVICE_DATA_T DeviceData;
#pragma udata



void DeviceDataInit(void)
{
    memset((void*)&DeviceData, 0x00, sizeof(DEVICE_DATA_T));
    
    DeviceData.SpecTrapMess         = ArraySpecTrapMess;
    DeviceData.Command              = ArrayCommand;
    DeviceData.DeviceLocation       = ArrayDeviceLocation;
    
    DeviceData.SNMPReadPort = 161;
    DeviceData.SNMPWritePort = 162;
    
    DeviceData.CurrentEnergy = 101;
    DeviceData.DeviceInfoResetCounter = 76543;
    DeviceData.SerialNum = 76544;

    
    DeviceData.EnergyMeterAddress = 485;
    //DeviceData.extTemperature = 23;
    DeviceData.ImpEnergyMeterImpulsPerKwth = 10000;
    DeviceData.ImpEnergyMeterTotal = 28500;
    DeviceData.ImpulseEnergyMeter = 110;
    //DeviceData.intTemperature = 38;
    
   
    DeviceData.LogIn1 = 0;
    DeviceData.LogIn2 = 1;
    DeviceData.LogIn3 = 0;
    DeviceData.LogIn4 = 1;
    DeviceData.LogIn5 = 0;
    DeviceData.LogIn6 = 1;
        
    
  
    DeviceData.SpecTrapValue0 = 0;
    DeviceData.SpecTrapValue1 = 1;
    DeviceData.SpecTrapValue2 = 2;
    DeviceData.TotalEnergy = 12345UL;

DeviceData.intTemperAlarm1Logic = 7;
}
