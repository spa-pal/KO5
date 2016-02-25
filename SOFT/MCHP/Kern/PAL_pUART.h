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
//Список команд для связи  PIC->ST
//	55
//		25		//Установка порога 1 по внутренней температуре
//		26		//Установка порога 2 по внутренней температуре
//		27		//Установка логики порога 1 по внутренней температуре
//		28		//Установка логики порога 2 по внутренней температуре
//		29		//Включение-выключение отсылки трапов по аварии внутренней температуры по 1 порогу
//		30		//Включение-выключение отсылки трапов по снятию аварии внутренней температуры по 1 порогу
//		31		//Включение-выключение отсылки трапов по аварии внутренней температуры по 2 порогу
//		32		//Включение-выключение отсылки трапов по снятию аварии внутренней температуры по 2 порогу

//		50		//Установка порога 1 по внешней температуре
//		51		//Установка порога 2 по внешней температуре
//		52		//Установка логики порога 1 по внешней температуре
//		53		//Установка логики порога 2 по внешней температуре
//		54		//Включение-выключение отсылки трапов по аварии внешней температуры по 1 порогу
//		55		//Включение-выключение отсылки трапов по снятию аварии внешней температуры по 1 порогу
//		56		//Включение-выключение отсылки трапов по аварии внешней температуры по 2 порогу
//		57		//Включение-выключение отсылки трапов по снятию внешней внутренней температуры по 2 порогу

	

