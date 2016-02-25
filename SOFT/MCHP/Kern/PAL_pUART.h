#define END 	0x0A
#define pTX_BUFFER_SIZE	32
#define PUART_RX_BUFFER_SIZE	64

extern char puart_rx_buffer[PUART_RX_BUFFER_SIZE];
extern char ptx_buffer[pTX_BUFFER_SIZE];
extern signed short puart_rx_wr_index,puart_rx_rd_index,puart_rx_counter;
extern unsigned short ptx_wr_index,ptx_rd_index,ptx_counter;
//typedef enum{psOFF,psTX,psON}enum_puart_stat;
//extern enum_puart_stat puart_stat;
extern char data_temp,control_temp;
extern char puart_data_temp;
extern char bPUART_RXIN;
extern char PUIB[64];
//-----------------------------------------------
void puart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5);
void pputchar(char c);
void puart_tx_drv(void);
//-----------------------------------------------
void puart_rx_init(void);
//-----------------------------------------------
void puart_uart_in(void);
//-----------------------------------------------
signed short puart_index_offset (signed short index,signed short offset);
//-----------------------------------------------
char puart_control_check(char index);
//-----------------------------------------------
void puart_uart_in_an(void);
//-----------------------------------------------
void puart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5);


//-----------------------------------------------
//������ ������ ��� �����  PIC->ST
//	55
//		25		//��������� ������ 1 �� ���������� �����������
//		26		//��������� ������ 2 �� ���������� �����������
//		27		//��������� ������ ������ 1 �� ���������� �����������
//		28		//��������� ������ ������ 2 �� ���������� �����������
//		29		//���������-���������� ������� ������ �� ������ ���������� ����������� �� 1 ������
//		30		//���������-���������� ������� ������ �� ������ ������ ���������� ����������� �� 1 ������
//		31		//���������-���������� ������� ������ �� ������ ���������� ����������� �� 2 ������
//		32		//���������-���������� ������� ������ �� ������ ������ ���������� ����������� �� 2 ������

//		50		//��������� ������ 1 �� ������� �����������
//		51		//��������� ������ 2 �� ������� �����������
//		52		//��������� ������ ������ 1 �� ������� �����������
//		53		//��������� ������ ������ 2 �� ������� �����������
//		54		//���������-���������� ������� ������ �� ������ ������� ����������� �� 1 ������
//		55		//���������-���������� ������� ������ �� ������ ������ ������� ����������� �� 1 ������
//		56		//���������-���������� ������� ������ �� ������ ������� ����������� �� 2 ������
//		57		//���������-���������� ������� ������ �� ������ ������� ���������� ����������� �� 2 ������

	

