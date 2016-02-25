#ifndef _PARAM_LIST_H
#define _PARAM_LIST_H
 

//#include "param_types.h"  // пользовательские типы параметров
#include "compiler.h"
#include "GenericTypeDefs.h"
#include "TCPIP Stack/TCPIP.h"
 
// ƒескритор параметра
typedef struct _TPARAM_DESC
{
    UINT16      addr;       // смещение параметра относительно базового адреса в NVRAM 
    UINT8       size;       // размер параметра в байтах
    void        *val;       // указатель на рабочую копию параметра в ќ«”              
    void  const *def;       // указатель на значение параметра по умолчанию            
} TPARAM_DESC;


// ќпределение таблицы параметров
typedef struct _TPARAM_TBL
{
    UINT32            addr;   // базовый адрес таблицы параметров в энергонезависимой пам€ти   
    UINT32            size;   // размер таблицы параметров в энергонезависимой пам€ти в байтах 
    UINT16            pnum;   // количество параметров в таблице                               
    TPARAM_DESC const   *dt;  // указатель на массив дескрипторов                              
} TPARAM_TBL;

// ѕеречисление возможных ошибок при работе с сохранением/восстановлением настроек из EEPROM
typedef enum _TPARAM_ERR
{
    TPARAM_NO_ERR = 0,
    TPARAM_READ_CRC_ERR,
    TPARAM_ILLEGAL_ADDR,
    TPARAM_WRITE_ERROR,
    TPARAM_FLASH_UNDEF
}TPARAM_ERR;
 

extern const TPARAM_TBL  SettingsTable;   // таблица параметров


extern const IP_ADDR IpAddr_def;  
extern const IP_ADDR NetMask_def;   
extern const IP_ADDR DefGw_def;   
extern const IP_ADDR SNMPTrapServer1_def;
extern const IP_ADDR SNMPTrapServer2_def;
extern const IP_ADDR SNMPTrapServer3_def;
extern const IP_ADDR SNMPTrapServer4_def;
extern const IP_ADDR SNMPTrapServer5_def;
extern const UINT16 SNMPReadPort_def;
extern const UINT16 SNMPWritePort_def;
extern const UINT8 SNMPReadCommunityName_def[];
extern const UINT8 DeviceLocation_def[];
extern const UINT8   SNMPWriteCommunityName_def[];



  
// ѕрототипы фнкции дл€ работы с сохранением настроек  
TPARAM_ERR SettingsInit(TPARAM_TBL const *tbl);                         // »нициализаци€ всех рабочих копий 
TPARAM_ERR SettingsLoad(TPARAM_TBL const *tbl, UINT16 index);           // «агрузка параметра в рабочую копию по индексу 
TPARAM_ERR SettingsLoadPointer(TPARAM_TBL const *tbl, void *value);     // «агрузка параметра в рабочую копию по указателю 
TPARAM_ERR SettingsSave(TPARAM_TBL const* tbl);                         // —охранение рабочей копии в NVRAM по индексу 
TPARAM_ERR SettingsSavePointer(TPARAM_TBL const *tbl, void *valueue);   // —охранение рабочей копии в NVRAM по указателю 
TPARAM_ERR SettingsReset(TPARAM_TBL const *tbl, UINT16 index);          // —брос параметра на значение по умолчанию по индексу 
TPARAM_ERR SettingsResetPointer(TPARAM_TBL const *tbl, void *val);      // —брос параметра на значение по умолчанию по указателю
TPARAM_ERR SettingsSetDefaul(TPARAM_TBL const *tbl);                    // —брос всех параметров на з-€ по умолчанию


#endif 

