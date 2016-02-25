#define PUART_RX_BUFFER_SIZE 64
#define PUART_TX_BUFFER_SIZE 64
//#define END				0x0a

extern char puart_data_temp;
extern @near char puart_rx_buffer[PUART_RX_BUFFER_SIZE];
extern @near char puart_tx_buffer[PUART_TX_BUFFER_SIZE];
extern @near char puart_rx_wr_index,puart_rx_rd_index;
extern @near char puart_tx_wr_index,puart_tx_rd_index;
extern char bPUART_RXIN;
extern @near char data_temp,control_temp;
extern @near char data_out[100];

//-----------------------------------------------
void p_uart_rx_init(void);
//-----------------------------------------------
void puart_uart_in(void);
//-----------------------------------------------
signed short puart_index_offset (signed short index,signed short offset);
//-----------------------------------------------
char puart_control_check(char index);
//-----------------------------------------------
void puart_uart_in_an(void);
//-----------------------------------------------
void p_uart_tx_init(void);
//-----------------------------------------------
void uart_out_adr (char *ptr, char len);
//-----------------------------------------------
void puart_tx_drv(void); 
//-----------------------------------------------
void pputchar(char c);
//-----------------------------------------------
void puart_out_adr (char *ptr, char len);
//-----------------------------------------------
void puart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5);
