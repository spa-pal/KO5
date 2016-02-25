#define TX_BUFFER_SIZE	50
#define RX_BUFFER_SIZE	50



typedef enum  {lisOFF,lisON} enum_log_in_stat;
extern @near enum_log_in_stat log_in_stat[8];
typedef enum  {liasOFF,liasON} enum_log_in_av_stat;
extern @near enum_log_in_av_stat log_in_av_stat[8],log_in_av_stat_old[8];
typedef enum  {lisoaOFF,lisoaON} enum_log_in_stat_of_av;
extern @eeprom enum_log_in_stat_of_av ee_log_in_stat_of_av[8];
typedef enum  {litsOFF,litsON} enum_log_in_trap_send;
extern @eeprom enum_log_in_trap_send ee_log_in_trap_send_av[8],ee_log_in_trap_send_no_av[8];
extern @near char PUIB[32];
extern signed char tx_counter;
extern char tx_buffer[TX_BUFFER_SIZE];
extern signed char tx_wr_index,tx_rd_index;
extern char power_cnt_adrl,power_cnt_adrh;
extern @eeprom signed short ee_power_cnt_adr;
extern @eeprom short ee_reset_cnt;

//-----------------------------------------------
//Работа с АЦП
extern @near char adc_plazma;
extern @near char adc_ch;
extern @near char adc_cnt;
extern @near short adc_buff[2][16];
extern @near short adc_buff_[2];
extern @near short adc_plazma_short;


//-----------------------------------------------
//Температура
extern @near signed short T1;
extern @near signed short T2;
extern @eeprom signed short ee_T1_koef,ee_T2_koef;
extern @eeprom signed short ee_T1_porog1,ee_T1_porog2;
extern @eeprom signed short ee_T2_porog1,ee_T2_porog2;
typedef enum {tlOFF=0,tlNW=1,tlNC=2} enum_temper_logic;
extern @eeprom enum_temper_logic ee_T1_logic1,ee_T1_logic2,ee_T2_logic1,ee_T2_logic2;
typedef enum {ttsOFF=0,ttsON=1}enum_temper_trap_send;
extern @eeprom enum_temper_trap_send ee_T1_trap_send_av_1,ee_T1_trap_send_no_av_1,ee_T1_trap_send_av_2,ee_T1_trap_send_no_av_2,
							  ee_T2_trap_send_av_1,ee_T2_trap_send_no_av_1,ee_T2_trap_send_av_2,ee_T2_trap_send_no_av_2;
extern @near char T1_status1,T1_status2,T1_status1_old,T1_status2_old;
extern @near char T2_status1,T2_status2,T2_status1_old,T2_status2_old;  
extern @near short T1_porog1_cnt,T1_porog2_cnt,T2_porog1_cnt,T2_porog2_cnt;


//-----------------------------------------------
//Влажность
extern @near signed short H1;
extern @eeprom signed short ee_H1_porog;
//typedef enum  {hasOFF,hasON} enum_hummidity_av_stat;
//extern @near enum_hummidity_av_stat hummidity_av_stat;
typedef enum  {htsOFF,htsON} enum_hummidity_trap_send;
extern @eeprom enum_hummidity_trap_send ee_hummidity_trap_send_av,ee_hummidity_trap_send_no_av;
extern @near signed char hummidity_alarm_cnt;
typedef enum  {hasOFF,hasON} enum_hummidity_alarm_stat;
extern @near enum_hummidity_alarm_stat hummidity_alarm_stat,hummidity_alarm_stat_old;
typedef enum  {hlOFF,hlNT,hlNB} enum_hummidity_alarm_logic;
extern @eeprom enum_hummidity_alarm_logic ee_H1_logic;
extern char bTRANSMIT_TO_STEND;

void t2_init(void);
void t4_init(void);
void rele_drv(void);
long delay_ms(short in);
@far @interrupt void TIM4_UPD_Interrupt (void);
void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7);
void uart_out_adr_block (unsigned long adress,char *ptr, char len);
void putchar(char c);
@far @interrupt void UARTTxInterrupt (void);
@far @interrupt void UARTRxInterrupt (void);
void uart_init (void);
//long DF_mf_dev_read(void);
void DF_memo_to_256(void);
char DF_status_read(void);
//void DF_buffer_read(unsigned buff_addr,unsigned len, char* adr);
void DF_buffer_write(/*char buff,*/unsigned buff_addr,unsigned len, char* adr);
void DF_page_to_buffer(unsigned page_addr);
void DF_buffer_to_page_er(/*char buff,*/unsigned page_addr);
char spi(char in);
void spi_init(void);
void gpio_init(void);
void uart_in(void);
signed short index_offset (signed short index,signed short offset);
char control_check(char index);
void uart_in_an(void);
//-----------------------------------------------
//Работа со счетчиком
extern signed long power_summary;
extern signed short power_current;
extern char power_cnt_adrl,power_cnt_adrh;
extern @near long power_summary_impuls_cnt;
extern @eeprom long ee_power_summary_impuls_cnt;
extern @near long power_summary_impuls;
extern @eeprom short ee_impuls_per_kwatt;

//-----------------------------------------------
void trap_send(char par1,short par2);
extern signed char rx_wr_index,rx_rd_index;

