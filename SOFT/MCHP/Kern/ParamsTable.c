/* Таблица параметров */

#include "compiler.h"
#include "GenericTypeDefs.h" 
#include "ParamList.h"  // список параметров
#include "TCPIP Stack/TCPIP.h"
#include "DeviceData.h"
#include "I2cEEPROM.h"


// Размер CRC
#define  CRC_SIZE   2


#define  PAR1_ADDR  0                                       // Адрес  парамтра 1
#define  PAR1_SIZE  sizeof(IP_ADDR)                         // Размер парамтра 1   IP адрес

#define  PAR2_ADDR  (PAR1_ADDR + PAR1_SIZE + CRC_SIZE)      // Маска подсети
#define  PAR2_SIZE  sizeof(IP_ADDR)

#define  PAR3_ADDR  (PAR2_ADDR + PAR2_SIZE + CRC_SIZE)      // Основной шлюз
#define  PAR3_SIZE  sizeof(IP_ADDR)

#define  PAR4_ADDR  (PAR3_ADDR + PAR3_SIZE + CRC_SIZE)      // IP трапсервера 1
#define  PAR4_SIZE  sizeof(IP_ADDR)

#define  PAR5_ADDR  (PAR4_ADDR + PAR4_SIZE + CRC_SIZE)      // IP трапсервера 2
#define  PAR5_SIZE  sizeof(IP_ADDR)

#define  PAR6_ADDR  (PAR5_ADDR + PAR5_SIZE + CRC_SIZE)      // IP трапсервера 3
#define  PAR6_SIZE  sizeof(IP_ADDR)

#define  PAR7_ADDR  (PAR6_ADDR + PAR6_SIZE + CRC_SIZE)      // IP трапсервера 4
#define  PAR7_SIZE  sizeof(IP_ADDR)

#define  PAR8_ADDR  (PAR7_ADDR + PAR7_SIZE + CRC_SIZE)      // IP трапсервера 5
#define  PAR8_SIZE  sizeof(IP_ADDR)

#define  PAR9_ADDR  (PAR8_ADDR + PAR8_SIZE + CRC_SIZE)      // SNMP порт на чтение
#define  PAR9_SIZE  sizeof(UINT16)

#define  PAR10_ADDR  (PAR9_ADDR + PAR9_SIZE + CRC_SIZE)     // SNMP порт на запись
#define  PAR10_SIZE sizeof(UINT16)

#define  PAR11_ADDR  (PAR10_ADDR + PAR10_SIZE + CRC_SIZE)   // SNMP Community Read
#define  PAR11_SIZE  SNMP_COMMUNITY_MAX_LEN

#define  PAR12_ADDR  (PAR11_ADDR + PAR11_SIZE + CRC_SIZE)   // Device Location
#define  PAR12_SIZE  DEV_LOCATION_LEN

#define  PAR13_ADDR  (PAR12_ADDR + PAR12_SIZE + CRC_SIZE)   // SNMP Community Write
#define  PAR13_SIZE  SNMP_COMMUNITY_MAX_LEN
 
const TPARAM_DESC param_desc_table[] =
{
//                 addr    size             *p RAM                                                      *p ROM
/* (  1) */ {  PAR1_ADDR,  PAR1_SIZE,       &AppConfig.MyIPAddr.v[0],                                  &IpAddr_def}, 
/* (  2) */ {  PAR2_ADDR,  PAR2_SIZE,       &AppConfig.MyMask.v[0],                                    &NetMask_def},
/* (  3) */ {  PAR3_ADDR,  PAR3_SIZE,       &AppConfig.MyGateway.v[0],                                 &DefGw_def},   
/* (  4) */ {  PAR4_ADDR,  PAR4_SIZE,       &DeviceData.SNMPTrapServer1.Val,                           &SNMPTrapServer1_def}, 
/* (  5) */ {  PAR5_ADDR,  PAR5_SIZE,       &DeviceData.SNMPTrapServer2.Val,                           &SNMPTrapServer2_def},
/* (  6) */ {  PAR6_ADDR,  PAR6_SIZE,       &DeviceData.SNMPTrapServer3.Val,                           &SNMPTrapServer3_def},
/* (  7) */ {  PAR7_ADDR,  PAR7_SIZE,       &DeviceData.SNMPTrapServer4.Val,                           &SNMPTrapServer4_def},
/* (  8) */ {  PAR8_ADDR,  PAR8_SIZE,       &DeviceData.SNMPTrapServer5.Val,                           &SNMPTrapServer5_def},     
/* (  9) */ {  PAR9_ADDR,  PAR9_SIZE,       &DeviceData.SNMPReadPort,                                  &SNMPReadPort_def}, 
/* ( 10) */ { PAR10_ADDR, PAR10_SIZE,       &DeviceData.SNMPWritePort,                                 &SNMPWritePort_def},   
/* ( 11) */ { PAR11_ADDR, PAR11_SIZE,       &AppConfig.readCommunity[0][0],                            SNMPReadCommunityName_def}, 
/* ( 12) */ { PAR12_ADDR, PAR12_SIZE,       &ArrayDeviceLocation[0],                                   DeviceLocation_def}, 
/* ( 13) */ { PAR13_ADDR, PAR13_SIZE,       &AppConfig.writeCommunity[0][0],                           SNMPWriteCommunityName_def},   
  
};
 
const TPARAM_TBL SettingsTable = {
    0x00,                                           // абсолютный адрес таблицы в NVRAM (UINT32)
    PAR13_ADDR + PAR13_SIZE + CRC_SIZE,               // @@ var @@ размер таблицы в NVRAM в байтах (addr_last + size_last + crc_sz)
    sizeof(param_desc_table)/sizeof(TPARAM_DESC),   // количество параметров в таблице
    param_desc_table
};


// Инициализация всех рабочих копий 
TPARAM_ERR SettingsInit(TPARAM_TBL const *tbl)
{
    UINT16 i = 0;

    for(i = 0; i < tbl->pnum; i++)
    {
        if(SettingsLoad(tbl, i) != TPARAM_NO_ERR)
            SettingsReset(tbl, i);
    }

    return TPARAM_NO_ERR;
}


// Сброс всех параметров на з-я по умолчанию
TPARAM_ERR SettingsSetDefaul(TPARAM_TBL const *tbl)
{
    UINT16 i = 0;

    for(i = 0; i < tbl->pnum; i++)
        SettingsReset(tbl, i);       // Сброс

    return TPARAM_NO_ERR;
}


// Загрузка параметра в рабочую копию по индексу 
TPARAM_ERR SettingsLoad(TPARAM_TBL const *tbl, UINT16 index)
{
    UINT16 crcRead = 0;
    UINT16 crcCalc = 0;

    if(index < (tbl -> pnum)) 
    {
        EEPROM_ReadArray(tbl->dt[index].addr, (UINT8*)(tbl->dt[index].val), tbl->dt[index].size);      // Читаем данные
        EEPROM_ReadArray(tbl->dt[index].addr + tbl->dt[index].size, (UINT8*)&crcRead, sizeof(crcRead));// Читаем CRC
        crcCalc = CalcIPChecksum((UINT8*)(tbl->dt[index].val), tbl->dt[index].size);                    // Считаем CRC

        if(crcCalc != crcRead)
            return TPARAM_READ_CRC_ERR; 
        
        return TPARAM_NO_ERR; 
    }
    return TPARAM_ILLEGAL_ADDR;
}

// Загрузка параметра в рабочую копию по указателю
TPARAM_ERR SettingsLoadPointer(TPARAM_TBL const *tbl, void *value)
{
    return TPARAM_NO_ERR;
}

/**************************************************************************
 *                      ПРОВЕРКА ЗАПИСАННЫХ ВО FLASH ПАРАМЕТРОВ
 * 
 * @author vadim (10.11.2011)
 * 
 * @param RamData - данные в локальной копии (с чем сравнивать)
 * @param ParAddr - адрес параметра во флеши
 * @param ParSize - размер параметра во флеши
 * 
 * @return BOOL   - TRUE - все хорошо, FALSE - проверка провалена
 **************************************************************************/
BOOL TestSaveParam(UINT8* RamData , UINT16 ParAddr, UINT8 ParSize)
{
    UINT8  i = 0;
    UINT8  testcell = 0;

    for(i = 0; i < ParSize; i++)
    {
        // Читаем данные по одному байту
        EEPROM_ReadArray(ParAddr + i, &testcell, 1);      

        if(testcell != RamData[i])
            return FALSE;
    }
    return TRUE;
}



// Сохранение рабочей копии в NVRAM
TPARAM_ERR SettingsSave(TPARAM_TBL const* tbl)
{
    UINT16 crc = 0;
    UINT16 i = 0;
    UINT8  testcell = 0;
    
    // Если размер памяти привышает отведенное место во флеши. Если попались тут - увеличиваем MPFS_RESERVE_BLOCK в настройках TCP
    if(tbl->size > MPFS_RESERVE_BLOCK)
    {
        return TPARAM_WRITE_ERROR;
    }
 

    for(i = 0; i < tbl -> pnum; i++)
    {
        EEPROM_WriteArray(tbl->dt[i].addr, (UINT8*)(tbl->dt[i].val), tbl->dt[i].size);
        crc = CalcIPChecksum((UINT8*)(tbl->dt[i].val), tbl->dt[i].size);      
        EEPROM_WriteArray(tbl->dt[i].addr + tbl->dt[i].size, (UINT8*)(&crc), sizeof(crc));

        // Проверяем записаные данные
        if(TestSaveParam((UINT8*)(tbl->dt[i].val), tbl->dt[i].addr, tbl->dt[i].size) == FALSE)
        {
            return TPARAM_WRITE_ERROR;
        }
        // Проверяем CRC
        if(TestSaveParam((UINT8*)(&crc), tbl->dt[i].addr + tbl->dt[i].size, sizeof(crc)) == FALSE)
        {
            return TPARAM_WRITE_ERROR;
        }
    }         
    

    return TPARAM_NO_ERR;
}

// Сохранение рабочей копии в NVRAM по указателю
TPARAM_ERR SettingsSavePointer(TPARAM_TBL const *tbl, void *valueue)
{
    return TPARAM_NO_ERR;   // Не реализовано
}



// Сброс параметра на значение по умолчанию по индексу 
TPARAM_ERR SettingsReset(TPARAM_TBL const *tbl, UINT16 index)
{
    UINT16 i = 0;
    UINT16 tmp;
    UINT16 crc = 0;

    if(index < (tbl -> pnum)) 
    {
        // Копируем значение по умолчанию в раб. копию
        for(i = 0; i < tbl->dt[index].size; i++)
        {
            tmp = ((UINT8*)(tbl->dt[index].def))[i];
            ((UINT8*)(tbl->dt[index].val))[i] = (UINT8)tmp;
        }
        return TPARAM_NO_ERR; 
    }
    return TPARAM_ILLEGAL_ADDR;
}



// Сброс параметра на значение по умолчанию по указателю
TPARAM_ERR SettingsResetPointer(TPARAM_TBL const *tbl, void *val)
{
    return TPARAM_NO_ERR;       // Не реализовано
}

