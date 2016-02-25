#ifndef __TX_PROTOCOL_H
#define __TX_PROTOCOL_H


// ����� � �������� �� UART - ���������
#define CHEAPLAN_TX_ADDRESS 0x01

// ID ������� ������
#define GET_IP_ID 				0x01
#define GET_MASK_ID 			0x02
#define GET_MAC_ID  			0x03
#define GET_DHCP_ID 			0x04
#define GET_TCP_PORT_ID 		0x05
#define GET_IP_MASK_DHCP_ID 	0x06
#define GET_GATEWAY_ID			0x07
#define GET_DNS_1_ID			0x08
#define GET_DNS_2_ID        	0x09
#define GET_UART_BAUD_ID    	0x0A
#define GET_MODE_ID         	0x0B
#define GET_BREAK_TIME_ID   	0x0C
#define GET_ETHERNET_V2_0_ID	0x0D
#define GET_UART_V2_0_ID     	0x0E
#define GET_ALL_V2_0_ID         0x0F


// ID ������� ������
#define SET_IP_ID     			0x20
#define SET_MASK_ID     		0x21
#define SET_DHCP_ID     		0x22
#define SET_MAC_ID     			0x23
#define SET_GATEWAY_ID     		0x24
#define SET_DNS1_ID     		0x25
#define SET_DNS2_ID     		0x26
#define SET_PORT_ID     		0x27
#define SET_UART_BAUD_ID   		0x28
#define SET_UART_MODE_ID   		0x29
#define SET_BREAK_TIME_ID  		0x30

#define SET_ETHERNET_V2_0_ID    0x2D
#define SET_UART_V2_0_ID     	0x2E
//#define SET_ALL_V2_0_ID   		0x2F


		

// ������
#define DTE     	0x00 	// ������ � ������� - ���������� ������ �� ������������� ���������� ��������
#define IDE     	0x01 	// ������ - �������� � ������� ID �� ����������
#define PRE     	0x02    // ������ � ��������� - �� ������� ����������
#define CME     	0x03	// ������ - �������� �������
#define ACE 		0x05 	// ������ - ������ ��������

#define ERROR_ID    0xFE    // ID ��������� �� ������

#define TX_RECEIVE_MAX_DATA_BYTES   100UL
#define TX_SEND_BUF_SIZE			100UL

// ��������� ������� ����������� TX ������
typedef struct
{
	UINT8   PreviousByte;       	// ���������� ����
	UINT16  TxCntr;             	// ������� �������� ���� (AD, ID, DATA)
	UINT8   TxStartID      :1;  	// ������� ������ ������
	UINT8   TxDone         :1;  	// ������� ��������� ������            
	
	UINT8 	TxAD;               	// �������� ����� ����������
	UINT8 	TxID;               	// �������� ������������� ����������                 
    UINT16 	TxDtLength;         	// �������� ����� �������� ������
	UINT8 	TxDT[TX_RECEIVE_MAX_DATA_BYTES]; 	// ���� ������
  
} TX_STATUS;


// ����������, � ������� ����� ������ ������
#define	I_UART			0
#define	I_UDP			1



void TxCommandParse(TX_STATUS* Stat, UINT8 Interface);
BYTE ASCII2Hex(BYTE Ascii);
void TxCommandHandling(TX_STATUS* Stat, UINT8 CurrentByte);
BYTE Hex2ASCII(BYTE Hex);
void TxSend(BYTE ID, BYTE *DATA,  BYTE DataLength, UINT8 Interface);   
void TxSendIpMaskDHCP(UINT8 Interface);
void TxSendIpAddr(UINT8 Interface);
void TxSendMask(UINT8 Interface);  
void TxSendMAC(UINT8 Interface);   
void TxSendDHCP(UINT8 Interface);  
void TxSendPort(UINT8 Interface); 
void TxSendGateway(UINT8 Interface);
void TxSendDns1(UINT8 Interface);
void TxSendDns2(UINT8 Interface); 
void TxSendUartBaud(UINT8 Interface);
void TxSendUartMode(UINT8 Interface);
void TxSendBreakTime(UINT8 Interface);
void TxSendEthernet_v2_0(UINT8 Interface);
void TxSendUart_2_0(UINT8 Interface);
void TxSendAll_v2_0(UINT8 Interface);
void TxSendOK(BYTE, UINT8 Interface);
void TxSendFault(BYTE, BYTE, UINT8 Interface);
void TxSendFaultParameter(BYTE, UINT16, UINT8 Interface);

BOOL SetIp(TX_STATUS* Stat, UINT8 Interface);
BOOL SetMask(TX_STATUS* Stat);
BOOL SetDhcp(TX_STATUS* Stat, UINT8 Interface);
BOOL SetGateway(TX_STATUS* Stat);
BOOL SetDns1(TX_STATUS* Stat);
BOOL SetDns2(TX_STATUS* Stat);
BOOL SetPort(TX_STATUS* Stat);
BOOL SetUartBaud(TX_STATUS* Stat);
BOOL SetUartMode(TX_STATUS* Stat);
BOOL SetBreakTime(TX_STATUS* Stat);
BOOL SetMac(TX_STATUS* Stat);
UINT16 SetEthernet_v2_0(TX_STATUS* Stat);
UINT16 SetUart_v2_0(TX_STATUS* Stat);

#endif

