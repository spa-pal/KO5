#ifndef _PARAM_LIST_H
#define _PARAM_LIST_H
 

//#include "param_types.h"  // ���������������� ���� ����������
#include "compiler.h"
#include "GenericTypeDefs.h"
#include "TCPIP Stack/TCPIP.h"
 
// ��������� ���������
typedef struct _TPARAM_DESC
{
    UINT16      addr;       // �������� ��������� ������������ �������� ������ � NVRAM 
    UINT8       size;       // ������ ��������� � ������
    void        *val;       // ��������� �� ������� ����� ��������� � ���              
    void  const *def;       // ��������� �� �������� ��������� �� ���������            
} TPARAM_DESC;


// ����������� ������� ����������
typedef struct _TPARAM_TBL
{
    UINT32            addr;   // ������� ����� ������� ���������� � ����������������� ������   
    UINT32            size;   // ������ ������� ���������� � ����������������� ������ � ������ 
    UINT16            pnum;   // ���������� ���������� � �������                               
    TPARAM_DESC const   *dt;  // ��������� �� ������ ������������                              
} TPARAM_TBL;

// ������������ ��������� ������ ��� ������ � �����������/��������������� �������� �� EEPROM
typedef enum _TPARAM_ERR
{
    TPARAM_NO_ERR = 0,
    TPARAM_READ_CRC_ERR,
    TPARAM_ILLEGAL_ADDR,
    TPARAM_WRITE_ERROR,
    TPARAM_FLASH_UNDEF
}TPARAM_ERR;
 

extern const TPARAM_TBL  SettingsTable;   // ������� ����������


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



  
// ��������� ������ ��� ������ � ����������� ��������  
TPARAM_ERR SettingsInit(TPARAM_TBL const *tbl);                         // ������������� ���� ������� ����� 
TPARAM_ERR SettingsLoad(TPARAM_TBL const *tbl, UINT16 index);           // �������� ��������� � ������� ����� �� ������� 
TPARAM_ERR SettingsLoadPointer(TPARAM_TBL const *tbl, void *value);     // �������� ��������� � ������� ����� �� ��������� 
TPARAM_ERR SettingsSave(TPARAM_TBL const* tbl);                         // ���������� ������� ����� � NVRAM �� ������� 
TPARAM_ERR SettingsSavePointer(TPARAM_TBL const *tbl, void *valueue);   // ���������� ������� ����� � NVRAM �� ��������� 
TPARAM_ERR SettingsReset(TPARAM_TBL const *tbl, UINT16 index);          // ����� ��������� �� �������� �� ��������� �� ������� 
TPARAM_ERR SettingsResetPointer(TPARAM_TBL const *tbl, void *val);      // ����� ��������� �� �������� �� ��������� �� ���������
TPARAM_ERR SettingsSetDefaul(TPARAM_TBL const *tbl);                    // ����� ���� ���������� �� �-� �� ���������


#endif 

