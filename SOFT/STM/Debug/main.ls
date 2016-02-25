   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32.1 - 30 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2525                     	bsct
2526  0000               _t0_cnt0:
2527  0000 00            	dc.b	0
2528  0001               _t0_cnt1:
2529  0001 00            	dc.b	0
2530  0002               _t0_cnt2:
2531  0002 00            	dc.b	0
2532  0003               _t0_cnt3:
2533  0003 00            	dc.b	0
2534  0004               _t0_cnt4:
2535  0004 00            	dc.b	0
2536  0005               _tx_buffer:
2537  0005 00            	dc.b	0
2538  0006 000000000000  	ds.b	49
2539  0037               _rx_buffer:
2540  0037 00            	dc.b	0
2541  0038 000000000000  	ds.b	49
2542  0069               _but_drv_cnt:
2543  0069 00            	dc.b	0
2544                     .const:	section	.text
2545  0000               _rele_cnt_const:
2546  0000 0a            	dc.b	10
2547  0001 19            	dc.b	25
2548  0002 32            	dc.b	50
2549                     	switch	.data
2550  0000               _ee_reset_cnt_:
2551  0000 014d          	dc.w	333
2556                     	bsct
2557  006a               __serial:
2558  006a 000181cd      	dc.l	98765
2559  006e               _power_summary:
2560  006e 00000000      	dc.l	0
2561  0072               _power_current:
2562  0072 0000          	dc.w	0
2563                     	switch	.data
2564  0002               _power_cnt_block:
2565  0002 05            	dc.b	5
2624                     ; 126 void gran_char(signed char *adr, signed char min, signed char max)
2624                     ; 127 {
2625                     	switch	.text
2626  0000               f_gran_char:
2628  0000 89            	pushw	x
2629       00000000      OFST:	set	0
2632                     ; 128 if (*adr<min) *adr=min;
2634  0001 9c            	rvf
2635  0002 f6            	ld	a,(x)
2636  0003 1106          	cp	a,(OFST+6,sp)
2637  0005 2e05          	jrsge	L7561
2640  0007 7b06          	ld	a,(OFST+6,sp)
2641  0009 1e01          	ldw	x,(OFST+1,sp)
2642  000b f7            	ld	(x),a
2643  000c               L7561:
2644                     ; 129 if (*adr>max)  *adr=max; 
2646  000c 9c            	rvf
2647  000d 1e01          	ldw	x,(OFST+1,sp)
2648  000f f6            	ld	a,(x)
2649  0010 1107          	cp	a,(OFST+7,sp)
2650  0012 2d05          	jrsle	L1661
2653  0014 7b07          	ld	a,(OFST+7,sp)
2654  0016 1e01          	ldw	x,(OFST+1,sp)
2655  0018 f7            	ld	(x),a
2656  0019               L1661:
2657                     ; 130 }
2660  0019 85            	popw	x
2661  001a 87            	retf
2683                     ; 133 void t2_init(void){
2684                     	switch	.text
2685  001b               f_t2_init:
2689                     ; 134 	TIM2->PSCR = 0;
2691  001b 725f530c      	clr	21260
2692                     ; 135 	TIM2->ARRH= 0x00;
2694  001f 725f530d      	clr	21261
2695                     ; 136 	TIM2->ARRL= 0xff;
2697  0023 35ff530e      	mov	21262,#255
2698                     ; 137 	TIM2->CCR1H= 0x00;	
2700  0027 725f530f      	clr	21263
2701                     ; 138 	TIM2->CCR1L= 200;
2703  002b 35c85310      	mov	21264,#200
2704                     ; 139 	TIM2->CCR2H= 0x00;	
2706  002f 725f5311      	clr	21265
2707                     ; 140 	TIM2->CCR2L= 200;
2709  0033 35c85312      	mov	21266,#200
2710                     ; 141 	TIM2->CCR3H= 0x00;	
2712  0037 725f5313      	clr	21267
2713                     ; 142 	TIM2->CCR3L= 200;
2715  003b 35c85314      	mov	21268,#200
2716                     ; 145 	TIM2->CCMR2= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
2718  003f 35685306      	mov	21254,#104
2719                     ; 146 	TIM2->CCMR3= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
2721  0043 35685307      	mov	21255,#104
2722                     ; 147 	TIM2->CCER1= /*TIM2_CCER1_CC1E | TIM2_CCER1_CC1P |*/ TIM2_CCER1_CC2E | TIM2_CCER1_CC2P; //OC1, OC2 output pins enabled
2724  0047 35305308      	mov	21256,#48
2725                     ; 149 	TIM2->CCER2= TIM2_CCER2_CC3E /*| TIM2_CCER2_CC3P*/; //OC1, OC2 output pins enabled
2727  004b 35015309      	mov	21257,#1
2728                     ; 151 	TIM2->CR1=(TIM2_CR1_CEN | TIM2_CR1_ARPE);	
2730  004f 35815300      	mov	21248,#129
2731                     ; 153 }
2734  0053 87            	retf
2756                     ; 156 void t4_init(void){
2757                     	switch	.text
2758  0054               f_t4_init:
2762                     ; 157 	TIM4->PSCR = 7;
2764  0054 35075345      	mov	21317,#7
2765                     ; 158 	TIM4->ARR= 125;
2767  0058 357d5346      	mov	21318,#125
2768                     ; 159 	TIM4->IER|= TIM4_IER_UIE;					// enable break interrupt
2770  005c 72105341      	bset	21313,#0
2771                     ; 161 	TIM4->CR1=(TIM4_CR1_URS | TIM4_CR1_CEN | TIM4_CR1_ARPE);	
2773  0060 35855340      	mov	21312,#133
2774                     ; 163 }
2777  0064 87            	retf
2800                     ; 167 void adc_init(void){
2801                     	switch	.text
2802  0065               f_adc_init:
2806                     ; 168 	GPIOB->DDR&=~(1<<0);
2808  0065 72115007      	bres	20487,#0
2809                     ; 169 	GPIOB->CR1&=~(1<<0);
2811  0069 72115008      	bres	20488,#0
2812                     ; 170 	GPIOB->CR2&=~(1<<0);
2814  006d 72115009      	bres	20489,#0
2815                     ; 171 	ADC1->TDRL|=(1<<0);
2817  0071 72105407      	bset	21511,#0
2818                     ; 173 	GPIOB->DDR&=~(1<<1);
2820  0075 72135007      	bres	20487,#1
2821                     ; 174 	GPIOB->CR1&=~(1<<1);
2823  0079 72135008      	bres	20488,#1
2824                     ; 175 	GPIOB->CR2&=~(1<<1);
2826  007d 72135009      	bres	20489,#1
2827                     ; 176 	ADC1->TDRL|=(1<<1);
2829  0081 72125407      	bset	21511,#1
2830                     ; 183 	ADC1->CR2=0x08;
2832  0085 35085402      	mov	21506,#8
2833                     ; 184 	ADC1->CR1=0x40;
2835  0089 35405401      	mov	21505,#64
2836                     ; 185 	ADC1->CSR=0x20+adc_ch;
2838  008d c600a9        	ld	a,_adc_ch
2839  0090 ab20          	add	a,#32
2840  0092 c75400        	ld	21504,a
2841                     ; 187 	ADC1->CR1|=1;
2843  0095 72105401      	bset	21505,#0
2844                     ; 188 ADC1->CR1|=1;
2846  0099 72105401      	bset	21505,#0
2847                     ; 189 }
2850  009d 87            	retf
2910                     ; 193 long delay_ms(short in)
2910                     ; 194 {
2911                     	switch	.text
2912  009e               f_delay_ms:
2914  009e 520c          	subw	sp,#12
2915       0000000c      OFST:	set	12
2918                     ; 197 i=((long)in)*100UL;
2920  00a0 90ae0064      	ldw	y,#100
2921  00a4 8d000000      	callf	d_vmul
2923  00a8 96            	ldw	x,sp
2924  00a9 1c0005        	addw	x,#OFST-7
2925  00ac 8d000000      	callf	d_rtol
2927                     ; 199 for(ii=0;ii<i;ii++)
2929  00b0 ae0000        	ldw	x,#0
2930  00b3 1f0b          	ldw	(OFST-1,sp),x
2931  00b5 ae0000        	ldw	x,#0
2932  00b8 1f09          	ldw	(OFST-3,sp),x
2934  00ba 2014          	jra	L1571
2935  00bc               L5471:
2936                     ; 201 		iii++;
2938  00bc 96            	ldw	x,sp
2939  00bd 1c0001        	addw	x,#OFST-11
2940  00c0 a601          	ld	a,#1
2941  00c2 8d000000      	callf	d_lgadc
2943                     ; 199 for(ii=0;ii<i;ii++)
2945  00c6 96            	ldw	x,sp
2946  00c7 1c0009        	addw	x,#OFST-3
2947  00ca a601          	ld	a,#1
2948  00cc 8d000000      	callf	d_lgadc
2950  00d0               L1571:
2953  00d0 9c            	rvf
2954  00d1 96            	ldw	x,sp
2955  00d2 1c0009        	addw	x,#OFST-3
2956  00d5 8d000000      	callf	d_ltor
2958  00d9 96            	ldw	x,sp
2959  00da 1c0005        	addw	x,#OFST-7
2960  00dd 8d000000      	callf	d_lcmp
2962  00e1 2fd9          	jrslt	L5471
2963                     ; 204 }
2966  00e3 5b0c          	addw	sp,#12
2967  00e5 87            	retf
3020                     ; 206 void for_stend_out(char flags,short data0,short data1)
3020                     ; 207 {
3021                     	switch	.text
3022  00e6               f_for_stend_out:
3024  00e6 88            	push	a
3025       00000000      OFST:	set	0
3028                     ; 208 data_for_stend[0]=0xAB;
3030  00e7 35ab0006      	mov	_data_for_stend,#171
3031                     ; 210 data_for_stend[1]=flags;
3033  00eb c70007        	ld	_data_for_stend+1,a
3034                     ; 212 data_for_stend[2]=(char)data0;
3036  00ee 7b06          	ld	a,(OFST+6,sp)
3037  00f0 c70008        	ld	_data_for_stend+2,a
3038                     ; 213 data_for_stend[3]=(char)(data0/256);
3040  00f3 1e05          	ldw	x,(OFST+5,sp)
3041  00f5 90ae0100      	ldw	y,#256
3042  00f9 8d000000      	callf	d_idiv
3044  00fd 9f            	ld	a,xl
3045  00fe c70009        	ld	_data_for_stend+3,a
3046                     ; 214 data_for_stend[4]=(char)data1;
3048  0101 7b08          	ld	a,(OFST+8,sp)
3049  0103 c7000a        	ld	_data_for_stend+4,a
3050                     ; 215 data_for_stend[5]=(char)(data1/256);
3052  0106 1e07          	ldw	x,(OFST+7,sp)
3053  0108 90ae0100      	ldw	y,#256
3054  010c 8d000000      	callf	d_idiv
3056  0110 9f            	ld	a,xl
3057  0111 c7000b        	ld	_data_for_stend+5,a
3058                     ; 216 data_for_stend[6]=0xBA;
3060  0114 35ba000c      	mov	_data_for_stend+6,#186
3061                     ; 218 uart_out_adr(data_for_stend,7);
3063  0118 4b07          	push	#7
3064  011a ae0006        	ldw	x,#_data_for_stend
3065  011d 8d000000      	callf	f_uart_out_adr
3067  0121 84            	pop	a
3068                     ; 220 }
3071  0122 84            	pop	a
3072  0123 87            	retf
3099                     	switch	.const
3100  0003               L22:
3101  0003 0000000a      	dc.l	10
3102                     ; 223 void impuls_meter(void)
3102                     ; 224 {
3103                     	switch	.text
3104  0124               f_impuls_meter:
3106  0124 5204          	subw	sp,#4
3107       00000004      OFST:	set	4
3110                     ; 225 if(!(GPIOC->IDR&(1<<4)))
3112  0126 c6500b        	ld	a,20491
3113  0129 a510          	bcp	a,#16
3114  012b 2618          	jrne	L3102
3115                     ; 227 	impuls_cnt++;
3117  012d ce000e        	ldw	x,_impuls_cnt
3118  0130 1c0001        	addw	x,#1
3119  0133 cf000e        	ldw	_impuls_cnt,x
3120                     ; 228 	if(impuls_cnt>200)impuls_cnt=0;
3122  0136 9c            	rvf
3123  0137 ce000e        	ldw	x,_impuls_cnt
3124  013a a300c9        	cpw	x,#201
3125  013d 2f47          	jrslt	L7102
3128  013f 5f            	clrw	x
3129  0140 cf000e        	ldw	_impuls_cnt,x
3130  0143 2041          	jra	L7102
3131  0145               L3102:
3132                     ; 234 	if((impuls_cnt>2)&&(impuls_cnt<90))
3134  0145 9c            	rvf
3135  0146 ce000e        	ldw	x,_impuls_cnt
3136  0149 a30003        	cpw	x,#3
3137  014c 2f34          	jrslt	L1202
3139  014e 9c            	rvf
3140  014f ce000e        	ldw	x,_impuls_cnt
3141  0152 a3005a        	cpw	x,#90
3142  0155 2e2b          	jrsge	L1202
3143                     ; 236 		power_summary_impuls_cnt++;
3145  0157 ae0045        	ldw	x,#_power_summary_impuls_cnt
3146  015a a601          	ld	a,#1
3147  015c 8d000000      	callf	d_lgadc
3149                     ; 237 		if((power_summary_impuls_cnt%10)==0)ee_power_summary_impuls_cnt=power_summary_impuls_cnt;
3151  0160 ae0045        	ldw	x,#_power_summary_impuls_cnt
3152  0163 8d000000      	callf	d_ltor
3154  0167 ae0003        	ldw	x,#L22
3155  016a 8d000000      	callf	d_lmod
3157  016e 8d000000      	callf	d_lrzmp
3159  0172 260e          	jrne	L1202
3162  0174 ae0045        	ldw	x,#_power_summary_impuls_cnt
3163  0177 8d000000      	callf	d_ltor
3165  017b ae0002        	ldw	x,#_ee_power_summary_impuls_cnt
3166  017e 8d000000      	callf	d_eewrl
3168  0182               L1202:
3169                     ; 243 	impuls_cnt=0;
3171  0182 5f            	clrw	x
3172  0183 cf000e        	ldw	_impuls_cnt,x
3173  0186               L7102:
3174                     ; 245 power_summary_impuls=power_summary_impuls_cnt/ee_impuls_per_kwatt;
3176  0186 ce0000        	ldw	x,_ee_impuls_per_kwatt
3177  0189 8d000000      	callf	d_itolx
3179  018d 96            	ldw	x,sp
3180  018e 1c0001        	addw	x,#OFST-3
3181  0191 8d000000      	callf	d_rtol
3183  0195 ae0045        	ldw	x,#_power_summary_impuls_cnt
3184  0198 8d000000      	callf	d_ltor
3186  019c 96            	ldw	x,sp
3187  019d 1c0001        	addw	x,#OFST-3
3188  01a0 8d000000      	callf	d_ldiv
3190  01a4 ae0041        	ldw	x,#_power_summary_impuls
3191  01a7 8d000000      	callf	d_rtol
3193                     ; 246 }
3196  01ab 5b04          	addw	sp,#4
3197  01ad 87            	retf
3236                     	switch	.const
3237  0007               L62:
3238  0007 000009c4      	dc.l	2500
3239  000b               L03:
3240  000b 00000005      	dc.l	5
3241                     ; 249 void matemat(void)
3241                     ; 250 {
3242                     	switch	.text
3243  01ae               f_matemat:
3245  01ae 5204          	subw	sp,#4
3246       00000004      OFST:	set	4
3249                     ; 253 tempSL=(signed long)adc_buff_[1];
3251  01b0 ce0066        	ldw	x,_adc_buff_+2
3252  01b3 8d000000      	callf	d_itolx
3254  01b7 96            	ldw	x,sp
3255  01b8 1c0001        	addw	x,#OFST-3
3256  01bb 8d000000      	callf	d_rtol
3258                     ; 254 tempSL*=(signed long)ee_T1_koef;
3260  01bf ce0021        	ldw	x,_ee_T1_koef
3261  01c2 8d000000      	callf	d_itolx
3263  01c6 96            	ldw	x,sp
3264  01c7 1c0001        	addw	x,#OFST-3
3265  01ca 8d000000      	callf	d_lgmul
3267                     ; 255 tempSL/=2500L;
3269  01ce 96            	ldw	x,sp
3270  01cf 1c0001        	addw	x,#OFST-3
3271  01d2 8d000000      	callf	d_ltor
3273  01d6 ae0007        	ldw	x,#L62
3274  01d9 8d000000      	callf	d_ldiv
3276  01dd 96            	ldw	x,sp
3277  01de 1c0001        	addw	x,#OFST-3
3278  01e1 8d000000      	callf	d_rtol
3280                     ; 256 tempSL-=273L;
3282  01e5 ae0111        	ldw	x,#273
3283  01e8 bf02          	ldw	c_lreg+2,x
3284  01ea ae0000        	ldw	x,#0
3285  01ed bf00          	ldw	c_lreg,x
3286  01ef 96            	ldw	x,sp
3287  01f0 1c0001        	addw	x,#OFST-3
3288  01f3 8d000000      	callf	d_lgsub
3290                     ; 257 T1=(signed short)tempSL;			//температура внутреннего датчика
3292  01f7 1e03          	ldw	x,(OFST-1,sp)
3293  01f9 cf0060        	ldw	_T1,x
3294                     ; 260 tempSL=(signed long)(adc_buff_[0]>>2);
3296  01fc ce0064        	ldw	x,_adc_buff_
3297  01ff 57            	sraw	x
3298  0200 57            	sraw	x
3299  0201 8d000000      	callf	d_itolx
3301  0205 96            	ldw	x,sp
3302  0206 1c0001        	addw	x,#OFST-3
3303  0209 8d000000      	callf	d_rtol
3305                     ; 261 tempSL*=(signed long)ee_T2_koef;
3307  020d ce001f        	ldw	x,_ee_T2_koef
3308  0210 8d000000      	callf	d_itolx
3310  0214 96            	ldw	x,sp
3311  0215 1c0001        	addw	x,#OFST-3
3312  0218 8d000000      	callf	d_lgmul
3314                     ; 262 tempSL/=2500L;
3316  021c 96            	ldw	x,sp
3317  021d 1c0001        	addw	x,#OFST-3
3318  0220 8d000000      	callf	d_ltor
3320  0224 ae0007        	ldw	x,#L62
3321  0227 8d000000      	callf	d_ldiv
3323  022b 96            	ldw	x,sp
3324  022c 1c0001        	addw	x,#OFST-3
3325  022f 8d000000      	callf	d_rtol
3327                     ; 263 tempSL-=273L;
3329  0233 ae0111        	ldw	x,#273
3330  0236 bf02          	ldw	c_lreg+2,x
3331  0238 ae0000        	ldw	x,#0
3332  023b bf00          	ldw	c_lreg,x
3333  023d 96            	ldw	x,sp
3334  023e 1c0001        	addw	x,#OFST-3
3335  0241 8d000000      	callf	d_lgsub
3337                     ; 264 T2=(signed short)tempSL;			//температура внешнего датчика
3339  0245 1e03          	ldw	x,(OFST-1,sp)
3340  0247 cf005e        	ldw	_T2,x
3341                     ; 267 tempSL=(signed long)adc_buff_[0];
3343  024a ce0064        	ldw	x,_adc_buff_
3344  024d 8d000000      	callf	d_itolx
3346  0251 96            	ldw	x,sp
3347  0252 1c0001        	addw	x,#OFST-3
3348  0255 8d000000      	callf	d_rtol
3350                     ; 268 tempSL*=(signed long)4;
3352  0259 96            	ldw	x,sp
3353  025a 1c0001        	addw	x,#OFST-3
3354  025d a602          	ld	a,#2
3355  025f 8d000000      	callf	d_lglsh
3357                     ; 269 tempSL/=(signed long)5;
3359  0263 96            	ldw	x,sp
3360  0264 1c0001        	addw	x,#OFST-3
3361  0267 8d000000      	callf	d_ltor
3363  026b ae000b        	ldw	x,#L03
3364  026e 8d000000      	callf	d_ldiv
3366  0272 96            	ldw	x,sp
3367  0273 1c0001        	addw	x,#OFST-3
3368  0276 8d000000      	callf	d_rtol
3370                     ; 270 H1=(signed short)tempSL;
3372  027a 1e03          	ldw	x,(OFST-1,sp)
3373  027c cf004c        	ldw	_H1,x
3374                     ; 272 }
3377  027f 5b04          	addw	sp,#4
3378  0281 87            	retf
3400                     ; 275 void uart_init (void)
3400                     ; 276 {
3401                     	switch	.text
3402  0282               f_uart_init:
3406                     ; 278 GPIOD->DDR&=~(1<<6);
3408  0282 721d5011      	bres	20497,#6
3409                     ; 279 GPIOD->CR1|=(1<<6);
3411  0286 721c5012      	bset	20498,#6
3412                     ; 280 GPIOD->CR2&=~(1<<6);
3414  028a 721d5013      	bres	20499,#6
3415                     ; 283 GPIOD->DDR|=(1<<5);
3417  028e 721a5011      	bset	20497,#5
3418                     ; 284 GPIOD->CR1|=(1<<5);
3420  0292 721a5012      	bset	20498,#5
3421                     ; 285 GPIOD->CR2&=~(1<<5);	
3423  0296 721b5013      	bres	20499,#5
3424                     ; 288 GPIOD->DDR|=(1<<7);
3426  029a 721e5011      	bset	20497,#7
3427                     ; 289 GPIOD->CR1|=(1<<7);
3429  029e 721e5012      	bset	20498,#7
3430                     ; 290 GPIOD->CR2&=~(1<<7);
3432  02a2 721f5013      	bres	20499,#7
3433                     ; 291 GPIOD->ODR|=(1<<7);		//Сразу в 1
3435  02a6 721e500f      	bset	20495,#7
3436                     ; 294 GPIOD->DDR|=(1<<4);
3438  02aa 72185011      	bset	20497,#4
3439                     ; 295 GPIOD->CR1|=(1<<4);
3441  02ae 72185012      	bset	20498,#4
3442                     ; 296 GPIOD->CR2&=~(1<<4);
3444  02b2 72195013      	bres	20499,#4
3445                     ; 298 UART2->CR1&=~UART2_CR1_M;					
3447  02b6 72195244      	bres	21060,#4
3448                     ; 299 UART2->CR3|= (0<<4) & UART2_CR3_STOP;	
3450  02ba c65246        	ld	a,21062
3451                     ; 300 UART2->BRR2= 0x03;
3453  02bd 35035243      	mov	21059,#3
3454                     ; 301 UART2->BRR1= 0x68;
3456  02c1 35685242      	mov	21058,#104
3457                     ; 302 UART2->CR2|= UART2_CR2_TEN | UART2_CR2_REN | UART2_CR2_RIEN/*| UART2_CR2_TIEN*/ ;	
3459  02c5 c65245        	ld	a,21061
3460  02c8 aa2c          	or	a,#44
3461  02ca c75245        	ld	21061,a
3462                     ; 303 }
3465  02cd 87            	retf
3600                     ; 306 void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7){
3601                     	switch	.text
3602  02ce               f_uart_out:
3604  02ce 89            	pushw	x
3605  02cf 520e          	subw	sp,#14
3606       0000000e      OFST:	set	14
3609                     ; 307 	char i=0,t=0,UOB[12];
3613  02d1 0f01          	clr	(OFST-13,sp)
3614                     ; 310 	UOB[0]=data0;
3616  02d3 9f            	ld	a,xl
3617  02d4 6b02          	ld	(OFST-12,sp),a
3618                     ; 311 	UOB[1]=data1;
3620  02d6 7b14          	ld	a,(OFST+6,sp)
3621  02d8 6b03          	ld	(OFST-11,sp),a
3622                     ; 312 	UOB[2]=data2;
3624  02da 7b15          	ld	a,(OFST+7,sp)
3625  02dc 6b04          	ld	(OFST-10,sp),a
3626                     ; 313 	UOB[3]=data3;
3628  02de 7b16          	ld	a,(OFST+8,sp)
3629  02e0 6b05          	ld	(OFST-9,sp),a
3630                     ; 314 	UOB[4]=data4;
3632  02e2 7b17          	ld	a,(OFST+9,sp)
3633  02e4 6b06          	ld	(OFST-8,sp),a
3634                     ; 315 	UOB[5]=data5;
3636  02e6 7b18          	ld	a,(OFST+10,sp)
3637  02e8 6b07          	ld	(OFST-7,sp),a
3638                     ; 316 	UOB[6]=data6;
3640  02ea 7b19          	ld	a,(OFST+11,sp)
3641  02ec 6b08          	ld	(OFST-6,sp),a
3642                     ; 317 	UOB[7]=data7;	
3644  02ee 7b1a          	ld	a,(OFST+12,sp)
3645  02f0 6b09          	ld	(OFST-5,sp),a
3646                     ; 318 	for (i=0;i<num;i++)
3648  02f2 0f0e          	clr	(OFST+0,sp)
3650  02f4 2013          	jra	L1512
3651  02f6               L5412:
3652                     ; 320 		t^=UOB[i];
3654  02f6 96            	ldw	x,sp
3655  02f7 1c0002        	addw	x,#OFST-12
3656  02fa 9f            	ld	a,xl
3657  02fb 5e            	swapw	x
3658  02fc 1b0e          	add	a,(OFST+0,sp)
3659  02fe 2401          	jrnc	L63
3660  0300 5c            	incw	x
3661  0301               L63:
3662  0301 02            	rlwa	x,a
3663  0302 7b01          	ld	a,(OFST-13,sp)
3664  0304 f8            	xor	a,	(x)
3665  0305 6b01          	ld	(OFST-13,sp),a
3666                     ; 318 	for (i=0;i<num;i++)
3668  0307 0c0e          	inc	(OFST+0,sp)
3669  0309               L1512:
3672  0309 7b0e          	ld	a,(OFST+0,sp)
3673  030b 110f          	cp	a,(OFST+1,sp)
3674  030d 25e7          	jrult	L5412
3675                     ; 322 	UOB[num]=num;
3677  030f 96            	ldw	x,sp
3678  0310 1c0002        	addw	x,#OFST-12
3679  0313 9f            	ld	a,xl
3680  0314 5e            	swapw	x
3681  0315 1b0f          	add	a,(OFST+1,sp)
3682  0317 2401          	jrnc	L04
3683  0319 5c            	incw	x
3684  031a               L04:
3685  031a 02            	rlwa	x,a
3686  031b 7b0f          	ld	a,(OFST+1,sp)
3687  031d f7            	ld	(x),a
3688                     ; 323 	t^=UOB[num];
3690  031e 96            	ldw	x,sp
3691  031f 1c0002        	addw	x,#OFST-12
3692  0322 9f            	ld	a,xl
3693  0323 5e            	swapw	x
3694  0324 1b0f          	add	a,(OFST+1,sp)
3695  0326 2401          	jrnc	L24
3696  0328 5c            	incw	x
3697  0329               L24:
3698  0329 02            	rlwa	x,a
3699  032a 7b01          	ld	a,(OFST-13,sp)
3700  032c f8            	xor	a,	(x)
3701  032d 6b01          	ld	(OFST-13,sp),a
3702                     ; 324 	UOB[num+1]=t;
3704  032f 96            	ldw	x,sp
3705  0330 1c0003        	addw	x,#OFST-11
3706  0333 9f            	ld	a,xl
3707  0334 5e            	swapw	x
3708  0335 1b0f          	add	a,(OFST+1,sp)
3709  0337 2401          	jrnc	L44
3710  0339 5c            	incw	x
3711  033a               L44:
3712  033a 02            	rlwa	x,a
3713  033b 7b01          	ld	a,(OFST-13,sp)
3714  033d f7            	ld	(x),a
3715                     ; 325 	UOB[num+2]=END;
3717  033e 96            	ldw	x,sp
3718  033f 1c0004        	addw	x,#OFST-10
3719  0342 9f            	ld	a,xl
3720  0343 5e            	swapw	x
3721  0344 1b0f          	add	a,(OFST+1,sp)
3722  0346 2401          	jrnc	L64
3723  0348 5c            	incw	x
3724  0349               L64:
3725  0349 02            	rlwa	x,a
3726  034a a60a          	ld	a,#10
3727  034c f7            	ld	(x),a
3728                     ; 329 	for (i=0;i<num+3;i++)
3730  034d 0f0e          	clr	(OFST+0,sp)
3732  034f 2013          	jra	L1612
3733  0351               L5512:
3734                     ; 331 		putchar(UOB[i]);
3736  0351 96            	ldw	x,sp
3737  0352 1c0002        	addw	x,#OFST-12
3738  0355 9f            	ld	a,xl
3739  0356 5e            	swapw	x
3740  0357 1b0e          	add	a,(OFST+0,sp)
3741  0359 2401          	jrnc	L05
3742  035b 5c            	incw	x
3743  035c               L05:
3744  035c 02            	rlwa	x,a
3745  035d f6            	ld	a,(x)
3746  035e 8d000000      	callf	f_putchar
3748                     ; 329 	for (i=0;i<num+3;i++)
3750  0362 0c0e          	inc	(OFST+0,sp)
3751  0364               L1612:
3754  0364 9c            	rvf
3755  0365 7b0e          	ld	a,(OFST+0,sp)
3756  0367 5f            	clrw	x
3757  0368 97            	ld	xl,a
3758  0369 7b0f          	ld	a,(OFST+1,sp)
3759  036b 905f          	clrw	y
3760  036d 9097          	ld	yl,a
3761  036f 72a90003      	addw	y,#3
3762  0373 bf00          	ldw	c_x,x
3763  0375 90b300        	cpw	y,c_x
3764  0378 2cd7          	jrsgt	L5512
3765                     ; 334 	bOUT_FREE=0;	  	
3767  037a 72110002      	bres	_bOUT_FREE
3768                     ; 335 }
3771  037e 5b10          	addw	sp,#16
3772  0380 87            	retf
3853                     ; 338 void uart_out_adr_block (unsigned long adress,char *ptr, char len)
3853                     ; 339 {
3854                     	switch	.text
3855  0381               f_uart_out_adr_block:
3857  0381 5203          	subw	sp,#3
3858       00000003      OFST:	set	3
3861                     ; 343 t=0;
3863  0383 0f02          	clr	(OFST-1,sp)
3864                     ; 344 temp11=CMND;
3866                     ; 345 t^=temp11;
3868  0385 7b02          	ld	a,(OFST-1,sp)
3869  0387 a816          	xor	a,	#22
3870  0389 6b02          	ld	(OFST-1,sp),a
3871                     ; 346 putchar(temp11);
3873  038b a616          	ld	a,#22
3874  038d 8d000000      	callf	f_putchar
3876                     ; 348 temp11=10;
3878                     ; 349 t^=temp11;
3880  0391 7b02          	ld	a,(OFST-1,sp)
3881  0393 a80a          	xor	a,	#10
3882  0395 6b02          	ld	(OFST-1,sp),a
3883                     ; 350 putchar(temp11);
3885  0397 a60a          	ld	a,#10
3886  0399 8d000000      	callf	f_putchar
3888                     ; 352 temp11=adress%256;//(*((char*)&adress));
3890  039d 7b0a          	ld	a,(OFST+7,sp)
3891  039f a4ff          	and	a,#255
3892  03a1 6b03          	ld	(OFST+0,sp),a
3893                     ; 353 t^=temp11;
3895  03a3 7b02          	ld	a,(OFST-1,sp)
3896  03a5 1803          	xor	a,	(OFST+0,sp)
3897  03a7 6b02          	ld	(OFST-1,sp),a
3898                     ; 354 putchar(temp11);
3900  03a9 7b03          	ld	a,(OFST+0,sp)
3901  03ab 8d000000      	callf	f_putchar
3903                     ; 355 adress>>=8;
3905  03af 96            	ldw	x,sp
3906  03b0 1c0007        	addw	x,#OFST+4
3907  03b3 a608          	ld	a,#8
3908  03b5 8d000000      	callf	d_lgursh
3910                     ; 356 temp11=adress%256;//(*(((char*)&adress)+1));
3912  03b9 7b0a          	ld	a,(OFST+7,sp)
3913  03bb a4ff          	and	a,#255
3914  03bd 6b03          	ld	(OFST+0,sp),a
3915                     ; 357 t^=temp11;
3917  03bf 7b02          	ld	a,(OFST-1,sp)
3918  03c1 1803          	xor	a,	(OFST+0,sp)
3919  03c3 6b02          	ld	(OFST-1,sp),a
3920                     ; 358 putchar(temp11);
3922  03c5 7b03          	ld	a,(OFST+0,sp)
3923  03c7 8d000000      	callf	f_putchar
3925                     ; 359 adress>>=8;
3927  03cb 96            	ldw	x,sp
3928  03cc 1c0007        	addw	x,#OFST+4
3929  03cf a608          	ld	a,#8
3930  03d1 8d000000      	callf	d_lgursh
3932                     ; 360 temp11=adress%256;//(*(((char*)&adress)+2));
3934  03d5 7b0a          	ld	a,(OFST+7,sp)
3935  03d7 a4ff          	and	a,#255
3936  03d9 6b03          	ld	(OFST+0,sp),a
3937                     ; 361 t^=temp11;
3939  03db 7b02          	ld	a,(OFST-1,sp)
3940  03dd 1803          	xor	a,	(OFST+0,sp)
3941  03df 6b02          	ld	(OFST-1,sp),a
3942                     ; 362 putchar(temp11);
3944  03e1 7b03          	ld	a,(OFST+0,sp)
3945  03e3 8d000000      	callf	f_putchar
3947                     ; 363 adress>>=8;
3949  03e7 96            	ldw	x,sp
3950  03e8 1c0007        	addw	x,#OFST+4
3951  03eb a608          	ld	a,#8
3952  03ed 8d000000      	callf	d_lgursh
3954                     ; 364 temp11=adress%256;//(*(((char*)&adress)+3));
3956  03f1 7b0a          	ld	a,(OFST+7,sp)
3957  03f3 a4ff          	and	a,#255
3958  03f5 6b03          	ld	(OFST+0,sp),a
3959                     ; 365 t^=temp11;
3961  03f7 7b02          	ld	a,(OFST-1,sp)
3962  03f9 1803          	xor	a,	(OFST+0,sp)
3963  03fb 6b02          	ld	(OFST-1,sp),a
3964                     ; 366 putchar(temp11);
3966  03fd 7b03          	ld	a,(OFST+0,sp)
3967  03ff 8d000000      	callf	f_putchar
3969                     ; 369 for(i11=0;i11<len;i11++)
3971  0403 0f01          	clr	(OFST-2,sp)
3973  0405 201c          	jra	L3322
3974  0407               L7222:
3975                     ; 371 	temp11=ptr[i11];
3977  0407 7b0b          	ld	a,(OFST+8,sp)
3978  0409 97            	ld	xl,a
3979  040a 7b0c          	ld	a,(OFST+9,sp)
3980  040c 1b01          	add	a,(OFST-2,sp)
3981  040e 2401          	jrnc	L45
3982  0410 5c            	incw	x
3983  0411               L45:
3984  0411 02            	rlwa	x,a
3985  0412 f6            	ld	a,(x)
3986  0413 6b03          	ld	(OFST+0,sp),a
3987                     ; 372 	t^=temp11;
3989  0415 7b02          	ld	a,(OFST-1,sp)
3990  0417 1803          	xor	a,	(OFST+0,sp)
3991  0419 6b02          	ld	(OFST-1,sp),a
3992                     ; 373 	putchar(temp11);
3994  041b 7b03          	ld	a,(OFST+0,sp)
3995  041d 8d000000      	callf	f_putchar
3997                     ; 369 for(i11=0;i11<len;i11++)
3999  0421 0c01          	inc	(OFST-2,sp)
4000  0423               L3322:
4003  0423 7b01          	ld	a,(OFST-2,sp)
4004  0425 110d          	cp	a,(OFST+10,sp)
4005  0427 25de          	jrult	L7222
4006                     ; 376 temp11=(len+6);
4008  0429 7b0d          	ld	a,(OFST+10,sp)
4009  042b ab06          	add	a,#6
4010  042d 6b03          	ld	(OFST+0,sp),a
4011                     ; 377 t^=temp11;
4013  042f 7b02          	ld	a,(OFST-1,sp)
4014  0431 1803          	xor	a,	(OFST+0,sp)
4015  0433 6b02          	ld	(OFST-1,sp),a
4016                     ; 378 putchar(temp11);
4018  0435 7b03          	ld	a,(OFST+0,sp)
4019  0437 8d000000      	callf	f_putchar
4021                     ; 380 putchar(t);
4023  043b 7b02          	ld	a,(OFST-1,sp)
4024  043d 8d000000      	callf	f_putchar
4026                     ; 382 putchar(0x0a);
4028  0441 a60a          	ld	a,#10
4029  0443 8d000000      	callf	f_putchar
4031                     ; 384 bOUT_FREE=0;	   
4033  0447 72110002      	bres	_bOUT_FREE
4034                     ; 385 }
4037  044b 5b03          	addw	sp,#3
4038  044d 87            	retf
4084                     ; 387 void uart_in_an(void) {
4085                     	switch	.text
4086  044e               f_uart_in_an:
4088  044e 89            	pushw	x
4089       00000002      OFST:	set	2
4092                     ; 390 	if(UIB[0]==CMND) {
4094  044f c60019        	ld	a,_UIB
4095  0452 a116          	cp	a,#22
4096  0454 2704          	jreq	L06
4097  0456 ace605e6      	jpf	L1622
4098  045a               L06:
4099                     ; 394 	 if(UIB[1]==2) {
4101  045a c6001a        	ld	a,_UIB+1
4102  045d a102          	cp	a,#2
4103  045f 2604          	jrne	L26
4104  0461 ace605e6      	jpf	L1622
4105  0465               L26:
4107                     ; 402 	else if(UIB[1]==3)
4109  0465 c6001a        	ld	a,_UIB+1
4110  0468 a103          	cp	a,#3
4111  046a 2604          	jrne	L46
4112  046c ace605e6      	jpf	L1622
4113  0470               L46:
4115                     ; 409 	else if(UIB[1]==4)
4117  0470 c6001a        	ld	a,_UIB+1
4118  0473 a104          	cp	a,#4
4119  0475 2604          	jrne	L66
4120  0477 ace605e6      	jpf	L1622
4121  047b               L66:
4123                     ; 416 	else if(UIB[1]==10)
4125  047b c6001a        	ld	a,_UIB+1
4126  047e a10a          	cp	a,#10
4127  0480 2670          	jrne	L7722
4128                     ; 420 		uart_out_adr_block (0,buff,64);
4130  0482 4b40          	push	#64
4131  0484 ae0021        	ldw	x,#_buff
4132  0487 89            	pushw	x
4133  0488 ae0000        	ldw	x,#0
4134  048b 89            	pushw	x
4135  048c ae0000        	ldw	x,#0
4136  048f 89            	pushw	x
4137  0490 8d810381      	callf	f_uart_out_adr_block
4139  0494 5b07          	addw	sp,#7
4140                     ; 421 		delay_ms(100);    
4142  0496 ae0064        	ldw	x,#100
4143  0499 8d9e009e      	callf	f_delay_ms
4145                     ; 422 		uart_out_adr_block (64,&buff[64],64);
4147  049d 4b40          	push	#64
4148  049f ae0061        	ldw	x,#_buff+64
4149  04a2 89            	pushw	x
4150  04a3 ae0040        	ldw	x,#64
4151  04a6 89            	pushw	x
4152  04a7 ae0000        	ldw	x,#0
4153  04aa 89            	pushw	x
4154  04ab 8d810381      	callf	f_uart_out_adr_block
4156  04af 5b07          	addw	sp,#7
4157                     ; 423 		delay_ms(100);    
4159  04b1 ae0064        	ldw	x,#100
4160  04b4 8d9e009e      	callf	f_delay_ms
4162                     ; 424 		uart_out_adr_block (128,&buff[128],64);
4164  04b8 4b40          	push	#64
4165  04ba ae00a1        	ldw	x,#_buff+128
4166  04bd 89            	pushw	x
4167  04be ae0080        	ldw	x,#128
4168  04c1 89            	pushw	x
4169  04c2 ae0000        	ldw	x,#0
4170  04c5 89            	pushw	x
4171  04c6 8d810381      	callf	f_uart_out_adr_block
4173  04ca 5b07          	addw	sp,#7
4174                     ; 425 		delay_ms(100);    
4176  04cc ae0064        	ldw	x,#100
4177  04cf 8d9e009e      	callf	f_delay_ms
4179                     ; 426 		uart_out_adr_block (192,&buff[192],64);
4181  04d3 4b40          	push	#64
4182  04d5 ae00e1        	ldw	x,#_buff+192
4183  04d8 89            	pushw	x
4184  04d9 ae00c0        	ldw	x,#192
4185  04dc 89            	pushw	x
4186  04dd ae0000        	ldw	x,#0
4187  04e0 89            	pushw	x
4188  04e1 8d810381      	callf	f_uart_out_adr_block
4190  04e5 5b07          	addw	sp,#7
4191                     ; 427 		delay_ms(100);    
4193  04e7 ae0064        	ldw	x,#100
4194  04ea 8d9e009e      	callf	f_delay_ms
4197  04ee ace605e6      	jpf	L1622
4198  04f2               L7722:
4199                     ; 430 	else if(UIB[1]==11)
4201  04f2 c6001a        	ld	a,_UIB+1
4202  04f5 a10b          	cp	a,#11
4203  04f7 261b          	jrne	L3032
4204                     ; 436 		for(i=0;i<256;i++)buff[i]=0;
4206  04f9 5f            	clrw	x
4207  04fa 1f01          	ldw	(OFST-1,sp),x
4208  04fc               L5032:
4211  04fc 1e01          	ldw	x,(OFST-1,sp)
4212  04fe 724f0021      	clr	(_buff,x)
4215  0502 1e01          	ldw	x,(OFST-1,sp)
4216  0504 1c0001        	addw	x,#1
4217  0507 1f01          	ldw	(OFST-1,sp),x
4220  0509 1e01          	ldw	x,(OFST-1,sp)
4221  050b a30100        	cpw	x,#256
4222  050e 25ec          	jrult	L5032
4224  0510 ace605e6      	jpf	L1622
4225  0514               L3032:
4226                     ; 440 	else if(UIB[1]==12)
4228  0514 c6001a        	ld	a,_UIB+1
4229  0517 a10c          	cp	a,#12
4230  0519 2704          	jreq	L07
4231  051b ace105e1      	jpf	L5132
4232  051f               L07:
4233                     ; 446 		for(i=0;i<256;i++)buff[i]=0;
4235  051f 5f            	clrw	x
4236  0520 1f01          	ldw	(OFST-1,sp),x
4237  0522               L7132:
4240  0522 1e01          	ldw	x,(OFST-1,sp)
4241  0524 724f0021      	clr	(_buff,x)
4244  0528 1e01          	ldw	x,(OFST-1,sp)
4245  052a 1c0001        	addw	x,#1
4246  052d 1f01          	ldw	(OFST-1,sp),x
4249  052f 1e01          	ldw	x,(OFST-1,sp)
4250  0531 a30100        	cpw	x,#256
4251  0534 25ec          	jrult	L7132
4252                     ; 448 		if(UIB[3]==1)
4254  0536 c6001c        	ld	a,_UIB+3
4255  0539 a101          	cp	a,#1
4256  053b 2632          	jrne	L5232
4257                     ; 450 			buff[0]=0x00;
4259  053d 725f0021      	clr	_buff
4260                     ; 451 			buff[1]=0x11;
4262  0541 35110022      	mov	_buff+1,#17
4263                     ; 452 			buff[2]=0x22;
4265  0545 35220023      	mov	_buff+2,#34
4266                     ; 453 			buff[3]=0x33;
4268  0549 35330024      	mov	_buff+3,#51
4269                     ; 454 			buff[4]=0x44;
4271  054d 35440025      	mov	_buff+4,#68
4272                     ; 455 			buff[5]=0x55;
4274  0551 35550026      	mov	_buff+5,#85
4275                     ; 456 			buff[6]=0x66;
4277  0555 35660027      	mov	_buff+6,#102
4278                     ; 457 			buff[7]=0x77;
4280  0559 35770028      	mov	_buff+7,#119
4281                     ; 458 			buff[8]=0x88;
4283  055d 35880029      	mov	_buff+8,#136
4284                     ; 459 			buff[9]=0x99;
4286  0561 3599002a      	mov	_buff+9,#153
4287                     ; 460 			buff[10]=0;
4289  0565 725f002b      	clr	_buff+10
4290                     ; 461 			buff[11]=0;
4292  0569 725f002c      	clr	_buff+11
4294  056d 2077          	jra	L1622
4295  056f               L5232:
4296                     ; 464 		else if(UIB[3]==2)
4298  056f c6001c        	ld	a,_UIB+3
4299  0572 a102          	cp	a,#2
4300  0574 2632          	jrne	L1332
4301                     ; 466 			buff[0]=0x00;
4303  0576 725f0021      	clr	_buff
4304                     ; 467 			buff[1]=0x10;
4306  057a 35100022      	mov	_buff+1,#16
4307                     ; 468 			buff[2]=0x20;
4309  057e 35200023      	mov	_buff+2,#32
4310                     ; 469 			buff[3]=0x30;
4312  0582 35300024      	mov	_buff+3,#48
4313                     ; 470 			buff[4]=0x40;
4315  0586 35400025      	mov	_buff+4,#64
4316                     ; 471 			buff[5]=0x50;
4318  058a 35500026      	mov	_buff+5,#80
4319                     ; 472 			buff[6]=0x60;
4321  058e 35600027      	mov	_buff+6,#96
4322                     ; 473 			buff[7]=0x70;
4324  0592 35700028      	mov	_buff+7,#112
4325                     ; 474 			buff[8]=0x80;
4327  0596 35800029      	mov	_buff+8,#128
4328                     ; 475 			buff[9]=0x90;
4330  059a 3590002a      	mov	_buff+9,#144
4331                     ; 476 			buff[10]=0;
4333  059e 725f002b      	clr	_buff+10
4334                     ; 477 			buff[11]=0;
4336  05a2 725f002c      	clr	_buff+11
4338  05a6 203e          	jra	L1622
4339  05a8               L1332:
4340                     ; 480 		else if(UIB[3]==3)
4342  05a8 c6001c        	ld	a,_UIB+3
4343  05ab a103          	cp	a,#3
4344  05ad 2637          	jrne	L1622
4345                     ; 482 			buff[0]=0x98;
4347  05af 35980021      	mov	_buff,#152
4348                     ; 483 			buff[1]=0x87;
4350  05b3 35870022      	mov	_buff+1,#135
4351                     ; 484 			buff[2]=0x76;
4353  05b7 35760023      	mov	_buff+2,#118
4354                     ; 485 			buff[3]=0x65;
4356  05bb 35650024      	mov	_buff+3,#101
4357                     ; 486 			buff[4]=0x54;
4359  05bf 35540025      	mov	_buff+4,#84
4360                     ; 487 			buff[5]=0x43;
4362  05c3 35430026      	mov	_buff+5,#67
4363                     ; 488 			buff[6]=0x32;
4365  05c7 35320027      	mov	_buff+6,#50
4366                     ; 489 			buff[7]=0x21;
4368  05cb 35210028      	mov	_buff+7,#33
4369                     ; 490 			buff[8]=0x10;
4371  05cf 35100029      	mov	_buff+8,#16
4372                     ; 491 			buff[9]=0x00;
4374  05d3 725f002a      	clr	_buff+9
4375                     ; 492 			buff[10]=0;
4377  05d7 725f002b      	clr	_buff+10
4378                     ; 493 			buff[11]=0;
4380  05db 725f002c      	clr	_buff+11
4381  05df 2005          	jra	L1622
4382  05e1               L5132:
4383                     ; 500 	else if(UIB[1]==20)
4385  05e1 c6001a        	ld	a,_UIB+1
4386  05e4 a114          	cp	a,#20
4387  05e6               L1622:
4388                     ; 531 }
4391  05e6 85            	popw	x
4392  05e7 87            	retf
4414                     ; 538 void gpio_init(void){
4415                     	switch	.text
4416  05e8               f_gpio_init:
4420                     ; 548 	GPIOD->DDR|=(1<<2);
4422  05e8 72145011      	bset	20497,#2
4423                     ; 549 	GPIOD->CR1|=(1<<2);
4425  05ec 72145012      	bset	20498,#2
4426                     ; 550 	GPIOD->CR2|=(1<<2);
4428  05f0 72145013      	bset	20499,#2
4429                     ; 551 	GPIOD->ODR&=~(1<<2);
4431  05f4 7215500f      	bres	20495,#2
4432                     ; 553 	GPIOD->DDR|=(1<<4);
4434  05f8 72185011      	bset	20497,#4
4435                     ; 554 	GPIOD->CR1|=(1<<4);
4437  05fc 72185012      	bset	20498,#4
4438                     ; 555 	GPIOD->CR2&=~(1<<4);
4440  0600 72195013      	bres	20499,#4
4441                     ; 557 	GPIOC->DDR&=~(1<<4);
4443  0604 7219500c      	bres	20492,#4
4444                     ; 558 	GPIOC->CR1&=~(1<<4);
4446  0608 7219500d      	bres	20493,#4
4447                     ; 559 	GPIOC->CR2&=~(1<<4);
4449  060c 7219500e      	bres	20494,#4
4450                     ; 563 }
4453  0610 87            	retf
4504                     ; 570 void uart_in(void)
4504                     ; 571 {
4505                     	switch	.text
4506  0611               f_uart_in:
4508  0611 89            	pushw	x
4509       00000002      OFST:	set	2
4512                     ; 575 if(rx_buffer_overflow)
4514                     	btst	_rx_buffer_overflow
4515  0617 240b          	jruge	L5732
4516                     ; 577 	rx_wr_index=0;
4518  0619 3f32          	clr	_rx_wr_index
4519                     ; 578 	rx_rd_index=0;
4521  061b 3f31          	clr	_rx_rd_index
4522                     ; 579 	rx_counter=0;
4524  061d 5f            	clrw	x
4525  061e bf2d          	ldw	_rx_counter,x
4526                     ; 580 	rx_buffer_overflow=0;
4528  0620 72110000      	bres	_rx_buffer_overflow
4529  0624               L5732:
4530                     ; 583 if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
4532  0624 be2d          	ldw	x,_rx_counter
4533  0626 2604          	jrne	L211
4534  0628 acc806c8      	jpf	L7732
4535  062c               L211:
4537  062c aeffff        	ldw	x,#65535
4538  062f 89            	pushw	x
4539  0630 5f            	clrw	x
4540  0631 b632          	ld	a,_rx_wr_index
4541  0633 2a01          	jrpl	L67
4542  0635 53            	cplw	x
4543  0636               L67:
4544  0636 97            	ld	xl,a
4545  0637 8dca06ca      	callf	f_index_offset
4547  063b 5b02          	addw	sp,#2
4548  063d e637          	ld	a,(_rx_buffer,x)
4549  063f a10a          	cp	a,#10
4550  0641 26e5          	jrne	L7732
4551                     ; 588 	temp=rx_buffer[index_offset(rx_wr_index,-3)];
4553  0643 aefffd        	ldw	x,#65533
4554  0646 89            	pushw	x
4555  0647 5f            	clrw	x
4556  0648 b632          	ld	a,_rx_wr_index
4557  064a 2a01          	jrpl	L001
4558  064c 53            	cplw	x
4559  064d               L001:
4560  064d 97            	ld	xl,a
4561  064e 8dca06ca      	callf	f_index_offset
4563  0652 5b02          	addw	sp,#2
4564  0654 e637          	ld	a,(_rx_buffer,x)
4565  0656 6b01          	ld	(OFST-1,sp),a
4566                     ; 589     	if(temp<100) 
4568  0658 7b01          	ld	a,(OFST-1,sp)
4569  065a a164          	cp	a,#100
4570  065c 246a          	jruge	L7732
4571                     ; 592     		if(control_check(index_offset(rx_wr_index,-1)))
4573  065e aeffff        	ldw	x,#65535
4574  0661 89            	pushw	x
4575  0662 5f            	clrw	x
4576  0663 b632          	ld	a,_rx_wr_index
4577  0665 2a01          	jrpl	L201
4578  0667 53            	cplw	x
4579  0668               L201:
4580  0668 97            	ld	xl,a
4581  0669 8dca06ca      	callf	f_index_offset
4583  066d 5b02          	addw	sp,#2
4584  066f 9f            	ld	a,xl
4585  0670 8df206f2      	callf	f_control_check
4587  0674 4d            	tnz	a
4588  0675 2751          	jreq	L7732
4589                     ; 595     			rx_rd_index=index_offset(rx_wr_index,-3-temp);
4591  0677 a6ff          	ld	a,#255
4592  0679 97            	ld	xl,a
4593  067a a6fd          	ld	a,#253
4594  067c 1001          	sub	a,(OFST-1,sp)
4595  067e 2401          	jrnc	L401
4596  0680 5a            	decw	x
4597  0681               L401:
4598  0681 02            	rlwa	x,a
4599  0682 89            	pushw	x
4600  0683 01            	rrwa	x,a
4601  0684 5f            	clrw	x
4602  0685 b632          	ld	a,_rx_wr_index
4603  0687 2a01          	jrpl	L601
4604  0689 53            	cplw	x
4605  068a               L601:
4606  068a 97            	ld	xl,a
4607  068b 8dca06ca      	callf	f_index_offset
4609  068f 5b02          	addw	sp,#2
4610  0691 01            	rrwa	x,a
4611  0692 b731          	ld	_rx_rd_index,a
4612  0694 02            	rlwa	x,a
4613                     ; 596     			for(i=0;i<temp;i++)
4615  0695 0f02          	clr	(OFST+0,sp)
4617  0697 201f          	jra	L1142
4618  0699               L5042:
4619                     ; 598 				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
4621  0699 7b02          	ld	a,(OFST+0,sp)
4622  069b 5f            	clrw	x
4623  069c 97            	ld	xl,a
4624  069d 89            	pushw	x
4625  069e 7b04          	ld	a,(OFST+2,sp)
4626  06a0 5f            	clrw	x
4627  06a1 97            	ld	xl,a
4628  06a2 89            	pushw	x
4629  06a3 5f            	clrw	x
4630  06a4 b631          	ld	a,_rx_rd_index
4631  06a6 2a01          	jrpl	L011
4632  06a8 53            	cplw	x
4633  06a9               L011:
4634  06a9 97            	ld	xl,a
4635  06aa 8dca06ca      	callf	f_index_offset
4637  06ae 5b02          	addw	sp,#2
4638  06b0 e637          	ld	a,(_rx_buffer,x)
4639  06b2 85            	popw	x
4640  06b3 d70019        	ld	(_UIB,x),a
4641                     ; 596     			for(i=0;i<temp;i++)
4643  06b6 0c02          	inc	(OFST+0,sp)
4644  06b8               L1142:
4647  06b8 7b02          	ld	a,(OFST+0,sp)
4648  06ba 1101          	cp	a,(OFST-1,sp)
4649  06bc 25db          	jrult	L5042
4650                     ; 600 			rx_rd_index=rx_wr_index;
4652  06be 453231        	mov	_rx_rd_index,_rx_wr_index
4653                     ; 601 			rx_counter=0;
4655  06c1 5f            	clrw	x
4656  06c2 bf2d          	ldw	_rx_counter,x
4657                     ; 611 			uart_in_an();
4659  06c4 8d4e044e      	callf	f_uart_in_an
4661  06c8               L7732:
4662                     ; 620 }
4665  06c8 85            	popw	x
4666  06c9 87            	retf
4708                     ; 623 signed short index_offset (signed short index,signed short offset)
4708                     ; 624 {
4709                     	switch	.text
4710  06ca               f_index_offset:
4712  06ca 89            	pushw	x
4713       00000000      OFST:	set	0
4716                     ; 625 index=index+offset;
4718  06cb 1e01          	ldw	x,(OFST+1,sp)
4719  06cd 72fb06        	addw	x,(OFST+6,sp)
4720  06d0 1f01          	ldw	(OFST+1,sp),x
4721                     ; 626 if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
4723  06d2 9c            	rvf
4724  06d3 1e01          	ldw	x,(OFST+1,sp)
4725  06d5 a30032        	cpw	x,#50
4726  06d8 2f07          	jrslt	L7342
4729  06da 1e01          	ldw	x,(OFST+1,sp)
4730  06dc 1d0032        	subw	x,#50
4731  06df 1f01          	ldw	(OFST+1,sp),x
4732  06e1               L7342:
4733                     ; 627 if(index<0) index+=RX_BUFFER_SIZE;
4735  06e1 9c            	rvf
4736  06e2 1e01          	ldw	x,(OFST+1,sp)
4737  06e4 2e07          	jrsge	L1442
4740  06e6 1e01          	ldw	x,(OFST+1,sp)
4741  06e8 1c0032        	addw	x,#50
4742  06eb 1f01          	ldw	(OFST+1,sp),x
4743  06ed               L1442:
4744                     ; 628 return index;
4746  06ed 1e01          	ldw	x,(OFST+1,sp)
4749  06ef 5b02          	addw	sp,#2
4750  06f1 87            	retf
4812                     ; 632 char control_check(char index)
4812                     ; 633 {
4813                     	switch	.text
4814  06f2               f_control_check:
4816  06f2 88            	push	a
4817  06f3 5203          	subw	sp,#3
4818       00000003      OFST:	set	3
4821                     ; 634 char i=0,ii=0,iii;
4825                     ; 636 if(rx_buffer[index]!=END) return 0;
4827  06f5 5f            	clrw	x
4828  06f6 97            	ld	xl,a
4829  06f7 e637          	ld	a,(_rx_buffer,x)
4830  06f9 a10a          	cp	a,#10
4831  06fb 2703          	jreq	L5742
4834  06fd 4f            	clr	a
4836  06fe 2057          	jra	L421
4837  0700               L5742:
4838                     ; 638 ii=rx_buffer[index_offset(index,-2)];
4840  0700 aefffe        	ldw	x,#65534
4841  0703 89            	pushw	x
4842  0704 7b06          	ld	a,(OFST+3,sp)
4843  0706 5f            	clrw	x
4844  0707 97            	ld	xl,a
4845  0708 8dca06ca      	callf	f_index_offset
4847  070c 5b02          	addw	sp,#2
4848  070e e637          	ld	a,(_rx_buffer,x)
4849  0710 6b02          	ld	(OFST-1,sp),a
4850                     ; 639 iii=0;
4852  0712 0f01          	clr	(OFST-2,sp)
4853                     ; 640 for(i=0;i<=ii;i++)
4855  0714 0f03          	clr	(OFST+0,sp)
4857  0716 2024          	jra	L3052
4858  0718               L7742:
4859                     ; 642 	iii^=rx_buffer[index_offset(index,-2-ii+i)];
4861  0718 a6ff          	ld	a,#255
4862  071a 97            	ld	xl,a
4863  071b a6fe          	ld	a,#254
4864  071d 1002          	sub	a,(OFST-1,sp)
4865  071f 2401          	jrnc	L021
4866  0721 5a            	decw	x
4867  0722               L021:
4868  0722 1b03          	add	a,(OFST+0,sp)
4869  0724 2401          	jrnc	L221
4870  0726 5c            	incw	x
4871  0727               L221:
4872  0727 02            	rlwa	x,a
4873  0728 89            	pushw	x
4874  0729 01            	rrwa	x,a
4875  072a 7b06          	ld	a,(OFST+3,sp)
4876  072c 5f            	clrw	x
4877  072d 97            	ld	xl,a
4878  072e 8dca06ca      	callf	f_index_offset
4880  0732 5b02          	addw	sp,#2
4881  0734 7b01          	ld	a,(OFST-2,sp)
4882  0736 e837          	xor	a,	(_rx_buffer,x)
4883  0738 6b01          	ld	(OFST-2,sp),a
4884                     ; 640 for(i=0;i<=ii;i++)
4886  073a 0c03          	inc	(OFST+0,sp)
4887  073c               L3052:
4890  073c 7b03          	ld	a,(OFST+0,sp)
4891  073e 1102          	cp	a,(OFST-1,sp)
4892  0740 23d6          	jrule	L7742
4893                     ; 644 if (iii!=rx_buffer[index_offset(index,-1)]) return 0;	
4895  0742 aeffff        	ldw	x,#65535
4896  0745 89            	pushw	x
4897  0746 7b06          	ld	a,(OFST+3,sp)
4898  0748 5f            	clrw	x
4899  0749 97            	ld	xl,a
4900  074a 8dca06ca      	callf	f_index_offset
4902  074e 5b02          	addw	sp,#2
4903  0750 e637          	ld	a,(_rx_buffer,x)
4904  0752 1101          	cp	a,(OFST-2,sp)
4905  0754 2704          	jreq	L7052
4908  0756 4f            	clr	a
4910  0757               L421:
4912  0757 5b04          	addw	sp,#4
4913  0759 87            	retf
4914  075a               L7052:
4915                     ; 646 return 1;
4917  075a a601          	ld	a,#1
4919  075c 20f9          	jra	L421
4986                     ; 651 void data_out_hndl(void)
4986                     ; 652 {
4987                     	switch	.text
4988  075e               f_data_out_hndl:
4992                     ; 659 data_out[0]=0x33;
4994  075e 35330000      	mov	_data_out,#51
4995                     ; 663 if(log_in_stat[0]==lisON)data_out[1]|=(1<<0);
4997  0762 c600db        	ld	a,_log_in_stat
4998  0765 a101          	cp	a,#1
4999  0767 2606          	jrne	L1252
5002  0769 72100001      	bset	_data_out+1,#0
5004  076d 2004          	jra	L3252
5005  076f               L1252:
5006                     ; 664 else data_out[1]&=~(1<<0);
5008  076f 72110001      	bres	_data_out+1,#0
5009  0773               L3252:
5010                     ; 666 if(log_in_stat[1]==lisON)data_out[1]|=(1<<1);
5012  0773 c600dc        	ld	a,_log_in_stat+1
5013  0776 a101          	cp	a,#1
5014  0778 2606          	jrne	L5252
5017  077a 72120001      	bset	_data_out+1,#1
5019  077e 2004          	jra	L7252
5020  0780               L5252:
5021                     ; 667 else data_out[1]&=~(1<<1);
5023  0780 72130001      	bres	_data_out+1,#1
5024  0784               L7252:
5025                     ; 669 if(log_in_stat[2]==lisON)data_out[1]|=(1<<2);
5027  0784 c600dd        	ld	a,_log_in_stat+2
5028  0787 a101          	cp	a,#1
5029  0789 2606          	jrne	L1352
5032  078b 72140001      	bset	_data_out+1,#2
5034  078f 2004          	jra	L3352
5035  0791               L1352:
5036                     ; 670 else data_out[1]&=~(1<<2);
5038  0791 72150001      	bres	_data_out+1,#2
5039  0795               L3352:
5040                     ; 672 if(log_in_stat[3]==lisON)data_out[1]|=(1<<3);
5042  0795 c600de        	ld	a,_log_in_stat+3
5043  0798 a101          	cp	a,#1
5044  079a 2606          	jrne	L5352
5047  079c 72160001      	bset	_data_out+1,#3
5049  07a0 2004          	jra	L7352
5050  07a2               L5352:
5051                     ; 673 else data_out[1]&=~(1<<3);
5053  07a2 72170001      	bres	_data_out+1,#3
5054  07a6               L7352:
5055                     ; 675 if(log_in_stat[4]==lisON)data_out[1]|=(1<<4);
5057  07a6 c600df        	ld	a,_log_in_stat+4
5058  07a9 a101          	cp	a,#1
5059  07ab 2606          	jrne	L1452
5062  07ad 72180001      	bset	_data_out+1,#4
5064  07b1 2004          	jra	L3452
5065  07b3               L1452:
5066                     ; 676 else data_out[1]&=~(1<<4);
5068  07b3 72190001      	bres	_data_out+1,#4
5069  07b7               L3452:
5070                     ; 678 if(log_in_stat[5]==lisON)data_out[1]|=(1<<5);
5072  07b7 c600e0        	ld	a,_log_in_stat+5
5073  07ba a101          	cp	a,#1
5074  07bc 2606          	jrne	L5452
5077  07be 721a0001      	bset	_data_out+1,#5
5079  07c2 2004          	jra	L7452
5080  07c4               L5452:
5081                     ; 679 else data_out[1]&=~(1<<5);
5083  07c4 721b0001      	bres	_data_out+1,#5
5084  07c8               L7452:
5085                     ; 682 if(ee_log_in_stat_of_av[0]==lisoaON)data_out[2]|=(1<<0);
5087  07c8 c60037        	ld	a,_ee_log_in_stat_of_av
5088  07cb a101          	cp	a,#1
5089  07cd 2606          	jrne	L1552
5092  07cf 72100002      	bset	_data_out+2,#0
5094  07d3 2004          	jra	L3552
5095  07d5               L1552:
5096                     ; 683 else data_out[2]&=~(1<<0);
5098  07d5 72110002      	bres	_data_out+2,#0
5099  07d9               L3552:
5100                     ; 685 if(ee_log_in_stat_of_av[1]==lisoaON)data_out[2]|=(1<<1);
5102  07d9 c60038        	ld	a,_ee_log_in_stat_of_av+1
5103  07dc a101          	cp	a,#1
5104  07de 2606          	jrne	L5552
5107  07e0 72120002      	bset	_data_out+2,#1
5109  07e4 2004          	jra	L7552
5110  07e6               L5552:
5111                     ; 686 else data_out[2]&=~(1<<1);
5113  07e6 72130002      	bres	_data_out+2,#1
5114  07ea               L7552:
5115                     ; 688 if(ee_log_in_stat_of_av[2]==lisoaON)data_out[2]|=(1<<2);
5117  07ea c60039        	ld	a,_ee_log_in_stat_of_av+2
5118  07ed a101          	cp	a,#1
5119  07ef 2606          	jrne	L1652
5122  07f1 72140002      	bset	_data_out+2,#2
5124  07f5 2004          	jra	L3652
5125  07f7               L1652:
5126                     ; 689 else data_out[2]&=~(1<<2);
5128  07f7 72150002      	bres	_data_out+2,#2
5129  07fb               L3652:
5130                     ; 691 if(ee_log_in_stat_of_av[3]==lisoaON)data_out[2]|=(1<<3);
5132  07fb c6003a        	ld	a,_ee_log_in_stat_of_av+3
5133  07fe a101          	cp	a,#1
5134  0800 2606          	jrne	L5652
5137  0802 72160002      	bset	_data_out+2,#3
5139  0806 2004          	jra	L7652
5140  0808               L5652:
5141                     ; 692 else data_out[2]&=~(1<<3);
5143  0808 72170002      	bres	_data_out+2,#3
5144  080c               L7652:
5145                     ; 694 if(ee_log_in_stat_of_av[4]==lisoaON)data_out[2]|=(1<<4);
5147  080c c6003b        	ld	a,_ee_log_in_stat_of_av+4
5148  080f a101          	cp	a,#1
5149  0811 2606          	jrne	L1752
5152  0813 72180002      	bset	_data_out+2,#4
5154  0817 2004          	jra	L3752
5155  0819               L1752:
5156                     ; 695 else data_out[2]&=~(1<<4);
5158  0819 72190002      	bres	_data_out+2,#4
5159  081d               L3752:
5160                     ; 697 if(ee_log_in_stat_of_av[5]==lisoaON)data_out[2]|=(1<<5);
5162  081d c6003c        	ld	a,_ee_log_in_stat_of_av+5
5163  0820 a101          	cp	a,#1
5164  0822 2606          	jrne	L5752
5167  0824 721a0002      	bset	_data_out+2,#5
5169  0828 2004          	jra	L7752
5170  082a               L5752:
5171                     ; 698 else data_out[2]&=~(1<<5);
5173  082a 721b0002      	bres	_data_out+2,#5
5174  082e               L7752:
5175                     ; 704 if(log_in_av_stat[0]==liasON)data_out[3]|=(1<<0);
5177  082e c600d3        	ld	a,_log_in_av_stat
5178  0831 a101          	cp	a,#1
5179  0833 2606          	jrne	L1062
5182  0835 72100003      	bset	_data_out+3,#0
5184  0839 2004          	jra	L3062
5185  083b               L1062:
5186                     ; 705 else data_out[3]&=~(1<<0);
5188  083b 72110003      	bres	_data_out+3,#0
5189  083f               L3062:
5190                     ; 707 if(log_in_av_stat[1]==liasON)data_out[3]|=(1<<1);
5192  083f c600d4        	ld	a,_log_in_av_stat+1
5193  0842 a101          	cp	a,#1
5194  0844 2606          	jrne	L5062
5197  0846 72120003      	bset	_data_out+3,#1
5199  084a 2004          	jra	L7062
5200  084c               L5062:
5201                     ; 708 else data_out[3]&=~(1<<1);
5203  084c 72130003      	bres	_data_out+3,#1
5204  0850               L7062:
5205                     ; 710 if(log_in_av_stat[2]==liasON)data_out[3]|=(1<<2);
5207  0850 c600d5        	ld	a,_log_in_av_stat+2
5208  0853 a101          	cp	a,#1
5209  0855 2606          	jrne	L1162
5212  0857 72140003      	bset	_data_out+3,#2
5214  085b 2004          	jra	L3162
5215  085d               L1162:
5216                     ; 711 else data_out[3]&=~(1<<2);
5218  085d 72150003      	bres	_data_out+3,#2
5219  0861               L3162:
5220                     ; 713 if(log_in_av_stat[3]==liasON)data_out[3]|=(1<<3);
5222  0861 c600d6        	ld	a,_log_in_av_stat+3
5223  0864 a101          	cp	a,#1
5224  0866 2606          	jrne	L5162
5227  0868 72160003      	bset	_data_out+3,#3
5229  086c 2004          	jra	L7162
5230  086e               L5162:
5231                     ; 714 else data_out[3]&=~(1<<3);
5233  086e 72170003      	bres	_data_out+3,#3
5234  0872               L7162:
5235                     ; 716 if(log_in_av_stat[4]==liasON)data_out[3]|=(1<<4);
5237  0872 c600d7        	ld	a,_log_in_av_stat+4
5238  0875 a101          	cp	a,#1
5239  0877 2606          	jrne	L1262
5242  0879 72180003      	bset	_data_out+3,#4
5244  087d 2004          	jra	L3262
5245  087f               L1262:
5246                     ; 717 else data_out[3]&=~(1<<4);
5248  087f 72190003      	bres	_data_out+3,#4
5249  0883               L3262:
5250                     ; 719 if(log_in_av_stat[5]==liasON)data_out[3]|=(1<<5);
5252  0883 c600d8        	ld	a,_log_in_av_stat+5
5253  0886 a101          	cp	a,#1
5254  0888 2606          	jrne	L5262
5257  088a 721a0003      	bset	_data_out+3,#5
5259  088e 2004          	jra	L7262
5260  0890               L5262:
5261                     ; 720 else data_out[3]&=~(1<<5);
5263  0890 721b0003      	bres	_data_out+3,#5
5264  0894               L7262:
5265                     ; 723 if(ee_log_in_trap_send_av[0]==litsON)data_out[4]|=(1<<0);
5267  0894 c6002f        	ld	a,_ee_log_in_trap_send_av
5268  0897 a101          	cp	a,#1
5269  0899 2606          	jrne	L1362
5272  089b 72100004      	bset	_data_out+4,#0
5274  089f 2004          	jra	L3362
5275  08a1               L1362:
5276                     ; 724 else data_out[4]&=~(1<<0);
5278  08a1 72110004      	bres	_data_out+4,#0
5279  08a5               L3362:
5280                     ; 726 if(ee_log_in_trap_send_av[1]==litsON)data_out[4]|=(1<<1);
5282  08a5 c60030        	ld	a,_ee_log_in_trap_send_av+1
5283  08a8 a101          	cp	a,#1
5284  08aa 2606          	jrne	L5362
5287  08ac 72120004      	bset	_data_out+4,#1
5289  08b0 2004          	jra	L7362
5290  08b2               L5362:
5291                     ; 727 else data_out[4]&=~(1<<1);
5293  08b2 72130004      	bres	_data_out+4,#1
5294  08b6               L7362:
5295                     ; 729 if(ee_log_in_trap_send_av[2]==litsON)data_out[4]|=(1<<2);
5297  08b6 c60031        	ld	a,_ee_log_in_trap_send_av+2
5298  08b9 a101          	cp	a,#1
5299  08bb 2606          	jrne	L1462
5302  08bd 72140004      	bset	_data_out+4,#2
5304  08c1 2004          	jra	L3462
5305  08c3               L1462:
5306                     ; 730 else data_out[4]&=~(1<<2);
5308  08c3 72150004      	bres	_data_out+4,#2
5309  08c7               L3462:
5310                     ; 732 if(ee_log_in_trap_send_av[3]==litsON)data_out[4]|=(1<<3);
5312  08c7 c60032        	ld	a,_ee_log_in_trap_send_av+3
5313  08ca a101          	cp	a,#1
5314  08cc 2606          	jrne	L5462
5317  08ce 72160004      	bset	_data_out+4,#3
5319  08d2 2004          	jra	L7462
5320  08d4               L5462:
5321                     ; 733 else data_out[4]&=~(1<<3);
5323  08d4 72170004      	bres	_data_out+4,#3
5324  08d8               L7462:
5325                     ; 735 if(ee_log_in_trap_send_av[4]==litsON)data_out[4]|=(1<<4);
5327  08d8 c60033        	ld	a,_ee_log_in_trap_send_av+4
5328  08db a101          	cp	a,#1
5329  08dd 2606          	jrne	L1562
5332  08df 72180004      	bset	_data_out+4,#4
5334  08e3 2004          	jra	L3562
5335  08e5               L1562:
5336                     ; 736 else data_out[4]&=~(1<<4);
5338  08e5 72190004      	bres	_data_out+4,#4
5339  08e9               L3562:
5340                     ; 738 if(ee_log_in_trap_send_av[5]==litsON)data_out[4]|=(1<<5);
5342  08e9 c60034        	ld	a,_ee_log_in_trap_send_av+5
5343  08ec a101          	cp	a,#1
5344  08ee 2606          	jrne	L5562
5347  08f0 721a0004      	bset	_data_out+4,#5
5349  08f4 2004          	jra	L7562
5350  08f6               L5562:
5351                     ; 739 else data_out[4]&=~(1<<5);
5353  08f6 721b0004      	bres	_data_out+4,#5
5354  08fa               L7562:
5355                     ; 741 if(ee_log_in_trap_send_av[6]==litsON)data_out[4]|=(1<<6);
5357  08fa c60035        	ld	a,_ee_log_in_trap_send_av+6
5358  08fd a101          	cp	a,#1
5359  08ff 2606          	jrne	L1662
5362  0901 721c0004      	bset	_data_out+4,#6
5364  0905 2004          	jra	L3662
5365  0907               L1662:
5366                     ; 742 else data_out[4]&=~(1<<6);
5368  0907 721d0004      	bres	_data_out+4,#6
5369  090b               L3662:
5370                     ; 745 if(ee_log_in_trap_send_no_av[0]==litsON)data_out[5]|=(1<<0);
5372  090b c60027        	ld	a,_ee_log_in_trap_send_no_av
5373  090e a101          	cp	a,#1
5374  0910 2606          	jrne	L5662
5377  0912 72100005      	bset	_data_out+5,#0
5379  0916 2004          	jra	L7662
5380  0918               L5662:
5381                     ; 746 else data_out[5]&=~(1<<0);
5383  0918 72110005      	bres	_data_out+5,#0
5384  091c               L7662:
5385                     ; 748 if(ee_log_in_trap_send_no_av[1]==litsON)data_out[5]|=(1<<1);
5387  091c c60028        	ld	a,_ee_log_in_trap_send_no_av+1
5388  091f a101          	cp	a,#1
5389  0921 2606          	jrne	L1762
5392  0923 72120005      	bset	_data_out+5,#1
5394  0927 2004          	jra	L3762
5395  0929               L1762:
5396                     ; 749 else data_out[5]&=~(1<<1);
5398  0929 72130005      	bres	_data_out+5,#1
5399  092d               L3762:
5400                     ; 751 if(ee_log_in_trap_send_no_av[2]==litsON)data_out[5]|=(1<<2);
5402  092d c60029        	ld	a,_ee_log_in_trap_send_no_av+2
5403  0930 a101          	cp	a,#1
5404  0932 2606          	jrne	L5762
5407  0934 72140005      	bset	_data_out+5,#2
5409  0938 2004          	jra	L7762
5410  093a               L5762:
5411                     ; 752 else data_out[5]&=~(1<<2);
5413  093a 72150005      	bres	_data_out+5,#2
5414  093e               L7762:
5415                     ; 754 if(ee_log_in_trap_send_no_av[3]==litsON)data_out[5]|=(1<<3);
5417  093e c6002a        	ld	a,_ee_log_in_trap_send_no_av+3
5418  0941 a101          	cp	a,#1
5419  0943 2606          	jrne	L1072
5422  0945 72160005      	bset	_data_out+5,#3
5424  0949 2004          	jra	L3072
5425  094b               L1072:
5426                     ; 755 else data_out[5]&=~(1<<3);
5428  094b 72170005      	bres	_data_out+5,#3
5429  094f               L3072:
5430                     ; 757 if(ee_log_in_trap_send_no_av[4]==litsON)data_out[5]|=(1<<4);
5432  094f c6002b        	ld	a,_ee_log_in_trap_send_no_av+4
5433  0952 a101          	cp	a,#1
5434  0954 2606          	jrne	L5072
5437  0956 72180005      	bset	_data_out+5,#4
5439  095a 2004          	jra	L7072
5440  095c               L5072:
5441                     ; 758 else data_out[5]&=~(1<<4);
5443  095c 72190005      	bres	_data_out+5,#4
5444  0960               L7072:
5445                     ; 760 if(ee_log_in_trap_send_no_av[5]==litsON)data_out[5]|=(1<<5);
5447  0960 c6002c        	ld	a,_ee_log_in_trap_send_no_av+5
5448  0963 a101          	cp	a,#1
5449  0965 2606          	jrne	L1172
5452  0967 721a0005      	bset	_data_out+5,#5
5454  096b 2004          	jra	L3172
5455  096d               L1172:
5456                     ; 761 else data_out[5]&=~(1<<5);
5458  096d 721b0005      	bres	_data_out+5,#5
5459  0971               L3172:
5460                     ; 763 if(ee_log_in_trap_send_no_av[6]==litsON)data_out[5]|=(1<<6);
5462  0971 c6002d        	ld	a,_ee_log_in_trap_send_no_av+6
5463  0974 a101          	cp	a,#1
5464  0976 2606          	jrne	L5172
5467  0978 721c0005      	bset	_data_out+5,#6
5469  097c 2004          	jra	L7172
5470  097e               L5172:
5471                     ; 764 else data_out[5]&=~(1<<6);
5473  097e 721d0005      	bres	_data_out+5,#6
5474  0982               L7172:
5475                     ; 769 data_out[6]=(char)(ee_power_cnt_adr);
5477  0982 5500260006    	mov	_data_out+6,_ee_power_cnt_adr+1
5478                     ; 770 data_out[7]=(char)(ee_power_cnt_adr>>8);
5480  0987 5500250007    	mov	_data_out+7,_ee_power_cnt_adr
5481                     ; 773 data_out[8]=(char)(power_summary);
5483  098c 5500710008    	mov	_data_out+8,_power_summary+3
5484                     ; 774 data_out[9]=(char)(power_summary>>8);
5486  0991 5500700009    	mov	_data_out+9,_power_summary+2
5487                     ; 775 data_out[10]=(char)(power_summary>>16);
5489  0996 55006f000a    	mov	_data_out+10,_power_summary+1
5490                     ; 776 data_out[11]=(char)(power_summary>>24);
5492  099b 55006e000b    	mov	_data_out+11,_power_summary
5493                     ; 779 data_out[12]=(char)(power_current);
5495  09a0 550073000c    	mov	_data_out+12,_power_current+1
5496                     ; 780 data_out[13]=(char)(power_current>>8);
5498  09a5 550072000d    	mov	_data_out+13,_power_current
5499                     ; 782 data_out[14]=adc_plazma;//adc_buff_[0]>>4;
5501  09aa 5500aa000e    	mov	_data_out+14,_adc_plazma
5502                     ; 783 data_out[15]=(char)adc_buff_[0]>>2;
5504  09af c60065        	ld	a,_adc_buff_+1
5505  09b2 44            	srl	a
5506  09b3 44            	srl	a
5507  09b4 c7000f        	ld	_data_out+15,a
5508                     ; 785 data_out[16]=(char)(adc_plazma_short);
5510  09b7 5500630010    	mov	_data_out+16,_adc_plazma_short+1
5511                     ; 786 data_out[17]=(char)(adc_plazma_short>>8);
5513  09bc 5500620011    	mov	_data_out+17,_adc_plazma_short
5514                     ; 789 data_out[18]=(char)(power_summary_impuls_cnt);
5516  09c1 5500480012    	mov	_data_out+18,_power_summary_impuls_cnt+3
5517                     ; 790 data_out[19]=(char)(power_summary_impuls_cnt>>8);
5519  09c6 5500470013    	mov	_data_out+19,_power_summary_impuls_cnt+2
5520                     ; 791 data_out[20]=(char)(power_summary_impuls_cnt>>16);
5522  09cb 5500460014    	mov	_data_out+20,_power_summary_impuls_cnt+1
5523                     ; 792 data_out[21]=(char)(power_summary_impuls_cnt>>24);
5525  09d0 5500450015    	mov	_data_out+21,_power_summary_impuls_cnt
5526                     ; 794 data_out[22]=(char)(ee_impuls_per_kwatt);
5528  09d5 5500010016    	mov	_data_out+22,_ee_impuls_per_kwatt+1
5529                     ; 795 data_out[23]=(char)(ee_impuls_per_kwatt>>8);
5531  09da 5500000017    	mov	_data_out+23,_ee_impuls_per_kwatt
5532                     ; 797 data_out[24]=(char)(power_summary_impuls);
5534  09df 5500440018    	mov	_data_out+24,_power_summary_impuls+3
5535                     ; 798 data_out[25]=(char)(power_summary_impuls>>8);
5537  09e4 5500430019    	mov	_data_out+25,_power_summary_impuls+2
5538                     ; 799 data_out[26]=(char)(power_summary_impuls>>16);
5540  09e9 550042001a    	mov	_data_out+26,_power_summary_impuls+1
5541                     ; 800 data_out[27]=(char)(power_summary_impuls>>24);
5543  09ee 550041001b    	mov	_data_out+27,_power_summary_impuls
5544                     ; 803 data_out[28]=(char)(__serial);
5546  09f3 558103001c    	mov	_data_out+28,___serial+3
5547                     ; 804 data_out[29]=(char)(__serial>>8);
5549  09f8 558102001d    	mov	_data_out+29,___serial+2
5550                     ; 805 data_out[30]=(char)(__serial>>16);
5552  09fd 558101001e    	mov	_data_out+30,___serial+1
5553                     ; 806 data_out[31]=(char)(__serial>>24);
5555  0a02 558100001f    	mov	_data_out+31,___serial
5556                     ; 809 data_out[32]=(char)(ee_reset_cnt);
5558  0a07 5500240020    	mov	_data_out+32,_ee_reset_cnt+1
5559                     ; 810 data_out[33]=(char)(ee_reset_cnt>>8);
5561  0a0c 5500230021    	mov	_data_out+33,_ee_reset_cnt
5562                     ; 814 data_out[34]=(char)(T1);
5564  0a11 5500610022    	mov	_data_out+34,_T1+1
5565                     ; 815 data_out[35]=(char)(T1>>8);
5567  0a16 5500600023    	mov	_data_out+35,_T1
5568                     ; 820 data_out[36]=(char)(ee_T1_porog1);
5570  0a1b 55001e0024    	mov	_data_out+36,_ee_T1_porog1+1
5571                     ; 821 data_out[37]=(char)(ee_T1_porog1>>8);
5573  0a20 55001d0025    	mov	_data_out+37,_ee_T1_porog1
5574                     ; 822 data_out[38]=(char)(ee_T1_porog2);
5576  0a25 55001c0026    	mov	_data_out+38,_ee_T1_porog2+1
5577                     ; 823 data_out[39]=(char)(ee_T1_porog2>>8);
5579  0a2a 55001b0027    	mov	_data_out+39,_ee_T1_porog2
5580                     ; 825 data_out[40]=ee_T1_logic1&0x03;
5582  0a2f c60016        	ld	a,_ee_T1_logic1
5583  0a32 a403          	and	a,#3
5584  0a34 c70028        	ld	_data_out+40,a
5585                     ; 826 data_out[40]+=(ee_T1_logic2&0x03)<<2;
5587  0a37 c60015        	ld	a,_ee_T1_logic2
5588  0a3a a403          	and	a,#3
5589  0a3c 48            	sll	a
5590  0a3d 48            	sll	a
5591  0a3e cb0028        	add	a,_data_out+40
5592  0a41 c70028        	ld	_data_out+40,a
5593                     ; 828 data_out[40]+=(ee_T1_trap_send_av_1&0x01)<<4;
5595  0a44 c60012        	ld	a,_ee_T1_trap_send_av_1
5596  0a47 a401          	and	a,#1
5597  0a49 97            	ld	xl,a
5598  0a4a a610          	ld	a,#16
5599  0a4c 42            	mul	x,a
5600  0a4d 9f            	ld	a,xl
5601  0a4e cb0028        	add	a,_data_out+40
5602  0a51 c70028        	ld	_data_out+40,a
5603                     ; 829 data_out[40]+=(ee_T1_trap_send_no_av_1&0x01)<<5;
5605  0a54 c60011        	ld	a,_ee_T1_trap_send_no_av_1
5606  0a57 a401          	and	a,#1
5607  0a59 97            	ld	xl,a
5608  0a5a a620          	ld	a,#32
5609  0a5c 42            	mul	x,a
5610  0a5d 9f            	ld	a,xl
5611  0a5e cb0028        	add	a,_data_out+40
5612  0a61 c70028        	ld	_data_out+40,a
5613                     ; 830 data_out[40]+=(ee_T1_trap_send_av_2&0x01)<<6;
5615  0a64 c60010        	ld	a,_ee_T1_trap_send_av_2
5616  0a67 a401          	and	a,#1
5617  0a69 97            	ld	xl,a
5618  0a6a a640          	ld	a,#64
5619  0a6c 42            	mul	x,a
5620  0a6d 9f            	ld	a,xl
5621  0a6e cb0028        	add	a,_data_out+40
5622  0a71 c70028        	ld	_data_out+40,a
5623                     ; 831 data_out[40]+=(ee_T1_trap_send_no_av_2&0x01)<<7;
5625  0a74 c6000f        	ld	a,_ee_T1_trap_send_no_av_2
5626  0a77 a401          	and	a,#1
5627  0a79 97            	ld	xl,a
5628  0a7a a680          	ld	a,#128
5629  0a7c 42            	mul	x,a
5630  0a7d 9f            	ld	a,xl
5631  0a7e cb0028        	add	a,_data_out+40
5632  0a81 c70028        	ld	_data_out+40,a
5633                     ; 833 data_out[41]=T1_status1&0x01;
5635  0a84 c6005d        	ld	a,_T1_status1
5636  0a87 a401          	and	a,#1
5637  0a89 c70029        	ld	_data_out+41,a
5638                     ; 834 data_out[41]+=(T1_status2&0x01)<<1;
5640  0a8c c6005c        	ld	a,_T1_status2
5641  0a8f a401          	and	a,#1
5642  0a91 48            	sll	a
5643  0a92 cb0029        	add	a,_data_out+41
5644  0a95 c70029        	ld	_data_out+41,a
5645                     ; 835 data_out[41]+=(T2_status1&0x01)<<2;
5647  0a98 c60059        	ld	a,_T2_status1
5648  0a9b a401          	and	a,#1
5649  0a9d 48            	sll	a
5650  0a9e 48            	sll	a
5651  0a9f cb0029        	add	a,_data_out+41
5652  0aa2 c70029        	ld	_data_out+41,a
5653                     ; 836 data_out[41]+=(T2_status2&0x01)<<3;
5655  0aa5 c60058        	ld	a,_T2_status2
5656  0aa8 a401          	and	a,#1
5657  0aaa 48            	sll	a
5658  0aab 48            	sll	a
5659  0aac 48            	sll	a
5660  0aad cb0029        	add	a,_data_out+41
5661  0ab0 c70029        	ld	_data_out+41,a
5662                     ; 839 data_out[42]=(char)(H1);
5664  0ab3 55004d002a    	mov	_data_out+42,_H1+1
5665                     ; 840 data_out[43]=(char)(H1>>8);
5667  0ab8 55004c002b    	mov	_data_out+43,_H1
5668                     ; 844 data_out[44]=(char)(ee_H1_porog);
5670  0abd 55000a002c    	mov	_data_out+44,_ee_H1_porog+1
5671                     ; 845 data_out[45]=(char)(ee_H1_porog>>8);
5673  0ac2 550009002d    	mov	_data_out+45,_ee_H1_porog
5674                     ; 849 data_out[46]=ee_H1_logic&0x03;
5676  0ac7 c60006        	ld	a,_ee_H1_logic
5677  0aca a403          	and	a,#3
5678  0acc c7002e        	ld	_data_out+46,a
5679                     ; 851 data_out[46]+=(ee_hummidity_trap_send_av&0x01)<<2;
5681  0acf c60008        	ld	a,_ee_hummidity_trap_send_av
5682  0ad2 a401          	and	a,#1
5683  0ad4 48            	sll	a
5684  0ad5 48            	sll	a
5685  0ad6 cb002e        	add	a,_data_out+46
5686  0ad9 c7002e        	ld	_data_out+46,a
5687                     ; 852 data_out[46]+=(ee_hummidity_trap_send_no_av&0x01)<<3;
5689  0adc c60007        	ld	a,_ee_hummidity_trap_send_no_av
5690  0adf a401          	and	a,#1
5691  0ae1 48            	sll	a
5692  0ae2 48            	sll	a
5693  0ae3 48            	sll	a
5694  0ae4 cb002e        	add	a,_data_out+46
5695  0ae7 c7002e        	ld	_data_out+46,a
5696                     ; 854 data_out[46]+=(hummidity_alarm_stat&0x01)<<4;
5698  0aea c6004a        	ld	a,_hummidity_alarm_stat
5699  0aed a401          	and	a,#1
5700  0aef 97            	ld	xl,a
5701  0af0 a610          	ld	a,#16
5702  0af2 42            	mul	x,a
5703  0af3 9f            	ld	a,xl
5704  0af4 cb002e        	add	a,_data_out+46
5705  0af7 c7002e        	ld	_data_out+46,a
5706                     ; 858 data_out[47]=(char)(T2);
5708  0afa 55005f002f    	mov	_data_out+47,_T2+1
5709                     ; 859 data_out[48]=(char)(T2>>8);
5711  0aff 55005e0030    	mov	_data_out+48,_T2
5712                     ; 864 data_out[49]=(char)(ee_T2_porog1);
5714  0b04 55001a0031    	mov	_data_out+49,_ee_T2_porog1+1
5715                     ; 865 data_out[50]=(char)(ee_T2_porog1>>8);
5717  0b09 5500190032    	mov	_data_out+50,_ee_T2_porog1
5718                     ; 866 data_out[51]=(char)(ee_T2_porog2);
5720  0b0e 5500180033    	mov	_data_out+51,_ee_T2_porog2+1
5721                     ; 867 data_out[52]=(char)(ee_T2_porog2>>8);
5723  0b13 5500170034    	mov	_data_out+52,_ee_T2_porog2
5724                     ; 870 data_out[53]=ee_T2_logic1&0x03;
5726  0b18 c60014        	ld	a,_ee_T2_logic1
5727  0b1b a403          	and	a,#3
5728  0b1d c70035        	ld	_data_out+53,a
5729                     ; 871 data_out[53]+=(ee_T2_logic2&0x03)<<2;
5731  0b20 c60013        	ld	a,_ee_T2_logic2
5732  0b23 a403          	and	a,#3
5733  0b25 48            	sll	a
5734  0b26 48            	sll	a
5735  0b27 cb0035        	add	a,_data_out+53
5736  0b2a c70035        	ld	_data_out+53,a
5737                     ; 873 data_out[53]+=(ee_T2_trap_send_av_1&0x01)<<4;
5739  0b2d c6000e        	ld	a,_ee_T2_trap_send_av_1
5740  0b30 a401          	and	a,#1
5741  0b32 97            	ld	xl,a
5742  0b33 a610          	ld	a,#16
5743  0b35 42            	mul	x,a
5744  0b36 9f            	ld	a,xl
5745  0b37 cb0035        	add	a,_data_out+53
5746  0b3a c70035        	ld	_data_out+53,a
5747                     ; 874 data_out[53]+=(ee_T2_trap_send_no_av_1&0x01)<<5;
5749  0b3d c6000d        	ld	a,_ee_T2_trap_send_no_av_1
5750  0b40 a401          	and	a,#1
5751  0b42 97            	ld	xl,a
5752  0b43 a620          	ld	a,#32
5753  0b45 42            	mul	x,a
5754  0b46 9f            	ld	a,xl
5755  0b47 cb0035        	add	a,_data_out+53
5756  0b4a c70035        	ld	_data_out+53,a
5757                     ; 875 data_out[53]+=(ee_T2_trap_send_av_2&0x01)<<6;
5759  0b4d c6000c        	ld	a,_ee_T2_trap_send_av_2
5760  0b50 a401          	and	a,#1
5761  0b52 97            	ld	xl,a
5762  0b53 a640          	ld	a,#64
5763  0b55 42            	mul	x,a
5764  0b56 9f            	ld	a,xl
5765  0b57 cb0035        	add	a,_data_out+53
5766  0b5a c70035        	ld	_data_out+53,a
5767                     ; 876 data_out[53]+=(ee_T2_trap_send_no_av_2&0x01)<<7;
5769  0b5d c6000b        	ld	a,_ee_T2_trap_send_no_av_2
5770  0b60 a401          	and	a,#1
5771  0b62 97            	ld	xl,a
5772  0b63 a680          	ld	a,#128
5773  0b65 42            	mul	x,a
5774  0b66 9f            	ld	a,xl
5775  0b67 cb0035        	add	a,_data_out+53
5776  0b6a c70035        	ld	_data_out+53,a
5777                     ; 888 }
5780  0b6d 87            	retf
5823                     ; 891 void trap_send(char par1,short par2)
5823                     ; 892 {
5824                     	switch	.text
5825  0b6e               f_trap_send:
5827  0b6e 88            	push	a
5828       00000000      OFST:	set	0
5831                     ; 901 puart_out (4,100,par1,(char)par2,(char)(par2>>8),0,0);
5833  0b6f 4b00          	push	#0
5834  0b71 4b00          	push	#0
5835  0b73 7b07          	ld	a,(OFST+7,sp)
5836  0b75 88            	push	a
5837  0b76 7b09          	ld	a,(OFST+9,sp)
5838  0b78 88            	push	a
5839  0b79 7b05          	ld	a,(OFST+5,sp)
5840  0b7b 88            	push	a
5841  0b7c ae0064        	ldw	x,#100
5842  0b7f a604          	ld	a,#4
5843  0b81 95            	ld	xh,a
5844  0b82 8d000000      	callf	f_puart_out
5846  0b86 5b05          	addw	sp,#5
5847                     ; 902 }
5850  0b88 84            	pop	a
5851  0b89 87            	retf
5883                     ; 906 void hummidity_drv(void)
5883                     ; 907 {
5884                     	switch	.text
5885  0b8a               f_hummidity_drv:
5889                     ; 911 if(ee_H1_logic==hlOFF)
5891  0b8a 725d0006      	tnz	_ee_H1_logic
5892  0b8e 260a          	jrne	L3572
5893                     ; 913 	hummidity_alarm_stat=hasOFF;
5895  0b90 725f004a      	clr	_hummidity_alarm_stat
5896                     ; 914 	hummidity_alarm_cnt=0;
5898  0b94 725f004b      	clr	_hummidity_alarm_cnt
5900  0b98 2054          	jra	L5572
5901  0b9a               L3572:
5902                     ; 916 else if(ee_H1_logic==hlNT)
5904  0b9a c60006        	ld	a,_ee_H1_logic
5905  0b9d a101          	cp	a,#1
5906  0b9f 2624          	jrne	L7572
5907                     ; 918 	if(H1>(ee_H1_porog+3))hummidity_alarm_cnt++;
5909  0ba1 9c            	rvf
5910  0ba2 ce0009        	ldw	x,_ee_H1_porog
5911  0ba5 1c0003        	addw	x,#3
5912  0ba8 c3004c        	cpw	x,_H1
5913  0bab 2e06          	jrsge	L1672
5916  0bad 725c004b      	inc	_hummidity_alarm_cnt
5918  0bb1 203b          	jra	L5572
5919  0bb3               L1672:
5920                     ; 919 	else if(H1<(ee_H1_porog-3))hummidity_alarm_cnt--;
5922  0bb3 9c            	rvf
5923  0bb4 ce0009        	ldw	x,_ee_H1_porog
5924  0bb7 1d0003        	subw	x,#3
5925  0bba c3004c        	cpw	x,_H1
5926  0bbd 2d2f          	jrsle	L5572
5929  0bbf 725a004b      	dec	_hummidity_alarm_cnt
5930  0bc3 2029          	jra	L5572
5931  0bc5               L7572:
5932                     ; 921 else if(ee_H1_logic==hlNB)
5934  0bc5 c60006        	ld	a,_ee_H1_logic
5935  0bc8 a102          	cp	a,#2
5936  0bca 2622          	jrne	L5572
5937                     ; 923 	if(H1>(ee_H1_porog+3))hummidity_alarm_cnt--;
5939  0bcc 9c            	rvf
5940  0bcd ce0009        	ldw	x,_ee_H1_porog
5941  0bd0 1c0003        	addw	x,#3
5942  0bd3 c3004c        	cpw	x,_H1
5943  0bd6 2e06          	jrsge	L3772
5946  0bd8 725a004b      	dec	_hummidity_alarm_cnt
5948  0bdc 2010          	jra	L5572
5949  0bde               L3772:
5950                     ; 924 	else if(H1<(ee_H1_porog-3))hummidity_alarm_cnt++;
5952  0bde 9c            	rvf
5953  0bdf ce0009        	ldw	x,_ee_H1_porog
5954  0be2 1d0003        	subw	x,#3
5955  0be5 c3004c        	cpw	x,_H1
5956  0be8 2d04          	jrsle	L5572
5959  0bea 725c004b      	inc	_hummidity_alarm_cnt
5960  0bee               L5572:
5961                     ; 935 gran_char(&hummidity_alarm_cnt,-30,30);
5963  0bee 4b1e          	push	#30
5964  0bf0 4be2          	push	#226
5965  0bf2 ae004b        	ldw	x,#_hummidity_alarm_cnt
5966  0bf5 8d000000      	callf	f_gran_char
5968  0bf9 85            	popw	x
5969                     ; 936 if(hummidity_alarm_cnt<-28)hummidity_alarm_stat=hasOFF;
5971  0bfa 9c            	rvf
5972  0bfb c6004b        	ld	a,_hummidity_alarm_cnt
5973  0bfe a1e4          	cp	a,#228
5974  0c00 2e06          	jrsge	L1003
5977  0c02 725f004a      	clr	_hummidity_alarm_stat
5979  0c06 200c          	jra	L3003
5980  0c08               L1003:
5981                     ; 937 else if (hummidity_alarm_cnt>28)hummidity_alarm_stat=hasON;
5983  0c08 9c            	rvf
5984  0c09 c6004b        	ld	a,_hummidity_alarm_cnt
5985  0c0c a11d          	cp	a,#29
5986  0c0e 2f04          	jrslt	L3003
5989  0c10 3501004a      	mov	_hummidity_alarm_stat,#1
5990  0c14               L3003:
5991                     ; 940 if(hummidity_alarm_stat_old!=hummidity_alarm_stat)
5993  0c14 c60049        	ld	a,_hummidity_alarm_stat_old
5994  0c17 c1004a        	cp	a,_hummidity_alarm_stat
5995  0c1a 2733          	jreq	L7003
5996                     ; 942 	if((hummidity_alarm_stat==hasON) && (ee_hummidity_trap_send_av==htsON)) trap_send((4<<5)+(1<<2)+1,H1);
5998  0c1c c6004a        	ld	a,_hummidity_alarm_stat
5999  0c1f a101          	cp	a,#1
6000  0c21 2614          	jrne	L1103
6002  0c23 c60008        	ld	a,_ee_hummidity_trap_send_av
6003  0c26 a101          	cp	a,#1
6004  0c28 260d          	jrne	L1103
6007  0c2a ce004c        	ldw	x,_H1
6008  0c2d 89            	pushw	x
6009  0c2e a685          	ld	a,#133
6010  0c30 8d6e0b6e      	callf	f_trap_send
6012  0c34 85            	popw	x
6014  0c35 2018          	jra	L7003
6015  0c37               L1103:
6016                     ; 943 	else if((hummidity_alarm_stat==hasOFF) && (ee_hummidity_trap_send_no_av==htsON))trap_send((4<<5)+(1<<2)+0,H1);
6018  0c37 725d004a      	tnz	_hummidity_alarm_stat
6019  0c3b 2612          	jrne	L7003
6021  0c3d c60007        	ld	a,_ee_hummidity_trap_send_no_av
6022  0c40 a101          	cp	a,#1
6023  0c42 260b          	jrne	L7003
6026  0c44 ce004c        	ldw	x,_H1
6027  0c47 89            	pushw	x
6028  0c48 a684          	ld	a,#132
6029  0c4a 8d6e0b6e      	callf	f_trap_send
6031  0c4e 85            	popw	x
6032  0c4f               L7003:
6033                     ; 946 hummidity_alarm_stat_old=hummidity_alarm_stat;
6035  0c4f 55004a0049    	mov	_hummidity_alarm_stat_old,_hummidity_alarm_stat
6036                     ; 948 }
6039  0c54 87            	retf
6092                     ; 953 void temper_drv(void)
6092                     ; 954 {
6093                     	switch	.text
6094  0c55               f_temper_drv:
6098                     ; 957 if(ee_T1_logic1==tlOFF)
6100  0c55 725d0016      	tnz	_ee_T1_logic1
6101  0c59 260a          	jrne	L7203
6102                     ; 959 	T1_status1=0;
6104  0c5b 725f005d      	clr	_T1_status1
6105                     ; 960 	T1_porog1_cnt=0;
6107  0c5f 5f            	clrw	x
6108  0c60 cf0054        	ldw	_T1_porog1_cnt,x
6110  0c63 2060          	jra	L1303
6111  0c65               L7203:
6112                     ; 962 else if(ee_T1_logic1==tlNW)
6114  0c65 c60016        	ld	a,_ee_T1_logic1
6115  0c68 a101          	cp	a,#1
6116  0c6a 262a          	jrne	L3303
6117                     ; 964 	if(T1>(ee_T1_porog1+1))T1_porog1_cnt++;
6119  0c6c 9c            	rvf
6120  0c6d ce001d        	ldw	x,_ee_T1_porog1
6121  0c70 5c            	incw	x
6122  0c71 c30060        	cpw	x,_T1
6123  0c74 2e0b          	jrsge	L5303
6126  0c76 ce0054        	ldw	x,_T1_porog1_cnt
6127  0c79 1c0001        	addw	x,#1
6128  0c7c cf0054        	ldw	_T1_porog1_cnt,x
6130  0c7f 2044          	jra	L1303
6131  0c81               L5303:
6132                     ; 965 	else if(T1<(ee_T1_porog1-1))T1_porog1_cnt--;
6134  0c81 9c            	rvf
6135  0c82 ce001d        	ldw	x,_ee_T1_porog1
6136  0c85 5a            	decw	x
6137  0c86 c30060        	cpw	x,_T1
6138  0c89 2d3a          	jrsle	L1303
6141  0c8b ce0054        	ldw	x,_T1_porog1_cnt
6142  0c8e 1d0001        	subw	x,#1
6143  0c91 cf0054        	ldw	_T1_porog1_cnt,x
6144  0c94 202f          	jra	L1303
6145  0c96               L3303:
6146                     ; 967 else if(ee_T1_logic1==tlNC)
6148  0c96 c60016        	ld	a,_ee_T1_logic1
6149  0c99 a102          	cp	a,#2
6150  0c9b 2628          	jrne	L1303
6151                     ; 969 	if(T1>(ee_T1_porog1+1))T1_porog1_cnt--;
6153  0c9d 9c            	rvf
6154  0c9e ce001d        	ldw	x,_ee_T1_porog1
6155  0ca1 5c            	incw	x
6156  0ca2 c30060        	cpw	x,_T1
6157  0ca5 2e0b          	jrsge	L7403
6160  0ca7 ce0054        	ldw	x,_T1_porog1_cnt
6161  0caa 1d0001        	subw	x,#1
6162  0cad cf0054        	ldw	_T1_porog1_cnt,x
6164  0cb0 2013          	jra	L1303
6165  0cb2               L7403:
6166                     ; 970 	else if(T1<(ee_T1_porog1-1))T1_porog1_cnt++;
6168  0cb2 9c            	rvf
6169  0cb3 ce001d        	ldw	x,_ee_T1_porog1
6170  0cb6 5a            	decw	x
6171  0cb7 c30060        	cpw	x,_T1
6172  0cba 2d09          	jrsle	L1303
6175  0cbc ce0054        	ldw	x,_T1_porog1_cnt
6176  0cbf 1c0001        	addw	x,#1
6177  0cc2 cf0054        	ldw	_T1_porog1_cnt,x
6178  0cc5               L1303:
6179                     ; 972 if(T1_porog1_cnt>100)T1_porog1_cnt=100;
6181  0cc5 9c            	rvf
6182  0cc6 ce0054        	ldw	x,_T1_porog1_cnt
6183  0cc9 a30065        	cpw	x,#101
6184  0ccc 2f06          	jrslt	L5503
6187  0cce ae0064        	ldw	x,#100
6188  0cd1 cf0054        	ldw	_T1_porog1_cnt,x
6189  0cd4               L5503:
6190                     ; 973 if(T1_porog1_cnt<0)T1_porog1_cnt=0;
6192  0cd4 9c            	rvf
6193  0cd5 ce0054        	ldw	x,_T1_porog1_cnt
6194  0cd8 2e04          	jrsge	L7503
6197  0cda 5f            	clrw	x
6198  0cdb cf0054        	ldw	_T1_porog1_cnt,x
6199  0cde               L7503:
6200                     ; 975 if(T1_porog1_cnt>95)T1_status1=1;
6202  0cde 9c            	rvf
6203  0cdf ce0054        	ldw	x,_T1_porog1_cnt
6204  0ce2 a30060        	cpw	x,#96
6205  0ce5 2f04          	jrslt	L1603
6208  0ce7 3501005d      	mov	_T1_status1,#1
6209  0ceb               L1603:
6210                     ; 976 if(T1_porog1_cnt<5)T1_status1=0;
6212  0ceb 9c            	rvf
6213  0cec ce0054        	ldw	x,_T1_porog1_cnt
6214  0cef a30005        	cpw	x,#5
6215  0cf2 2e04          	jrsge	L3603
6218  0cf4 725f005d      	clr	_T1_status1
6219  0cf8               L3603:
6220                     ; 979 if(ee_T1_logic2==tlOFF)
6222  0cf8 725d0015      	tnz	_ee_T1_logic2
6223  0cfc 260a          	jrne	L5603
6224                     ; 981 	T1_status2=0;
6226  0cfe 725f005c      	clr	_T1_status2
6227                     ; 982 	T1_porog2_cnt=0;
6229  0d02 5f            	clrw	x
6230  0d03 cf0052        	ldw	_T1_porog2_cnt,x
6232  0d06 2060          	jra	L7603
6233  0d08               L5603:
6234                     ; 984 else if(ee_T1_logic2==tlNW)
6236  0d08 c60015        	ld	a,_ee_T1_logic2
6237  0d0b a101          	cp	a,#1
6238  0d0d 262a          	jrne	L1703
6239                     ; 986 	if(T1>(ee_T1_porog2+1))T1_porog2_cnt++;
6241  0d0f 9c            	rvf
6242  0d10 ce001b        	ldw	x,_ee_T1_porog2
6243  0d13 5c            	incw	x
6244  0d14 c30060        	cpw	x,_T1
6245  0d17 2e0b          	jrsge	L3703
6248  0d19 ce0052        	ldw	x,_T1_porog2_cnt
6249  0d1c 1c0001        	addw	x,#1
6250  0d1f cf0052        	ldw	_T1_porog2_cnt,x
6252  0d22 2044          	jra	L7603
6253  0d24               L3703:
6254                     ; 987 	else if(T1<(ee_T1_porog2-1))T1_porog2_cnt--;
6256  0d24 9c            	rvf
6257  0d25 ce001b        	ldw	x,_ee_T1_porog2
6258  0d28 5a            	decw	x
6259  0d29 c30060        	cpw	x,_T1
6260  0d2c 2d3a          	jrsle	L7603
6263  0d2e ce0052        	ldw	x,_T1_porog2_cnt
6264  0d31 1d0001        	subw	x,#1
6265  0d34 cf0052        	ldw	_T1_porog2_cnt,x
6266  0d37 202f          	jra	L7603
6267  0d39               L1703:
6268                     ; 989 else if(ee_T1_logic2==tlNC)
6270  0d39 c60015        	ld	a,_ee_T1_logic2
6271  0d3c a102          	cp	a,#2
6272  0d3e 2628          	jrne	L7603
6273                     ; 991 	if(T1>(ee_T1_porog2+1))T1_porog2_cnt--;
6275  0d40 9c            	rvf
6276  0d41 ce001b        	ldw	x,_ee_T1_porog2
6277  0d44 5c            	incw	x
6278  0d45 c30060        	cpw	x,_T1
6279  0d48 2e0b          	jrsge	L5013
6282  0d4a ce0052        	ldw	x,_T1_porog2_cnt
6283  0d4d 1d0001        	subw	x,#1
6284  0d50 cf0052        	ldw	_T1_porog2_cnt,x
6286  0d53 2013          	jra	L7603
6287  0d55               L5013:
6288                     ; 992 	else if(T1<(ee_T1_porog2-1))T1_porog2_cnt++;
6290  0d55 9c            	rvf
6291  0d56 ce001b        	ldw	x,_ee_T1_porog2
6292  0d59 5a            	decw	x
6293  0d5a c30060        	cpw	x,_T1
6294  0d5d 2d09          	jrsle	L7603
6297  0d5f ce0052        	ldw	x,_T1_porog2_cnt
6298  0d62 1c0001        	addw	x,#1
6299  0d65 cf0052        	ldw	_T1_porog2_cnt,x
6300  0d68               L7603:
6301                     ; 994 if(T1_porog2_cnt>100)T1_porog2_cnt=100;
6303  0d68 9c            	rvf
6304  0d69 ce0052        	ldw	x,_T1_porog2_cnt
6305  0d6c a30065        	cpw	x,#101
6306  0d6f 2f06          	jrslt	L3113
6309  0d71 ae0064        	ldw	x,#100
6310  0d74 cf0052        	ldw	_T1_porog2_cnt,x
6311  0d77               L3113:
6312                     ; 995 if(T1_porog2_cnt<0)T1_porog2_cnt=0;
6314  0d77 9c            	rvf
6315  0d78 ce0052        	ldw	x,_T1_porog2_cnt
6316  0d7b 2e04          	jrsge	L5113
6319  0d7d 5f            	clrw	x
6320  0d7e cf0052        	ldw	_T1_porog2_cnt,x
6321  0d81               L5113:
6322                     ; 997 if(T1_porog2_cnt>95)T1_status2=1;
6324  0d81 9c            	rvf
6325  0d82 ce0052        	ldw	x,_T1_porog2_cnt
6326  0d85 a30060        	cpw	x,#96
6327  0d88 2f04          	jrslt	L7113
6330  0d8a 3501005c      	mov	_T1_status2,#1
6331  0d8e               L7113:
6332                     ; 998 if(T1_porog2_cnt<5)T1_status2=0;
6334  0d8e 9c            	rvf
6335  0d8f ce0052        	ldw	x,_T1_porog2_cnt
6336  0d92 a30005        	cpw	x,#5
6337  0d95 2e04          	jrsge	L1213
6340  0d97 725f005c      	clr	_T1_status2
6341  0d9b               L1213:
6342                     ; 1001 if(T1_status1_old!=T1_status1)
6344  0d9b c6005b        	ld	a,_T1_status1_old
6345  0d9e c1005d        	cp	a,_T1_status1
6346  0da1 2733          	jreq	L3213
6347                     ; 1003 	if((T1_status1==1)&&(ee_T1_trap_send_av_1==ttsON))
6349  0da3 c6005d        	ld	a,_T1_status1
6350  0da6 a101          	cp	a,#1
6351  0da8 2614          	jrne	L5213
6353  0daa c60012        	ld	a,_ee_T1_trap_send_av_1
6354  0dad a101          	cp	a,#1
6355  0daf 260d          	jrne	L5213
6356                     ; 1005 		trap_send((3<<5)+(1<<2)+1,T1);
6358  0db1 ce0060        	ldw	x,_T1
6359  0db4 89            	pushw	x
6360  0db5 a665          	ld	a,#101
6361  0db7 8d6e0b6e      	callf	f_trap_send
6363  0dbb 85            	popw	x
6365  0dbc 2018          	jra	L3213
6366  0dbe               L5213:
6367                     ; 1007 	else if((T1_status1==0)&&(ee_T1_trap_send_no_av_1==ttsON))
6369  0dbe 725d005d      	tnz	_T1_status1
6370  0dc2 2612          	jrne	L3213
6372  0dc4 c60011        	ld	a,_ee_T1_trap_send_no_av_1
6373  0dc7 a101          	cp	a,#1
6374  0dc9 260b          	jrne	L3213
6375                     ; 1009 		trap_send((3<<5)+(1<<2)+0,T1);
6377  0dcb ce0060        	ldw	x,_T1
6378  0dce 89            	pushw	x
6379  0dcf a664          	ld	a,#100
6380  0dd1 8d6e0b6e      	callf	f_trap_send
6382  0dd5 85            	popw	x
6383  0dd6               L3213:
6384                     ; 1013 if(T1_status2_old!=T1_status2)
6386  0dd6 c6005a        	ld	a,_T1_status2_old
6387  0dd9 c1005c        	cp	a,_T1_status2
6388  0ddc 2733          	jreq	L3313
6389                     ; 1015 	if((T1_status2==1)&&(ee_T1_trap_send_av_2==ttsON))
6391  0dde c6005c        	ld	a,_T1_status2
6392  0de1 a101          	cp	a,#1
6393  0de3 2614          	jrne	L5313
6395  0de5 c60010        	ld	a,_ee_T1_trap_send_av_2
6396  0de8 a101          	cp	a,#1
6397  0dea 260d          	jrne	L5313
6398                     ; 1017 		trap_send((3<<5)+(2<<2)+1,T1);
6400  0dec ce0060        	ldw	x,_T1
6401  0def 89            	pushw	x
6402  0df0 a669          	ld	a,#105
6403  0df2 8d6e0b6e      	callf	f_trap_send
6405  0df6 85            	popw	x
6407  0df7 2018          	jra	L3313
6408  0df9               L5313:
6409                     ; 1019 	else if((T1_status2==0)&&(ee_T1_trap_send_no_av_2==ttsON))
6411  0df9 725d005c      	tnz	_T1_status2
6412  0dfd 2612          	jrne	L3313
6414  0dff c6000f        	ld	a,_ee_T1_trap_send_no_av_2
6415  0e02 a101          	cp	a,#1
6416  0e04 260b          	jrne	L3313
6417                     ; 1021 		trap_send((3<<5)+(2<<2)+0,T1);
6419  0e06 ce0060        	ldw	x,_T1
6420  0e09 89            	pushw	x
6421  0e0a a668          	ld	a,#104
6422  0e0c 8d6e0b6e      	callf	f_trap_send
6424  0e10 85            	popw	x
6425  0e11               L3313:
6426                     ; 1025 T1_status1_old=T1_status1;
6428  0e11 55005d005b    	mov	_T1_status1_old,_T1_status1
6429                     ; 1026 T1_status2_old=T1_status2;
6431  0e16 55005c005a    	mov	_T1_status2_old,_T1_status2
6432                     ; 1031 if(ee_T2_logic1==tlOFF)
6434  0e1b 725d0014      	tnz	_ee_T2_logic1
6435  0e1f 260a          	jrne	L3413
6436                     ; 1033 	T2_status1=0;
6438  0e21 725f0059      	clr	_T2_status1
6439                     ; 1034 	T2_porog1_cnt=0;
6441  0e25 5f            	clrw	x
6442  0e26 cf0050        	ldw	_T2_porog1_cnt,x
6444  0e29 2060          	jra	L5413
6445  0e2b               L3413:
6446                     ; 1036 else if(ee_T2_logic1==tlNW)
6448  0e2b c60014        	ld	a,_ee_T2_logic1
6449  0e2e a101          	cp	a,#1
6450  0e30 262a          	jrne	L7413
6451                     ; 1038 	if(T2>(ee_T2_porog1+1))T2_porog1_cnt++;
6453  0e32 9c            	rvf
6454  0e33 ce0019        	ldw	x,_ee_T2_porog1
6455  0e36 5c            	incw	x
6456  0e37 c3005e        	cpw	x,_T2
6457  0e3a 2e0b          	jrsge	L1513
6460  0e3c ce0050        	ldw	x,_T2_porog1_cnt
6461  0e3f 1c0001        	addw	x,#1
6462  0e42 cf0050        	ldw	_T2_porog1_cnt,x
6464  0e45 2044          	jra	L5413
6465  0e47               L1513:
6466                     ; 1039 	else if(T2<(ee_T2_porog1-1))T2_porog1_cnt--;
6468  0e47 9c            	rvf
6469  0e48 ce0019        	ldw	x,_ee_T2_porog1
6470  0e4b 5a            	decw	x
6471  0e4c c3005e        	cpw	x,_T2
6472  0e4f 2d3a          	jrsle	L5413
6475  0e51 ce0050        	ldw	x,_T2_porog1_cnt
6476  0e54 1d0001        	subw	x,#1
6477  0e57 cf0050        	ldw	_T2_porog1_cnt,x
6478  0e5a 202f          	jra	L5413
6479  0e5c               L7413:
6480                     ; 1041 else if(ee_T2_logic1==tlNC)
6482  0e5c c60014        	ld	a,_ee_T2_logic1
6483  0e5f a102          	cp	a,#2
6484  0e61 2628          	jrne	L5413
6485                     ; 1043 	if(T2>(ee_T2_porog1+1))T2_porog1_cnt--;
6487  0e63 9c            	rvf
6488  0e64 ce0019        	ldw	x,_ee_T2_porog1
6489  0e67 5c            	incw	x
6490  0e68 c3005e        	cpw	x,_T2
6491  0e6b 2e0b          	jrsge	L3613
6494  0e6d ce0050        	ldw	x,_T2_porog1_cnt
6495  0e70 1d0001        	subw	x,#1
6496  0e73 cf0050        	ldw	_T2_porog1_cnt,x
6498  0e76 2013          	jra	L5413
6499  0e78               L3613:
6500                     ; 1044 	else if(T2<(ee_T2_porog1-1))T2_porog1_cnt++;
6502  0e78 9c            	rvf
6503  0e79 ce0019        	ldw	x,_ee_T2_porog1
6504  0e7c 5a            	decw	x
6505  0e7d c3005e        	cpw	x,_T2
6506  0e80 2d09          	jrsle	L5413
6509  0e82 ce0050        	ldw	x,_T2_porog1_cnt
6510  0e85 1c0001        	addw	x,#1
6511  0e88 cf0050        	ldw	_T2_porog1_cnt,x
6512  0e8b               L5413:
6513                     ; 1046 if(T2_porog1_cnt>100)T2_porog1_cnt=100;
6515  0e8b 9c            	rvf
6516  0e8c ce0050        	ldw	x,_T2_porog1_cnt
6517  0e8f a30065        	cpw	x,#101
6518  0e92 2f06          	jrslt	L1713
6521  0e94 ae0064        	ldw	x,#100
6522  0e97 cf0050        	ldw	_T2_porog1_cnt,x
6523  0e9a               L1713:
6524                     ; 1047 if(T2_porog1_cnt<0)T2_porog1_cnt=0;
6526  0e9a 9c            	rvf
6527  0e9b ce0050        	ldw	x,_T2_porog1_cnt
6528  0e9e 2e04          	jrsge	L3713
6531  0ea0 5f            	clrw	x
6532  0ea1 cf0050        	ldw	_T2_porog1_cnt,x
6533  0ea4               L3713:
6534                     ; 1049 if(T2_porog1_cnt>95)T2_status1=1;
6536  0ea4 9c            	rvf
6537  0ea5 ce0050        	ldw	x,_T2_porog1_cnt
6538  0ea8 a30060        	cpw	x,#96
6539  0eab 2f04          	jrslt	L5713
6542  0ead 35010059      	mov	_T2_status1,#1
6543  0eb1               L5713:
6544                     ; 1050 if(T2_porog1_cnt<5)T2_status1=0;
6546  0eb1 9c            	rvf
6547  0eb2 ce0050        	ldw	x,_T2_porog1_cnt
6548  0eb5 a30005        	cpw	x,#5
6549  0eb8 2e04          	jrsge	L7713
6552  0eba 725f0059      	clr	_T2_status1
6553  0ebe               L7713:
6554                     ; 1053 if(ee_T2_logic2==tlOFF)
6556  0ebe 725d0013      	tnz	_ee_T2_logic2
6557  0ec2 260a          	jrne	L1023
6558                     ; 1055 	T2_status2=0;
6560  0ec4 725f0058      	clr	_T2_status2
6561                     ; 1056 	T2_porog2_cnt=0;
6563  0ec8 5f            	clrw	x
6564  0ec9 cf004e        	ldw	_T2_porog2_cnt,x
6566  0ecc 2060          	jra	L3023
6567  0ece               L1023:
6568                     ; 1058 else if(ee_T2_logic2==tlNW)
6570  0ece c60013        	ld	a,_ee_T2_logic2
6571  0ed1 a101          	cp	a,#1
6572  0ed3 262a          	jrne	L5023
6573                     ; 1060 	if(T2>(ee_T2_porog2+1))T2_porog2_cnt++;
6575  0ed5 9c            	rvf
6576  0ed6 ce0017        	ldw	x,_ee_T2_porog2
6577  0ed9 5c            	incw	x
6578  0eda c3005e        	cpw	x,_T2
6579  0edd 2e0b          	jrsge	L7023
6582  0edf ce004e        	ldw	x,_T2_porog2_cnt
6583  0ee2 1c0001        	addw	x,#1
6584  0ee5 cf004e        	ldw	_T2_porog2_cnt,x
6586  0ee8 2044          	jra	L3023
6587  0eea               L7023:
6588                     ; 1061 	else if(T2<(ee_T2_porog2-1))T2_porog2_cnt--;
6590  0eea 9c            	rvf
6591  0eeb ce0017        	ldw	x,_ee_T2_porog2
6592  0eee 5a            	decw	x
6593  0eef c3005e        	cpw	x,_T2
6594  0ef2 2d3a          	jrsle	L3023
6597  0ef4 ce004e        	ldw	x,_T2_porog2_cnt
6598  0ef7 1d0001        	subw	x,#1
6599  0efa cf004e        	ldw	_T2_porog2_cnt,x
6600  0efd 202f          	jra	L3023
6601  0eff               L5023:
6602                     ; 1063 else if(ee_T2_logic2==tlNC)
6604  0eff c60013        	ld	a,_ee_T2_logic2
6605  0f02 a102          	cp	a,#2
6606  0f04 2628          	jrne	L3023
6607                     ; 1065 	if(T2>(ee_T2_porog2+1))T2_porog2_cnt--;
6609  0f06 9c            	rvf
6610  0f07 ce0017        	ldw	x,_ee_T2_porog2
6611  0f0a 5c            	incw	x
6612  0f0b c3005e        	cpw	x,_T2
6613  0f0e 2e0b          	jrsge	L1223
6616  0f10 ce004e        	ldw	x,_T2_porog2_cnt
6617  0f13 1d0001        	subw	x,#1
6618  0f16 cf004e        	ldw	_T2_porog2_cnt,x
6620  0f19 2013          	jra	L3023
6621  0f1b               L1223:
6622                     ; 1066 	else if(T2<(ee_T2_porog2-1))T2_porog2_cnt++;
6624  0f1b 9c            	rvf
6625  0f1c ce0017        	ldw	x,_ee_T2_porog2
6626  0f1f 5a            	decw	x
6627  0f20 c3005e        	cpw	x,_T2
6628  0f23 2d09          	jrsle	L3023
6631  0f25 ce004e        	ldw	x,_T2_porog2_cnt
6632  0f28 1c0001        	addw	x,#1
6633  0f2b cf004e        	ldw	_T2_porog2_cnt,x
6634  0f2e               L3023:
6635                     ; 1068 if(T2_porog2_cnt>100)T2_porog2_cnt=100;
6637  0f2e 9c            	rvf
6638  0f2f ce004e        	ldw	x,_T2_porog2_cnt
6639  0f32 a30065        	cpw	x,#101
6640  0f35 2f06          	jrslt	L7223
6643  0f37 ae0064        	ldw	x,#100
6644  0f3a cf004e        	ldw	_T2_porog2_cnt,x
6645  0f3d               L7223:
6646                     ; 1069 if(T2_porog2_cnt<0)T2_porog2_cnt=0;
6648  0f3d 9c            	rvf
6649  0f3e ce004e        	ldw	x,_T2_porog2_cnt
6650  0f41 2e04          	jrsge	L1323
6653  0f43 5f            	clrw	x
6654  0f44 cf004e        	ldw	_T2_porog2_cnt,x
6655  0f47               L1323:
6656                     ; 1071 if(T2_porog2_cnt>95)T2_status2=1;
6658  0f47 9c            	rvf
6659  0f48 ce004e        	ldw	x,_T2_porog2_cnt
6660  0f4b a30060        	cpw	x,#96
6661  0f4e 2f04          	jrslt	L3323
6664  0f50 35010058      	mov	_T2_status2,#1
6665  0f54               L3323:
6666                     ; 1072 if(T2_porog2_cnt<5)T2_status2=0;
6668  0f54 9c            	rvf
6669  0f55 ce004e        	ldw	x,_T2_porog2_cnt
6670  0f58 a30005        	cpw	x,#5
6671  0f5b 2e04          	jrsge	L5323
6674  0f5d 725f0058      	clr	_T2_status2
6675  0f61               L5323:
6676                     ; 1075 if(T2_status1_old!=T2_status1)
6678  0f61 c60057        	ld	a,_T2_status1_old
6679  0f64 c10059        	cp	a,_T2_status1
6680  0f67 2733          	jreq	L7323
6681                     ; 1077 	if((T2_status1==1)&&(ee_T2_trap_send_av_1==ttsON))
6683  0f69 c60059        	ld	a,_T2_status1
6684  0f6c a101          	cp	a,#1
6685  0f6e 2614          	jrne	L1423
6687  0f70 c6000e        	ld	a,_ee_T2_trap_send_av_1
6688  0f73 a101          	cp	a,#1
6689  0f75 260d          	jrne	L1423
6690                     ; 1079 		trap_send((3<<5)+(3<<2)+1,T2);
6692  0f77 ce005e        	ldw	x,_T2
6693  0f7a 89            	pushw	x
6694  0f7b a66d          	ld	a,#109
6695  0f7d 8d6e0b6e      	callf	f_trap_send
6697  0f81 85            	popw	x
6699  0f82 2018          	jra	L7323
6700  0f84               L1423:
6701                     ; 1081 	else if((T2_status1==0)&&(ee_T2_trap_send_no_av_1==ttsON))
6703  0f84 725d0059      	tnz	_T2_status1
6704  0f88 2612          	jrne	L7323
6706  0f8a c6000d        	ld	a,_ee_T2_trap_send_no_av_1
6707  0f8d a101          	cp	a,#1
6708  0f8f 260b          	jrne	L7323
6709                     ; 1083 		trap_send((3<<5)+(3<<2)+0,T2);
6711  0f91 ce005e        	ldw	x,_T2
6712  0f94 89            	pushw	x
6713  0f95 a66c          	ld	a,#108
6714  0f97 8d6e0b6e      	callf	f_trap_send
6716  0f9b 85            	popw	x
6717  0f9c               L7323:
6718                     ; 1087 if(T2_status2_old!=T2_status2)
6720  0f9c c60056        	ld	a,_T2_status2_old
6721  0f9f c10058        	cp	a,_T2_status2
6722  0fa2 2733          	jreq	L7423
6723                     ; 1089 	if((T2_status2==1)&&(ee_T2_trap_send_av_2==ttsON))
6725  0fa4 c60058        	ld	a,_T2_status2
6726  0fa7 a101          	cp	a,#1
6727  0fa9 2614          	jrne	L1523
6729  0fab c6000c        	ld	a,_ee_T2_trap_send_av_2
6730  0fae a101          	cp	a,#1
6731  0fb0 260d          	jrne	L1523
6732                     ; 1091 		trap_send((3<<5)+(4<<2)+1,T2);
6734  0fb2 ce005e        	ldw	x,_T2
6735  0fb5 89            	pushw	x
6736  0fb6 a671          	ld	a,#113
6737  0fb8 8d6e0b6e      	callf	f_trap_send
6739  0fbc 85            	popw	x
6741  0fbd 2018          	jra	L7423
6742  0fbf               L1523:
6743                     ; 1093 	else if((T2_status2==0)&&(ee_T2_trap_send_no_av_2==ttsON))
6745  0fbf 725d0058      	tnz	_T2_status2
6746  0fc3 2612          	jrne	L7423
6748  0fc5 c6000b        	ld	a,_ee_T2_trap_send_no_av_2
6749  0fc8 a101          	cp	a,#1
6750  0fca 260b          	jrne	L7423
6751                     ; 1095 		trap_send((3<<5)+(4<<2)+0,T2);
6753  0fcc ce005e        	ldw	x,_T2
6754  0fcf 89            	pushw	x
6755  0fd0 a670          	ld	a,#112
6756  0fd2 8d6e0b6e      	callf	f_trap_send
6758  0fd6 85            	popw	x
6759  0fd7               L7423:
6760                     ; 1099 T2_status1_old=T2_status1;
6762  0fd7 5500590057    	mov	_T2_status1_old,_T2_status1
6763                     ; 1100 T2_status2_old=T2_status2;
6765  0fdc 5500580056    	mov	_T2_status2_old,_T2_status2
6766                     ; 1105 }
6769  0fe1 87            	retf
6821                     ; 1111 void log_in_drv(void)
6821                     ; 1112 {
6822                     	switch	.text
6823  0fe2               f_log_in_drv:
6825  0fe2 5204          	subw	sp,#4
6826       00000004      OFST:	set	4
6829                     ; 1116 GPIOB->DDR&=~(1<<2);
6831  0fe4 72155007      	bres	20487,#2
6832                     ; 1117 GPIOB->CR1|=(1<<2);
6834  0fe8 72145008      	bset	20488,#2
6835                     ; 1118 GPIOB->CR2&=~(1<<2);	
6837  0fec 72155009      	bres	20489,#2
6838                     ; 1120 GPIOB->DDR&=~(1<<3);
6840  0ff0 72175007      	bres	20487,#3
6841                     ; 1121 GPIOB->CR1|=(1<<3);
6843  0ff4 72165008      	bset	20488,#3
6844                     ; 1122 GPIOB->CR2&=~(1<<3);
6846  0ff8 72175009      	bres	20489,#3
6847                     ; 1124 GPIOC->DDR&=~(1<<1);
6849  0ffc 7213500c      	bres	20492,#1
6850                     ; 1125 GPIOC->CR1|=(1<<1);
6852  1000 7212500d      	bset	20493,#1
6853                     ; 1126 GPIOC->CR2&=~(1<<1);
6855  1004 7213500e      	bres	20494,#1
6856                     ; 1128 GPIOC->DDR&=~(1<<2);
6858  1008 7215500c      	bres	20492,#2
6859                     ; 1129 GPIOC->CR1|=(1<<2);
6861  100c 7214500d      	bset	20493,#2
6862                     ; 1130 GPIOC->CR2&=~(1<<2);
6864  1010 7215500e      	bres	20494,#2
6865                     ; 1132 GPIOC->DDR&=~(1<<3);
6867  1014 7217500c      	bres	20492,#3
6868                     ; 1133 GPIOC->CR1|=(1<<3);
6870  1018 7216500d      	bset	20493,#3
6871                     ; 1134 GPIOC->CR2&=~(1<<3);
6873  101c 7217500e      	bres	20494,#3
6874                     ; 1136 GPIOC->DDR&=~(1<<4);
6876  1020 7219500c      	bres	20492,#4
6877                     ; 1137 GPIOC->CR1|=(1<<4);
6879  1024 7218500d      	bset	20493,#4
6880                     ; 1138 GPIOC->CR2&=~(1<<4);
6882  1028 7219500e      	bres	20494,#4
6883                     ; 1140 temp=0;
6885  102c 0f03          	clr	(OFST-1,sp)
6886                     ; 1141 if(!(GPIOB->IDR&(1<<2))) temp|=(1<<0);
6888  102e c65006        	ld	a,20486
6889  1031 a504          	bcp	a,#4
6890  1033 2606          	jrne	L1033
6893  1035 7b03          	ld	a,(OFST-1,sp)
6894  1037 aa01          	or	a,#1
6895  1039 6b03          	ld	(OFST-1,sp),a
6896  103b               L1033:
6897                     ; 1142 if(!(GPIOB->IDR&(1<<3))) temp|=(1<<1);
6899  103b c65006        	ld	a,20486
6900  103e a508          	bcp	a,#8
6901  1040 2606          	jrne	L3033
6904  1042 7b03          	ld	a,(OFST-1,sp)
6905  1044 aa02          	or	a,#2
6906  1046 6b03          	ld	(OFST-1,sp),a
6907  1048               L3033:
6908                     ; 1143 if(!(GPIOC->IDR&(1<<1))) temp|=(1<<2);
6910  1048 c6500b        	ld	a,20491
6911  104b a502          	bcp	a,#2
6912  104d 2606          	jrne	L5033
6915  104f 7b03          	ld	a,(OFST-1,sp)
6916  1051 aa04          	or	a,#4
6917  1053 6b03          	ld	(OFST-1,sp),a
6918  1055               L5033:
6919                     ; 1144 if(!(GPIOC->IDR&(1<<2))) temp|=(1<<3);
6921  1055 c6500b        	ld	a,20491
6922  1058 a504          	bcp	a,#4
6923  105a 2606          	jrne	L7033
6926  105c 7b03          	ld	a,(OFST-1,sp)
6927  105e aa08          	or	a,#8
6928  1060 6b03          	ld	(OFST-1,sp),a
6929  1062               L7033:
6930                     ; 1145 if(!(GPIOC->IDR&(1<<3))) temp|=(1<<4);
6932  1062 c6500b        	ld	a,20491
6933  1065 a508          	bcp	a,#8
6934  1067 2606          	jrne	L1133
6937  1069 7b03          	ld	a,(OFST-1,sp)
6938  106b aa10          	or	a,#16
6939  106d 6b03          	ld	(OFST-1,sp),a
6940  106f               L1133:
6941                     ; 1146 if(!(GPIOC->IDR&(1<<4))) temp|=(1<<5);
6943  106f c6500b        	ld	a,20491
6944  1072 a510          	bcp	a,#16
6945  1074 2606          	jrne	L3133
6948  1076 7b03          	ld	a,(OFST-1,sp)
6949  1078 aa20          	or	a,#32
6950  107a 6b03          	ld	(OFST-1,sp),a
6951  107c               L3133:
6952                     ; 1149 for(i=0;i<8;i++)
6954  107c 0f04          	clr	(OFST+0,sp)
6955  107e               L5133:
6956                     ; 1151 	if(temp&(1<<i))log_in_cnt[i]++;
6958  107e 7b03          	ld	a,(OFST-1,sp)
6959  1080 5f            	clrw	x
6960  1081 97            	ld	xl,a
6961  1082 1f01          	ldw	(OFST-3,sp),x
6962  1084 ae0001        	ldw	x,#1
6963  1087 7b04          	ld	a,(OFST+0,sp)
6964  1089 4d            	tnz	a
6965  108a 2704          	jreq	L041
6966  108c               L241:
6967  108c 58            	sllw	x
6968  108d 4a            	dec	a
6969  108e 26fc          	jrne	L241
6970  1090               L041:
6971  1090 01            	rrwa	x,a
6972  1091 1402          	and	a,(OFST-2,sp)
6973  1093 01            	rrwa	x,a
6974  1094 1401          	and	a,(OFST-3,sp)
6975  1096 01            	rrwa	x,a
6976  1097 a30000        	cpw	x,#0
6977  109a 270a          	jreq	L3233
6980  109c 7b04          	ld	a,(OFST+0,sp)
6981  109e 5f            	clrw	x
6982  109f 97            	ld	xl,a
6983  10a0 724c0011      	inc	(_log_in_cnt,x)
6985  10a4 2008          	jra	L5233
6986  10a6               L3233:
6987                     ; 1152 	else log_in_cnt[i]--;
6989  10a6 7b04          	ld	a,(OFST+0,sp)
6990  10a8 5f            	clrw	x
6991  10a9 97            	ld	xl,a
6992  10aa 724a0011      	dec	(_log_in_cnt,x)
6993  10ae               L5233:
6994                     ; 1153 	gran_char(&log_in_cnt[i],-10,10);
6996  10ae 4b0a          	push	#10
6997  10b0 4bf6          	push	#246
6998  10b2 7b06          	ld	a,(OFST+2,sp)
6999  10b4 5f            	clrw	x
7000  10b5 97            	ld	xl,a
7001  10b6 1c0011        	addw	x,#_log_in_cnt
7002  10b9 8d000000      	callf	f_gran_char
7004  10bd 85            	popw	x
7005                     ; 1154 	if(log_in_cnt[i]<-7)log_in_stat[i]=lisOFF;
7007  10be 9c            	rvf
7008  10bf 7b04          	ld	a,(OFST+0,sp)
7009  10c1 5f            	clrw	x
7010  10c2 97            	ld	xl,a
7011  10c3 d60011        	ld	a,(_log_in_cnt,x)
7012  10c6 a1f9          	cp	a,#249
7013  10c8 2e0a          	jrsge	L7233
7016  10ca 7b04          	ld	a,(OFST+0,sp)
7017  10cc 5f            	clrw	x
7018  10cd 97            	ld	xl,a
7019  10ce 724f00db      	clr	(_log_in_stat,x)
7021  10d2 2015          	jra	L1333
7022  10d4               L7233:
7023                     ; 1155 	else if (log_in_cnt[i]>7)log_in_stat[i]=lisON;
7025  10d4 9c            	rvf
7026  10d5 7b04          	ld	a,(OFST+0,sp)
7027  10d7 5f            	clrw	x
7028  10d8 97            	ld	xl,a
7029  10d9 d60011        	ld	a,(_log_in_cnt,x)
7030  10dc a108          	cp	a,#8
7031  10de 2f09          	jrslt	L1333
7034  10e0 7b04          	ld	a,(OFST+0,sp)
7035  10e2 5f            	clrw	x
7036  10e3 97            	ld	xl,a
7037  10e4 a601          	ld	a,#1
7038  10e6 d700db        	ld	(_log_in_stat,x),a
7039  10e9               L1333:
7040                     ; 1149 for(i=0;i<8;i++)
7042  10e9 0c04          	inc	(OFST+0,sp)
7045  10eb 7b04          	ld	a,(OFST+0,sp)
7046  10ed a108          	cp	a,#8
7047  10ef 258d          	jrult	L5133
7048                     ; 1158 for(i=0;i<8;i++)
7050  10f1 0f04          	clr	(OFST+0,sp)
7051  10f3               L5333:
7052                     ; 1160 	if( 
7052                     ; 1161 		( (log_in_stat[i]==lisON) && (ee_log_in_stat_of_av[i]==lisoaON) )
7052                     ; 1162 		||
7052                     ; 1163 		( (log_in_stat[i]==lisOFF) && (ee_log_in_stat_of_av[i]==lisoaOFF) )
7052                     ; 1164 	  )	log_in_av_stat[i]=liasON;
7054  10f3 7b04          	ld	a,(OFST+0,sp)
7055  10f5 5f            	clrw	x
7056  10f6 97            	ld	xl,a
7057  10f7 d600db        	ld	a,(_log_in_stat,x)
7058  10fa a101          	cp	a,#1
7059  10fc 260b          	jrne	L7433
7061  10fe 7b04          	ld	a,(OFST+0,sp)
7062  1100 5f            	clrw	x
7063  1101 97            	ld	xl,a
7064  1102 d60037        	ld	a,(_ee_log_in_stat_of_av,x)
7065  1105 a101          	cp	a,#1
7066  1107 2714          	jreq	L5433
7067  1109               L7433:
7069  1109 7b04          	ld	a,(OFST+0,sp)
7070  110b 5f            	clrw	x
7071  110c 97            	ld	xl,a
7072  110d 724d00db      	tnz	(_log_in_stat,x)
7073  1111 2615          	jrne	L3433
7075  1113 7b04          	ld	a,(OFST+0,sp)
7076  1115 5f            	clrw	x
7077  1116 97            	ld	xl,a
7078  1117 724d0037      	tnz	(_ee_log_in_stat_of_av,x)
7079  111b 260b          	jrne	L3433
7080  111d               L5433:
7083  111d 7b04          	ld	a,(OFST+0,sp)
7084  111f 5f            	clrw	x
7085  1120 97            	ld	xl,a
7086  1121 a601          	ld	a,#1
7087  1123 d700d3        	ld	(_log_in_av_stat,x),a
7089  1126 2008          	jra	L1533
7090  1128               L3433:
7091                     ; 1165 	else log_in_av_stat[i]=liasOFF;
7093  1128 7b04          	ld	a,(OFST+0,sp)
7094  112a 5f            	clrw	x
7095  112b 97            	ld	xl,a
7096  112c 724f00d3      	clr	(_log_in_av_stat,x)
7097  1130               L1533:
7098                     ; 1158 for(i=0;i<8;i++)
7100  1130 0c04          	inc	(OFST+0,sp)
7103  1132 7b04          	ld	a,(OFST+0,sp)
7104  1134 a108          	cp	a,#8
7105  1136 25bb          	jrult	L5333
7106                     ; 1168 for(i=0;i<8;i++)
7108  1138 0f04          	clr	(OFST+0,sp)
7109  113a               L3533:
7110                     ; 1170 	if(log_in_av_stat_old[i]!=log_in_av_stat[i])
7112  113a 7b04          	ld	a,(OFST+0,sp)
7113  113c 5f            	clrw	x
7114  113d 97            	ld	xl,a
7115  113e 7b04          	ld	a,(OFST+0,sp)
7116  1140 905f          	clrw	y
7117  1142 9097          	ld	yl,a
7118  1144 90d600cb      	ld	a,(_log_in_av_stat_old,y)
7119  1148 d100d3        	cp	a,(_log_in_av_stat,x)
7120  114b 2757          	jreq	L1633
7121                     ; 1173 		if((log_in_av_stat[i]==liasON) && (ee_log_in_trap_send_av[i]==litsON)) trap_send((1<<5)+((i+1)<<2)+1,log_in_stat[i]);
7123  114d 7b04          	ld	a,(OFST+0,sp)
7124  114f 5f            	clrw	x
7125  1150 97            	ld	xl,a
7126  1151 d600d3        	ld	a,(_log_in_av_stat,x)
7127  1154 a101          	cp	a,#1
7128  1156 2622          	jrne	L3633
7130  1158 7b04          	ld	a,(OFST+0,sp)
7131  115a 5f            	clrw	x
7132  115b 97            	ld	xl,a
7133  115c d6002f        	ld	a,(_ee_log_in_trap_send_av,x)
7134  115f a101          	cp	a,#1
7135  1161 2617          	jrne	L3633
7138  1163 7b04          	ld	a,(OFST+0,sp)
7139  1165 5f            	clrw	x
7140  1166 97            	ld	xl,a
7141  1167 d600db        	ld	a,(_log_in_stat,x)
7142  116a 5f            	clrw	x
7143  116b 97            	ld	xl,a
7144  116c 89            	pushw	x
7145  116d 7b06          	ld	a,(OFST+2,sp)
7146  116f 48            	sll	a
7147  1170 48            	sll	a
7148  1171 ab25          	add	a,#37
7149  1173 8d6e0b6e      	callf	f_trap_send
7151  1177 85            	popw	x
7153  1178 202a          	jra	L1633
7154  117a               L3633:
7155                     ; 1174 		else if((log_in_av_stat[i]==liasOFF) && (ee_log_in_trap_send_no_av[i]==litsON)) trap_send((1<<5)+((i+1)<<2)+0,log_in_stat[i]);
7157  117a 7b04          	ld	a,(OFST+0,sp)
7158  117c 5f            	clrw	x
7159  117d 97            	ld	xl,a
7160  117e 724d00d3      	tnz	(_log_in_av_stat,x)
7161  1182 2620          	jrne	L1633
7163  1184 7b04          	ld	a,(OFST+0,sp)
7164  1186 5f            	clrw	x
7165  1187 97            	ld	xl,a
7166  1188 d60027        	ld	a,(_ee_log_in_trap_send_no_av,x)
7167  118b a101          	cp	a,#1
7168  118d 2615          	jrne	L1633
7171  118f 7b04          	ld	a,(OFST+0,sp)
7172  1191 5f            	clrw	x
7173  1192 97            	ld	xl,a
7174  1193 d600db        	ld	a,(_log_in_stat,x)
7175  1196 5f            	clrw	x
7176  1197 97            	ld	xl,a
7177  1198 89            	pushw	x
7178  1199 7b06          	ld	a,(OFST+2,sp)
7179  119b 48            	sll	a
7180  119c 48            	sll	a
7181  119d ab24          	add	a,#36
7182  119f 8d6e0b6e      	callf	f_trap_send
7184  11a3 85            	popw	x
7185  11a4               L1633:
7186                     ; 1168 for(i=0;i<8;i++)
7188  11a4 0c04          	inc	(OFST+0,sp)
7191  11a6 7b04          	ld	a,(OFST+0,sp)
7192  11a8 a108          	cp	a,#8
7193  11aa 258e          	jrult	L3533
7194                     ; 1178 for(i=0;i<8;i++)
7196  11ac 0f04          	clr	(OFST+0,sp)
7197  11ae               L1733:
7198                     ; 1180 	log_in_av_stat_old[i]=log_in_av_stat[i];
7200  11ae 7b04          	ld	a,(OFST+0,sp)
7201  11b0 5f            	clrw	x
7202  11b1 97            	ld	xl,a
7203  11b2 d600d3        	ld	a,(_log_in_av_stat,x)
7204  11b5 d700cb        	ld	(_log_in_av_stat_old,x),a
7205                     ; 1178 for(i=0;i<8;i++)
7207  11b8 0c04          	inc	(OFST+0,sp)
7210  11ba 7b04          	ld	a,(OFST+0,sp)
7211  11bc a108          	cp	a,#8
7212  11be 25ee          	jrult	L1733
7213                     ; 1182 temp=0;
7215  11c0 0f03          	clr	(OFST-1,sp)
7216                     ; 1183 for(i=0;i<6;i++)
7218  11c2 0f04          	clr	(OFST+0,sp)
7219  11c4               L7733:
7220                     ; 1185 	if(log_in_stat[i]==lisON)temp|=(1<<i);
7222  11c4 7b04          	ld	a,(OFST+0,sp)
7223  11c6 5f            	clrw	x
7224  11c7 97            	ld	xl,a
7225  11c8 d600db        	ld	a,(_log_in_stat,x)
7226  11cb a101          	cp	a,#1
7227  11cd 2611          	jrne	L5043
7230  11cf 7b04          	ld	a,(OFST+0,sp)
7231  11d1 5f            	clrw	x
7232  11d2 97            	ld	xl,a
7233  11d3 a601          	ld	a,#1
7234  11d5 5d            	tnzw	x
7235  11d6 2704          	jreq	L441
7236  11d8               L641:
7237  11d8 48            	sll	a
7238  11d9 5a            	decw	x
7239  11da 26fc          	jrne	L641
7240  11dc               L441:
7241  11dc 1a03          	or	a,(OFST-1,sp)
7242  11de 6b03          	ld	(OFST-1,sp),a
7243  11e0               L5043:
7244                     ; 1183 for(i=0;i<6;i++)
7246  11e0 0c04          	inc	(OFST+0,sp)
7249  11e2 7b04          	ld	a,(OFST+0,sp)
7250  11e4 a106          	cp	a,#6
7251  11e6 25dc          	jrult	L7733
7252                     ; 1187 data_for_stend_char=temp;	
7254  11e8 7b03          	ld	a,(OFST-1,sp)
7255  11ea c70005        	ld	_data_for_stend_char,a
7256                     ; 1189 }
7259  11ed 5b04          	addw	sp,#4
7260  11ef 87            	retf
7296                     ; 1196 @far @interrupt void TIM4_UPD_Interrupt (void) 
7296                     ; 1197 {
7297                     	switch	.text
7298  11f0               f_TIM4_UPD_Interrupt:
7302                     ; 1203 bPUART_TX=1;
7304  11f0 72100003      	bset	_bPUART_TX
7305                     ; 1205 if(tx_stat_cnt)
7307  11f4 725d0000      	tnz	_tx_stat_cnt
7308  11f8 270c          	jreq	L7143
7309                     ; 1207 	tx_stat_cnt--;
7311  11fa 725a0000      	dec	_tx_stat_cnt
7312                     ; 1208 	if(tx_stat_cnt==0)tx_stat=tsOFF;
7314  11fe 725d0000      	tnz	_tx_stat_cnt
7315  1202 2602          	jrne	L7143
7318  1204 3f00          	clr	_tx_stat
7319  1206               L7143:
7320                     ; 1211 	if(++t0_cnt0>=10){
7322  1206 3c00          	inc	_t0_cnt0
7323  1208 b600          	ld	a,_t0_cnt0
7324  120a a10a          	cp	a,#10
7325  120c 253e          	jrult	L3243
7326                     ; 1212     		t0_cnt0=0;
7328  120e 3f00          	clr	_t0_cnt0
7329                     ; 1213     		b100Hz=1;
7331  1210 72100008      	bset	_b100Hz
7332                     ; 1215 		if(++t0_cnt1>=10){
7334  1214 3c01          	inc	_t0_cnt1
7335  1216 b601          	ld	a,_t0_cnt1
7336  1218 a10a          	cp	a,#10
7337  121a 2506          	jrult	L5243
7338                     ; 1216 			t0_cnt1=0;
7340  121c 3f01          	clr	_t0_cnt1
7341                     ; 1217 			b10Hz=1;
7343  121e 72100007      	bset	_b10Hz
7344  1222               L5243:
7345                     ; 1220 		if(++t0_cnt2>=20){
7347  1222 3c02          	inc	_t0_cnt2
7348  1224 b602          	ld	a,_t0_cnt2
7349  1226 a114          	cp	a,#20
7350  1228 2506          	jrult	L7243
7351                     ; 1221 			t0_cnt2=0;
7353  122a 3f02          	clr	_t0_cnt2
7354                     ; 1222 			b5Hz=1;
7356  122c 72100006      	bset	_b5Hz
7357  1230               L7243:
7358                     ; 1225 		if(++t0_cnt4>=50)
7360  1230 3c04          	inc	_t0_cnt4
7361  1232 b604          	ld	a,_t0_cnt4
7362  1234 a132          	cp	a,#50
7363  1236 2506          	jrult	L1343
7364                     ; 1227 			t0_cnt4=0;
7366  1238 3f04          	clr	_t0_cnt4
7367                     ; 1228 			b2Hz=1;
7369  123a 72100005      	bset	_b2Hz
7370  123e               L1343:
7371                     ; 1231 		if(++t0_cnt3>=100){
7373  123e 3c03          	inc	_t0_cnt3
7374  1240 b603          	ld	a,_t0_cnt3
7375  1242 a164          	cp	a,#100
7376  1244 2506          	jrult	L3243
7377                     ; 1232 			t0_cnt3=0;
7379  1246 3f03          	clr	_t0_cnt3
7380                     ; 1233 			b1Hz=1;
7382  1248 72100004      	bset	_b1Hz
7383  124c               L3243:
7384                     ; 1237 	TIM4->SR1&=~TIM4_SR1_UIF;			// disable break interrupt
7386  124c 72115342      	bres	21314,#0
7387                     ; 1246 if(tx_wd_cnt)
7389  1250 3d00          	tnz	_tx_wd_cnt
7390  1252 2704          	jreq	L5343
7391                     ; 1248 	tx_wd_cnt--;
7393  1254 3a00          	dec	_tx_wd_cnt
7395  1256 2004          	jra	L7343
7396  1258               L5343:
7397                     ; 1253 	GPIOD->ODR&=~(1<<4);
7399  1258 7219500f      	bres	20495,#4
7400  125c               L7343:
7401                     ; 1257 	return;
7404  125c 80            	iret
7432                     ; 1261 @far @interrupt void UARTTxInterrupt (void) 
7432                     ; 1262 {
7433                     	switch	.text
7434  125d               f_UARTTxInterrupt:
7438                     ; 1263 if (tx_counter)
7440  125d 3d38          	tnz	_tx_counter
7441  125f 271e          	jreq	L1543
7442                     ; 1265    	--tx_counter;
7444  1261 3a38          	dec	_tx_counter
7445                     ; 1266 	UART2->DR=tx_buffer[tx_rd_index];
7447  1263 5f            	clrw	x
7448  1264 b636          	ld	a,_tx_rd_index
7449  1266 2a01          	jrpl	L451
7450  1268 53            	cplw	x
7451  1269               L451:
7452  1269 97            	ld	xl,a
7453  126a e605          	ld	a,(_tx_buffer,x)
7454  126c c75241        	ld	21057,a
7455                     ; 1267 	if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
7457  126f 3c36          	inc	_tx_rd_index
7458  1271 b636          	ld	a,_tx_rd_index
7459  1273 a132          	cp	a,#50
7460  1275 2602          	jrne	L3543
7463  1277 3f36          	clr	_tx_rd_index
7464  1279               L3543:
7465                     ; 1269     	tx_wd_cnt=3;
7467  1279 35030000      	mov	_tx_wd_cnt,#3
7469  127d 200c          	jra	L5543
7470  127f               L1543:
7471                     ; 1274 	tx_stat_cnt=3;
7473  127f 35030000      	mov	_tx_stat_cnt,#3
7474                     ; 1277 		bOUT_FREE=1;
7476  1283 72100002      	bset	_bOUT_FREE
7477                     ; 1278 		UART2->CR2&= ~UART1_CR2_TIEN;
7479  1287 721f5245      	bres	21061,#7
7480  128b               L5543:
7481                     ; 1281 }
7484  128b 80            	iret
7572                     ; 1284 @far @interrupt void UARTRxInterrupt (void) 
7572                     ; 1285 {
7573                     	switch	.text
7574  128c               f_UARTRxInterrupt:
7576       00000005      OFST:	set	5
7577  128c 3b0002        	push	c_x+2
7578  128f be00          	ldw	x,c_x
7579  1291 89            	pushw	x
7580  1292 3b0002        	push	c_y+2
7581  1295 be00          	ldw	x,c_y
7582  1297 89            	pushw	x
7583  1298 5205          	subw	sp,#5
7586                     ; 1288 rx_status=UART2->SR;
7588  129a c65240        	ld	a,21056
7589  129d 6b05          	ld	(OFST+0,sp),a
7590                     ; 1289 rx_data=UART2->DR;
7592  129f c65241        	ld	a,21057
7593  12a2 6b04          	ld	(OFST-1,sp),a
7594                     ; 1291 if (rx_status & (UART1_SR_RXNE))
7596  12a4 7b05          	ld	a,(OFST+0,sp)
7597  12a6 a520          	bcp	a,#32
7598  12a8 2604          	jrne	L212
7599  12aa ac5a145a      	jpf	L1253
7600  12ae               L212:
7601                     ; 1294 temp=rx_data;
7603  12ae 7b04          	ld	a,(OFST-1,sp)
7604  12b0 6b04          	ld	(OFST-1,sp),a
7605                     ; 1295 if(tx_stat==tsOFF)
7607  12b2 3d00          	tnz	_tx_stat
7608  12b4 2704          	jreq	L412
7609  12b6 ac5a145a      	jpf	L1253
7610  12ba               L412:
7611                     ; 1297 	gran_char(&rx_wr_index,0,RX_BUFFER_SIZE); 
7613  12ba 4b32          	push	#50
7614  12bc 4b00          	push	#0
7615  12be ae0032        	ldw	x,#_rx_wr_index
7616  12c1 8d000000      	callf	f_gran_char
7618  12c5 85            	popw	x
7619                     ; 1298 	rx_buffer[rx_wr_index]=temp;
7621  12c6 5f            	clrw	x
7622  12c7 b632          	ld	a,_rx_wr_index
7623  12c9 2a01          	jrpl	L061
7624  12cb 53            	cplw	x
7625  12cc               L061:
7626  12cc 97            	ld	xl,a
7627  12cd 7b04          	ld	a,(OFST-1,sp)
7628  12cf e737          	ld	(_rx_buffer,x),a
7629                     ; 1299 	if(rx_read_power_102m_phase==0)
7631  12d1 725d0000      	tnz	_rx_read_power_102m_phase
7632  12d5 2704          	jreq	L612
7633  12d7 ac801380      	jpf	L5253
7634  12db               L612:
7635                     ; 1301 		if(temp==0xc0)
7637  12db 7b04          	ld	a,(OFST-1,sp)
7638  12dd a1c0          	cp	a,#192
7639  12df 2704          	jreq	L022
7640  12e1 ac361436      	jpf	L5553
7641  12e5               L022:
7642                     ; 1304 			if(rx_wr_index>1)
7644  12e5 9c            	rvf
7645  12e6 b632          	ld	a,_rx_wr_index
7646  12e8 a102          	cp	a,#2
7647  12ea 2e04          	jrsge	L222
7648  12ec ac361436      	jpf	L5553
7649  12f0               L222:
7650                     ; 1307 				for(i_=rx_wr_index-1;i_>=0;i_--)
7652  12f0 b632          	ld	a,_rx_wr_index
7653  12f2 4a            	dec	a
7654  12f3 6b03          	ld	(OFST-2,sp),a
7656  12f5 207a          	jra	L7353
7657  12f7               L3353:
7658                     ; 1309 					if(rx_buffer[i_]==0xc0)
7660  12f7 7b03          	ld	a,(OFST-2,sp)
7661  12f9 5f            	clrw	x
7662  12fa 4d            	tnz	a
7663  12fb 2a01          	jrpl	L261
7664  12fd 53            	cplw	x
7665  12fe               L261:
7666  12fe 97            	ld	xl,a
7667  12ff e637          	ld	a,(_rx_buffer,x)
7668  1301 a1c0          	cp	a,#192
7669  1303 266a          	jrne	L3453
7670                     ; 1311 						begin_i=i_;
7672  1305 7b03          	ld	a,(OFST-2,sp)
7673  1307 6b05          	ld	(OFST+0,sp),a
7674                     ; 1312 						sleep_len=rx_wr_index-begin_i+1;
7676  1309 b632          	ld	a,_rx_wr_index
7677  130b 1005          	sub	a,(OFST+0,sp)
7678  130d 4c            	inc	a
7679  130e b700          	ld	_sleep_len,a
7680                     ; 1314 						for(i_=0;i_<=(rx_wr_index-begin_i);i_++)
7682  1310 0f03          	clr	(OFST-2,sp)
7684  1312 202a          	jra	L1553
7685  1314               L5453:
7686                     ; 1316 							sleep_buff[i_]=rx_buffer[begin_i+i_];
7688  1314 7b03          	ld	a,(OFST-2,sp)
7689  1316 5f            	clrw	x
7690  1317 4d            	tnz	a
7691  1318 2a01          	jrpl	L461
7692  131a 53            	cplw	x
7693  131b               L461:
7694  131b 97            	ld	xl,a
7695  131c 7b05          	ld	a,(OFST+0,sp)
7696  131e 905f          	clrw	y
7697  1320 4d            	tnz	a
7698  1321 2a02          	jrpl	L661
7699  1323 9053          	cplw	y
7700  1325               L661:
7701  1325 9097          	ld	yl,a
7702  1327 1701          	ldw	(OFST-4,sp),y
7703  1329 7b03          	ld	a,(OFST-2,sp)
7704  132b 905f          	clrw	y
7705  132d 4d            	tnz	a
7706  132e 2a02          	jrpl	L071
7707  1330 9053          	cplw	y
7708  1332               L071:
7709  1332 9097          	ld	yl,a
7710  1334 72f901        	addw	y,(OFST-4,sp)
7711  1337 90e637        	ld	a,(_rx_buffer,y)
7712  133a e700          	ld	(_sleep_buff,x),a
7713                     ; 1314 						for(i_=0;i_<=(rx_wr_index-begin_i);i_++)
7715  133c 0c03          	inc	(OFST-2,sp)
7716  133e               L1553:
7719  133e 9c            	rvf
7720  133f 7b05          	ld	a,(OFST+0,sp)
7721  1341 5f            	clrw	x
7722  1342 4d            	tnz	a
7723  1343 2a01          	jrpl	L271
7724  1345 53            	cplw	x
7725  1346               L271:
7726  1346 97            	ld	xl,a
7727  1347 1f01          	ldw	(OFST-4,sp),x
7728  1349 5f            	clrw	x
7729  134a b632          	ld	a,_rx_wr_index
7730  134c 2a01          	jrpl	L471
7731  134e 53            	cplw	x
7732  134f               L471:
7733  134f 97            	ld	xl,a
7734  1350 72f001        	subw	x,(OFST-4,sp)
7735  1353 7b03          	ld	a,(OFST-2,sp)
7736  1355 905f          	clrw	y
7737  1357 4d            	tnz	a
7738  1358 2a02          	jrpl	L671
7739  135a 9053          	cplw	y
7740  135c               L671:
7741  135c 9097          	ld	yl,a
7742  135e 90bf00        	ldw	c_y,y
7743  1361 b300          	cpw	x,c_y
7744  1363 2eaf          	jrsge	L5453
7745                     ; 1318 						sleep_in=1;
7747  1365 35010000      	mov	_sleep_in,#1
7748                     ; 1319 						rx_wr_index=0;
7750  1369 3f32          	clr	_rx_wr_index
7751                     ; 1321 						break;
7753  136b ac361436      	jpf	L5553
7754  136f               L3453:
7755                     ; 1307 				for(i_=rx_wr_index-1;i_>=0;i_--)
7757  136f 0a03          	dec	(OFST-2,sp)
7758  1371               L7353:
7761  1371 9c            	rvf
7762  1372 7b03          	ld	a,(OFST-2,sp)
7763  1374 a100          	cp	a,#0
7764  1376 2f04acf712f7  	jrsge	L3353
7765  137c ac361436      	jpf	L5553
7766  1380               L5253:
7767                     ; 1327 	else if(rx_read_power_102m_phase==1)
7769  1380 c60000        	ld	a,_rx_read_power_102m_phase
7770  1383 a101          	cp	a,#1
7771  1385 2623          	jrne	L7553
7772                     ; 1329 		if((rx_buffer[rx_wr_index]==0x0a)&&(rx_buffer[6]==0xc5))
7774  1387 5f            	clrw	x
7775  1388 b632          	ld	a,_rx_wr_index
7776  138a 2a01          	jrpl	L002
7777  138c 53            	cplw	x
7778  138d               L002:
7779  138d 97            	ld	xl,a
7780  138e e637          	ld	a,(_rx_buffer,x)
7781  1390 a10a          	cp	a,#10
7782  1392 2704          	jreq	L422
7783  1394 ac361436      	jpf	L5553
7784  1398               L422:
7786  1398 b63d          	ld	a,_rx_buffer+6
7787  139a a1c5          	cp	a,#197
7788  139c 2704          	jreq	L622
7789  139e ac361436      	jpf	L5553
7790  13a2               L622:
7791                     ; 1331 			rx_read_power_102m_phase=2;
7793  13a2 35020000      	mov	_rx_read_power_102m_phase,#2
7794  13a6 ac361436      	jpf	L5553
7795  13aa               L7553:
7796                     ; 1334 	else if(rx_read_power_102m_phase==3)
7798  13aa c60000        	ld	a,_rx_read_power_102m_phase
7799  13ad a103          	cp	a,#3
7800  13af 2619          	jrne	L5653
7801                     ; 1336 		if((rx_buffer[rx_wr_index]==0x03)&&(rx_buffer[0]==0x81))
7803  13b1 5f            	clrw	x
7804  13b2 b632          	ld	a,_rx_wr_index
7805  13b4 2a01          	jrpl	L202
7806  13b6 53            	cplw	x
7807  13b7               L202:
7808  13b7 97            	ld	xl,a
7809  13b8 e637          	ld	a,(_rx_buffer,x)
7810  13ba a103          	cp	a,#3
7811  13bc 2678          	jrne	L5553
7813  13be b637          	ld	a,_rx_buffer
7814  13c0 a181          	cp	a,#129
7815  13c2 2672          	jrne	L5553
7816                     ; 1338 			rx_read_power_102m_phase=4;
7818  13c4 35040000      	mov	_rx_read_power_102m_phase,#4
7819  13c8 206c          	jra	L5553
7820  13ca               L5653:
7821                     ; 1341 	else if(rx_read_power_102m_phase==4)
7823  13ca c60000        	ld	a,_rx_read_power_102m_phase
7824  13cd a104          	cp	a,#4
7825  13cf 2606          	jrne	L3753
7826                     ; 1345 			rx_read_power_102m_phase=5;
7828  13d1 35050000      	mov	_rx_read_power_102m_phase,#5
7830  13d5 205f          	jra	L5553
7831  13d7               L3753:
7832                     ; 1348 	else if(rx_read_power_102m_phase==6)
7834  13d7 c60000        	ld	a,_rx_read_power_102m_phase
7835  13da a106          	cp	a,#6
7836  13dc 2615          	jrne	L7753
7837                     ; 1350 		if(((rx_buffer[rx_wr_index]&0x7f)=='(')/*&&(rx_buffer[0]==0x81)*/)
7839  13de 5f            	clrw	x
7840  13df b632          	ld	a,_rx_wr_index
7841  13e1 2a01          	jrpl	L402
7842  13e3 53            	cplw	x
7843  13e4               L402:
7844  13e4 97            	ld	xl,a
7845  13e5 e637          	ld	a,(_rx_buffer,x)
7846  13e7 a47f          	and	a,#127
7847  13e9 a128          	cp	a,#40
7848  13eb 2649          	jrne	L5553
7849                     ; 1352 			rx_read_power_102m_phase=7;
7851  13ed 35070000      	mov	_rx_read_power_102m_phase,#7
7852  13f1 2043          	jra	L5553
7853  13f3               L7753:
7854                     ; 1355 	else if(rx_read_power_102m_phase==7)
7856  13f3 c60000        	ld	a,_rx_read_power_102m_phase
7857  13f6 a107          	cp	a,#7
7858  13f8 2615          	jrne	L5063
7859                     ; 1357 		if(((rx_buffer[rx_wr_index]&0x7f)==')')/*&&(rx_buffer[0]==0x81)*/)
7861  13fa 5f            	clrw	x
7862  13fb b632          	ld	a,_rx_wr_index
7863  13fd 2a01          	jrpl	L602
7864  13ff 53            	cplw	x
7865  1400               L602:
7866  1400 97            	ld	xl,a
7867  1401 e637          	ld	a,(_rx_buffer,x)
7868  1403 a47f          	and	a,#127
7869  1405 a129          	cp	a,#41
7870  1407 262d          	jrne	L5553
7871                     ; 1359 			rx_read_power_102m_phase=8;
7873  1409 35080000      	mov	_rx_read_power_102m_phase,#8
7874  140d 2027          	jra	L5553
7875  140f               L5063:
7876                     ; 1363 	else if(rx_read_power_102m_phase==8)
7878  140f c60000        	ld	a,_rx_read_power_102m_phase
7879  1412 a108          	cp	a,#8
7880  1414 2615          	jrne	L3163
7881                     ; 1365 		if(((rx_buffer[rx_wr_index]&0x7f)==0x03)/*&&(rx_buffer[0]==0x81)*/)
7883  1416 5f            	clrw	x
7884  1417 b632          	ld	a,_rx_wr_index
7885  1419 2a01          	jrpl	L012
7886  141b 53            	cplw	x
7887  141c               L012:
7888  141c 97            	ld	xl,a
7889  141d e637          	ld	a,(_rx_buffer,x)
7890  141f a47f          	and	a,#127
7891  1421 a103          	cp	a,#3
7892  1423 2611          	jrne	L5553
7893                     ; 1367 			rx_read_power_102m_phase=9;
7895  1425 35090000      	mov	_rx_read_power_102m_phase,#9
7896  1429 200b          	jra	L5553
7897  142b               L3163:
7898                     ; 1370 	else if(rx_read_power_102m_phase==9)
7900  142b c60000        	ld	a,_rx_read_power_102m_phase
7901  142e a109          	cp	a,#9
7902  1430 2604          	jrne	L5553
7903                     ; 1374 			rx_read_power_102m_phase=10;
7905  1432 350a0000      	mov	_rx_read_power_102m_phase,#10
7906  1436               L5553:
7907                     ; 1377 		if(temp==0xca)
7909  1436 7b04          	ld	a,(OFST-1,sp)
7910  1438 a1ca          	cp	a,#202
7911  143a 261c          	jrne	L3263
7912                     ; 1381 			temp_rx_wr_index=rx_wr_index;
7914  143c b632          	ld	a,_rx_wr_index
7915  143e 6b05          	ld	(OFST+0,sp),a
7916                     ; 1382 			temp_rx_wr_index-=5;
7918  1440 7b05          	ld	a,(OFST+0,sp)
7919  1442 a005          	sub	a,#5
7920  1444 6b05          	ld	(OFST+0,sp),a
7921                     ; 1384 			if(rx_buffer[temp_rx_wr_index]==0xac)
7923  1446 7b05          	ld	a,(OFST+0,sp)
7924  1448 5f            	clrw	x
7925  1449 97            	ld	xl,a
7926  144a e637          	ld	a,(_rx_buffer,x)
7927  144c a1ac          	cp	a,#172
7928  144e 2608          	jrne	L3263
7929                     ; 1386 				bTRANSMIT_TO_STEND=1;
7931  1450 35010033      	mov	_bTRANSMIT_TO_STEND,#1
7932                     ; 1387 				power_cnt_block=30;
7934  1454 351e0002      	mov	_power_cnt_block,#30
7935  1458               L3263:
7936                     ; 1406 	rx_wr_index++;
7938  1458 3c32          	inc	_rx_wr_index
7939  145a               L1253:
7940                     ; 1412 }
7943  145a 5b05          	addw	sp,#5
7944  145c 85            	popw	x
7945  145d bf00          	ldw	c_y,x
7946  145f 320002        	pop	c_y+2
7947  1462 85            	popw	x
7948  1463 bf00          	ldw	c_x,x
7949  1465 320002        	pop	c_x+2
7950  1468 80            	iret
8007                     ; 1415 @far @interrupt void ADC_EOC_Interrupt (void) {
8008                     	switch	.text
8009  1469               f_ADC_EOC_Interrupt:
8011       00000009      OFST:	set	9
8012  1469 be00          	ldw	x,c_x
8013  146b 89            	pushw	x
8014  146c be00          	ldw	x,c_y
8015  146e 89            	pushw	x
8016  146f be02          	ldw	x,c_lreg+2
8017  1471 89            	pushw	x
8018  1472 be00          	ldw	x,c_lreg
8019  1474 89            	pushw	x
8020  1475 5209          	subw	sp,#9
8023                     ; 1420 		GPIOA->DDR|=(1<<1);
8025  1477 72125002      	bset	20482,#1
8026                     ; 1421 		GPIOA->CR1|=(1<<1);
8028  147b 72125003      	bset	20483,#1
8029                     ; 1422 		GPIOA->CR2&=~(1<<1);	
8031  147f 72135004      	bres	20484,#1
8032                     ; 1423 		GPIOA->ODR|=(1<<1);
8034  1483 72125000      	bset	20480,#1
8035                     ; 1425 ADC1->CSR&=~(1<<7);
8037  1487 721f5400      	bres	21504,#7
8038                     ; 1427 temp_adc=(((signed long)(ADC1->DRH))*256)+((signed long)(ADC1->DRL));
8040  148b c65405        	ld	a,21509
8041  148e b703          	ld	c_lreg+3,a
8042  1490 3f02          	clr	c_lreg+2
8043  1492 3f01          	clr	c_lreg+1
8044  1494 3f00          	clr	c_lreg
8045  1496 96            	ldw	x,sp
8046  1497 1c0001        	addw	x,#OFST-8
8047  149a 8d000000      	callf	d_rtol
8049  149e c65404        	ld	a,21508
8050  14a1 5f            	clrw	x
8051  14a2 97            	ld	xl,a
8052  14a3 90ae0100      	ldw	y,#256
8053  14a7 8d000000      	callf	d_umul
8055  14ab 96            	ldw	x,sp
8056  14ac 1c0001        	addw	x,#OFST-8
8057  14af 8d000000      	callf	d_ladd
8059  14b3 96            	ldw	x,sp
8060  14b4 1c0006        	addw	x,#OFST-3
8061  14b7 8d000000      	callf	d_rtol
8063                     ; 1433 adc_buff[adc_ch][adc_cnt]=temp_adc;
8065  14bb c600a8        	ld	a,_adc_cnt
8066  14be 5f            	clrw	x
8067  14bf 97            	ld	xl,a
8068  14c0 58            	sllw	x
8069  14c1 1f03          	ldw	(OFST-6,sp),x
8070  14c3 c600a9        	ld	a,_adc_ch
8071  14c6 97            	ld	xl,a
8072  14c7 a620          	ld	a,#32
8073  14c9 42            	mul	x,a
8074  14ca 72fb03        	addw	x,(OFST-6,sp)
8075  14cd 1608          	ldw	y,(OFST-1,sp)
8076  14cf df0068        	ldw	(_adc_buff,x),y
8077                     ; 1438 adc_ch++;
8079  14d2 725c00a9      	inc	_adc_ch
8080                     ; 1439 if(adc_ch>=2)
8082  14d6 c600a9        	ld	a,_adc_ch
8083  14d9 a102          	cp	a,#2
8084  14db 2517          	jrult	L5563
8085                     ; 1443 	adc_plazma++;
8087  14dd 725c00aa      	inc	_adc_plazma
8088                     ; 1444 	adc_ch=0;
8090  14e1 725f00a9      	clr	_adc_ch
8091                     ; 1445 	adc_cnt++;
8093  14e5 725c00a8      	inc	_adc_cnt
8094                     ; 1446 	if(adc_cnt>=16)
8096  14e9 c600a8        	ld	a,_adc_cnt
8097  14ec a110          	cp	a,#16
8098  14ee 2504          	jrult	L5563
8099                     ; 1448 		adc_cnt=0;
8101  14f0 725f00a8      	clr	_adc_cnt
8102  14f4               L5563:
8103                     ; 1452 if((adc_cnt&0x03)==0)
8105  14f4 c600a8        	ld	a,_adc_cnt
8106  14f7 a503          	bcp	a,#3
8107  14f9 2676          	jrne	L1663
8108                     ; 1456 	tempSS=0;
8110  14fb ae0000        	ldw	x,#0
8111  14fe 1f08          	ldw	(OFST-1,sp),x
8112  1500 ae0000        	ldw	x,#0
8113  1503 1f06          	ldw	(OFST-3,sp),x
8114                     ; 1460 	for(i=0;i<16;i++)
8116  1505 0f05          	clr	(OFST-4,sp)
8117  1507               L3663:
8118                     ; 1462 		tempSS+=(signed long)adc_buff[adc_ch][i];
8120  1507 7b05          	ld	a,(OFST-4,sp)
8121  1509 5f            	clrw	x
8122  150a 97            	ld	xl,a
8123  150b 58            	sllw	x
8124  150c 1f03          	ldw	(OFST-6,sp),x
8125  150e c600a9        	ld	a,_adc_ch
8126  1511 97            	ld	xl,a
8127  1512 a620          	ld	a,#32
8128  1514 42            	mul	x,a
8129  1515 72fb03        	addw	x,(OFST-6,sp)
8130  1518 de0068        	ldw	x,(_adc_buff,x)
8131  151b 8d000000      	callf	d_itolx
8133  151f 96            	ldw	x,sp
8134  1520 1c0006        	addw	x,#OFST-3
8135  1523 8d000000      	callf	d_lgadd
8137                     ; 1460 	for(i=0;i<16;i++)
8139  1527 0c05          	inc	(OFST-4,sp)
8142  1529 7b05          	ld	a,(OFST-4,sp)
8143  152b a110          	cp	a,#16
8144  152d 25d8          	jrult	L3663
8145                     ; 1464 	if(adc_ch==0)adc_buff_[adc_ch]=(signed short)(tempSS>>2);
8147  152f 725d00a9      	tnz	_adc_ch
8148  1533 261f          	jrne	L1763
8151  1535 96            	ldw	x,sp
8152  1536 1c0006        	addw	x,#OFST-3
8153  1539 8d000000      	callf	d_ltor
8155  153d a602          	ld	a,#2
8156  153f 8d000000      	callf	d_lrsh
8158  1543 be02          	ldw	x,c_lreg+2
8159  1545 c600a9        	ld	a,_adc_ch
8160  1548 905f          	clrw	y
8161  154a 9097          	ld	yl,a
8162  154c 9058          	sllw	y
8163  154e 90df0064      	ldw	(_adc_buff_,y),x
8165  1552 201d          	jra	L1663
8166  1554               L1763:
8167                     ; 1465 	else adc_buff_[adc_ch]=(signed short)(tempSS>>4);
8169  1554 96            	ldw	x,sp
8170  1555 1c0006        	addw	x,#OFST-3
8171  1558 8d000000      	callf	d_ltor
8173  155c a604          	ld	a,#4
8174  155e 8d000000      	callf	d_lrsh
8176  1562 be02          	ldw	x,c_lreg+2
8177  1564 c600a9        	ld	a,_adc_ch
8178  1567 905f          	clrw	y
8179  1569 9097          	ld	yl,a
8180  156b 9058          	sllw	y
8181  156d 90df0064      	ldw	(_adc_buff_,y),x
8182  1571               L1663:
8183                     ; 1474 adc_plazma_short=adc_buff_[1];
8185  1571 ce0066        	ldw	x,_adc_buff_+2
8186  1574 cf0062        	ldw	_adc_plazma_short,x
8187                     ; 1484 GPIOD->ODR|=(1<<0);
8189  1577 7210500f      	bset	20495,#0
8190                     ; 1488 		GPIOA->ODR&=~(1<<1);
8192  157b 72135000      	bres	20480,#1
8193                     ; 1489 }
8196  157f 5b09          	addw	sp,#9
8197  1581 85            	popw	x
8198  1582 bf00          	ldw	c_lreg,x
8199  1584 85            	popw	x
8200  1585 bf02          	ldw	c_lreg+2,x
8201  1587 85            	popw	x
8202  1588 bf00          	ldw	c_y,x
8203  158a 85            	popw	x
8204  158b bf00          	ldw	c_x,x
8205  158d 80            	iret
8244                     ; 1492 @far @interrupt void PORTD_Interrupt (void)
8244                     ; 1493 {
8245                     	switch	.text
8246  158e               f_PORTD_Interrupt:
8248       00000001      OFST:	set	1
8249  158e 88            	push	a
8252                     ; 1499 pin_temp=GPIOD->IDR&0x0f;
8254  158f c65010        	ld	a,20496
8255  1592 a40f          	and	a,#15
8256  1594 6b01          	ld	(OFST+0,sp),a
8257                     ; 1502 data_temp=(pin_temp&0x0c)>>2;
8259  1596 7b01          	ld	a,(OFST+0,sp)
8260  1598 a40c          	and	a,#12
8261  159a 44            	srl	a
8262  159b 44            	srl	a
8263  159c c70000        	ld	_data_temp,a
8264                     ; 1503 control_temp=(pin_temp&0x03);
8266  159f 7b01          	ld	a,(OFST+0,sp)
8267  15a1 a403          	and	a,#3
8268  15a3 c70000        	ld	_control_temp,a
8269                     ; 1506 puart_data_temp|=(data_temp<<(control_temp*2));
8271  15a6 c60000        	ld	a,_control_temp
8272  15a9 48            	sll	a
8273  15aa 5f            	clrw	x
8274  15ab 97            	ld	xl,a
8275  15ac c60000        	ld	a,_data_temp
8276  15af 5d            	tnzw	x
8277  15b0 2704          	jreq	L432
8278  15b2               L632:
8279  15b2 48            	sll	a
8280  15b3 5a            	decw	x
8281  15b4 26fc          	jrne	L632
8282  15b6               L432:
8283  15b6 ba00          	or	a,_puart_data_temp
8284  15b8 b700          	ld	_puart_data_temp,a
8285                     ; 1509 if(control_temp==0x03)
8287  15ba c60000        	ld	a,_control_temp
8288  15bd a103          	cp	a,#3
8289  15bf 2623          	jrne	L3173
8290                     ; 1513 	puart_rx_buffer[puart_rx_wr_index]=puart_data_temp;
8292  15c1 c60000        	ld	a,_puart_rx_wr_index
8293  15c4 5f            	clrw	x
8294  15c5 97            	ld	xl,a
8295  15c6 b600          	ld	a,_puart_data_temp
8296  15c8 d70000        	ld	(_puart_rx_buffer,x),a
8297                     ; 1514 	bPUART_RXIN=1;
8299  15cb 35010000      	mov	_bPUART_RXIN,#1
8300                     ; 1515 	puart_rx_wr_index++;
8302  15cf 725c0000      	inc	_puart_rx_wr_index
8303                     ; 1516 	if (puart_rx_wr_index >= PUART_RX_BUFFER_SIZE)
8305  15d3 c60000        	ld	a,_puart_rx_wr_index
8306  15d6 a140          	cp	a,#64
8307  15d8 2504          	jrult	L5173
8308                     ; 1518 		puart_rx_wr_index=0;
8310  15da 725f0000      	clr	_puart_rx_wr_index
8311  15de               L5173:
8312                     ; 1522 	if(puart_data_temp==0x0a)
8314  15de b600          	ld	a,_puart_data_temp
8315  15e0 a10a          	cp	a,#10
8316                     ; 1526 	puart_data_temp=0;
8318  15e2 3f00          	clr	_puart_data_temp
8319  15e4               L3173:
8320                     ; 1531 }
8323  15e4 84            	pop	a
8324  15e5 80            	iret
8390                     ; 1538 main(){
8391                     	switch	.text
8392  15e6               f_main:
8396                     ; 1539 	CLK->CKDIVR=0;
8398  15e6 725f50c6      	clr	20678
8399                     ; 1540 	FLASH_DUKR=0xae;
8401  15ea 35ae5064      	mov	_FLASH_DUKR,#174
8402                     ; 1541 	FLASH_DUKR=0x56;
8404  15ee 35565064      	mov	_FLASH_DUKR,#86
8405                     ; 1544 ee_reset_cnt++;
8407  15f2 ce0023        	ldw	x,_ee_reset_cnt
8408  15f5 1c0001        	addw	x,#1
8409  15f8 cf0023        	ldw	_ee_reset_cnt,x
8410                     ; 1545 if(ee_reset_cnt>=10000)ee_reset_cnt=0;
8412  15fb 9c            	rvf
8413  15fc ce0023        	ldw	x,_ee_reset_cnt
8414  15ff a32710        	cpw	x,#10000
8415  1602 2f0a          	jrslt	L1373
8418  1604 5f            	clrw	x
8419  1605 89            	pushw	x
8420  1606 ae0023        	ldw	x,#_ee_reset_cnt
8421  1609 8d000000      	callf	d_eewrw
8423  160d 85            	popw	x
8424  160e               L1373:
8425                     ; 1549 	t4_init();
8427  160e 8d540054      	callf	f_t4_init
8429                     ; 1560 	p_uart_rx_init();
8431  1612 8d000000      	callf	f_p_uart_rx_init
8433                     ; 1561 	p_uart_tx_init();	
8435  1616 8d000000      	callf	f_p_uart_tx_init
8437                     ; 1562 	uart_init();
8439  161a 8d820282      	callf	f_uart_init
8441                     ; 1564 	power_summary_impuls_cnt=ee_power_summary_impuls_cnt;
8443  161e ce0004        	ldw	x,_ee_power_summary_impuls_cnt+2
8444  1621 cf0047        	ldw	_power_summary_impuls_cnt+2,x
8445  1624 ce0002        	ldw	x,_ee_power_summary_impuls_cnt
8446  1627 cf0045        	ldw	_power_summary_impuls_cnt,x
8447                     ; 1568 	if(ee_T1_koef>1035)ee_T1_koef=1035;
8449  162a 9c            	rvf
8450  162b ce0021        	ldw	x,_ee_T1_koef
8451  162e a3040c        	cpw	x,#1036
8452  1631 2f0c          	jrslt	L3373
8455  1633 ae040b        	ldw	x,#1035
8456  1636 89            	pushw	x
8457  1637 ae0021        	ldw	x,#_ee_T1_koef
8458  163a 8d000000      	callf	d_eewrw
8460  163e 85            	popw	x
8461  163f               L3373:
8462                     ; 1569 	if(ee_T1_koef<1005)ee_T1_koef=1005;
8464  163f 9c            	rvf
8465  1640 ce0021        	ldw	x,_ee_T1_koef
8466  1643 a303ed        	cpw	x,#1005
8467  1646 2e0c          	jrsge	L5373
8470  1648 ae03ed        	ldw	x,#1005
8471  164b 89            	pushw	x
8472  164c ae0021        	ldw	x,#_ee_T1_koef
8473  164f 8d000000      	callf	d_eewrw
8475  1653 85            	popw	x
8476  1654               L5373:
8477                     ; 1571 	adc_init();
8479  1654 8d650065      	callf	f_adc_init
8481                     ; 1573 	enableInterrupts();	
8484  1658 9a            rim
8486  1659               L7373:
8487                     ; 1583 	if(bTRANSMIT_TO_STEND)
8489  1659 3d33          	tnz	_bTRANSMIT_TO_STEND
8490  165b 2713          	jreq	L3473
8491                     ; 1585 		for_stend_out(data_for_stend_char,adc_buff_[1]/*data_for_stend_short0*/,adc_buff_[0]/*data_for_stend_short1*/);	
8493  165d ce0064        	ldw	x,_adc_buff_
8494  1660 89            	pushw	x
8495  1661 ce0066        	ldw	x,_adc_buff_+2
8496  1664 89            	pushw	x
8497  1665 c60005        	ld	a,_data_for_stend_char
8498  1668 8de600e6      	callf	f_for_stend_out
8500  166c 5b04          	addw	sp,#4
8501                     ; 1586 		bTRANSMIT_TO_STEND=0;	
8503  166e 3f33          	clr	_bTRANSMIT_TO_STEND
8504  1670               L3473:
8505                     ; 1588      if(sleep_in) 
8507  1670 3d00          	tnz	_sleep_in
8508  1672 2706          	jreq	L5473
8509                     ; 1590           sleep_in=0;
8511  1674 3f00          	clr	_sleep_in
8512                     ; 1591           sleep_an();
8514  1676 8d000000      	callf	f_sleep_an
8516  167a               L5473:
8517                     ; 1593 	if(bPUART_RXIN)
8519  167a 3d00          	tnz	_bPUART_RXIN
8520  167c 2706          	jreq	L7473
8521                     ; 1595 		bPUART_RXIN=0;
8523  167e 3f00          	clr	_bPUART_RXIN
8524                     ; 1596 		puart_uart_in();
8526  1680 8d000000      	callf	f_puart_uart_in
8528  1684               L7473:
8529                     ; 1598 	if(bPUART_TX)
8531                     	btst	_bPUART_TX
8532  1689 2408          	jruge	L1573
8533                     ; 1600 		bPUART_TX=0;
8535  168b 72110003      	bres	_bPUART_TX
8536                     ; 1601 		puart_tx_drv();
8538  168f 8d000000      	callf	f_puart_tx_drv
8540  1693               L1573:
8541                     ; 1610 		if(bRXIN)	{
8543                     	btst	_bRXIN
8544  1698 2404          	jruge	L3573
8545                     ; 1611 			bRXIN=0;
8547  169a 72110001      	bres	_bRXIN
8548  169e               L3573:
8549                     ; 1617 	if(b100Hz)
8551                     	btst	_b100Hz
8552  16a3 240c          	jruge	L5573
8553                     ; 1619 		b100Hz=0;
8555  16a5 72110008      	bres	_b100Hz
8556                     ; 1624 		impuls_meter();
8558  16a9 8d240124      	callf	f_impuls_meter
8560                     ; 1625 read_power_102m_drv();		
8562  16ad 8d000000      	callf	f_read_power_102m_drv
8564  16b1               L5573:
8565                     ; 1628 	if(b10Hz)
8567                     	btst	_b10Hz
8568  16b6 2414          	jruge	L7573
8569                     ; 1630 		b10Hz=0;
8571  16b8 72110007      	bres	_b10Hz
8572                     ; 1632 		log_in_drv();
8574  16bc 8de20fe2      	callf	f_log_in_drv
8576                     ; 1634 		hummidity_drv();
8578  16c0 8d8a0b8a      	callf	f_hummidity_drv
8580                     ; 1635 		temper_drv();
8582  16c4 8d550c55      	callf	f_temper_drv
8584                     ; 1640 		adc_init();
8586  16c8 8d650065      	callf	f_adc_init
8588  16cc               L7573:
8589                     ; 1643 	if(b2Hz)
8591                     	btst	_b2Hz
8592  16d1 2416          	jruge	L1673
8593                     ; 1645 		b2Hz=0;
8595  16d3 72110005      	bres	_b2Hz
8596                     ; 1647 		matemat();
8598  16d7 8dae01ae      	callf	f_matemat
8600                     ; 1649 		data_out_hndl();
8602  16db 8d5e075e      	callf	f_data_out_hndl
8604                     ; 1651 		puart_out_adr (data_out,60);
8606  16df 4b3c          	push	#60
8607  16e1 ae0000        	ldw	x,#_data_out
8608  16e4 8d000000      	callf	f_puart_out_adr
8610  16e8 84            	pop	a
8611  16e9               L1673:
8612                     ; 1657 	if(b1Hz)
8614                     	btst	_b1Hz
8615  16ee 2504ac591659  	jruge	L7373
8616                     ; 1659 		b1Hz=0;
8618  16f4 72110004      	bres	_b1Hz
8619                     ; 1661 		pavl++;
8621  16f8 3c00          	inc	_pavl
8622                     ; 1663 		if(main_cnt<1000) main_cnt++;
8624  16fa 9c            	rvf
8625  16fb ce003f        	ldw	x,_main_cnt
8626  16fe a303e8        	cpw	x,#1000
8627  1701 2e09          	jrsge	L5673
8630  1703 ce003f        	ldw	x,_main_cnt
8631  1706 1c0001        	addw	x,#1
8632  1709 cf003f        	ldw	_main_cnt,x
8633  170c               L5673:
8634                     ; 1665 		ee_reset_cnt_++;
8636  170c ce0000        	ldw	x,_ee_reset_cnt_
8637  170f 1c0001        	addw	x,#1
8638  1712 cf0000        	ldw	_ee_reset_cnt_,x
8639                     ; 1667 		GPIOF->DDR|=(1<<4);
8641  1715 7218501b      	bset	20507,#4
8642                     ; 1668 		GPIOF->CR1|=(1<<4);
8644  1719 7218501c      	bset	20508,#4
8645                     ; 1669 		GPIOF->CR2&=~(1<<4);	
8647  171d 7219501d      	bres	20509,#4
8648                     ; 1671 		if(main_cnt<7)GPIOF->ODR&=~(1<<4);
8650  1721 9c            	rvf
8651  1722 ce003f        	ldw	x,_main_cnt
8652  1725 a30007        	cpw	x,#7
8653  1728 2e06          	jrsge	L7673
8656  172a 72195019      	bres	20505,#4
8658  172e 2008          	jra	L1773
8659  1730               L7673:
8660                     ; 1672 		else GPIOF->ODR^=(1<<4);	
8662  1730 c65019        	ld	a,20505
8663  1733 a810          	xor	a,	#16
8664  1735 c75019        	ld	20505,a
8665  1738               L1773:
8666                     ; 1674 		if(power_cnt_block)power_cnt_block--;
8668  1738 725d0002      	tnz	_power_cnt_block
8669  173c 2708          	jreq	L3773
8672  173e 725a0002      	dec	_power_cnt_block
8674  1742 ac591659      	jpf	L7373
8675  1746               L3773:
8676                     ; 1678 			if(!ppp_cnt)
8678  1746 725d0010      	tnz	_ppp_cnt
8679  174a 2612          	jrne	L7773
8680                     ; 1680 				power_cnt_adrl=(char)ee_power_cnt_adr;
8682  174c 5500260035    	mov	_power_cnt_adrl,_ee_power_cnt_adr+1
8683                     ; 1681 				power_cnt_adrh=(char)(ee_power_cnt_adr>>8);
8685  1751 5500250034    	mov	_power_cnt_adrh,_ee_power_cnt_adr
8686                     ; 1683 				ppp_cnt=1;
8688  1756 35010010      	mov	_ppp_cnt,#1
8690  175a ac591659      	jpf	L7373
8691  175e               L7773:
8692                     ; 1685 			else if(ppp_cnt==1)
8694  175e c60010        	ld	a,_ppp_cnt
8695  1761 a101          	cp	a,#1
8696  1763 2608          	jrne	L3004
8697                     ; 1688 				ppp_cnt=2;
8699  1765 35020010      	mov	_ppp_cnt,#2
8701  1769 ac591659      	jpf	L7373
8702  176d               L3004:
8703                     ; 1691 			else if(ppp_cnt==2)
8705  176d c60010        	ld	a,_ppp_cnt
8706  1770 a102          	cp	a,#2
8707  1772 260c          	jrne	L7004
8708                     ; 1693 				read_power_102m();
8710  1774 8d000000      	callf	f_read_power_102m
8712                     ; 1694 				ppp_cnt=3;
8714  1778 35030010      	mov	_ppp_cnt,#3
8716  177c ac591659      	jpf	L7373
8717  1780               L7004:
8718                     ; 1698 				ppp_cnt=0;
8720  1780 725f0010      	clr	_ppp_cnt
8721  1784 ac591659      	jpf	L7373
10048                     	xdef	f_main
10049                     	xdef	f_PORTD_Interrupt
10050                     	xdef	f_ADC_EOC_Interrupt
10051                     	xdef	f_log_in_drv
10052                     	xdef	f_temper_drv
10053                     	xdef	f_hummidity_drv
10054                     	xdef	f_data_out_hndl
10055                     	xdef	f_matemat
10056                     	xdef	f_impuls_meter
10057                     	xdef	f_for_stend_out
10058                     	xdef	f_adc_init
10059                     	xdef	f_gran_char
10060                     	switch	.ubsct
10061  0000               _pavl:
10062  0000 00            	ds.b	1
10063                     	xdef	_pavl
10064                     	switch	.bss
10065  0000               _tx_stat_cnt:
10066  0000 00            	ds.b	1
10067                     	xdef	_tx_stat_cnt
10068                     	xdef	_power_cnt_block
10069  0001               _data_for_stend_short1:
10070  0001 0000          	ds.b	2
10071                     	xdef	_data_for_stend_short1
10072  0003               _data_for_stend_short0:
10073  0003 0000          	ds.b	2
10074                     	xdef	_data_for_stend_short0
10075  0005               _data_for_stend_char:
10076  0005 00            	ds.b	1
10077                     	xdef	_data_for_stend_char
10078  0006               _data_for_stend:
10079  0006 000000000000  	ds.b	8
10080                     	xdef	_data_for_stend
10081  000e               _impuls_cnt:
10082  000e 0000          	ds.b	2
10083                     	xdef	_impuls_cnt
10084                     	xdef	__serial
10085                     	xdef	_ee_reset_cnt_
10086  0010               _ppp_cnt:
10087  0010 00            	ds.b	1
10088                     	xdef	_ppp_cnt
10089  0011               _log_in_cnt:
10090  0011 000000000000  	ds.b	8
10091                     	xdef	_log_in_cnt
10092  0019               _UIB:
10093  0019 000000000000  	ds.b	8
10094                     	xdef	_UIB
10095  0021               _buff:
10096  0021 000000000000  	ds.b	30
10097                     	xdef	_buff
10098                     .bit:	section	.data,bit
10099  0000               _rx_buffer_overflow:
10100  0000 00            	ds.b	1
10101                     	xdef	_rx_buffer_overflow
10102  0001               _bRXIN:
10103  0001 00            	ds.b	1
10104                     	xdef	_bRXIN
10105  0002               _bOUT_FREE:
10106  0002 00            	ds.b	1
10107                     	xdef	_bOUT_FREE
10108  0003               _bPUART_TX:
10109  0003 00            	ds.b	1
10110                     	xdef	_bPUART_TX
10111  0004               _b1Hz:
10112  0004 00            	ds.b	1
10113                     	xdef	_b1Hz
10114  0005               _b2Hz:
10115  0005 00            	ds.b	1
10116                     	xdef	_b2Hz
10117  0006               _b5Hz:
10118  0006 00            	ds.b	1
10119                     	xdef	_b5Hz
10120  0007               _b10Hz:
10121  0007 00            	ds.b	1
10122                     	xdef	_b10Hz
10123  0008               _b100Hz:
10124  0008 00            	ds.b	1
10125                     	xdef	_b100Hz
10126                     	switch	.ubsct
10127  0001               _adc_sigma_res:
10128  0001 000000000000  	ds.b	6
10129                     	xdef	_adc_sigma_res
10130  0007               _adc_sigma:
10131  0007 000000000000  	ds.b	12
10132                     	xdef	_adc_sigma
10133  0013               _adc_gorb_cnt:
10134  0013 000000000000  	ds.b	6
10135                     	xdef	_adc_gorb_cnt
10136  0019               _adc_cnt_zero:
10137  0019 000000        	ds.b	3
10138                     	xdef	_adc_cnt_zero
10139                     	xdef	_rele_cnt_const
10140  001c               _adcw:
10141  001c 000000000000  	ds.b	6
10142                     	xdef	_adcw
10143  0022               _rx_offset:
10144  0022 00            	ds.b	1
10145                     	xdef	_rx_offset
10146  0023               _rx_data:
10147  0023 00            	ds.b	1
10148                     	xdef	_rx_data
10149  0024               _rx_status:
10150  0024 00            	ds.b	1
10151                     	xdef	_rx_status
10152  0025               _rs_data:
10153  0025 000000000000  	ds.b	7
10154                     	xdef	_rs_data
10155                     	xdef	_but_drv_cnt
10156  002c               _sample:
10157  002c 00            	ds.b	1
10158                     	xdef	_sample
10159  002d               _rx_counter:
10160  002d 0000          	ds.b	2
10161                     	xdef	_rx_counter
10162                     	xdef	_rx_buffer
10163  002f               _sample_cnt:
10164  002f 0000          	ds.b	2
10165                     	xdef	_sample_cnt
10166                     	switch	.bss
10167  003f               _main_cnt:
10168  003f 0000          	ds.b	2
10169                     	xdef	_main_cnt
10170                     	xdef	_t0_cnt4
10171                     	xdef	_t0_cnt3
10172                     	xdef	_t0_cnt2
10173                     	xdef	_t0_cnt1
10174                     	xdef	_t0_cnt0
10175                     	xref	f_read_power_102m_drv
10176                     	xref	f_read_power_102m
10177                     	xref	f_sleep_an
10178                     	xref	_rx_read_power_102m_phase
10179                     	xref.b	_sleep_len
10180                     	xref.b	_sleep_in
10181                     	xref.b	_sleep_buff
10182                     	xref.b	_tx_stat
10183                     	xref.b	_tx_wd_cnt
10184                     	xref	f_puart_out
10185                     	xref	f_puart_out_adr
10186                     	xref	f_puart_tx_drv
10187                     	xref	f_uart_out_adr
10188                     	xref	f_p_uart_tx_init
10189                     	xref	f_puart_uart_in
10190                     	xref	f_p_uart_rx_init
10191                     	xref	_data_out
10192                     	xref	_control_temp
10193                     	xref	_data_temp
10194                     	xref.b	_bPUART_RXIN
10195                     	xref	_puart_rx_wr_index
10196                     	xref	_puart_rx_buffer
10197                     	xref.b	_puart_data_temp
10198                     	switch	.ubsct
10199  0031               _rx_rd_index:
10200  0031 00            	ds.b	1
10201                     	xdef	_rx_rd_index
10202  0032               _rx_wr_index:
10203  0032 00            	ds.b	1
10204                     	xdef	_rx_wr_index
10205                     	xdef	f_trap_send
10206                     .eeprom:	section	.data
10207  0000               _ee_impuls_per_kwatt:
10208  0000 0000          	ds.b	2
10209                     	xdef	_ee_impuls_per_kwatt
10210                     	switch	.bss
10211  0041               _power_summary_impuls:
10212  0041 00000000      	ds.b	4
10213                     	xdef	_power_summary_impuls
10214                     	switch	.eeprom
10215  0002               _ee_power_summary_impuls_cnt:
10216  0002 00000000      	ds.b	4
10217                     	xdef	_ee_power_summary_impuls_cnt
10218                     	switch	.bss
10219  0045               _power_summary_impuls_cnt:
10220  0045 00000000      	ds.b	4
10221                     	xdef	_power_summary_impuls_cnt
10222                     	xdef	_power_current
10223                     	xdef	_power_summary
10224                     	xdef	f_uart_in_an
10225                     	xdef	f_control_check
10226                     	xdef	f_index_offset
10227                     	xdef	f_uart_in
10228                     	xdef	f_gpio_init
10229                     	xdef	f_uart_init
10230                     	xdef	f_UARTRxInterrupt
10231                     	xdef	f_UARTTxInterrupt
10232                     	xref	f_putchar
10233                     	xdef	f_uart_out_adr_block
10234                     	xdef	f_uart_out
10235                     	xdef	f_TIM4_UPD_Interrupt
10236                     	xdef	f_delay_ms
10237                     	xdef	f_t4_init
10238                     	xdef	f_t2_init
10239                     	switch	.ubsct
10240  0033               _bTRANSMIT_TO_STEND:
10241  0033 00            	ds.b	1
10242                     	xdef	_bTRANSMIT_TO_STEND
10243                     	switch	.eeprom
10244  0006               _ee_H1_logic:
10245  0006 00            	ds.b	1
10246                     	xdef	_ee_H1_logic
10247                     	switch	.bss
10248  0049               _hummidity_alarm_stat_old:
10249  0049 00            	ds.b	1
10250                     	xdef	_hummidity_alarm_stat_old
10251  004a               _hummidity_alarm_stat:
10252  004a 00            	ds.b	1
10253                     	xdef	_hummidity_alarm_stat
10254  004b               _hummidity_alarm_cnt:
10255  004b 00            	ds.b	1
10256                     	xdef	_hummidity_alarm_cnt
10257                     	switch	.eeprom
10258  0007               _ee_hummidity_trap_send_no_av:
10259  0007 00            	ds.b	1
10260                     	xdef	_ee_hummidity_trap_send_no_av
10261  0008               _ee_hummidity_trap_send_av:
10262  0008 00            	ds.b	1
10263                     	xdef	_ee_hummidity_trap_send_av
10264  0009               _ee_H1_porog:
10265  0009 0000          	ds.b	2
10266                     	xdef	_ee_H1_porog
10267                     	switch	.bss
10268  004c               _H1:
10269  004c 0000          	ds.b	2
10270                     	xdef	_H1
10271  004e               _T2_porog2_cnt:
10272  004e 0000          	ds.b	2
10273                     	xdef	_T2_porog2_cnt
10274  0050               _T2_porog1_cnt:
10275  0050 0000          	ds.b	2
10276                     	xdef	_T2_porog1_cnt
10277  0052               _T1_porog2_cnt:
10278  0052 0000          	ds.b	2
10279                     	xdef	_T1_porog2_cnt
10280  0054               _T1_porog1_cnt:
10281  0054 0000          	ds.b	2
10282                     	xdef	_T1_porog1_cnt
10283  0056               _T2_status2_old:
10284  0056 00            	ds.b	1
10285                     	xdef	_T2_status2_old
10286  0057               _T2_status1_old:
10287  0057 00            	ds.b	1
10288                     	xdef	_T2_status1_old
10289  0058               _T2_status2:
10290  0058 00            	ds.b	1
10291                     	xdef	_T2_status2
10292  0059               _T2_status1:
10293  0059 00            	ds.b	1
10294                     	xdef	_T2_status1
10295  005a               _T1_status2_old:
10296  005a 00            	ds.b	1
10297                     	xdef	_T1_status2_old
10298  005b               _T1_status1_old:
10299  005b 00            	ds.b	1
10300                     	xdef	_T1_status1_old
10301  005c               _T1_status2:
10302  005c 00            	ds.b	1
10303                     	xdef	_T1_status2
10304  005d               _T1_status1:
10305  005d 00            	ds.b	1
10306                     	xdef	_T1_status1
10307                     	switch	.eeprom
10308  000b               _ee_T2_trap_send_no_av_2:
10309  000b 00            	ds.b	1
10310                     	xdef	_ee_T2_trap_send_no_av_2
10311  000c               _ee_T2_trap_send_av_2:
10312  000c 00            	ds.b	1
10313                     	xdef	_ee_T2_trap_send_av_2
10314  000d               _ee_T2_trap_send_no_av_1:
10315  000d 00            	ds.b	1
10316                     	xdef	_ee_T2_trap_send_no_av_1
10317  000e               _ee_T2_trap_send_av_1:
10318  000e 00            	ds.b	1
10319                     	xdef	_ee_T2_trap_send_av_1
10320  000f               _ee_T1_trap_send_no_av_2:
10321  000f 00            	ds.b	1
10322                     	xdef	_ee_T1_trap_send_no_av_2
10323  0010               _ee_T1_trap_send_av_2:
10324  0010 00            	ds.b	1
10325                     	xdef	_ee_T1_trap_send_av_2
10326  0011               _ee_T1_trap_send_no_av_1:
10327  0011 00            	ds.b	1
10328                     	xdef	_ee_T1_trap_send_no_av_1
10329  0012               _ee_T1_trap_send_av_1:
10330  0012 00            	ds.b	1
10331                     	xdef	_ee_T1_trap_send_av_1
10332  0013               _ee_T2_logic2:
10333  0013 00            	ds.b	1
10334                     	xdef	_ee_T2_logic2
10335  0014               _ee_T2_logic1:
10336  0014 00            	ds.b	1
10337                     	xdef	_ee_T2_logic1
10338  0015               _ee_T1_logic2:
10339  0015 00            	ds.b	1
10340                     	xdef	_ee_T1_logic2
10341  0016               _ee_T1_logic1:
10342  0016 00            	ds.b	1
10343                     	xdef	_ee_T1_logic1
10344  0017               _ee_T2_porog2:
10345  0017 0000          	ds.b	2
10346                     	xdef	_ee_T2_porog2
10347  0019               _ee_T2_porog1:
10348  0019 0000          	ds.b	2
10349                     	xdef	_ee_T2_porog1
10350  001b               _ee_T1_porog2:
10351  001b 0000          	ds.b	2
10352                     	xdef	_ee_T1_porog2
10353  001d               _ee_T1_porog1:
10354  001d 0000          	ds.b	2
10355                     	xdef	_ee_T1_porog1
10356  001f               _ee_T2_koef:
10357  001f 0000          	ds.b	2
10358                     	xdef	_ee_T2_koef
10359  0021               _ee_T1_koef:
10360  0021 0000          	ds.b	2
10361                     	xdef	_ee_T1_koef
10362                     	switch	.bss
10363  005e               _T2:
10364  005e 0000          	ds.b	2
10365                     	xdef	_T2
10366  0060               _T1:
10367  0060 0000          	ds.b	2
10368                     	xdef	_T1
10369  0062               _adc_plazma_short:
10370  0062 0000          	ds.b	2
10371                     	xdef	_adc_plazma_short
10372  0064               _adc_buff_:
10373  0064 00000000      	ds.b	4
10374                     	xdef	_adc_buff_
10375  0068               _adc_buff:
10376  0068 000000000000  	ds.b	64
10377                     	xdef	_adc_buff
10378  00a8               _adc_cnt:
10379  00a8 00            	ds.b	1
10380                     	xdef	_adc_cnt
10381  00a9               _adc_ch:
10382  00a9 00            	ds.b	1
10383                     	xdef	_adc_ch
10384  00aa               _adc_plazma:
10385  00aa 00            	ds.b	1
10386                     	xdef	_adc_plazma
10387                     	switch	.eeprom
10388  0023               _ee_reset_cnt:
10389  0023 0000          	ds.b	2
10390                     	xdef	_ee_reset_cnt
10391  0025               _ee_power_cnt_adr:
10392  0025 0000          	ds.b	2
10393                     	xdef	_ee_power_cnt_adr
10394                     	switch	.ubsct
10395  0034               _power_cnt_adrh:
10396  0034 00            	ds.b	1
10397                     	xdef	_power_cnt_adrh
10398  0035               _power_cnt_adrl:
10399  0035 00            	ds.b	1
10400                     	xdef	_power_cnt_adrl
10401  0036               _tx_rd_index:
10402  0036 00            	ds.b	1
10403                     	xdef	_tx_rd_index
10404  0037               _tx_wr_index:
10405  0037 00            	ds.b	1
10406                     	xdef	_tx_wr_index
10407                     	xdef	_tx_buffer
10408  0038               _tx_counter:
10409  0038 00            	ds.b	1
10410                     	xdef	_tx_counter
10411                     	switch	.bss
10412  00ab               _PUIB:
10413  00ab 000000000000  	ds.b	32
10414                     	xdef	_PUIB
10415                     	switch	.eeprom
10416  0027               _ee_log_in_trap_send_no_av:
10417  0027 000000000000  	ds.b	8
10418                     	xdef	_ee_log_in_trap_send_no_av
10419  002f               _ee_log_in_trap_send_av:
10420  002f 000000000000  	ds.b	8
10421                     	xdef	_ee_log_in_trap_send_av
10422  0037               _ee_log_in_stat_of_av:
10423  0037 000000000000  	ds.b	8
10424                     	xdef	_ee_log_in_stat_of_av
10425                     	switch	.bss
10426  00cb               _log_in_av_stat_old:
10427  00cb 000000000000  	ds.b	8
10428                     	xdef	_log_in_av_stat_old
10429  00d3               _log_in_av_stat:
10430  00d3 000000000000  	ds.b	8
10431                     	xdef	_log_in_av_stat
10432  00db               _log_in_stat:
10433  00db 000000000000  	ds.b	8
10434                     	xdef	_log_in_stat
10435                     	xref.b	c_lreg
10436                     	xref.b	c_x
10437                     	xref.b	c_y
10457                     	xref	d_eewrw
10458                     	xref	d_lrsh
10459                     	xref	d_lgadd
10460                     	xref	d_ladd
10461                     	xref	d_umul
10462                     	xref	d_lgursh
10463                     	xref	d_lglsh
10464                     	xref	d_lgsub
10465                     	xref	d_lgmul
10466                     	xref	d_ldiv
10467                     	xref	d_itolx
10468                     	xref	d_eewrl
10469                     	xref	d_lrzmp
10470                     	xref	d_lmod
10471                     	xref	d_idiv
10472                     	xref	d_lcmp
10473                     	xref	d_ltor
10474                     	xref	d_lgadc
10475                     	xref	d_rtol
10476                     	xref	d_vmul
10477                     	end
