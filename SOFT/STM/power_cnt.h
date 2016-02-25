#define IER_RBR		0x01
#define IER_THRE		0x02
#define IER_RLS		0x04
#define IIR_PEND	0x01
#define IIR_RLS		0x03
#define IIR_RDA		0x02
#define IIR_CTI		0x06
#define IIR_THRE	0x01
#define LSR_RDR		0x01
#define LSR_OE		0x02
#define LSR_PE		0x04
#define LSR_FE		0x08
#define LSR_BI		0x10
#define LSR_THRE	0x20
#define LSR_TEMT	0x40
#define LSR_RXFE	0x80

//#define BUFSIZE		200
//#define RX_BUFFER_SIZE1 100
//#define TX_BUFFER_SIZE1 100

extern const unsigned char crc8tab[256];
extern char tx_wd_cnt;
extern unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
extern unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
//extern char rx_buffer1[RX_BUFFER_SIZE1];
//extern char tx_buffer1[TX_BUFFER_SIZE1];

typedef enum {tsOFF,tsON}tx_stat_enum;
extern tx_stat_enum tx_stat;
extern char sleep_buff[50];
extern char sleep_in;
extern char sleep_len;
extern char sleep_plazma;
extern @near char rx_read_power_102m_phase;

//-----------------------------------------------
void sleep_an(void);
//-----------------------------------------------
char sleep_coding(char* adr_src,char* adr_dst,char str_len);
//-----------------------------------------------
void read_current_power(void);
//-----------------------------------------------
void putchar1(char c);
//-----------------------------------------------
void uart_out_adr (char *ptr, char len);
//-----------------------------------------------
void UART1_IRQHandler (void);
//-----------------------------------------------
unsigned int UARTInit( unsigned int PortNum, unsigned int baudrate );
//-----------------------------------------------
char power_cnt_crc(char* adr, char len);
//-----------------------------------------------
void read_current_power(void);
//-----------------------------------------------
void read_summary_power(void);
//-----------------------------------------------
void read_power_102m(void);
//-----------------------------------------------
void read_power_102m_drv(void);


/******************************************************************************
**                            End Of File
******************************************************************************/
