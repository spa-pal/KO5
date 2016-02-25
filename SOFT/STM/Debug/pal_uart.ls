   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32.1 - 30 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2552                     ; 19 void p_uart_rx_init(void)
2552                     ; 20 {
2553                     	switch	.text
2554  0000               f_p_uart_rx_init:
2558                     ; 22 GPIOD->DDR&=~(1<<0);
2560  0000 72115011      	bres	20497,#0
2561                     ; 23 GPIOD->CR1|=(1<<0);
2563  0004 72105012      	bset	20498,#0
2564                     ; 24 GPIOD->CR2|=(1<<0);	
2566  0008 72105013      	bset	20499,#0
2567                     ; 27 GPIOD->DDR&=~(1<<1);
2569  000c 72135011      	bres	20497,#1
2570                     ; 28 GPIOD->CR1|=(1<<1);
2572  0010 72125012      	bset	20498,#1
2573                     ; 29 GPIOD->CR2&=~(1<<1);
2575  0014 72135013      	bres	20499,#1
2576                     ; 32 GPIOD->DDR&=~(1<<2);
2578  0018 72155011      	bres	20497,#2
2579                     ; 33 GPIOD->CR1|=(1<<2);
2581  001c 72145012      	bset	20498,#2
2582                     ; 34 GPIOD->CR2&=~(1<<2);	
2584  0020 72155013      	bres	20499,#2
2585                     ; 37 GPIOD->DDR&=~(1<<3);
2587  0024 72175011      	bres	20497,#3
2588                     ; 38 GPIOD->CR1|=(1<<3);
2590  0028 72165012      	bset	20498,#3
2591                     ; 39 GPIOD->CR2&=~(1<<3);
2593  002c 72175013      	bres	20499,#3
2594                     ; 41 EXTI->CR1=0xc0; 	//прерывание по любому фронту на порт D	
2596  0030 35c050a0      	mov	20640,#192
2597                     ; 43 }
2600  0034 87            	retf
2649                     ; 46 void puart_uart_in(void)
2649                     ; 47 {
2650                     	switch	.text
2651  0035               f_puart_uart_in:
2653  0035 89            	pushw	x
2654       00000002      OFST:	set	2
2657                     ; 50 if((puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-1)])==END)
2659  0036 aeffff        	ldw	x,#65535
2660  0039 89            	pushw	x
2661  003a c60069        	ld	a,_puart_rx_wr_index
2662  003d 5f            	clrw	x
2663  003e 97            	ld	xl,a
2664  003f 8dd100d1      	callf	f_puart_index_offset
2666  0043 5b02          	addw	sp,#2
2667  0045 d600aa        	ld	a,(_puart_rx_buffer,x)
2668  0048 a10a          	cp	a,#10
2669  004a 2704accf00cf  	jrne	L3661
2670                     ; 53 	temp=puart_rx_buffer[puart_index_offset(puart_rx_wr_index,-3)];
2672  0050 aefffd        	ldw	x,#65533
2673  0053 89            	pushw	x
2674  0054 c60069        	ld	a,_puart_rx_wr_index
2675  0057 5f            	clrw	x
2676  0058 97            	ld	xl,a
2677  0059 8dd100d1      	callf	f_puart_index_offset
2679  005d 5b02          	addw	sp,#2
2680  005f d600aa        	ld	a,(_puart_rx_buffer,x)
2681  0062 6b01          	ld	(OFST-1,sp),a
2682                     ; 54     	if(temp<100) 
2684  0064 7b01          	ld	a,(OFST-1,sp)
2685  0066 a164          	cp	a,#100
2686  0068 2465          	jruge	L3661
2687                     ; 56 		if(puart_control_check(puart_index_offset(puart_rx_wr_index,-1)))
2689  006a aeffff        	ldw	x,#65535
2690  006d 89            	pushw	x
2691  006e c60069        	ld	a,_puart_rx_wr_index
2692  0071 5f            	clrw	x
2693  0072 97            	ld	xl,a
2694  0073 8dd100d1      	callf	f_puart_index_offset
2696  0077 5b02          	addw	sp,#2
2697  0079 9f            	ld	a,xl
2698  007a 8df900f9      	callf	f_puart_control_check
2700  007e 4d            	tnz	a
2701  007f 274e          	jreq	L3661
2702                     ; 58     			puart_rx_rd_index=puart_index_offset(puart_rx_wr_index,-3-temp);
2704  0081 a6ff          	ld	a,#255
2705  0083 97            	ld	xl,a
2706  0084 a6fd          	ld	a,#253
2707  0086 1001          	sub	a,(OFST-1,sp)
2708  0088 2401          	jrnc	L01
2709  008a 5a            	decw	x
2710  008b               L01:
2711  008b 02            	rlwa	x,a
2712  008c 89            	pushw	x
2713  008d 01            	rrwa	x,a
2714  008e c60069        	ld	a,_puart_rx_wr_index
2715  0091 5f            	clrw	x
2716  0092 97            	ld	xl,a
2717  0093 8dd100d1      	callf	f_puart_index_offset
2719  0097 5b02          	addw	sp,#2
2720  0099 01            	rrwa	x,a
2721  009a c70068        	ld	_puart_rx_rd_index,a
2722  009d 02            	rlwa	x,a
2723                     ; 59     			for(i=0;i<temp;i++)
2725  009e 0f02          	clr	(OFST+0,sp)
2727  00a0 201e          	jra	L5761
2728  00a2               L1761:
2729                     ; 61 				PUIB[i]=puart_rx_buffer[puart_index_offset(puart_rx_rd_index,i)];
2731  00a2 7b02          	ld	a,(OFST+0,sp)
2732  00a4 5f            	clrw	x
2733  00a5 97            	ld	xl,a
2734  00a6 89            	pushw	x
2735  00a7 7b04          	ld	a,(OFST+2,sp)
2736  00a9 5f            	clrw	x
2737  00aa 97            	ld	xl,a
2738  00ab 89            	pushw	x
2739  00ac c60068        	ld	a,_puart_rx_rd_index
2740  00af 5f            	clrw	x
2741  00b0 97            	ld	xl,a
2742  00b1 8dd100d1      	callf	f_puart_index_offset
2744  00b5 5b02          	addw	sp,#2
2745  00b7 d600aa        	ld	a,(_puart_rx_buffer,x)
2746  00ba 85            	popw	x
2747  00bb d70000        	ld	(_PUIB,x),a
2748                     ; 59     			for(i=0;i<temp;i++)
2750  00be 0c02          	inc	(OFST+0,sp)
2751  00c0               L5761:
2754  00c0 7b02          	ld	a,(OFST+0,sp)
2755  00c2 1101          	cp	a,(OFST-1,sp)
2756  00c4 25dc          	jrult	L1761
2757                     ; 63 			puart_rx_rd_index=puart_rx_wr_index;
2759  00c6 5500690068    	mov	_puart_rx_rd_index,_puart_rx_wr_index
2760                     ; 65 			puart_uart_in_an();
2762  00cb 8d690169      	callf	f_puart_uart_in_an
2764  00cf               L3661:
2765                     ; 70 }
2768  00cf 85            	popw	x
2769  00d0 87            	retf
2811                     ; 73 signed short puart_index_offset (signed short index,signed short offset)
2811                     ; 74 {
2812                     	switch	.text
2813  00d1               f_puart_index_offset:
2815  00d1 89            	pushw	x
2816       00000000      OFST:	set	0
2819                     ; 75 index=index+offset;
2821  00d2 1e01          	ldw	x,(OFST+1,sp)
2822  00d4 72fb06        	addw	x,(OFST+6,sp)
2823  00d7 1f01          	ldw	(OFST+1,sp),x
2824                     ; 76 if(index>=PUART_RX_BUFFER_SIZE) index-=PUART_RX_BUFFER_SIZE; 
2826  00d9 9c            	rvf
2827  00da 1e01          	ldw	x,(OFST+1,sp)
2828  00dc a30040        	cpw	x,#64
2829  00df 2f07          	jrslt	L3271
2832  00e1 1e01          	ldw	x,(OFST+1,sp)
2833  00e3 1d0040        	subw	x,#64
2834  00e6 1f01          	ldw	(OFST+1,sp),x
2835  00e8               L3271:
2836                     ; 77 if(index<0) index+=PUART_RX_BUFFER_SIZE;
2838  00e8 9c            	rvf
2839  00e9 1e01          	ldw	x,(OFST+1,sp)
2840  00eb 2e07          	jrsge	L5271
2843  00ed 1e01          	ldw	x,(OFST+1,sp)
2844  00ef 1c0040        	addw	x,#64
2845  00f2 1f01          	ldw	(OFST+1,sp),x
2846  00f4               L5271:
2847                     ; 78 return index;
2849  00f4 1e01          	ldw	x,(OFST+1,sp)
2852  00f6 5b02          	addw	sp,#2
2853  00f8 87            	retf
2916                     ; 82 char puart_control_check(char index)
2916                     ; 83 {
2917                     	switch	.text
2918  00f9               f_puart_control_check:
2920  00f9 88            	push	a
2921  00fa 5203          	subw	sp,#3
2922       00000003      OFST:	set	3
2925                     ; 84 char i=0,ii=0,iii;
2929                     ; 86 if(puart_rx_buffer[index]!=END) return 0;
2931  00fc 5f            	clrw	x
2932  00fd 97            	ld	xl,a
2933  00fe d600aa        	ld	a,(_puart_rx_buffer,x)
2934  0101 a10a          	cp	a,#10
2935  0103 2703          	jreq	L1671
2938  0105 4f            	clr	a
2940  0106 205a          	jra	L22
2941  0108               L1671:
2942                     ; 88 ii=puart_rx_buffer[puart_index_offset(index,-2)];
2944  0108 aefffe        	ldw	x,#65534
2945  010b 89            	pushw	x
2946  010c 7b06          	ld	a,(OFST+3,sp)
2947  010e 5f            	clrw	x
2948  010f 97            	ld	xl,a
2949  0110 8dd100d1      	callf	f_puart_index_offset
2951  0114 5b02          	addw	sp,#2
2952  0116 d600aa        	ld	a,(_puart_rx_buffer,x)
2953  0119 6b02          	ld	(OFST-1,sp),a
2954                     ; 89 iii=0;
2956  011b 0f01          	clr	(OFST-2,sp)
2957                     ; 90 for(i=0;i<=ii;i++)
2959  011d 0f03          	clr	(OFST+0,sp)
2961  011f 2025          	jra	L7671
2962  0121               L3671:
2963                     ; 92 	iii^=puart_rx_buffer[puart_index_offset(index,-2-ii+i)];
2965  0121 a6ff          	ld	a,#255
2966  0123 97            	ld	xl,a
2967  0124 a6fe          	ld	a,#254
2968  0126 1002          	sub	a,(OFST-1,sp)
2969  0128 2401          	jrnc	L61
2970  012a 5a            	decw	x
2971  012b               L61:
2972  012b 1b03          	add	a,(OFST+0,sp)
2973  012d 2401          	jrnc	L02
2974  012f 5c            	incw	x
2975  0130               L02:
2976  0130 02            	rlwa	x,a
2977  0131 89            	pushw	x
2978  0132 01            	rrwa	x,a
2979  0133 7b06          	ld	a,(OFST+3,sp)
2980  0135 5f            	clrw	x
2981  0136 97            	ld	xl,a
2982  0137 8dd100d1      	callf	f_puart_index_offset
2984  013b 5b02          	addw	sp,#2
2985  013d 7b01          	ld	a,(OFST-2,sp)
2986  013f d800aa        	xor	a,	(_puart_rx_buffer,x)
2987  0142 6b01          	ld	(OFST-2,sp),a
2988                     ; 90 for(i=0;i<=ii;i++)
2990  0144 0c03          	inc	(OFST+0,sp)
2991  0146               L7671:
2994  0146 7b03          	ld	a,(OFST+0,sp)
2995  0148 1102          	cp	a,(OFST-1,sp)
2996  014a 23d5          	jrule	L3671
2997                     ; 94 if (iii!=puart_rx_buffer[puart_index_offset(index,-1)]) return 0;	
2999  014c aeffff        	ldw	x,#65535
3000  014f 89            	pushw	x
3001  0150 7b06          	ld	a,(OFST+3,sp)
3002  0152 5f            	clrw	x
3003  0153 97            	ld	xl,a
3004  0154 8dd100d1      	callf	f_puart_index_offset
3006  0158 5b02          	addw	sp,#2
3007  015a d600aa        	ld	a,(_puart_rx_buffer,x)
3008  015d 1101          	cp	a,(OFST-2,sp)
3009  015f 2704          	jreq	L3771
3012  0161 4f            	clr	a
3014  0162               L22:
3016  0162 5b04          	addw	sp,#4
3017  0164 87            	retf
3018  0165               L3771:
3019                     ; 96 return 1;
3021  0165 a601          	ld	a,#1
3023  0167 20f9          	jra	L22
3077                     ; 101 void puart_uart_in_an(void) 
3077                     ; 102 {
3078                     	switch	.text
3079  0169               f_puart_uart_in_an:
3081  0169 5208          	subw	sp,#8
3082       00000008      OFST:	set	8
3085                     ; 104 if((PUIB[0]==1)&&(PUIB[1]==2))
3087  016b c60000        	ld	a,_PUIB
3088  016e a101          	cp	a,#1
3089  0170 260b          	jrne	L5002
3091  0172 c60001        	ld	a,_PUIB+1
3092  0175 a102          	cp	a,#2
3093  0177 2604          	jrne	L021
3094  0179 aca907a9      	jpf	L7002
3095  017d               L021:
3097  017d               L5002:
3098                     ; 108 else if(PUIB[0]==55)
3100  017d c60000        	ld	a,_PUIB
3101  0180 a137          	cp	a,#55
3102  0182 2704          	jreq	L221
3103  0184 aca907a9      	jpf	L7002
3104  0188               L221:
3105                     ; 109 	{		FLASH_DUKR=0xae;
3107  0188 35ae5064      	mov	_FLASH_DUKR,#174
3108                     ; 110 		FLASH_DUKR=0x56;
3110  018c 35565064      	mov	_FLASH_DUKR,#86
3111                     ; 112 	if(PUIB[1]==1)
3113  0190 c60001        	ld	a,_PUIB+1
3114  0193 a101          	cp	a,#1
3115  0195 2618          	jrne	L3102
3116                     ; 114 		ee_log_in_stat_of_av[0]=PUIB[2]+(PUIB[3]*256);
3118  0197 c60003        	ld	a,_PUIB+3
3119  019a ae0008        	ldw	x,#8
3120  019d               L62:
3121  019d 48            	sll	a
3122  019e 5a            	decw	x
3123  019f 26fc          	jrne	L62
3124  01a1 cb0002        	add	a,_PUIB+2
3125  01a4 ae0000        	ldw	x,#_ee_log_in_stat_of_av
3126  01a7 8d000000      	callf	d_eewrc
3129  01ab aca907a9      	jpf	L7002
3130  01af               L3102:
3131                     ; 116 	else if(PUIB[1]==2)
3133  01af c60001        	ld	a,_PUIB+1
3134  01b2 a102          	cp	a,#2
3135  01b4 2618          	jrne	L7102
3136                     ; 118 		ee_log_in_stat_of_av[1]=PUIB[2]+(PUIB[3]*256);
3138  01b6 c60003        	ld	a,_PUIB+3
3139  01b9 ae0008        	ldw	x,#8
3140  01bc               L03:
3141  01bc 48            	sll	a
3142  01bd 5a            	decw	x
3143  01be 26fc          	jrne	L03
3144  01c0 cb0002        	add	a,_PUIB+2
3145  01c3 ae0001        	ldw	x,#_ee_log_in_stat_of_av+1
3146  01c6 8d000000      	callf	d_eewrc
3149  01ca aca907a9      	jpf	L7002
3150  01ce               L7102:
3151                     ; 120 	else if(PUIB[1]==3)
3153  01ce c60001        	ld	a,_PUIB+1
3154  01d1 a103          	cp	a,#3
3155  01d3 2618          	jrne	L3202
3156                     ; 122 		ee_log_in_stat_of_av[2]=PUIB[2]+(PUIB[3]*256);
3158  01d5 c60003        	ld	a,_PUIB+3
3159  01d8 ae0008        	ldw	x,#8
3160  01db               L23:
3161  01db 48            	sll	a
3162  01dc 5a            	decw	x
3163  01dd 26fc          	jrne	L23
3164  01df cb0002        	add	a,_PUIB+2
3165  01e2 ae0002        	ldw	x,#_ee_log_in_stat_of_av+2
3166  01e5 8d000000      	callf	d_eewrc
3169  01e9 aca907a9      	jpf	L7002
3170  01ed               L3202:
3171                     ; 124 	else if(PUIB[1]==4)
3173  01ed c60001        	ld	a,_PUIB+1
3174  01f0 a104          	cp	a,#4
3175  01f2 2618          	jrne	L7202
3176                     ; 126 		ee_log_in_stat_of_av[3]=PUIB[2]+(PUIB[3]*256);
3178  01f4 c60003        	ld	a,_PUIB+3
3179  01f7 ae0008        	ldw	x,#8
3180  01fa               L43:
3181  01fa 48            	sll	a
3182  01fb 5a            	decw	x
3183  01fc 26fc          	jrne	L43
3184  01fe cb0002        	add	a,_PUIB+2
3185  0201 ae0003        	ldw	x,#_ee_log_in_stat_of_av+3
3186  0204 8d000000      	callf	d_eewrc
3189  0208 aca907a9      	jpf	L7002
3190  020c               L7202:
3191                     ; 128 	else if(PUIB[1]==5)
3193  020c c60001        	ld	a,_PUIB+1
3194  020f a105          	cp	a,#5
3195  0211 2618          	jrne	L3302
3196                     ; 130 		ee_log_in_stat_of_av[4]=PUIB[2]+(PUIB[3]*256);
3198  0213 c60003        	ld	a,_PUIB+3
3199  0216 ae0008        	ldw	x,#8
3200  0219               L63:
3201  0219 48            	sll	a
3202  021a 5a            	decw	x
3203  021b 26fc          	jrne	L63
3204  021d cb0002        	add	a,_PUIB+2
3205  0220 ae0004        	ldw	x,#_ee_log_in_stat_of_av+4
3206  0223 8d000000      	callf	d_eewrc
3209  0227 aca907a9      	jpf	L7002
3210  022b               L3302:
3211                     ; 132 	else if(PUIB[1]==6)
3213  022b c60001        	ld	a,_PUIB+1
3214  022e a106          	cp	a,#6
3215  0230 2618          	jrne	L7302
3216                     ; 134 		ee_log_in_stat_of_av[5]=PUIB[2]+(PUIB[3]*256);
3218  0232 c60003        	ld	a,_PUIB+3
3219  0235 ae0008        	ldw	x,#8
3220  0238               L04:
3221  0238 48            	sll	a
3222  0239 5a            	decw	x
3223  023a 26fc          	jrne	L04
3224  023c cb0002        	add	a,_PUIB+2
3225  023f ae0005        	ldw	x,#_ee_log_in_stat_of_av+5
3226  0242 8d000000      	callf	d_eewrc
3229  0246 aca907a9      	jpf	L7002
3230  024a               L7302:
3231                     ; 138 	else if(PUIB[1]==7)
3233  024a c60001        	ld	a,_PUIB+1
3234  024d a107          	cp	a,#7
3235  024f 260e          	jrne	L3402
3236                     ; 140 		ee_log_in_trap_send_av[0]=PUIB[2];
3238  0251 c60002        	ld	a,_PUIB+2
3239  0254 ae0000        	ldw	x,#_ee_log_in_trap_send_av
3240  0257 8d000000      	callf	d_eewrc
3243  025b aca907a9      	jpf	L7002
3244  025f               L3402:
3245                     ; 142 	else if(PUIB[1]==8)
3247  025f c60001        	ld	a,_PUIB+1
3248  0262 a108          	cp	a,#8
3249  0264 2618          	jrne	L7402
3250                     ; 144 		ee_log_in_trap_send_av[1]=PUIB[2]+(PUIB[3]*256);
3252  0266 c60003        	ld	a,_PUIB+3
3253  0269 ae0008        	ldw	x,#8
3254  026c               L24:
3255  026c 48            	sll	a
3256  026d 5a            	decw	x
3257  026e 26fc          	jrne	L24
3258  0270 cb0002        	add	a,_PUIB+2
3259  0273 ae0001        	ldw	x,#_ee_log_in_trap_send_av+1
3260  0276 8d000000      	callf	d_eewrc
3263  027a aca907a9      	jpf	L7002
3264  027e               L7402:
3265                     ; 146 	else if(PUIB[1]==9)
3267  027e c60001        	ld	a,_PUIB+1
3268  0281 a109          	cp	a,#9
3269  0283 2618          	jrne	L3502
3270                     ; 148 		ee_log_in_trap_send_av[2]=PUIB[2]+(PUIB[3]*256);
3272  0285 c60003        	ld	a,_PUIB+3
3273  0288 ae0008        	ldw	x,#8
3274  028b               L44:
3275  028b 48            	sll	a
3276  028c 5a            	decw	x
3277  028d 26fc          	jrne	L44
3278  028f cb0002        	add	a,_PUIB+2
3279  0292 ae0002        	ldw	x,#_ee_log_in_trap_send_av+2
3280  0295 8d000000      	callf	d_eewrc
3283  0299 aca907a9      	jpf	L7002
3284  029d               L3502:
3285                     ; 150 	else if(PUIB[1]==10)
3287  029d c60001        	ld	a,_PUIB+1
3288  02a0 a10a          	cp	a,#10
3289  02a2 2618          	jrne	L7502
3290                     ; 152 		ee_log_in_trap_send_av[3]=PUIB[2]+(PUIB[3]*256);
3292  02a4 c60003        	ld	a,_PUIB+3
3293  02a7 ae0008        	ldw	x,#8
3294  02aa               L64:
3295  02aa 48            	sll	a
3296  02ab 5a            	decw	x
3297  02ac 26fc          	jrne	L64
3298  02ae cb0002        	add	a,_PUIB+2
3299  02b1 ae0003        	ldw	x,#_ee_log_in_trap_send_av+3
3300  02b4 8d000000      	callf	d_eewrc
3303  02b8 aca907a9      	jpf	L7002
3304  02bc               L7502:
3305                     ; 154 	else if(PUIB[1]==11)
3307  02bc c60001        	ld	a,_PUIB+1
3308  02bf a10b          	cp	a,#11
3309  02c1 2618          	jrne	L3602
3310                     ; 156 		ee_log_in_trap_send_av[4]=PUIB[2]+(PUIB[3]*256);
3312  02c3 c60003        	ld	a,_PUIB+3
3313  02c6 ae0008        	ldw	x,#8
3314  02c9               L05:
3315  02c9 48            	sll	a
3316  02ca 5a            	decw	x
3317  02cb 26fc          	jrne	L05
3318  02cd cb0002        	add	a,_PUIB+2
3319  02d0 ae0004        	ldw	x,#_ee_log_in_trap_send_av+4
3320  02d3 8d000000      	callf	d_eewrc
3323  02d7 aca907a9      	jpf	L7002
3324  02db               L3602:
3325                     ; 158 	else if(PUIB[1]==12)
3327  02db c60001        	ld	a,_PUIB+1
3328  02de a10c          	cp	a,#12
3329  02e0 2618          	jrne	L7602
3330                     ; 160 		ee_log_in_trap_send_av[5]=PUIB[2]+(PUIB[3]*256);
3332  02e2 c60003        	ld	a,_PUIB+3
3333  02e5 ae0008        	ldw	x,#8
3334  02e8               L25:
3335  02e8 48            	sll	a
3336  02e9 5a            	decw	x
3337  02ea 26fc          	jrne	L25
3338  02ec cb0002        	add	a,_PUIB+2
3339  02ef ae0005        	ldw	x,#_ee_log_in_trap_send_av+5
3340  02f2 8d000000      	callf	d_eewrc
3343  02f6 aca907a9      	jpf	L7002
3344  02fa               L7602:
3345                     ; 164 	else if(PUIB[1]==13)
3347  02fa c60001        	ld	a,_PUIB+1
3348  02fd a10d          	cp	a,#13
3349  02ff 2618          	jrne	L3702
3350                     ; 166 		ee_log_in_trap_send_no_av[0]=PUIB[2]+(PUIB[3]*256);
3352  0301 c60003        	ld	a,_PUIB+3
3353  0304 ae0008        	ldw	x,#8
3354  0307               L45:
3355  0307 48            	sll	a
3356  0308 5a            	decw	x
3357  0309 26fc          	jrne	L45
3358  030b cb0002        	add	a,_PUIB+2
3359  030e ae0000        	ldw	x,#_ee_log_in_trap_send_no_av
3360  0311 8d000000      	callf	d_eewrc
3363  0315 aca907a9      	jpf	L7002
3364  0319               L3702:
3365                     ; 168 	else if(PUIB[1]==14)
3367  0319 c60001        	ld	a,_PUIB+1
3368  031c a10e          	cp	a,#14
3369  031e 2618          	jrne	L7702
3370                     ; 170 		ee_log_in_trap_send_no_av[1]=PUIB[2]+(PUIB[3]*256);
3372  0320 c60003        	ld	a,_PUIB+3
3373  0323 ae0008        	ldw	x,#8
3374  0326               L65:
3375  0326 48            	sll	a
3376  0327 5a            	decw	x
3377  0328 26fc          	jrne	L65
3378  032a cb0002        	add	a,_PUIB+2
3379  032d ae0001        	ldw	x,#_ee_log_in_trap_send_no_av+1
3380  0330 8d000000      	callf	d_eewrc
3383  0334 aca907a9      	jpf	L7002
3384  0338               L7702:
3385                     ; 172 	else if(PUIB[1]==15)
3387  0338 c60001        	ld	a,_PUIB+1
3388  033b a10f          	cp	a,#15
3389  033d 2618          	jrne	L3012
3390                     ; 174 		ee_log_in_trap_send_no_av[2]=PUIB[2]+(PUIB[3]*256);
3392  033f c60003        	ld	a,_PUIB+3
3393  0342 ae0008        	ldw	x,#8
3394  0345               L06:
3395  0345 48            	sll	a
3396  0346 5a            	decw	x
3397  0347 26fc          	jrne	L06
3398  0349 cb0002        	add	a,_PUIB+2
3399  034c ae0002        	ldw	x,#_ee_log_in_trap_send_no_av+2
3400  034f 8d000000      	callf	d_eewrc
3403  0353 aca907a9      	jpf	L7002
3404  0357               L3012:
3405                     ; 176 	else if(PUIB[1]==16)
3407  0357 c60001        	ld	a,_PUIB+1
3408  035a a110          	cp	a,#16
3409  035c 2618          	jrne	L7012
3410                     ; 178 		ee_log_in_trap_send_no_av[3]=PUIB[2]+(PUIB[3]*256);
3412  035e c60003        	ld	a,_PUIB+3
3413  0361 ae0008        	ldw	x,#8
3414  0364               L26:
3415  0364 48            	sll	a
3416  0365 5a            	decw	x
3417  0366 26fc          	jrne	L26
3418  0368 cb0002        	add	a,_PUIB+2
3419  036b ae0003        	ldw	x,#_ee_log_in_trap_send_no_av+3
3420  036e 8d000000      	callf	d_eewrc
3423  0372 aca907a9      	jpf	L7002
3424  0376               L7012:
3425                     ; 180 	else if(PUIB[1]==17)
3427  0376 c60001        	ld	a,_PUIB+1
3428  0379 a111          	cp	a,#17
3429  037b 2618          	jrne	L3112
3430                     ; 182 		ee_log_in_trap_send_no_av[4]=PUIB[2]+(PUIB[3]*256);
3432  037d c60003        	ld	a,_PUIB+3
3433  0380 ae0008        	ldw	x,#8
3434  0383               L46:
3435  0383 48            	sll	a
3436  0384 5a            	decw	x
3437  0385 26fc          	jrne	L46
3438  0387 cb0002        	add	a,_PUIB+2
3439  038a ae0004        	ldw	x,#_ee_log_in_trap_send_no_av+4
3440  038d 8d000000      	callf	d_eewrc
3443  0391 aca907a9      	jpf	L7002
3444  0395               L3112:
3445                     ; 184 	else if(PUIB[1]==18)
3447  0395 c60001        	ld	a,_PUIB+1
3448  0398 a112          	cp	a,#18
3449  039a 2618          	jrne	L7112
3450                     ; 186 		ee_log_in_trap_send_no_av[5]=PUIB[2]+(PUIB[3]*256);
3452  039c c60003        	ld	a,_PUIB+3
3453  039f ae0008        	ldw	x,#8
3454  03a2               L66:
3455  03a2 48            	sll	a
3456  03a3 5a            	decw	x
3457  03a4 26fc          	jrne	L66
3458  03a6 cb0002        	add	a,_PUIB+2
3459  03a9 ae0005        	ldw	x,#_ee_log_in_trap_send_no_av+5
3460  03ac 8d000000      	callf	d_eewrc
3463  03b0 aca907a9      	jpf	L7002
3464  03b4               L7112:
3465                     ; 189 	else if(PUIB[1]==19)
3467  03b4 c60001        	ld	a,_PUIB+1
3468  03b7 a113          	cp	a,#19
3469  03b9 261d          	jrne	L3212
3470                     ; 191 		ee_power_cnt_adr=PUIB[2]+(PUIB[3]*256);
3472  03bb c60003        	ld	a,_PUIB+3
3473  03be 5f            	clrw	x
3474  03bf 97            	ld	xl,a
3475  03c0 4f            	clr	a
3476  03c1 02            	rlwa	x,a
3477  03c2 01            	rrwa	x,a
3478  03c3 cb0002        	add	a,_PUIB+2
3479  03c6 2401          	jrnc	L07
3480  03c8 5c            	incw	x
3481  03c9               L07:
3482  03c9 02            	rlwa	x,a
3483  03ca 89            	pushw	x
3484  03cb 01            	rrwa	x,a
3485  03cc ae0000        	ldw	x,#_ee_power_cnt_adr
3486  03cf 8d000000      	callf	d_eewrw
3488  03d3 85            	popw	x
3490  03d4 aca907a9      	jpf	L7002
3491  03d8               L3212:
3492                     ; 194 	else if(PUIB[1]==20)
3494  03d8 c60001        	ld	a,_PUIB+1
3495  03db a114          	cp	a,#20
3496  03dd 261d          	jrne	L7212
3497                     ; 196 		ee_impuls_per_kwatt=PUIB[2]+(PUIB[3]*256);
3499  03df c60003        	ld	a,_PUIB+3
3500  03e2 5f            	clrw	x
3501  03e3 97            	ld	xl,a
3502  03e4 4f            	clr	a
3503  03e5 02            	rlwa	x,a
3504  03e6 01            	rrwa	x,a
3505  03e7 cb0002        	add	a,_PUIB+2
3506  03ea 2401          	jrnc	L27
3507  03ec 5c            	incw	x
3508  03ed               L27:
3509  03ed 02            	rlwa	x,a
3510  03ee 89            	pushw	x
3511  03ef 01            	rrwa	x,a
3512  03f0 ae0000        	ldw	x,#_ee_impuls_per_kwatt
3513  03f3 8d000000      	callf	d_eewrw
3515  03f7 85            	popw	x
3517  03f8 aca907a9      	jpf	L7002
3518  03fc               L7212:
3519                     ; 199 	else if(PUIB[1]==21)
3521  03fc c60001        	ld	a,_PUIB+1
3522  03ff a115          	cp	a,#21
3523  0401 2702          	jreq	L421
3524  0403 206f          	jpf	L3312
3525  0405               L421:
3526                     ; 201 		power_summary_impuls_cnt=(((long)PUIB[5])<<24)+(((long)PUIB[4])<<16)+(((long)PUIB[3])<<8)+(PUIB[2]);
3528  0405 c60003        	ld	a,_PUIB+3
3529  0408 5f            	clrw	x
3530  0409 97            	ld	xl,a
3531  040a 90ae0100      	ldw	y,#256
3532  040e 8d000000      	callf	d_umul
3534  0412 96            	ldw	x,sp
3535  0413 1c0005        	addw	x,#OFST-3
3536  0416 8d000000      	callf	d_rtol
3538  041a c60004        	ld	a,_PUIB+4
3539  041d b703          	ld	c_lreg+3,a
3540  041f 3f02          	clr	c_lreg+2
3541  0421 3f01          	clr	c_lreg+1
3542  0423 3f00          	clr	c_lreg
3543  0425 a610          	ld	a,#16
3544  0427 8d000000      	callf	d_llsh
3546  042b 96            	ldw	x,sp
3547  042c 1c0001        	addw	x,#OFST-7
3548  042f 8d000000      	callf	d_rtol
3550  0433 c60005        	ld	a,_PUIB+5
3551  0436 b703          	ld	c_lreg+3,a
3552  0438 3f02          	clr	c_lreg+2
3553  043a 3f01          	clr	c_lreg+1
3554  043c 3f00          	clr	c_lreg
3555  043e a618          	ld	a,#24
3556  0440 8d000000      	callf	d_llsh
3558  0444 96            	ldw	x,sp
3559  0445 1c0001        	addw	x,#OFST-7
3560  0448 8d000000      	callf	d_ladd
3562  044c 96            	ldw	x,sp
3563  044d 1c0005        	addw	x,#OFST-3
3564  0450 8d000000      	callf	d_ladd
3566  0454 c60002        	ld	a,_PUIB+2
3567  0457 8d000000      	callf	d_ladc
3569  045b ae0000        	ldw	x,#_power_summary_impuls_cnt
3570  045e 8d000000      	callf	d_rtol
3572                     ; 202 		ee_power_summary_impuls_cnt=power_summary_impuls_cnt;
3574  0462 ae0000        	ldw	x,#_power_summary_impuls_cnt
3575  0465 8d000000      	callf	d_ltor
3577  0469 ae0000        	ldw	x,#_ee_power_summary_impuls_cnt
3578  046c 8d000000      	callf	d_eewrl
3581  0470 aca907a9      	jpf	L7002
3582  0474               L3312:
3583                     ; 205 	else if(PUIB[1]==22)
3585  0474 c60001        	ld	a,_PUIB+1
3586  0477 a116          	cp	a,#22
3587  0479 261d          	jrne	L7312
3588                     ; 207 		ee_reset_cnt=PUIB[2]+(PUIB[3]*256);
3590  047b c60003        	ld	a,_PUIB+3
3591  047e 5f            	clrw	x
3592  047f 97            	ld	xl,a
3593  0480 4f            	clr	a
3594  0481 02            	rlwa	x,a
3595  0482 01            	rrwa	x,a
3596  0483 cb0002        	add	a,_PUIB+2
3597  0486 2401          	jrnc	L47
3598  0488 5c            	incw	x
3599  0489               L47:
3600  0489 02            	rlwa	x,a
3601  048a 89            	pushw	x
3602  048b 01            	rrwa	x,a
3603  048c ae0000        	ldw	x,#_ee_reset_cnt
3604  048f 8d000000      	callf	d_eewrw
3606  0493 85            	popw	x
3608  0494 aca907a9      	jpf	L7002
3609  0498               L7312:
3610                     ; 210 	else if(PUIB[1]==23)
3612  0498 c60001        	ld	a,_PUIB+1
3613  049b a117          	cp	a,#23
3614  049d 2678          	jrne	L3412
3615                     ; 212 		if(PUIB[2]==1)
3617  049f c60002        	ld	a,_PUIB+2
3618  04a2 a101          	cp	a,#1
3619  04a4 260b          	jrne	L5412
3620                     ; 214 			ee_T1_koef+=2;
3622  04a6 ce0000        	ldw	x,_ee_T1_koef
3623  04a9 1c0002        	addw	x,#2
3624  04ac cf0000        	ldw	_ee_T1_koef,x
3626  04af 2034          	jra	L7412
3627  04b1               L5412:
3628                     ; 216 		else if(PUIB[2]==2)
3630  04b1 c60002        	ld	a,_PUIB+2
3631  04b4 a102          	cp	a,#2
3632  04b6 260b          	jrne	L1512
3633                     ; 218 			ee_T1_koef-=2;
3635  04b8 ce0000        	ldw	x,_ee_T1_koef
3636  04bb 1d0002        	subw	x,#2
3637  04be cf0000        	ldw	_ee_T1_koef,x
3639  04c1 2022          	jra	L7412
3640  04c3               L1512:
3641                     ; 220 		else if(PUIB[2]==3)
3643  04c3 c60002        	ld	a,_PUIB+2
3644  04c6 a103          	cp	a,#3
3645  04c8 260b          	jrne	L5512
3646                     ; 222 			ee_T1_koef+=15;
3648  04ca ce0000        	ldw	x,_ee_T1_koef
3649  04cd 1c000f        	addw	x,#15
3650  04d0 cf0000        	ldw	_ee_T1_koef,x
3652  04d3 2010          	jra	L7412
3653  04d5               L5512:
3654                     ; 224 		else if(PUIB[2]==4)
3656  04d5 c60002        	ld	a,_PUIB+2
3657  04d8 a104          	cp	a,#4
3658  04da 2609          	jrne	L7412
3659                     ; 226 			ee_T1_koef-=15;
3661  04dc ce0000        	ldw	x,_ee_T1_koef
3662  04df 1d000f        	subw	x,#15
3663  04e2 cf0000        	ldw	_ee_T1_koef,x
3664  04e5               L7412:
3665                     ; 228 		if(ee_T1_koef>1035)ee_T1_koef=1035;
3667  04e5 9c            	rvf
3668  04e6 ce0000        	ldw	x,_ee_T1_koef
3669  04e9 a3040c        	cpw	x,#1036
3670  04ec 2f0c          	jrslt	L3612
3673  04ee ae040b        	ldw	x,#1035
3674  04f1 89            	pushw	x
3675  04f2 ae0000        	ldw	x,#_ee_T1_koef
3676  04f5 8d000000      	callf	d_eewrw
3678  04f9 85            	popw	x
3679  04fa               L3612:
3680                     ; 229 		if(ee_T1_koef<1005)ee_T1_koef=1005;
3682  04fa 9c            	rvf
3683  04fb ce0000        	ldw	x,_ee_T1_koef
3684  04fe a303ed        	cpw	x,#1005
3685  0501 2f04          	jrslt	L621
3686  0503 aca907a9      	jpf	L7002
3687  0507               L621:
3690  0507 ae03ed        	ldw	x,#1005
3691  050a 89            	pushw	x
3692  050b ae0000        	ldw	x,#_ee_T1_koef
3693  050e 8d000000      	callf	d_eewrw
3695  0512 85            	popw	x
3696  0513 aca907a9      	jpf	L7002
3697  0517               L3412:
3698                     ; 232 	else if(PUIB[1]==24)
3700  0517 c60001        	ld	a,_PUIB+1
3701  051a a118          	cp	a,#24
3702  051c 2678          	jrne	L1712
3703                     ; 234 		if(PUIB[2]==1)
3705  051e c60002        	ld	a,_PUIB+2
3706  0521 a101          	cp	a,#1
3707  0523 260b          	jrne	L3712
3708                     ; 236 			ee_T2_koef+=2;
3710  0525 ce0000        	ldw	x,_ee_T2_koef
3711  0528 1c0002        	addw	x,#2
3712  052b cf0000        	ldw	_ee_T2_koef,x
3714  052e 2034          	jra	L5712
3715  0530               L3712:
3716                     ; 238 		else if(PUIB[2]==2)
3718  0530 c60002        	ld	a,_PUIB+2
3719  0533 a102          	cp	a,#2
3720  0535 260b          	jrne	L7712
3721                     ; 240 			ee_T2_koef-=2;
3723  0537 ce0000        	ldw	x,_ee_T2_koef
3724  053a 1d0002        	subw	x,#2
3725  053d cf0000        	ldw	_ee_T2_koef,x
3727  0540 2022          	jra	L5712
3728  0542               L7712:
3729                     ; 242 		else if(PUIB[2]==3)
3731  0542 c60002        	ld	a,_PUIB+2
3732  0545 a103          	cp	a,#3
3733  0547 260b          	jrne	L3022
3734                     ; 244 			ee_T2_koef+=15;
3736  0549 ce0000        	ldw	x,_ee_T2_koef
3737  054c 1c000f        	addw	x,#15
3738  054f cf0000        	ldw	_ee_T2_koef,x
3740  0552 2010          	jra	L5712
3741  0554               L3022:
3742                     ; 246 		else if(PUIB[2]==4)
3744  0554 c60002        	ld	a,_PUIB+2
3745  0557 a104          	cp	a,#4
3746  0559 2609          	jrne	L5712
3747                     ; 248 			ee_T2_koef-=15;
3749  055b ce0000        	ldw	x,_ee_T2_koef
3750  055e 1d000f        	subw	x,#15
3751  0561 cf0000        	ldw	_ee_T2_koef,x
3752  0564               L5712:
3753                     ; 250 		if(ee_T2_koef>1035)ee_T2_koef=1035;
3755  0564 9c            	rvf
3756  0565 ce0000        	ldw	x,_ee_T2_koef
3757  0568 a3040c        	cpw	x,#1036
3758  056b 2f0c          	jrslt	L1122
3761  056d ae040b        	ldw	x,#1035
3762  0570 89            	pushw	x
3763  0571 ae0000        	ldw	x,#_ee_T2_koef
3764  0574 8d000000      	callf	d_eewrw
3766  0578 85            	popw	x
3767  0579               L1122:
3768                     ; 251 		if(ee_T2_koef<1005)ee_T2_koef=1005;
3770  0579 9c            	rvf
3771  057a ce0000        	ldw	x,_ee_T2_koef
3772  057d a303ed        	cpw	x,#1005
3773  0580 2f04          	jrslt	L031
3774  0582 aca907a9      	jpf	L7002
3775  0586               L031:
3778  0586 ae03ed        	ldw	x,#1005
3779  0589 89            	pushw	x
3780  058a ae0000        	ldw	x,#_ee_T2_koef
3781  058d 8d000000      	callf	d_eewrw
3783  0591 85            	popw	x
3784  0592 aca907a9      	jpf	L7002
3785  0596               L1712:
3786                     ; 254 	else if(PUIB[1]==25)
3788  0596 c60001        	ld	a,_PUIB+1
3789  0599 a119          	cp	a,#25
3790  059b 2624          	jrne	L7122
3791                     ; 256 		ee_T1_porog1=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
3793  059d 5f            	clrw	x
3794  059e c60002        	ld	a,_PUIB+2
3795  05a1 2a01          	jrpl	L67
3796  05a3 53            	cplw	x
3797  05a4               L67:
3798  05a4 97            	ld	xl,a
3799  05a5 1f07          	ldw	(OFST-1,sp),x
3800  05a7 5f            	clrw	x
3801  05a8 c60003        	ld	a,_PUIB+3
3802  05ab 2a01          	jrpl	L001
3803  05ad 53            	cplw	x
3804  05ae               L001:
3805  05ae 97            	ld	xl,a
3806  05af 4f            	clr	a
3807  05b0 02            	rlwa	x,a
3808  05b1 72fb07        	addw	x,(OFST-1,sp)
3809  05b4 89            	pushw	x
3810  05b5 ae0000        	ldw	x,#_ee_T1_porog1
3811  05b8 8d000000      	callf	d_eewrw
3813  05bc 85            	popw	x
3815  05bd aca907a9      	jpf	L7002
3816  05c1               L7122:
3817                     ; 259 	else if(PUIB[1]==26)
3819  05c1 c60001        	ld	a,_PUIB+1
3820  05c4 a11a          	cp	a,#26
3821  05c6 2624          	jrne	L3222
3822                     ; 261 		ee_T1_porog2=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
3824  05c8 5f            	clrw	x
3825  05c9 c60002        	ld	a,_PUIB+2
3826  05cc 2a01          	jrpl	L201
3827  05ce 53            	cplw	x
3828  05cf               L201:
3829  05cf 97            	ld	xl,a
3830  05d0 1f07          	ldw	(OFST-1,sp),x
3831  05d2 5f            	clrw	x
3832  05d3 c60003        	ld	a,_PUIB+3
3833  05d6 2a01          	jrpl	L401
3834  05d8 53            	cplw	x
3835  05d9               L401:
3836  05d9 97            	ld	xl,a
3837  05da 4f            	clr	a
3838  05db 02            	rlwa	x,a
3839  05dc 72fb07        	addw	x,(OFST-1,sp)
3840  05df 89            	pushw	x
3841  05e0 ae0000        	ldw	x,#_ee_T1_porog2
3842  05e3 8d000000      	callf	d_eewrw
3844  05e7 85            	popw	x
3846  05e8 aca907a9      	jpf	L7002
3847  05ec               L3222:
3848                     ; 264 	else if(PUIB[1]==27)
3850  05ec c60001        	ld	a,_PUIB+1
3851  05ef a11b          	cp	a,#27
3852  05f1 2610          	jrne	L7222
3853                     ; 266 		ee_T1_logic1=(PUIB[2]&0x03);
3855  05f3 c60002        	ld	a,_PUIB+2
3856  05f6 a403          	and	a,#3
3857  05f8 ae0000        	ldw	x,#_ee_T1_logic1
3858  05fb 8d000000      	callf	d_eewrc
3861  05ff aca907a9      	jpf	L7002
3862  0603               L7222:
3863                     ; 269 	else if(PUIB[1]==28)
3865  0603 c60001        	ld	a,_PUIB+1
3866  0606 a11c          	cp	a,#28
3867  0608 2610          	jrne	L3322
3868                     ; 271 		ee_T1_logic2=(PUIB[2]&0x03);
3870  060a c60002        	ld	a,_PUIB+2
3871  060d a403          	and	a,#3
3872  060f ae0000        	ldw	x,#_ee_T1_logic2
3873  0612 8d000000      	callf	d_eewrc
3876  0616 aca907a9      	jpf	L7002
3877  061a               L3322:
3878                     ; 274 	else if(PUIB[1]==29)
3880  061a c60001        	ld	a,_PUIB+1
3881  061d a11d          	cp	a,#29
3882  061f 2610          	jrne	L7322
3883                     ; 276 		ee_T1_trap_send_av_1=(PUIB[2]&0x01);
3885  0621 c60002        	ld	a,_PUIB+2
3886  0624 a401          	and	a,#1
3887  0626 ae0000        	ldw	x,#_ee_T1_trap_send_av_1
3888  0629 8d000000      	callf	d_eewrc
3891  062d aca907a9      	jpf	L7002
3892  0631               L7322:
3893                     ; 280 	else if(PUIB[1]==30)
3895  0631 c60001        	ld	a,_PUIB+1
3896  0634 a11e          	cp	a,#30
3897  0636 2610          	jrne	L3422
3898                     ; 282 		ee_T1_trap_send_no_av_1=(PUIB[2]&0x01);
3900  0638 c60002        	ld	a,_PUIB+2
3901  063b a401          	and	a,#1
3902  063d ae0000        	ldw	x,#_ee_T1_trap_send_no_av_1
3903  0640 8d000000      	callf	d_eewrc
3906  0644 aca907a9      	jpf	L7002
3907  0648               L3422:
3908                     ; 286 	else if(PUIB[1]==31)
3910  0648 c60001        	ld	a,_PUIB+1
3911  064b a11f          	cp	a,#31
3912  064d 2610          	jrne	L7422
3913                     ; 288 		ee_T1_trap_send_av_2=(PUIB[2]&0x01);
3915  064f c60002        	ld	a,_PUIB+2
3916  0652 a401          	and	a,#1
3917  0654 ae0000        	ldw	x,#_ee_T1_trap_send_av_2
3918  0657 8d000000      	callf	d_eewrc
3921  065b aca907a9      	jpf	L7002
3922  065f               L7422:
3923                     ; 292 	else if(PUIB[1]==32)
3925  065f c60001        	ld	a,_PUIB+1
3926  0662 a120          	cp	a,#32
3927  0664 2610          	jrne	L3522
3928                     ; 294 		ee_T1_trap_send_no_av_2=(PUIB[2]&0x01);
3930  0666 c60002        	ld	a,_PUIB+2
3931  0669 a401          	and	a,#1
3932  066b ae0000        	ldw	x,#_ee_T1_trap_send_no_av_2
3933  066e 8d000000      	callf	d_eewrc
3936  0672 aca907a9      	jpf	L7002
3937  0676               L3522:
3938                     ; 297 	else if(PUIB[1]==33)
3940  0676 c60001        	ld	a,_PUIB+1
3941  0679 a121          	cp	a,#33
3942  067b 261d          	jrne	L7522
3943                     ; 299 		ee_H1_porog=PUIB[2]+(PUIB[3]*256);
3945  067d c60003        	ld	a,_PUIB+3
3946  0680 5f            	clrw	x
3947  0681 97            	ld	xl,a
3948  0682 4f            	clr	a
3949  0683 02            	rlwa	x,a
3950  0684 01            	rrwa	x,a
3951  0685 cb0002        	add	a,_PUIB+2
3952  0688 2401          	jrnc	L601
3953  068a 5c            	incw	x
3954  068b               L601:
3955  068b 02            	rlwa	x,a
3956  068c 89            	pushw	x
3957  068d 01            	rrwa	x,a
3958  068e ae0000        	ldw	x,#_ee_H1_porog
3959  0691 8d000000      	callf	d_eewrw
3961  0695 85            	popw	x
3963  0696 aca907a9      	jpf	L7002
3964  069a               L7522:
3965                     ; 302 	else if(PUIB[1]==34)
3967  069a c60001        	ld	a,_PUIB+1
3968  069d a122          	cp	a,#34
3969  069f 260e          	jrne	L3622
3970                     ; 304 		ee_H1_logic=PUIB[2];
3972  06a1 c60002        	ld	a,_PUIB+2
3973  06a4 ae0000        	ldw	x,#_ee_H1_logic
3974  06a7 8d000000      	callf	d_eewrc
3977  06ab aca907a9      	jpf	L7002
3978  06af               L3622:
3979                     ; 307 	else if(PUIB[1]==35)
3981  06af c60001        	ld	a,_PUIB+1
3982  06b2 a123          	cp	a,#35
3983  06b4 260e          	jrne	L7622
3984                     ; 309 		ee_hummidity_trap_send_av=PUIB[2];
3986  06b6 c60002        	ld	a,_PUIB+2
3987  06b9 ae0000        	ldw	x,#_ee_hummidity_trap_send_av
3988  06bc 8d000000      	callf	d_eewrc
3991  06c0 aca907a9      	jpf	L7002
3992  06c4               L7622:
3993                     ; 312 	else if(PUIB[1]==36)
3995  06c4 c60001        	ld	a,_PUIB+1
3996  06c7 a124          	cp	a,#36
3997  06c9 260e          	jrne	L3722
3998                     ; 314 		ee_hummidity_trap_send_no_av=PUIB[2];
4000  06cb c60002        	ld	a,_PUIB+2
4001  06ce ae0000        	ldw	x,#_ee_hummidity_trap_send_no_av
4002  06d1 8d000000      	callf	d_eewrc
4005  06d5 aca907a9      	jpf	L7002
4006  06d9               L3722:
4007                     ; 318 	else if(PUIB[1]==50)
4009  06d9 c60001        	ld	a,_PUIB+1
4010  06dc a132          	cp	a,#50
4011  06de 2624          	jrne	L7722
4012                     ; 320 		ee_T2_porog1=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
4014  06e0 5f            	clrw	x
4015  06e1 c60002        	ld	a,_PUIB+2
4016  06e4 2a01          	jrpl	L011
4017  06e6 53            	cplw	x
4018  06e7               L011:
4019  06e7 97            	ld	xl,a
4020  06e8 1f07          	ldw	(OFST-1,sp),x
4021  06ea 5f            	clrw	x
4022  06eb c60003        	ld	a,_PUIB+3
4023  06ee 2a01          	jrpl	L211
4024  06f0 53            	cplw	x
4025  06f1               L211:
4026  06f1 97            	ld	xl,a
4027  06f2 4f            	clr	a
4028  06f3 02            	rlwa	x,a
4029  06f4 72fb07        	addw	x,(OFST-1,sp)
4030  06f7 89            	pushw	x
4031  06f8 ae0000        	ldw	x,#_ee_T2_porog1
4032  06fb 8d000000      	callf	d_eewrw
4034  06ff 85            	popw	x
4036  0700 aca907a9      	jpf	L7002
4037  0704               L7722:
4038                     ; 323 	else if(PUIB[1]==51)
4040  0704 c60001        	ld	a,_PUIB+1
4041  0707 a133          	cp	a,#51
4042  0709 2622          	jrne	L3032
4043                     ; 325 		ee_T2_porog2=((signed char)PUIB[2])+(((signed char)PUIB[3])*256);
4045  070b 5f            	clrw	x
4046  070c c60002        	ld	a,_PUIB+2
4047  070f 2a01          	jrpl	L411
4048  0711 53            	cplw	x
4049  0712               L411:
4050  0712 97            	ld	xl,a
4051  0713 1f07          	ldw	(OFST-1,sp),x
4052  0715 5f            	clrw	x
4053  0716 c60003        	ld	a,_PUIB+3
4054  0719 2a01          	jrpl	L611
4055  071b 53            	cplw	x
4056  071c               L611:
4057  071c 97            	ld	xl,a
4058  071d 4f            	clr	a
4059  071e 02            	rlwa	x,a
4060  071f 72fb07        	addw	x,(OFST-1,sp)
4061  0722 89            	pushw	x
4062  0723 ae0000        	ldw	x,#_ee_T2_porog2
4063  0726 8d000000      	callf	d_eewrw
4065  072a 85            	popw	x
4067  072b 207c          	jpf	L7002
4068  072d               L3032:
4069                     ; 328 	else if(PUIB[1]==52)
4071  072d c60001        	ld	a,_PUIB+1
4072  0730 a134          	cp	a,#52
4073  0732 260e          	jrne	L7032
4074                     ; 330 		ee_T2_logic1=(PUIB[2]&0x03);
4076  0734 c60002        	ld	a,_PUIB+2
4077  0737 a403          	and	a,#3
4078  0739 ae0000        	ldw	x,#_ee_T2_logic1
4079  073c 8d000000      	callf	d_eewrc
4082  0740 2067          	jra	L7002
4083  0742               L7032:
4084                     ; 333 	else if(PUIB[1]==53)
4086  0742 c60001        	ld	a,_PUIB+1
4087  0745 a135          	cp	a,#53
4088  0747 260e          	jrne	L3132
4089                     ; 335 		ee_T2_logic2=(PUIB[2]&0x03);
4091  0749 c60002        	ld	a,_PUIB+2
4092  074c a403          	and	a,#3
4093  074e ae0000        	ldw	x,#_ee_T2_logic2
4094  0751 8d000000      	callf	d_eewrc
4097  0755 2052          	jra	L7002
4098  0757               L3132:
4099                     ; 338 	else if(PUIB[1]==54)
4101  0757 c60001        	ld	a,_PUIB+1
4102  075a a136          	cp	a,#54
4103  075c 260e          	jrne	L7132
4104                     ; 340 		ee_T2_trap_send_av_1=(PUIB[2]&0x01);
4106  075e c60002        	ld	a,_PUIB+2
4107  0761 a401          	and	a,#1
4108  0763 ae0000        	ldw	x,#_ee_T2_trap_send_av_1
4109  0766 8d000000      	callf	d_eewrc
4112  076a 203d          	jra	L7002
4113  076c               L7132:
4114                     ; 344 	else if(PUIB[1]==55)
4116  076c c60001        	ld	a,_PUIB+1
4117  076f a137          	cp	a,#55
4118  0771 260e          	jrne	L3232
4119                     ; 346 		ee_T2_trap_send_no_av_1=(PUIB[2]&0x01);
4121  0773 c60002        	ld	a,_PUIB+2
4122  0776 a401          	and	a,#1
4123  0778 ae0000        	ldw	x,#_ee_T2_trap_send_no_av_1
4124  077b 8d000000      	callf	d_eewrc
4127  077f 2028          	jra	L7002
4128  0781               L3232:
4129                     ; 350 	else if(PUIB[1]==56)
4131  0781 c60001        	ld	a,_PUIB+1
4132  0784 a138          	cp	a,#56
4133  0786 260e          	jrne	L7232
4134                     ; 352 		ee_T2_trap_send_av_2=(PUIB[2]&0x01);
4136  0788 c60002        	ld	a,_PUIB+2
4137  078b a401          	and	a,#1
4138  078d ae0000        	ldw	x,#_ee_T2_trap_send_av_2
4139  0790 8d000000      	callf	d_eewrc
4142  0794 2013          	jra	L7002
4143  0796               L7232:
4144                     ; 356 	else if(PUIB[1]==57)
4146  0796 c60001        	ld	a,_PUIB+1
4147  0799 a139          	cp	a,#57
4148  079b 260c          	jrne	L7002
4149                     ; 358 		ee_T2_trap_send_no_av_2=(PUIB[2]&0x01);
4151  079d c60002        	ld	a,_PUIB+2
4152  07a0 a401          	and	a,#1
4153  07a2 ae0000        	ldw	x,#_ee_T2_trap_send_no_av_2
4154  07a5 8d000000      	callf	d_eewrc
4156  07a9               L7002:
4157                     ; 361 }
4160  07a9 5b08          	addw	sp,#8
4161  07ab 87            	retf
4183                     ; 364 void p_uart_tx_init(void)
4183                     ; 365 {
4184                     	switch	.text
4185  07ac               f_p_uart_tx_init:
4189                     ; 367 GPIOC->DDR|=(1<<5);
4191  07ac 721a500c      	bset	20492,#5
4192                     ; 368 GPIOC->CR1|=(1<<5);
4194  07b0 721a500d      	bset	20493,#5
4195                     ; 369 GPIOC->CR2&=~(1<<5);	
4197  07b4 721b500e      	bres	20494,#5
4198                     ; 372 GPIOC->DDR&=~(1<<6);
4200  07b8 721d500c      	bres	20492,#6
4201                     ; 373 GPIOC->CR1&=~(1<<6);
4203  07bc 721d500d      	bres	20493,#6
4204                     ; 374 GPIOC->CR2&=~(1<<6);
4206  07c0 721d500e      	bres	20494,#6
4207                     ; 377 GPIOC->DDR|=(1<<7);
4209  07c4 721e500c      	bset	20492,#7
4210                     ; 378 GPIOC->CR1|=(1<<7);
4212  07c8 721e500d      	bset	20493,#7
4213                     ; 379 GPIOC->CR2&=~(1<<7);	
4215  07cc 721f500e      	bres	20494,#7
4216                     ; 382 GPIOE->DDR|=(1<<5);
4218  07d0 721a5016      	bset	20502,#5
4219                     ; 383 GPIOE->CR1|=(1<<5);
4221  07d4 721a5017      	bset	20503,#5
4222                     ; 384 GPIOE->CR2&=~(1<<5);
4224  07d8 721b5018      	bres	20504,#5
4225                     ; 387 }
4228  07dc 87            	retf
4230                     	switch	.ubsct
4231  0000               L5432_puart_cnt:
4232  0000 00            	ds.b	1
4285                     ; 390 void puart_tx_drv(void)
4285                     ; 391 {
4286                     	switch	.text
4287  07dd               f_puart_tx_drv:
4289  07dd 89            	pushw	x
4290       00000002      OFST:	set	2
4293                     ; 394 char puart_cnt__=0;
4295  07de 0f01          	clr	(OFST-1,sp)
4296                     ; 395 temp_tx=puart_tx_buffer[puart_tx_rd_index];
4298  07e0 c60066        	ld	a,_puart_tx_rd_index
4299  07e3 5f            	clrw	x
4300  07e4 97            	ld	xl,a
4301  07e5 d6006a        	ld	a,(_puart_tx_buffer,x)
4302  07e8 6b02          	ld	(OFST+0,sp),a
4303                     ; 416 if(puart_tx_rd_index!=puart_tx_wr_index)
4305  07ea c60066        	ld	a,_puart_tx_rd_index
4306  07ed c10067        	cp	a,_puart_tx_wr_index
4307  07f0 2604ac780878  	jreq	L5732
4308                     ; 418 	if( ( ((GPIOC->ODR)&(1<<5)) && ((GPIOC->IDR)&(1<<6)) ) || ( (!((GPIOC->ODR)&(1<<5))) && (!((GPIOC->IDR)&(1<<6))) ) )
4310  07f6 c6500a        	ld	a,20490
4311  07f9 a520          	bcp	a,#32
4312  07fb 2707          	jreq	L3042
4314  07fd c6500b        	ld	a,20491
4315  0800 a540          	bcp	a,#64
4316  0802 260e          	jrne	L1042
4317  0804               L3042:
4319  0804 c6500a        	ld	a,20490
4320  0807 a520          	bcp	a,#32
4321  0809 2671          	jrne	L5242
4323  080b c6500b        	ld	a,20491
4324  080e a540          	bcp	a,#64
4325  0810 266a          	jrne	L5242
4326  0812               L1042:
4327                     ; 420 		if((temp_tx>>(puart_cnt*2))&0x01)GPIOC->ODR|=(1<<7);
4329  0812 b600          	ld	a,L5432_puart_cnt
4330  0814 48            	sll	a
4331  0815 5f            	clrw	x
4332  0816 97            	ld	xl,a
4333  0817 7b02          	ld	a,(OFST+0,sp)
4334  0819 5d            	tnzw	x
4335  081a 2704          	jreq	L631
4336  081c               L041:
4337  081c 44            	srl	a
4338  081d 5a            	decw	x
4339  081e 26fc          	jrne	L041
4340  0820               L631:
4341  0820 5f            	clrw	x
4342  0821 a501          	bcp	a,#1
4343  0823 2706          	jreq	L5042
4346  0825 721e500a      	bset	20490,#7
4348  0829 2004          	jra	L7042
4349  082b               L5042:
4350                     ; 421 		else GPIOC->ODR&=~(1<<7);
4352  082b 721f500a      	bres	20490,#7
4353  082f               L7042:
4354                     ; 422 		if((temp_tx>>((puart_cnt*2)+1))&0x01)GPIOE->ODR|=(1<<5);
4356  082f b600          	ld	a,L5432_puart_cnt
4357  0831 48            	sll	a
4358  0832 4c            	inc	a
4359  0833 5f            	clrw	x
4360  0834 97            	ld	xl,a
4361  0835 7b02          	ld	a,(OFST+0,sp)
4362  0837 5d            	tnzw	x
4363  0838 2704          	jreq	L241
4364  083a               L441:
4365  083a 44            	srl	a
4366  083b 5a            	decw	x
4367  083c 26fc          	jrne	L441
4368  083e               L241:
4369  083e 5f            	clrw	x
4370  083f a501          	bcp	a,#1
4371  0841 2706          	jreq	L1142
4374  0843 721a5014      	bset	20500,#5
4376  0847 2004          	jra	L3142
4377  0849               L1142:
4378                     ; 423 		else GPIOE->ODR&=~(1<<5);
4380  0849 721b5014      	bres	20500,#5
4381  084d               L3142:
4382                     ; 425 		if(puart_cnt&0x01)GPIOC->ODR|=(1<<5);
4384  084d b600          	ld	a,L5432_puart_cnt
4385  084f a501          	bcp	a,#1
4386  0851 2706          	jreq	L5142
4389  0853 721a500a      	bset	20490,#5
4391  0857 2004          	jra	L7142
4392  0859               L5142:
4393                     ; 426 		else GPIOC->ODR&=~(1<<5);
4395  0859 721b500a      	bres	20490,#5
4396  085d               L7142:
4397                     ; 427 		puart_cnt++;
4399  085d 3c00          	inc	L5432_puart_cnt
4400                     ; 428 		if(puart_cnt>=4)
4402  085f b600          	ld	a,L5432_puart_cnt
4403  0861 a104          	cp	a,#4
4404  0863 2517          	jrult	L5242
4405                     ; 430 			puart_cnt=0;
4407  0865 3f00          	clr	L5432_puart_cnt
4408                     ; 431 			puart_tx_rd_index++;
4410  0867 725c0066      	inc	_puart_tx_rd_index
4411                     ; 432 			if(puart_tx_rd_index >= PUART_TX_BUFFER_SIZE) puart_tx_rd_index=0;
4413  086b c60066        	ld	a,_puart_tx_rd_index
4414  086e a140          	cp	a,#64
4415  0870 250a          	jrult	L5242
4418  0872 725f0066      	clr	_puart_tx_rd_index
4419  0876 2004          	jra	L5242
4420  0878               L5732:
4421                     ; 438 	GPIOC->ODR|=(1<<5);
4423  0878 721a500a      	bset	20490,#5
4424  087c               L5242:
4425                     ; 440 }
4428  087c 85            	popw	x
4429  087d 87            	retf
4545                     ; 445 void puart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5)
4545                     ; 446 {
4546                     	switch	.text
4547  087e               f_puart_out:
4549  087e 89            	pushw	x
4550  087f 5212          	subw	sp,#18
4551       00000012      OFST:	set	18
4554                     ; 447 char i,t=0;
4556  0881 0f01          	clr	(OFST-17,sp)
4557                     ; 450 UOB0[0]=data0;
4559  0883 9f            	ld	a,xl
4560  0884 6b02          	ld	(OFST-16,sp),a
4561                     ; 451 UOB0[1]=data1;
4563  0886 7b18          	ld	a,(OFST+6,sp)
4564  0888 6b03          	ld	(OFST-15,sp),a
4565                     ; 452 UOB0[2]=data2;
4567  088a 7b19          	ld	a,(OFST+7,sp)
4568  088c 6b04          	ld	(OFST-14,sp),a
4569                     ; 453 UOB0[3]=data3;
4571  088e 7b1a          	ld	a,(OFST+8,sp)
4572  0890 6b05          	ld	(OFST-13,sp),a
4573                     ; 454 UOB0[4]=data4;
4575  0892 7b1b          	ld	a,(OFST+9,sp)
4576  0894 6b06          	ld	(OFST-12,sp),a
4577                     ; 455 UOB0[5]=data5;
4579  0896 7b1c          	ld	a,(OFST+10,sp)
4580  0898 6b07          	ld	(OFST-11,sp),a
4581                     ; 457 for (i=0;i<num;i++)
4583  089a 0f12          	clr	(OFST+0,sp)
4585  089c 2013          	jra	L5152
4586  089e               L1152:
4587                     ; 459 	t^=UOB0[i];
4589  089e 96            	ldw	x,sp
4590  089f 1c0002        	addw	x,#OFST-16
4591  08a2 9f            	ld	a,xl
4592  08a3 5e            	swapw	x
4593  08a4 1b12          	add	a,(OFST+0,sp)
4594  08a6 2401          	jrnc	L051
4595  08a8 5c            	incw	x
4596  08a9               L051:
4597  08a9 02            	rlwa	x,a
4598  08aa 7b01          	ld	a,(OFST-17,sp)
4599  08ac f8            	xor	a,	(x)
4600  08ad 6b01          	ld	(OFST-17,sp),a
4601                     ; 457 for (i=0;i<num;i++)
4603  08af 0c12          	inc	(OFST+0,sp)
4604  08b1               L5152:
4607  08b1 7b12          	ld	a,(OFST+0,sp)
4608  08b3 1113          	cp	a,(OFST+1,sp)
4609  08b5 25e7          	jrult	L1152
4610                     ; 461 UOB0[num]=num;
4612  08b7 96            	ldw	x,sp
4613  08b8 1c0002        	addw	x,#OFST-16
4614  08bb 9f            	ld	a,xl
4615  08bc 5e            	swapw	x
4616  08bd 1b13          	add	a,(OFST+1,sp)
4617  08bf 2401          	jrnc	L251
4618  08c1 5c            	incw	x
4619  08c2               L251:
4620  08c2 02            	rlwa	x,a
4621  08c3 7b13          	ld	a,(OFST+1,sp)
4622  08c5 f7            	ld	(x),a
4623                     ; 462 t^=UOB0[num];
4625  08c6 96            	ldw	x,sp
4626  08c7 1c0002        	addw	x,#OFST-16
4627  08ca 9f            	ld	a,xl
4628  08cb 5e            	swapw	x
4629  08cc 1b13          	add	a,(OFST+1,sp)
4630  08ce 2401          	jrnc	L451
4631  08d0 5c            	incw	x
4632  08d1               L451:
4633  08d1 02            	rlwa	x,a
4634  08d2 7b01          	ld	a,(OFST-17,sp)
4635  08d4 f8            	xor	a,	(x)
4636  08d5 6b01          	ld	(OFST-17,sp),a
4637                     ; 463 UOB0[num+1]=t;
4639  08d7 96            	ldw	x,sp
4640  08d8 1c0003        	addw	x,#OFST-15
4641  08db 9f            	ld	a,xl
4642  08dc 5e            	swapw	x
4643  08dd 1b13          	add	a,(OFST+1,sp)
4644  08df 2401          	jrnc	L651
4645  08e1 5c            	incw	x
4646  08e2               L651:
4647  08e2 02            	rlwa	x,a
4648  08e3 7b01          	ld	a,(OFST-17,sp)
4649  08e5 f7            	ld	(x),a
4650                     ; 464 UOB0[num+2]=END;
4652  08e6 96            	ldw	x,sp
4653  08e7 1c0004        	addw	x,#OFST-14
4654  08ea 9f            	ld	a,xl
4655  08eb 5e            	swapw	x
4656  08ec 1b13          	add	a,(OFST+1,sp)
4657  08ee 2401          	jrnc	L061
4658  08f0 5c            	incw	x
4659  08f1               L061:
4660  08f1 02            	rlwa	x,a
4661  08f2 a60a          	ld	a,#10
4662  08f4 f7            	ld	(x),a
4663                     ; 466 for (i=0;i<num+3;i++)
4665  08f5 0f12          	clr	(OFST+0,sp)
4667  08f7 2013          	jra	L5252
4668  08f9               L1252:
4669                     ; 468 	pputchar(UOB0[i]);
4671  08f9 96            	ldw	x,sp
4672  08fa 1c0002        	addw	x,#OFST-16
4673  08fd 9f            	ld	a,xl
4674  08fe 5e            	swapw	x
4675  08ff 1b12          	add	a,(OFST+0,sp)
4676  0901 2401          	jrnc	L261
4677  0903 5c            	incw	x
4678  0904               L261:
4679  0904 02            	rlwa	x,a
4680  0905 f6            	ld	a,(x)
4681  0906 8d6f096f      	callf	f_pputchar
4683                     ; 466 for (i=0;i<num+3;i++)
4685  090a 0c12          	inc	(OFST+0,sp)
4686  090c               L5252:
4689  090c 9c            	rvf
4690  090d 7b12          	ld	a,(OFST+0,sp)
4691  090f 5f            	clrw	x
4692  0910 97            	ld	xl,a
4693  0911 7b13          	ld	a,(OFST+1,sp)
4694  0913 905f          	clrw	y
4695  0915 9097          	ld	yl,a
4696  0917 72a90003      	addw	y,#3
4697  091b bf00          	ldw	c_x,x
4698  091d 90b300        	cpw	y,c_x
4699  0920 2cd7          	jrsgt	L1252
4700                     ; 470 }
4703  0922 5b14          	addw	sp,#20
4704  0924 87            	retf
4775                     ; 473 void puart_out_adr (char *ptr, char len)
4775                     ; 474 {
4776                     	switch	.text
4777  0925               f_puart_out_adr:
4779  0925 89            	pushw	x
4780  0926 5203          	subw	sp,#3
4781       00000003      OFST:	set	3
4784                     ; 477 t=0;
4786  0928 0f01          	clr	(OFST-2,sp)
4787                     ; 479 for(i11=0;i11<len;i11++)
4789  092a 0f02          	clr	(OFST-1,sp)
4791  092c 201c          	jra	L3752
4792  092e               L7652:
4793                     ; 481 	temp11=ptr[i11];
4795  092e 7b04          	ld	a,(OFST+1,sp)
4796  0930 97            	ld	xl,a
4797  0931 7b05          	ld	a,(OFST+2,sp)
4798  0933 1b02          	add	a,(OFST-1,sp)
4799  0935 2401          	jrnc	L661
4800  0937 5c            	incw	x
4801  0938               L661:
4802  0938 02            	rlwa	x,a
4803  0939 f6            	ld	a,(x)
4804  093a 6b03          	ld	(OFST+0,sp),a
4805                     ; 482 	t^=temp11;
4807  093c 7b01          	ld	a,(OFST-2,sp)
4808  093e 1803          	xor	a,	(OFST+0,sp)
4809  0940 6b01          	ld	(OFST-2,sp),a
4810                     ; 483 	pputchar(temp11);
4812  0942 7b03          	ld	a,(OFST+0,sp)
4813  0944 8d6f096f      	callf	f_pputchar
4815                     ; 479 for(i11=0;i11<len;i11++)
4817  0948 0c02          	inc	(OFST-1,sp)
4818  094a               L3752:
4821  094a 7b02          	ld	a,(OFST-1,sp)
4822  094c 1109          	cp	a,(OFST+6,sp)
4823  094e 25de          	jrult	L7652
4824                     ; 486 temp11=len;
4826  0950 7b09          	ld	a,(OFST+6,sp)
4827  0952 6b03          	ld	(OFST+0,sp),a
4828                     ; 487 t^=temp11;
4830  0954 7b01          	ld	a,(OFST-2,sp)
4831  0956 1803          	xor	a,	(OFST+0,sp)
4832  0958 6b01          	ld	(OFST-2,sp),a
4833                     ; 488 pputchar(temp11);
4835  095a 7b03          	ld	a,(OFST+0,sp)
4836  095c 8d6f096f      	callf	f_pputchar
4838                     ; 490 pputchar(t);
4840  0960 7b01          	ld	a,(OFST-2,sp)
4841  0962 8d6f096f      	callf	f_pputchar
4843                     ; 492 pputchar(0x0a);   
4845  0966 a60a          	ld	a,#10
4846  0968 8d6f096f      	callf	f_pputchar
4848                     ; 493 }
4851  096c 5b05          	addw	sp,#5
4852  096e 87            	retf
4887                     ; 496 void pputchar(char c)
4887                     ; 497 {
4888                     	switch	.text
4889  096f               f_pputchar:
4891  096f 88            	push	a
4892       00000000      OFST:	set	0
4895                     ; 498 puart_tx_buffer[puart_tx_wr_index]=c;
4897  0970 c60067        	ld	a,_puart_tx_wr_index
4898  0973 5f            	clrw	x
4899  0974 97            	ld	xl,a
4900  0975 7b01          	ld	a,(OFST+1,sp)
4901  0977 d7006a        	ld	(_puart_tx_buffer,x),a
4902                     ; 499 if (++puart_tx_wr_index >= PUART_TX_BUFFER_SIZE) puart_tx_wr_index=0;
4904  097a 725c0067      	inc	_puart_tx_wr_index
4905  097e c60067        	ld	a,_puart_tx_wr_index
4906  0981 a140          	cp	a,#64
4907  0983 2504          	jrult	L5162
4910  0985 725f0067      	clr	_puart_tx_wr_index
4911  0989               L5162:
4912                     ; 501 }
4915  0989 84            	pop	a
4916  098a 87            	retf
5032                     	xref	_ee_impuls_per_kwatt
5033                     	xref	_ee_power_summary_impuls_cnt
5034                     	xref	_power_summary_impuls_cnt
5035                     	xref	_ee_H1_logic
5036                     	xref	_ee_hummidity_trap_send_no_av
5037                     	xref	_ee_hummidity_trap_send_av
5038                     	xref	_ee_H1_porog
5039                     	xref	_ee_T2_trap_send_no_av_2
5040                     	xref	_ee_T2_trap_send_av_2
5041                     	xref	_ee_T2_trap_send_no_av_1
5042                     	xref	_ee_T2_trap_send_av_1
5043                     	xref	_ee_T1_trap_send_no_av_2
5044                     	xref	_ee_T1_trap_send_av_2
5045                     	xref	_ee_T1_trap_send_no_av_1
5046                     	xref	_ee_T1_trap_send_av_1
5047                     	xref	_ee_T2_logic2
5048                     	xref	_ee_T2_logic1
5049                     	xref	_ee_T1_logic2
5050                     	xref	_ee_T1_logic1
5051                     	xref	_ee_T2_porog2
5052                     	xref	_ee_T2_porog1
5053                     	xref	_ee_T1_porog2
5054                     	xref	_ee_T1_porog1
5055                     	xref	_ee_T2_koef
5056                     	xref	_ee_T1_koef
5057                     	xref	_ee_reset_cnt
5058                     	xref	_ee_power_cnt_adr
5059                     	xref	_PUIB
5060                     	xref	_ee_log_in_trap_send_no_av
5061                     	xref	_ee_log_in_trap_send_av
5062                     	xref	_ee_log_in_stat_of_av
5063                     	xdef	f_puart_out
5064                     	xdef	f_puart_out_adr
5065                     	xdef	f_pputchar
5066                     	xdef	f_puart_tx_drv
5067                     	xdef	f_p_uart_tx_init
5068                     	xdef	f_puart_uart_in_an
5069                     	xdef	f_puart_control_check
5070                     	xdef	f_puart_index_offset
5071                     	xdef	f_puart_uart_in
5072                     	xdef	f_p_uart_rx_init
5073                     	switch	.bss
5074  0000               _data_out:
5075  0000 000000000000  	ds.b	100
5076                     	xdef	_data_out
5077  0064               _control_temp:
5078  0064 00            	ds.b	1
5079                     	xdef	_control_temp
5080  0065               _data_temp:
5081  0065 00            	ds.b	1
5082                     	xdef	_data_temp
5083                     	switch	.ubsct
5084  0001               _bPUART_RXIN:
5085  0001 00            	ds.b	1
5086                     	xdef	_bPUART_RXIN
5087                     	switch	.bss
5088  0066               _puart_tx_rd_index:
5089  0066 00            	ds.b	1
5090                     	xdef	_puart_tx_rd_index
5091  0067               _puart_tx_wr_index:
5092  0067 00            	ds.b	1
5093                     	xdef	_puart_tx_wr_index
5094  0068               _puart_rx_rd_index:
5095  0068 00            	ds.b	1
5096                     	xdef	_puart_rx_rd_index
5097  0069               _puart_rx_wr_index:
5098  0069 00            	ds.b	1
5099                     	xdef	_puart_rx_wr_index
5100  006a               _puart_tx_buffer:
5101  006a 000000000000  	ds.b	64
5102                     	xdef	_puart_tx_buffer
5103  00aa               _puart_rx_buffer:
5104  00aa 000000000000  	ds.b	64
5105                     	xdef	_puart_rx_buffer
5106                     	switch	.ubsct
5107  0002               _puart_data_temp:
5108  0002 00            	ds.b	1
5109                     	xdef	_puart_data_temp
5110                     	xref.b	c_lreg
5111                     	xref.b	c_x
5112                     	xref.b	c_y
5132                     	xref	d_eewrl
5133                     	xref	d_ltor
5134                     	xref	d_ladc
5135                     	xref	d_umul
5136                     	xref	d_ladd
5137                     	xref	d_rtol
5138                     	xref	d_llsh
5139                     	xref	d_eewrw
5140                     	xref	d_eewrc
5141                     	end
