   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32.1 - 30 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  46                     ; 12 @far @interrupt void NonHandledInterrupt (void)
  46                     ; 13 {
  47                     	switch	.text
  48  0000               f_NonHandledInterrupt:
  52                     ; 17 	return;
  55  0000 80            	iret
  78                     ; 20 @far @interrupt void NonHandledInterrupt_ (void)
  78                     ; 21 {
  79                     	switch	.text
  80  0001               f_NonHandledInterrupt_:
  84                     ; 25 	return;
  87  0001 80            	iret
  89                     .const:	section	.text
  90  0000               __vectab:
  91  0000 82            	dc.b	130
  93  0001 00            	dc.b	page(f__stext)
  94  0002 0000          	dc.w	f__stext
  95  0004 82            	dc.b	130
  97  0005 00            	dc.b	page(f_NonHandledInterrupt)
  98  0006 0000          	dc.w	f_NonHandledInterrupt
  99  0008 82            	dc.b	130
 101  0009 00            	dc.b	page(f_NonHandledInterrupt)
 102  000a 0000          	dc.w	f_NonHandledInterrupt
 103  000c 82            	dc.b	130
 105  000d 00            	dc.b	page(f_NonHandledInterrupt)
 106  000e 0000          	dc.w	f_NonHandledInterrupt
 107  0010 82            	dc.b	130
 109  0011 00            	dc.b	page(f_NonHandledInterrupt)
 110  0012 0000          	dc.w	f_NonHandledInterrupt
 111  0014 82            	dc.b	130
 113  0015 00            	dc.b	page(f_NonHandledInterrupt)
 114  0016 0000          	dc.w	f_NonHandledInterrupt
 115  0018 82            	dc.b	130
 117  0019 00            	dc.b	page(f_NonHandledInterrupt)
 118  001a 0000          	dc.w	f_NonHandledInterrupt
 119  001c 82            	dc.b	130
 121  001d 00            	dc.b	page(f_NonHandledInterrupt)
 122  001e 0000          	dc.w	f_NonHandledInterrupt
 123  0020 82            	dc.b	130
 125  0021 00            	dc.b	page(f_PORTD_Interrupt)
 126  0022 0000          	dc.w	f_PORTD_Interrupt
 127  0024 82            	dc.b	130
 129  0025 00            	dc.b	page(f_NonHandledInterrupt)
 130  0026 0000          	dc.w	f_NonHandledInterrupt
 131  0028 82            	dc.b	130
 133  0029 00            	dc.b	page(f_NonHandledInterrupt)
 134  002a 0000          	dc.w	f_NonHandledInterrupt
 135  002c 82            	dc.b	130
 137  002d 00            	dc.b	page(f_NonHandledInterrupt)
 138  002e 0000          	dc.w	f_NonHandledInterrupt
 139  0030 82            	dc.b	130
 141  0031 00            	dc.b	page(f_NonHandledInterrupt)
 142  0032 0000          	dc.w	f_NonHandledInterrupt
 143  0034 82            	dc.b	130
 145  0035 00            	dc.b	page(f_NonHandledInterrupt)
 146  0036 0000          	dc.w	f_NonHandledInterrupt
 147  0038 82            	dc.b	130
 149  0039 00            	dc.b	page(f_NonHandledInterrupt)
 150  003a 0000          	dc.w	f_NonHandledInterrupt
 151  003c 82            	dc.b	130
 153  003d 00            	dc.b	page(f_NonHandledInterrupt)
 154  003e 0000          	dc.w	f_NonHandledInterrupt
 155  0040 82            	dc.b	130
 157  0041 00            	dc.b	page(f_NonHandledInterrupt)
 158  0042 0000          	dc.w	f_NonHandledInterrupt
 159  0044 82            	dc.b	130
 161  0045 00            	dc.b	page(f_NonHandledInterrupt)
 162  0046 0000          	dc.w	f_NonHandledInterrupt
 163  0048 82            	dc.b	130
 165  0049 00            	dc.b	page(f_NonHandledInterrupt)
 166  004a 0000          	dc.w	f_NonHandledInterrupt
 167  004c 82            	dc.b	130
 169  004d 00            	dc.b	page(f_NonHandledInterrupt)
 170  004e 0000          	dc.w	f_NonHandledInterrupt
 171  0050 82            	dc.b	130
 173  0051 00            	dc.b	page(f_NonHandledInterrupt)
 174  0052 0000          	dc.w	f_NonHandledInterrupt
 175  0054 82            	dc.b	130
 177  0055 01            	dc.b	page(f_NonHandledInterrupt_)
 178  0056 0001          	dc.w	f_NonHandledInterrupt_
 179  0058 82            	dc.b	130
 181  0059 00            	dc.b	page(f_UARTTxInterrupt)
 182  005a 0000          	dc.w	f_UARTTxInterrupt
 183  005c 82            	dc.b	130
 185  005d 00            	dc.b	page(f_UARTRxInterrupt)
 186  005e 0000          	dc.w	f_UARTRxInterrupt
 187  0060 82            	dc.b	130
 189  0061 00            	dc.b	page(f_ADC_EOC_Interrupt)
 190  0062 0000          	dc.w	f_ADC_EOC_Interrupt
 191  0064 82            	dc.b	130
 193  0065 00            	dc.b	page(f_TIM4_UPD_Interrupt)
 194  0066 0000          	dc.w	f_TIM4_UPD_Interrupt
 195  0068 82            	dc.b	130
 197  0069 00            	dc.b	page(f_NonHandledInterrupt)
 198  006a 0000          	dc.w	f_NonHandledInterrupt
 199  006c 82            	dc.b	130
 201  006d 00            	dc.b	page(f_NonHandledInterrupt)
 202  006e 0000          	dc.w	f_NonHandledInterrupt
 203  0070 82            	dc.b	130
 205  0071 00            	dc.b	page(f_NonHandledInterrupt)
 206  0072 0000          	dc.w	f_NonHandledInterrupt
 207  0074 82            	dc.b	130
 209  0075 00            	dc.b	page(f_NonHandledInterrupt)
 210  0076 0000          	dc.w	f_NonHandledInterrupt
 211  0078 82            	dc.b	130
 213  0079 00            	dc.b	page(f_NonHandledInterrupt)
 214  007a 0000          	dc.w	f_NonHandledInterrupt
 215  007c 82            	dc.b	130
 217  007d 00            	dc.b	page(f_NonHandledInterrupt)
 218  007e 0000          	dc.w	f_NonHandledInterrupt
 269                     	xdef	__vectab
 270                     	xref	f_PORTD_Interrupt
 271                     	xref	f_ADC_EOC_Interrupt
 272                     	xref	f_UARTRxInterrupt
 273                     	xref	f_UARTTxInterrupt
 274                     	xref	f__stext
 275                     	xref	f_TIM4_UPD_Interrupt
 276                     	xdef	f_NonHandledInterrupt_
 277                     	xdef	f_NonHandledInterrupt
 296                     	end
