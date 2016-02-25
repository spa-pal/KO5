   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32.1 - 30 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2525                     .const:	section	.text
2526  0000               _crc8tab:
2527  0000 00            	dc.b	0
2528  0001 b5            	dc.b	181
2529  0002 df            	dc.b	223
2530  0003 6a            	dc.b	106
2531  0004 0b            	dc.b	11
2532  0005 be            	dc.b	190
2533  0006 d4            	dc.b	212
2534  0007 61            	dc.b	97
2535  0008 16            	dc.b	22
2536  0009 a3            	dc.b	163
2537  000a c9            	dc.b	201
2538  000b 7c            	dc.b	124
2539  000c 1d            	dc.b	29
2540  000d a8            	dc.b	168
2541  000e c2            	dc.b	194
2542  000f 77            	dc.b	119
2543  0010 2c            	dc.b	44
2544  0011 99            	dc.b	153
2545  0012 f3            	dc.b	243
2546  0013 46            	dc.b	70
2547  0014 27            	dc.b	39
2548  0015 92            	dc.b	146
2549  0016 f8            	dc.b	248
2550  0017 4d            	dc.b	77
2551  0018 3a            	dc.b	58
2552  0019 8f            	dc.b	143
2553  001a e5            	dc.b	229
2554  001b 50            	dc.b	80
2555  001c 31            	dc.b	49
2556  001d 84            	dc.b	132
2557  001e ee            	dc.b	238
2558  001f 5b            	dc.b	91
2559  0020 58            	dc.b	88
2560  0021 ed            	dc.b	237
2561  0022 87            	dc.b	135
2562  0023 32            	dc.b	50
2563  0024 53            	dc.b	83
2564  0025 e6            	dc.b	230
2565  0026 8c            	dc.b	140
2566  0027 39            	dc.b	57
2567  0028 4e            	dc.b	78
2568  0029 fb            	dc.b	251
2569  002a 91            	dc.b	145
2570  002b 24            	dc.b	36
2571  002c 45            	dc.b	69
2572  002d f0            	dc.b	240
2573  002e 9a            	dc.b	154
2574  002f 2f            	dc.b	47
2575  0030 74            	dc.b	116
2576  0031 c1            	dc.b	193
2577  0032 ab            	dc.b	171
2578  0033 1e            	dc.b	30
2579  0034 7f            	dc.b	127
2580  0035 ca            	dc.b	202
2581  0036 a0            	dc.b	160
2582  0037 15            	dc.b	21
2583  0038 62            	dc.b	98
2584  0039 d7            	dc.b	215
2585  003a bd            	dc.b	189
2586  003b 08            	dc.b	8
2587  003c 69            	dc.b	105
2588  003d dc            	dc.b	220
2589  003e b6            	dc.b	182
2590  003f 03            	dc.b	3
2591  0040 b0            	dc.b	176
2592  0041 05            	dc.b	5
2593  0042 6f            	dc.b	111
2594  0043 da            	dc.b	218
2595  0044 bb            	dc.b	187
2596  0045 0e            	dc.b	14
2597  0046 64            	dc.b	100
2598  0047 d1            	dc.b	209
2599  0048 a6            	dc.b	166
2600  0049 13            	dc.b	19
2601  004a 79            	dc.b	121
2602  004b cc            	dc.b	204
2603  004c ad            	dc.b	173
2604  004d 18            	dc.b	24
2605  004e 72            	dc.b	114
2606  004f c7            	dc.b	199
2607  0050 9c            	dc.b	156
2608  0051 29            	dc.b	41
2609  0052 43            	dc.b	67
2610  0053 f6            	dc.b	246
2611  0054 97            	dc.b	151
2612  0055 22            	dc.b	34
2613  0056 48            	dc.b	72
2614  0057 fd            	dc.b	253
2615  0058 8a            	dc.b	138
2616  0059 3f            	dc.b	63
2617  005a 55            	dc.b	85
2618  005b e0            	dc.b	224
2619  005c 81            	dc.b	129
2620  005d 34            	dc.b	52
2621  005e 5e            	dc.b	94
2622  005f eb            	dc.b	235
2623  0060 e8            	dc.b	232
2624  0061 5d            	dc.b	93
2625  0062 37            	dc.b	55
2626  0063 82            	dc.b	130
2627  0064 e3            	dc.b	227
2628  0065 56            	dc.b	86
2629  0066 3c            	dc.b	60
2630  0067 89            	dc.b	137
2631  0068 fe            	dc.b	254
2632  0069 4b            	dc.b	75
2633  006a 21            	dc.b	33
2634  006b 94            	dc.b	148
2635  006c f5            	dc.b	245
2636  006d 40            	dc.b	64
2637  006e 2a            	dc.b	42
2638  006f 9f            	dc.b	159
2639  0070 c4            	dc.b	196
2640  0071 71            	dc.b	113
2641  0072 1b            	dc.b	27
2642  0073 ae            	dc.b	174
2643  0074 cf            	dc.b	207
2644  0075 7a            	dc.b	122
2645  0076 10            	dc.b	16
2646  0077 a5            	dc.b	165
2647  0078 d2            	dc.b	210
2648  0079 67            	dc.b	103
2649  007a 0d            	dc.b	13
2650  007b b8            	dc.b	184
2651  007c d9            	dc.b	217
2652  007d 6c            	dc.b	108
2653  007e 06            	dc.b	6
2654  007f b3            	dc.b	179
2655  0080 d5            	dc.b	213
2656  0081 60            	dc.b	96
2657  0082 0a            	dc.b	10
2658  0083 bf            	dc.b	191
2659  0084 de            	dc.b	222
2660  0085 6b            	dc.b	107
2661  0086 01            	dc.b	1
2662  0087 b4            	dc.b	180
2663  0088 c3            	dc.b	195
2664  0089 76            	dc.b	118
2665  008a 1c            	dc.b	28
2666  008b a9            	dc.b	169
2667  008c c8            	dc.b	200
2668  008d 7d            	dc.b	125
2669  008e 17            	dc.b	23
2670  008f a2            	dc.b	162
2671  0090 f9            	dc.b	249
2672  0091 4c            	dc.b	76
2673  0092 26            	dc.b	38
2674  0093 93            	dc.b	147
2675  0094 f2            	dc.b	242
2676  0095 47            	dc.b	71
2677  0096 2d            	dc.b	45
2678  0097 98            	dc.b	152
2679  0098 ef            	dc.b	239
2680  0099 5a            	dc.b	90
2681  009a 30            	dc.b	48
2682  009b 85            	dc.b	133
2683  009c e4            	dc.b	228
2684  009d 51            	dc.b	81
2685  009e 3b            	dc.b	59
2686  009f 8e            	dc.b	142
2687  00a0 8d            	dc.b	141
2688  00a1 38            	dc.b	56
2689  00a2 52            	dc.b	82
2690  00a3 e7            	dc.b	231
2691  00a4 86            	dc.b	134
2692  00a5 33            	dc.b	51
2693  00a6 59            	dc.b	89
2694  00a7 ec            	dc.b	236
2695  00a8 9b            	dc.b	155
2696  00a9 2e            	dc.b	46
2697  00aa 44            	dc.b	68
2698  00ab f1            	dc.b	241
2699  00ac 90            	dc.b	144
2700  00ad 25            	dc.b	37
2701  00ae 4f            	dc.b	79
2702  00af fa            	dc.b	250
2703  00b0 a1            	dc.b	161
2704  00b1 14            	dc.b	20
2705  00b2 7e            	dc.b	126
2706  00b3 cb            	dc.b	203
2707  00b4 aa            	dc.b	170
2708  00b5 1f            	dc.b	31
2709  00b6 75            	dc.b	117
2710  00b7 c0            	dc.b	192
2711  00b8 b7            	dc.b	183
2712  00b9 02            	dc.b	2
2713  00ba 68            	dc.b	104
2714  00bb dd            	dc.b	221
2715  00bc bc            	dc.b	188
2716  00bd 09            	dc.b	9
2717  00be 63            	dc.b	99
2718  00bf d6            	dc.b	214
2719  00c0 65            	dc.b	101
2720  00c1 d0            	dc.b	208
2721  00c2 ba            	dc.b	186
2722  00c3 0f            	dc.b	15
2723  00c4 6e            	dc.b	110
2724  00c5 db            	dc.b	219
2725  00c6 b1            	dc.b	177
2726  00c7 04            	dc.b	4
2727  00c8 73            	dc.b	115
2728  00c9 c6            	dc.b	198
2729  00ca ac            	dc.b	172
2730  00cb 19            	dc.b	25
2731  00cc 78            	dc.b	120
2732  00cd cd            	dc.b	205
2733  00ce a7            	dc.b	167
2734  00cf 12            	dc.b	18
2735  00d0 49            	dc.b	73
2736  00d1 fc            	dc.b	252
2737  00d2 96            	dc.b	150
2738  00d3 23            	dc.b	35
2739  00d4 42            	dc.b	66
2740  00d5 f7            	dc.b	247
2741  00d6 9d            	dc.b	157
2742  00d7 28            	dc.b	40
2743  00d8 5f            	dc.b	95
2744  00d9 ea            	dc.b	234
2745  00da 80            	dc.b	128
2746  00db 35            	dc.b	53
2747  00dc 54            	dc.b	84
2748  00dd e1            	dc.b	225
2749  00de 8b            	dc.b	139
2750  00df 3e            	dc.b	62
2751  00e0 3d            	dc.b	61
2752  00e1 88            	dc.b	136
2753  00e2 e2            	dc.b	226
2754  00e3 57            	dc.b	87
2755  00e4 36            	dc.b	54
2756  00e5 83            	dc.b	131
2757  00e6 e9            	dc.b	233
2758  00e7 5c            	dc.b	92
2759  00e8 2b            	dc.b	43
2760  00e9 9e            	dc.b	158
2761  00ea f4            	dc.b	244
2762  00eb 41            	dc.b	65
2763  00ec 20            	dc.b	32
2764  00ed 95            	dc.b	149
2765  00ee ff            	dc.b	255
2766  00ef 4a            	dc.b	74
2767  00f0 11            	dc.b	17
2768  00f1 a4            	dc.b	164
2769  00f2 ce            	dc.b	206
2770  00f3 7b            	dc.b	123
2771  00f4 1a            	dc.b	26
2772  00f5 af            	dc.b	175
2773  00f6 c5            	dc.b	197
2774  00f7 70            	dc.b	112
2775  00f8 07            	dc.b	7
2776  00f9 b2            	dc.b	178
2777  00fa d8            	dc.b	216
2778  00fb 6d            	dc.b	109
2779  00fc 0c            	dc.b	12
2780  00fd b9            	dc.b	185
2781  00fe d3            	dc.b	211
2782  00ff 66            	dc.b	102
2783                     	bsct
2784  0000               _tx_wd_cnt:
2785  0000 64            	dc.b	100
2786  0001               _tx_stat:
2787  0001 00            	dc.b	0
2856                     ; 45 char power_cnt_crc(char* adr, char len)
2856                     ; 46 {
2857                     	switch	.text
2858  0000               f_power_cnt_crc:
2860  0000 89            	pushw	x
2861  0001 89            	pushw	x
2862       00000002      OFST:	set	2
2865                     ; 50 r=0;
2867  0002 0f01          	clr	(OFST-1,sp)
2868                     ; 51 for(j=1;j<len;j++)
2870  0004 a601          	ld	a,#1
2871  0006 6b02          	ld	(OFST+0,sp),a
2873  0008 2017          	jra	L7661
2874  000a               L3661:
2875                     ; 53 	r=crc8tab[r^adr[j]];
2877  000a 7b03          	ld	a,(OFST+1,sp)
2878  000c 97            	ld	xl,a
2879  000d 7b04          	ld	a,(OFST+2,sp)
2880  000f 1b02          	add	a,(OFST+0,sp)
2881  0011 2401          	jrnc	L6
2882  0013 5c            	incw	x
2883  0014               L6:
2884  0014 02            	rlwa	x,a
2885  0015 f6            	ld	a,(x)
2886  0016 1801          	xor	a,(OFST-1,sp)
2887  0018 5f            	clrw	x
2888  0019 97            	ld	xl,a
2889  001a d60000        	ld	a,(_crc8tab,x)
2890  001d 6b01          	ld	(OFST-1,sp),a
2891                     ; 51 for(j=1;j<len;j++)
2893  001f 0c02          	inc	(OFST+0,sp)
2894  0021               L7661:
2897  0021 7b02          	ld	a,(OFST+0,sp)
2898  0023 1108          	cp	a,(OFST+6,sp)
2899  0025 25e3          	jrult	L3661
2900                     ; 67 return r;	
2902  0027 7b01          	ld	a,(OFST-1,sp)
2905  0029 5b04          	addw	sp,#4
2906  002b 87            	retf
2979                     ; 72 void uart_out_adr(char *ptr, char len)
2979                     ; 73 {
2980                     	switch	.text
2981  002c               f_uart_out_adr:
2983  002c 89            	pushw	x
2984  002d 5270          	subw	sp,#112
2985       00000070      OFST:	set	112
2988                     ; 75 @near char i,t=0;
2990  002f 0f01          	clr	(OFST-111,sp)
2991                     ; 77 for(i=0;i<len;i++)
2993  0031 0f70          	clr	(OFST+0,sp)
2995  0033 201d          	jra	L5371
2996  0035               L1371:
2997                     ; 79 	UOB[i]=ptr[i];
2999  0035 96            	ldw	x,sp
3000  0036 1c0002        	addw	x,#OFST-110
3001  0039 9f            	ld	a,xl
3002  003a 5e            	swapw	x
3003  003b 1b70          	add	a,(OFST+0,sp)
3004  003d 2401          	jrnc	L21
3005  003f 5c            	incw	x
3006  0040               L21:
3007  0040 02            	rlwa	x,a
3008  0041 89            	pushw	x
3009  0042 7b73          	ld	a,(OFST+3,sp)
3010  0044 97            	ld	xl,a
3011  0045 7b74          	ld	a,(OFST+4,sp)
3012  0047 1b72          	add	a,(OFST+2,sp)
3013  0049 2401          	jrnc	L41
3014  004b 5c            	incw	x
3015  004c               L41:
3016  004c 02            	rlwa	x,a
3017  004d f6            	ld	a,(x)
3018  004e 85            	popw	x
3019  004f f7            	ld	(x),a
3020                     ; 77 for(i=0;i<len;i++)
3022  0050 0c70          	inc	(OFST+0,sp)
3023  0052               L5371:
3026  0052 7b70          	ld	a,(OFST+0,sp)
3027  0054 1176          	cp	a,(OFST+6,sp)
3028  0056 25dd          	jrult	L1371
3029                     ; 83 GPIOD->ODR|=(1<<4);
3031  0058 7218500f      	bset	20495,#4
3032                     ; 85 tx_stat=tsON;
3034  005c 35010001      	mov	_tx_stat,#1
3035                     ; 87 for (i=0;i<len;i++)
3037  0060 0f70          	clr	(OFST+0,sp)
3039  0062 2013          	jra	L5471
3040  0064               L1471:
3041                     ; 89 	putchar(UOB[i]);
3043  0064 96            	ldw	x,sp
3044  0065 1c0002        	addw	x,#OFST-110
3045  0068 9f            	ld	a,xl
3046  0069 5e            	swapw	x
3047  006a 1b70          	add	a,(OFST+0,sp)
3048  006c 2401          	jrnc	L61
3049  006e 5c            	incw	x
3050  006f               L61:
3051  006f 02            	rlwa	x,a
3052  0070 f6            	ld	a,(x)
3053  0071 8d800080      	callf	f_putchar
3055                     ; 87 for (i=0;i<len;i++)
3057  0075 0c70          	inc	(OFST+0,sp)
3058  0077               L5471:
3061  0077 7b70          	ld	a,(OFST+0,sp)
3062  0079 1176          	cp	a,(OFST+6,sp)
3063  007b 25e7          	jrult	L1471
3064                     ; 91 }
3067  007d 5b72          	addw	sp,#114
3068  007f 87            	retf
3104                     ; 94 void putchar(char c)
3104                     ; 95 {
3105                     	switch	.text
3106  0080               f_putchar:
3108  0080 88            	push	a
3109       00000000      OFST:	set	0
3112  0081               L1771:
3113                     ; 96 while (tx_counter == TX_BUFFER_SIZE);
3115  0081 b600          	ld	a,_tx_counter
3116  0083 a132          	cp	a,#50
3117  0085 27fa          	jreq	L1771
3118                     ; 98 if (tx_counter || ((UART2->SR & UART2_SR_TXE)==0))
3120  0087 3d00          	tnz	_tx_counter
3121  0089 2607          	jrne	L7771
3123  008b c65240        	ld	a,21056
3124  008e a580          	bcp	a,#128
3125  0090 261d          	jrne	L5771
3126  0092               L7771:
3127                     ; 100    tx_buffer[tx_wr_index]=c;
3129  0092 5f            	clrw	x
3130  0093 b600          	ld	a,_tx_wr_index
3131  0095 2a01          	jrpl	L22
3132  0097 53            	cplw	x
3133  0098               L22:
3134  0098 97            	ld	xl,a
3135  0099 7b01          	ld	a,(OFST+1,sp)
3136  009b e700          	ld	(_tx_buffer,x),a
3137                     ; 101    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
3139  009d 3c00          	inc	_tx_wr_index
3140  009f b600          	ld	a,_tx_wr_index
3141  00a1 a132          	cp	a,#50
3142  00a3 2602          	jrne	L1002
3145  00a5 3f00          	clr	_tx_wr_index
3146  00a7               L1002:
3147                     ; 102    ++tx_counter;
3149  00a7 3c00          	inc	_tx_counter
3151  00a9               L3002:
3152                     ; 106 UART2->CR2|= UART2_CR2_TIEN;
3154  00a9 721e5245      	bset	21061,#7
3155                     ; 107 }
3158  00ad 84            	pop	a
3159  00ae 87            	retf
3160  00af               L5771:
3161                     ; 104 else UART2->DR=c;
3163  00af 7b01          	ld	a,(OFST+1,sp)
3164  00b1 c75241        	ld	21057,a
3165  00b4 20f3          	jra	L3002
3202                     ; 111 void read_power_102m(void)
3202                     ; 112 {
3203                     	switch	.text
3204  00b6               f_read_power_102m:
3206  00b6 5214          	subw	sp,#20
3207       00000014      OFST:	set	20
3210                     ; 115 command_with_crc[0]=0xaf;  // /
3212  00b8 a6af          	ld	a,#175
3213  00ba 6b01          	ld	(OFST-19,sp),a
3214                     ; 116 command_with_crc[1]=0x3f;  // ?
3216  00bc a63f          	ld	a,#63
3217  00be 6b02          	ld	(OFST-18,sp),a
3218                     ; 117 command_with_crc[2]=0x21;  // !
3220  00c0 a621          	ld	a,#33
3221  00c2 6b03          	ld	(OFST-17,sp),a
3222                     ; 118 command_with_crc[3]=0x8d;  // CR
3224  00c4 a68d          	ld	a,#141
3225  00c6 6b04          	ld	(OFST-16,sp),a
3226                     ; 119 command_with_crc[4]=0x0a;  // LF
3228  00c8 a60a          	ld	a,#10
3229  00ca 6b05          	ld	(OFST-15,sp),a
3230                     ; 121 uart_out_adr(command_with_crc,5);
3232  00cc 4b05          	push	#5
3233  00ce 96            	ldw	x,sp
3234  00cf 1c0002        	addw	x,#OFST-18
3235  00d2 8d2c002c      	callf	f_uart_out_adr
3237  00d6 84            	pop	a
3238                     ; 124 rx_read_power_102m_phase=1;
3240  00d7 35010000      	mov	_rx_read_power_102m_phase,#1
3241                     ; 125 rx_wr_index=0;	
3243  00db 3f00          	clr	_rx_wr_index
3244                     ; 126 }
3247  00dd 5b14          	addw	sp,#20
3248  00df 87            	retf
3306                     ; 129 void read_power_102m_drv(void)
3306                     ; 130 {
3307                     	switch	.text
3308  00e0               f_read_power_102m_drv:
3310  00e0 5214          	subw	sp,#20
3311       00000014      OFST:	set	20
3314                     ; 131 if (rx_read_power_102m_phase==2)
3316  00e2 c60000        	ld	a,_rx_read_power_102m_phase
3317  00e5 a102          	cp	a,#2
3318  00e7 2629          	jrne	L1502
3319                     ; 135 	command_with_crc[0]=0x06;  //  
3321  00e9 a606          	ld	a,#6
3322  00eb 6b01          	ld	(OFST-19,sp),a
3323                     ; 136 	command_with_crc[1]=0x30;  // 0
3325  00ed a630          	ld	a,#48
3326  00ef 6b02          	ld	(OFST-18,sp),a
3327                     ; 137 	command_with_crc[2]=0x35;  // 5
3329  00f1 a635          	ld	a,#53
3330  00f3 6b03          	ld	(OFST-17,sp),a
3331                     ; 138 	command_with_crc[3]=0xb1;  // 1
3333  00f5 a6b1          	ld	a,#177
3334  00f7 6b04          	ld	(OFST-16,sp),a
3335                     ; 139 	command_with_crc[4]=0x8d;  // CR
3337  00f9 a68d          	ld	a,#141
3338  00fb 6b05          	ld	(OFST-15,sp),a
3339                     ; 140 	command_with_crc[5]=0x0a;  // LF
3341  00fd a60a          	ld	a,#10
3342  00ff 6b06          	ld	(OFST-14,sp),a
3343                     ; 142 	uart_out_adr(command_with_crc,6);
3345  0101 4b06          	push	#6
3346  0103 96            	ldw	x,sp
3347  0104 1c0002        	addw	x,#OFST-18
3348  0107 8d2c002c      	callf	f_uart_out_adr
3350  010b 84            	pop	a
3351                     ; 144 	rx_wr_index=0;
3353  010c 3f00          	clr	_rx_wr_index
3354                     ; 145 	rx_read_power_102m_phase=3;
3356  010e 35030000      	mov	_rx_read_power_102m_phase,#3
3357  0112               L1502:
3358                     ; 148 if (rx_read_power_102m_phase==5)
3360  0112 c60000        	ld	a,_rx_read_power_102m_phase
3361  0115 a105          	cp	a,#5
3362  0117 2645          	jrne	L3502
3363                     ; 152 	command_with_crc[0]=0x81;  //  
3365  0119 a681          	ld	a,#129
3366  011b 6b01          	ld	(OFST-19,sp),a
3367                     ; 153 	command_with_crc[1]=0xD2;  // R
3369  011d a6d2          	ld	a,#210
3370  011f 6b02          	ld	(OFST-18,sp),a
3371                     ; 154 	command_with_crc[2]=0xb1;  // 1
3373  0121 a6b1          	ld	a,#177
3374  0123 6b03          	ld	(OFST-17,sp),a
3375                     ; 155 	command_with_crc[3]=0x82;  // 
3377  0125 a682          	ld	a,#130
3378  0127 6b04          	ld	(OFST-16,sp),a
3379                     ; 156 	command_with_crc[4]=0xC5;  // E 
3381  0129 a6c5          	ld	a,#197
3382  012b 6b05          	ld	(OFST-15,sp),a
3383                     ; 157 	command_with_crc[5]=0xD4;  // T
3385  012d a6d4          	ld	a,#212
3386  012f 6b06          	ld	(OFST-14,sp),a
3387                     ; 158 	command_with_crc[6]=0x30;  // 0
3389  0131 a630          	ld	a,#48
3390  0133 6b07          	ld	(OFST-13,sp),a
3391                     ; 159 	command_with_crc[7]=0x50;  // P
3393  0135 a650          	ld	a,#80
3394  0137 6b08          	ld	(OFST-12,sp),a
3395                     ; 160 	command_with_crc[8]=0xC5;  // E 
3397  0139 a6c5          	ld	a,#197
3398  013b 6b09          	ld	(OFST-11,sp),a
3399                     ; 161 	command_with_crc[9]=0x28;  // (
3401  013d a628          	ld	a,#40
3402  013f 6b0a          	ld	(OFST-10,sp),a
3403                     ; 162 	command_with_crc[10]=0xA9;  // )
3405  0141 a6a9          	ld	a,#169
3406  0143 6b0b          	ld	(OFST-9,sp),a
3407                     ; 163 	command_with_crc[11]=0x03;  // 
3409  0145 a603          	ld	a,#3
3410  0147 6b0c          	ld	(OFST-8,sp),a
3411                     ; 164 	command_with_crc[12]=0xb7;  // bcc
3413  0149 a6b7          	ld	a,#183
3414  014b 6b0d          	ld	(OFST-7,sp),a
3415                     ; 166 	uart_out_adr(command_with_crc,13);
3417  014d 4b0d          	push	#13
3418  014f 96            	ldw	x,sp
3419  0150 1c0002        	addw	x,#OFST-18
3420  0153 8d2c002c      	callf	f_uart_out_adr
3422  0157 84            	pop	a
3423                     ; 168 	rx_wr_index=0;
3425  0158 3f00          	clr	_rx_wr_index
3426                     ; 169 	rx_read_power_102m_phase=6;
3428  015a 35060000      	mov	_rx_read_power_102m_phase,#6
3429  015e               L3502:
3430                     ; 190 if (rx_read_power_102m_phase==10)
3432  015e c60000        	ld	a,_rx_read_power_102m_phase
3433  0161 a10a          	cp	a,#10
3434  0163 2645          	jrne	L5502
3435                     ; 194 	command_with_crc[0]=0x81;  //  
3437  0165 a681          	ld	a,#129
3438  0167 6b01          	ld	(OFST-19,sp),a
3439                     ; 195 	command_with_crc[1]=0xD2;  // R
3441  0169 a6d2          	ld	a,#210
3442  016b 6b02          	ld	(OFST-18,sp),a
3443                     ; 196 	command_with_crc[2]=0xb1;  // 1
3445  016d a6b1          	ld	a,#177
3446  016f 6b03          	ld	(OFST-17,sp),a
3447                     ; 197 	command_with_crc[3]=0x82;  // 
3449  0171 a682          	ld	a,#130
3450  0173 6b04          	ld	(OFST-16,sp),a
3451                     ; 198 	command_with_crc[4]=0x50;  // P 
3453  0175 a650          	ld	a,#80
3454  0177 6b05          	ld	(OFST-15,sp),a
3455                     ; 199 	command_with_crc[5]=0xCF;  // O
3457  0179 a6cf          	ld	a,#207
3458  017b 6b06          	ld	(OFST-14,sp),a
3459                     ; 200 	command_with_crc[6]=0xd7;  // W
3461  017d a6d7          	ld	a,#215
3462  017f 6b07          	ld	(OFST-13,sp),a
3463                     ; 201 	command_with_crc[7]=0xc5;  // E
3465  0181 a6c5          	ld	a,#197
3466  0183 6b08          	ld	(OFST-12,sp),a
3467                     ; 202 	command_with_crc[8]=0x50;  // P 
3469  0185 a650          	ld	a,#80
3470  0187 6b09          	ld	(OFST-11,sp),a
3471                     ; 203 	command_with_crc[9]=0x28;  // (
3473  0189 a628          	ld	a,#40
3474  018b 6b0a          	ld	(OFST-10,sp),a
3475                     ; 204 	command_with_crc[10]=0xA9;  // )
3477  018d a6a9          	ld	a,#169
3478  018f 6b0b          	ld	(OFST-9,sp),a
3479                     ; 205 	command_with_crc[11]=0x03;  // 
3481  0191 a603          	ld	a,#3
3482  0193 6b0c          	ld	(OFST-8,sp),a
3483                     ; 206 	command_with_crc[12]=0xe4;  // bcc
3485  0195 a6e4          	ld	a,#228
3486  0197 6b0d          	ld	(OFST-7,sp),a
3487                     ; 208 	uart_out_adr(command_with_crc,13);
3489  0199 4b0d          	push	#13
3490  019b 96            	ldw	x,sp
3491  019c 1c0002        	addw	x,#OFST-18
3492  019f 8d2c002c      	callf	f_uart_out_adr
3494  01a3 84            	pop	a
3495                     ; 210 	rx_wr_index=0;
3497  01a4 3f00          	clr	_rx_wr_index
3498                     ; 211 	rx_read_power_102m_phase=11;
3500  01a6 350b0000      	mov	_rx_read_power_102m_phase,#11
3501  01aa               L5502:
3502                     ; 213 }
3505  01aa 5b14          	addw	sp,#20
3506  01ac 87            	retf
3566                     ; 216 void read_current_power(void)
3566                     ; 217 {
3567                     	switch	.text
3568  01ad               f_read_current_power:
3570  01ad 5229          	subw	sp,#41
3571       00000029      OFST:	set	41
3574                     ; 220 command_with_crc[0]=0xc0;
3576  01af a6c0          	ld	a,#192
3577  01b1 6b16          	ld	(OFST-19,sp),a
3578                     ; 221 command_with_crc[1]=0x48;
3580  01b3 a648          	ld	a,#72
3581  01b5 6b17          	ld	(OFST-18,sp),a
3582                     ; 222 command_with_crc[2]=power_cnt_adrl;
3584  01b7 b600          	ld	a,_power_cnt_adrl
3585  01b9 6b18          	ld	(OFST-17,sp),a
3586                     ; 223 command_with_crc[3]=power_cnt_adrh;
3588  01bb b600          	ld	a,_power_cnt_adrh
3589  01bd 6b19          	ld	(OFST-16,sp),a
3590                     ; 224 command_with_crc[4]=0;
3592  01bf 0f1a          	clr	(OFST-15,sp)
3593                     ; 225 command_with_crc[5]=0;
3595  01c1 0f1b          	clr	(OFST-14,sp)
3596                     ; 227 command_with_crc[6]=0;
3598  01c3 0f1c          	clr	(OFST-13,sp)
3599                     ; 228 command_with_crc[7]=0;
3601  01c5 0f1d          	clr	(OFST-12,sp)
3602                     ; 229 command_with_crc[8]=0;
3604  01c7 0f1e          	clr	(OFST-11,sp)
3605                     ; 230 command_with_crc[9]=0;
3607  01c9 0f1f          	clr	(OFST-10,sp)
3608                     ; 232 command_with_crc[10]=0xd0;
3610  01cb a6d0          	ld	a,#208
3611  01cd 6b20          	ld	(OFST-9,sp),a
3612                     ; 234 command_with_crc[11]=0x01;
3614  01cf a601          	ld	a,#1
3615  01d1 6b21          	ld	(OFST-8,sp),a
3616                     ; 235 command_with_crc[12]=0x32;
3618  01d3 a632          	ld	a,#50
3619  01d5 6b22          	ld	(OFST-7,sp),a
3620                     ; 237 command_with_crc[13]=power_cnt_crc(command_with_crc,13);
3622  01d7 4b0d          	push	#13
3623  01d9 96            	ldw	x,sp
3624  01da 1c0017        	addw	x,#OFST-18
3625  01dd 8d000000      	callf	f_power_cnt_crc
3627  01e1 5b01          	addw	sp,#1
3628  01e3 6b23          	ld	(OFST-6,sp),a
3629                     ; 238 command_with_crc[14]=0xc0;
3631  01e5 a6c0          	ld	a,#192
3632  01e7 6b24          	ld	(OFST-5,sp),a
3633                     ; 241 len=sleep_coding(command_with_crc,command_with_crc_with_sleep,15);
3635  01e9 4b0f          	push	#15
3636  01eb 96            	ldw	x,sp
3637  01ec 1c0002        	addw	x,#OFST-39
3638  01ef 89            	pushw	x
3639  01f0 96            	ldw	x,sp
3640  01f1 1c0019        	addw	x,#OFST-16
3641  01f4 8d730273      	callf	f_sleep_coding
3643  01f8 5b03          	addw	sp,#3
3644  01fa 6b15          	ld	(OFST-20,sp),a
3645                     ; 243 uart_out_adr(command_with_crc_with_sleep,len);
3647  01fc 7b15          	ld	a,(OFST-20,sp)
3648  01fe 88            	push	a
3649  01ff 96            	ldw	x,sp
3650  0200 1c0002        	addw	x,#OFST-39
3651  0203 8d2c002c      	callf	f_uart_out_adr
3653  0207 84            	pop	a
3654                     ; 244 rx_read_power_102m_phase=0;
3656  0208 725f0000      	clr	_rx_read_power_102m_phase
3657                     ; 246 }
3660  020c 5b29          	addw	sp,#41
3661  020e 87            	retf
3721                     ; 250 void read_summary_power(void)
3721                     ; 251 {
3722                     	switch	.text
3723  020f               f_read_summary_power:
3725  020f 5229          	subw	sp,#41
3726       00000029      OFST:	set	41
3729                     ; 254 command_with_crc[0]=0xc0;
3731  0211 a6c0          	ld	a,#192
3732  0213 6b16          	ld	(OFST-19,sp),a
3733                     ; 255 command_with_crc[1]=0x48;
3735  0215 a648          	ld	a,#72
3736  0217 6b17          	ld	(OFST-18,sp),a
3737                     ; 256 command_with_crc[2]=power_cnt_adrl;
3739  0219 b600          	ld	a,_power_cnt_adrl
3740  021b 6b18          	ld	(OFST-17,sp),a
3741                     ; 257 command_with_crc[3]=power_cnt_adrh;
3743  021d b600          	ld	a,_power_cnt_adrh
3744  021f 6b19          	ld	(OFST-16,sp),a
3745                     ; 258 command_with_crc[4]=0;
3747  0221 0f1a          	clr	(OFST-15,sp)
3748                     ; 259 command_with_crc[5]=0;
3750  0223 0f1b          	clr	(OFST-14,sp)
3751                     ; 261 command_with_crc[6]=0;
3753  0225 0f1c          	clr	(OFST-13,sp)
3754                     ; 262 command_with_crc[7]=0;
3756  0227 0f1d          	clr	(OFST-12,sp)
3757                     ; 263 command_with_crc[8]=0;
3759  0229 0f1e          	clr	(OFST-11,sp)
3760                     ; 264 command_with_crc[9]=0;
3762  022b 0f1f          	clr	(OFST-10,sp)
3763                     ; 266 command_with_crc[10]=0xd1;
3765  022d a6d1          	ld	a,#209
3766  022f 6b20          	ld	(OFST-9,sp),a
3767                     ; 268 command_with_crc[11]=0x01;
3769  0231 a601          	ld	a,#1
3770  0233 6b21          	ld	(OFST-8,sp),a
3771                     ; 269 command_with_crc[12]=0x31;
3773  0235 a631          	ld	a,#49
3774  0237 6b22          	ld	(OFST-7,sp),a
3775                     ; 271 command_with_crc[13]=0x00;
3777  0239 0f23          	clr	(OFST-6,sp)
3778                     ; 273 command_with_crc[14]=power_cnt_crc(command_with_crc,14);
3780  023b 4b0e          	push	#14
3781  023d 96            	ldw	x,sp
3782  023e 1c0017        	addw	x,#OFST-18
3783  0241 8d000000      	callf	f_power_cnt_crc
3785  0245 5b01          	addw	sp,#1
3786  0247 6b24          	ld	(OFST-5,sp),a
3787                     ; 274 command_with_crc[15]=0xc0;
3789  0249 a6c0          	ld	a,#192
3790  024b 6b25          	ld	(OFST-4,sp),a
3791                     ; 277 len=sleep_coding(command_with_crc,command_with_crc_with_sleep,16);
3793  024d 4b10          	push	#16
3794  024f 96            	ldw	x,sp
3795  0250 1c0002        	addw	x,#OFST-39
3796  0253 89            	pushw	x
3797  0254 96            	ldw	x,sp
3798  0255 1c0019        	addw	x,#OFST-16
3799  0258 8d730273      	callf	f_sleep_coding
3801  025c 5b03          	addw	sp,#3
3802  025e 6b15          	ld	(OFST-20,sp),a
3803                     ; 279 uart_out_adr(command_with_crc_with_sleep,len);
3805  0260 7b15          	ld	a,(OFST-20,sp)
3806  0262 88            	push	a
3807  0263 96            	ldw	x,sp
3808  0264 1c0002        	addw	x,#OFST-39
3809  0267 8d2c002c      	callf	f_uart_out_adr
3811  026b 84            	pop	a
3812                     ; 280 rx_read_power_102m_phase=0;
3814  026c 725f0000      	clr	_rx_read_power_102m_phase
3815                     ; 282 }
3818  0270 5b29          	addw	sp,#41
3819  0272 87            	retf
3890                     ; 286 char sleep_coding(char* adr_src,char* adr_dst,char str_len)
3890                     ; 287 {
3891                     	switch	.text
3892  0273               f_sleep_coding:
3894  0273 89            	pushw	x
3895  0274 89            	pushw	x
3896       00000002      OFST:	set	2
3899                     ; 290 new_len=str_len;
3901  0275 7b0a          	ld	a,(OFST+8,sp)
3902  0277 6b02          	ld	(OFST+0,sp),a
3903                     ; 292 *adr_dst=*adr_src;
3905  0279 f6            	ld	a,(x)
3906  027a 1e08          	ldw	x,(OFST+6,sp)
3907  027c f7            	ld	(x),a
3908                     ; 293 adr_dst++;
3910  027d 1e08          	ldw	x,(OFST+6,sp)
3911  027f 1c0001        	addw	x,#1
3912  0282 1f08          	ldw	(OFST+6,sp),x
3913                     ; 294 adr_src++;
3915  0284 1e03          	ldw	x,(OFST+1,sp)
3916  0286 1c0001        	addw	x,#1
3917  0289 1f03          	ldw	(OFST+1,sp),x
3918                     ; 296 for(i=1;i<(str_len-1);i++)
3920  028b a601          	ld	a,#1
3921  028d 6b01          	ld	(OFST-1,sp),a
3923  028f 205c          	jra	L5712
3924  0291               L1712:
3925                     ; 298      if(*adr_src==0xc0)
3927  0291 1e03          	ldw	x,(OFST+1,sp)
3928  0293 f6            	ld	a,(x)
3929  0294 a1c0          	cp	a,#192
3930  0296 261c          	jrne	L1022
3931                     ; 300           *adr_dst=0xdb;
3933  0298 1e08          	ldw	x,(OFST+6,sp)
3934  029a a6db          	ld	a,#219
3935  029c f7            	ld	(x),a
3936                     ; 301           adr_dst++;
3938  029d 1e08          	ldw	x,(OFST+6,sp)
3939  029f 1c0001        	addw	x,#1
3940  02a2 1f08          	ldw	(OFST+6,sp),x
3941                     ; 302           *adr_dst=0xdc;
3943  02a4 1e08          	ldw	x,(OFST+6,sp)
3944  02a6 a6dc          	ld	a,#220
3945  02a8 f7            	ld	(x),a
3946                     ; 303           adr_dst++;
3948  02a9 1e08          	ldw	x,(OFST+6,sp)
3949  02ab 1c0001        	addw	x,#1
3950  02ae 1f08          	ldw	(OFST+6,sp),x
3951                     ; 304           new_len++;
3953  02b0 0c02          	inc	(OFST+0,sp)
3955  02b2 2030          	jra	L3022
3956  02b4               L1022:
3957                     ; 306      else if(*adr_src==0xdb)
3959  02b4 1e03          	ldw	x,(OFST+1,sp)
3960  02b6 f6            	ld	a,(x)
3961  02b7 a1db          	cp	a,#219
3962  02b9 261c          	jrne	L5022
3963                     ; 308           *adr_dst=0xdb;
3965  02bb 1e08          	ldw	x,(OFST+6,sp)
3966  02bd a6db          	ld	a,#219
3967  02bf f7            	ld	(x),a
3968                     ; 309           adr_dst++;
3970  02c0 1e08          	ldw	x,(OFST+6,sp)
3971  02c2 1c0001        	addw	x,#1
3972  02c5 1f08          	ldw	(OFST+6,sp),x
3973                     ; 310           *adr_dst=0xdd;
3975  02c7 1e08          	ldw	x,(OFST+6,sp)
3976  02c9 a6dd          	ld	a,#221
3977  02cb f7            	ld	(x),a
3978                     ; 311           adr_dst++;
3980  02cc 1e08          	ldw	x,(OFST+6,sp)
3981  02ce 1c0001        	addw	x,#1
3982  02d1 1f08          	ldw	(OFST+6,sp),x
3983                     ; 312           new_len++;
3985  02d3 0c02          	inc	(OFST+0,sp)
3987  02d5 200d          	jra	L3022
3988  02d7               L5022:
3989                     ; 316           *adr_dst=*adr_src;
3991  02d7 1e03          	ldw	x,(OFST+1,sp)
3992  02d9 f6            	ld	a,(x)
3993  02da 1e08          	ldw	x,(OFST+6,sp)
3994  02dc f7            	ld	(x),a
3995                     ; 317           adr_dst++;
3997  02dd 1e08          	ldw	x,(OFST+6,sp)
3998  02df 1c0001        	addw	x,#1
3999  02e2 1f08          	ldw	(OFST+6,sp),x
4000  02e4               L3022:
4001                     ; 319      adr_src++;
4003  02e4 1e03          	ldw	x,(OFST+1,sp)
4004  02e6 1c0001        	addw	x,#1
4005  02e9 1f03          	ldw	(OFST+1,sp),x
4006                     ; 296 for(i=1;i<(str_len-1);i++)
4008  02eb 0c01          	inc	(OFST-1,sp)
4009  02ed               L5712:
4012  02ed 9c            	rvf
4013  02ee 7b0a          	ld	a,(OFST+8,sp)
4014  02f0 5f            	clrw	x
4015  02f1 97            	ld	xl,a
4016  02f2 5a            	decw	x
4017  02f3 7b01          	ld	a,(OFST-1,sp)
4018  02f5 905f          	clrw	y
4019  02f7 9097          	ld	yl,a
4020  02f9 90bf00        	ldw	c_y,y
4021  02fc b300          	cpw	x,c_y
4022  02fe 2c91          	jrsgt	L1712
4023                     ; 322 *adr_dst=*adr_src;
4025  0300 1e03          	ldw	x,(OFST+1,sp)
4026  0302 f6            	ld	a,(x)
4027  0303 1e08          	ldw	x,(OFST+6,sp)
4028  0305 f7            	ld	(x),a
4029                     ; 324 return new_len;
4031  0306 7b02          	ld	a,(OFST+0,sp)
4034  0308 5b04          	addw	sp,#4
4035  030a 87            	retf
4105                     ; 328 void sleep_an(void)
4105                     ; 329 {
4106                     	switch	.text
4107  030b               f_sleep_an:
4109  030b 5239          	subw	sp,#57
4110       00000039      OFST:	set	57
4113                     ; 335 ptr = sleep_pure_buff;
4115  030d 96            	ldw	x,sp
4116  030e 1c0005        	addw	x,#OFST-52
4117  0311 1f37          	ldw	(OFST-2,sp),x
4118                     ; 336 len_=sleep_len;
4120  0313 b601          	ld	a,_sleep_len
4121  0315 6b04          	ld	(OFST-53,sp),a
4122                     ; 340 sleep_plazma=sleep_buff[0];
4124  0317 450300        	mov	_sleep_plazma,_sleep_buff
4125                     ; 342 for(i=0;i<sleep_len;i++)
4127  031a 0f39          	clr	(OFST+0,sp)
4129  031c 2054          	jra	L7422
4130  031e               L3422:
4131                     ; 344      if(sleep_buff[i]==0xdb)
4133  031e 7b39          	ld	a,(OFST+0,sp)
4134  0320 5f            	clrw	x
4135  0321 97            	ld	xl,a
4136  0322 e603          	ld	a,(_sleep_buff,x)
4137  0324 a1db          	cp	a,#219
4138  0326 2638          	jrne	L3522
4139                     ; 346           if(sleep_buff[i+1]==0xdc)
4141  0328 7b39          	ld	a,(OFST+0,sp)
4142  032a 5f            	clrw	x
4143  032b 97            	ld	xl,a
4144  032c e604          	ld	a,(_sleep_buff+1,x)
4145  032e a1dc          	cp	a,#220
4146  0330 2612          	jrne	L5522
4147                     ; 348                *ptr=0x0c;
4149  0332 1e37          	ldw	x,(OFST-2,sp)
4150  0334 a60c          	ld	a,#12
4151  0336 f7            	ld	(x),a
4152                     ; 349                i++;
4154  0337 0c39          	inc	(OFST+0,sp)
4155                     ; 350                ptr++;
4157  0339 1e37          	ldw	x,(OFST-2,sp)
4158  033b 1c0001        	addw	x,#1
4159  033e 1f37          	ldw	(OFST-2,sp),x
4160                     ; 351                len_--;
4162  0340 0a04          	dec	(OFST-53,sp)
4164  0342 202c          	jra	L3622
4165  0344               L5522:
4166                     ; 354           else if(sleep_buff[i+1]==0xdd)
4168  0344 7b39          	ld	a,(OFST+0,sp)
4169  0346 5f            	clrw	x
4170  0347 97            	ld	xl,a
4171  0348 e604          	ld	a,(_sleep_buff+1,x)
4172  034a a1dd          	cp	a,#221
4173  034c 2622          	jrne	L3622
4174                     ; 356                *ptr=0xdb;
4176  034e 1e37          	ldw	x,(OFST-2,sp)
4177  0350 a6db          	ld	a,#219
4178  0352 f7            	ld	(x),a
4179                     ; 357                i++;
4181  0353 0c39          	inc	(OFST+0,sp)
4182                     ; 358                ptr++;
4184  0355 1e37          	ldw	x,(OFST-2,sp)
4185  0357 1c0001        	addw	x,#1
4186  035a 1f37          	ldw	(OFST-2,sp),x
4187                     ; 360                len_--;
4189  035c 0a04          	dec	(OFST-53,sp)
4190  035e 2010          	jra	L3622
4191  0360               L3522:
4192                     ; 365           *ptr=sleep_buff[i];
4194  0360 7b39          	ld	a,(OFST+0,sp)
4195  0362 5f            	clrw	x
4196  0363 97            	ld	xl,a
4197  0364 e603          	ld	a,(_sleep_buff,x)
4198  0366 1e37          	ldw	x,(OFST-2,sp)
4199  0368 f7            	ld	(x),a
4200                     ; 366           ptr++;
4202  0369 1e37          	ldw	x,(OFST-2,sp)
4203  036b 1c0001        	addw	x,#1
4204  036e 1f37          	ldw	(OFST-2,sp),x
4205  0370               L3622:
4206                     ; 342 for(i=0;i<sleep_len;i++)
4208  0370 0c39          	inc	(OFST+0,sp)
4209  0372               L7422:
4212  0372 7b39          	ld	a,(OFST+0,sp)
4213  0374 b101          	cp	a,_sleep_len
4214  0376 25a6          	jrult	L3422
4215                     ; 376 if(sleep_pure_buff[len_-2]==power_cnt_crc(sleep_pure_buff,len_-2))
4217  0378 7b04          	ld	a,(OFST-53,sp)
4218  037a a002          	sub	a,#2
4219  037c 88            	push	a
4220  037d 96            	ldw	x,sp
4221  037e 1c0006        	addw	x,#OFST-51
4222  0381 8d000000      	callf	f_power_cnt_crc
4224  0385 5b01          	addw	sp,#1
4225  0387 6b03          	ld	(OFST-54,sp),a
4226  0389 96            	ldw	x,sp
4227  038a 1c0005        	addw	x,#OFST-52
4228  038d 1f01          	ldw	(OFST-56,sp),x
4229  038f 7b04          	ld	a,(OFST-53,sp)
4230  0391 5f            	clrw	x
4231  0392 97            	ld	xl,a
4232  0393 5a            	decw	x
4233  0394 5a            	decw	x
4234  0395 72fb01        	addw	x,(OFST-56,sp)
4235  0398 f6            	ld	a,(x)
4236  0399 1103          	cp	a,(OFST-54,sp)
4237  039b 2667          	jrne	L5622
4238                     ; 379      if   (
4238                     ; 380           (sleep_pure_buff[1]==0x48)&&
4238                     ; 381           (sleep_pure_buff[2]==0)&&
4238                     ; 382           (sleep_pure_buff[3]==0)&&
4238                     ; 383           (sleep_pure_buff[4]==power_cnt_adrl)&&
4238                     ; 384           (sleep_pure_buff[5]==power_cnt_adrh)
4238                     ; 385           )
4240  039d 7b06          	ld	a,(OFST-51,sp)
4241  039f a148          	cp	a,#72
4242  03a1 2661          	jrne	L5622
4244  03a3 0d07          	tnz	(OFST-50,sp)
4245  03a5 265d          	jrne	L5622
4247  03a7 0d08          	tnz	(OFST-49,sp)
4248  03a9 2659          	jrne	L5622
4250  03ab 7b09          	ld	a,(OFST-48,sp)
4251  03ad b100          	cp	a,_power_cnt_adrl
4252  03af 2653          	jrne	L5622
4254  03b1 7b0a          	ld	a,(OFST-47,sp)
4255  03b3 b100          	cp	a,_power_cnt_adrh
4256  03b5 264d          	jrne	L5622
4257                     ; 389           if   (
4257                     ; 390                (sleep_pure_buff[7]==0x01)&&
4257                     ; 391                (sleep_pure_buff[8]==0x32)
4257                     ; 392                )
4259  03b7 7b0c          	ld	a,(OFST-45,sp)
4260  03b9 a101          	cp	a,#1
4261  03bb 2621          	jrne	L1722
4263  03bd 7b0d          	ld	a,(OFST-44,sp)
4264  03bf a132          	cp	a,#50
4265  03c1 261b          	jrne	L1722
4266                     ; 396                power_current=(((short)sleep_pure_buff[9]) + (((short)sleep_pure_buff[10])<<8))*10 ;
4268  03c3 7b0f          	ld	a,(OFST-42,sp)
4269  03c5 5f            	clrw	x
4270  03c6 97            	ld	xl,a
4271  03c7 4f            	clr	a
4272  03c8 02            	rlwa	x,a
4273  03c9 1f02          	ldw	(OFST-55,sp),x
4274  03cb 7b0e          	ld	a,(OFST-43,sp)
4275  03cd 5f            	clrw	x
4276  03ce 97            	ld	xl,a
4277  03cf 72fb02        	addw	x,(OFST-55,sp)
4278  03d2 90ae000a      	ldw	y,#10
4279  03d6 8d000000      	callf	d_imul
4281  03da bf00          	ldw	_power_current,x
4283  03dc 2026          	jra	L5622
4284  03de               L1722:
4285                     ; 399           else if   (
4285                     ; 400                (sleep_pure_buff[7]==0x01)&&
4285                     ; 401                (sleep_pure_buff[8]==0x31)
4285                     ; 402                )
4287  03de 7b0c          	ld	a,(OFST-45,sp)
4288  03e0 a101          	cp	a,#1
4289  03e2 2620          	jrne	L5622
4291  03e4 7b0d          	ld	a,(OFST-44,sp)
4292  03e6 a131          	cp	a,#49
4293  03e8 261a          	jrne	L5622
4294                     ; 406                power_summary= (
4294                     ; 407                               ((unsigned)sleep_pure_buff[9]) + 
4294                     ; 408                               (((unsigned)sleep_pure_buff[10])<<8)+ 
4294                     ; 409                               (((unsigned)sleep_pure_buff[11])<<16)+ 
4294                     ; 410                               (((unsigned)sleep_pure_buff[12])<<32)
4294                     ; 411                               ) ;
4296  03ea 7b0f          	ld	a,(OFST-42,sp)
4297  03ec 5f            	clrw	x
4298  03ed 97            	ld	xl,a
4299  03ee 4f            	clr	a
4300  03ef 02            	rlwa	x,a
4301  03f0 1f02          	ldw	(OFST-55,sp),x
4302  03f2 7b0e          	ld	a,(OFST-43,sp)
4303  03f4 5f            	clrw	x
4304  03f5 97            	ld	xl,a
4305  03f6 72fb02        	addw	x,(OFST-55,sp)
4306  03f9 8d000000      	callf	d_uitolx
4308  03fd ae0000        	ldw	x,#_power_summary
4309  0400 8d000000      	callf	d_rtol
4311  0404               L5622:
4312                     ; 419 }
4315  0404 5b39          	addw	sp,#57
4316  0406 87            	retf
4480                     	xdef	f_read_power_102m_drv
4481                     	xdef	f_read_power_102m
4482                     	xdef	f_read_summary_power
4483                     	xdef	f_power_cnt_crc
4484                     	xdef	f_uart_out_adr
4485                     	xdef	f_read_current_power
4486                     	xdef	f_sleep_coding
4487                     	xdef	f_sleep_an
4488                     	switch	.bss
4489  0000               _rx_read_power_102m_phase:
4490  0000 00            	ds.b	1
4491                     	xdef	_rx_read_power_102m_phase
4492                     	switch	.ubsct
4493  0000               _sleep_plazma:
4494  0000 00            	ds.b	1
4495                     	xdef	_sleep_plazma
4496  0001               _sleep_len:
4497  0001 00            	ds.b	1
4498                     	xdef	_sleep_len
4499  0002               _sleep_in:
4500  0002 00            	ds.b	1
4501                     	xdef	_sleep_in
4502  0003               _sleep_buff:
4503  0003 000000000000  	ds.b	50
4504                     	xdef	_sleep_buff
4505                     	xdef	_tx_stat
4506  0035               _tx_counter1:
4507  0035 00            	ds.b	1
4508                     	xdef	_tx_counter1
4509  0036               _tx_rd_index1:
4510  0036 00            	ds.b	1
4511                     	xdef	_tx_rd_index1
4512  0037               _tx_wr_index1:
4513  0037 00            	ds.b	1
4514                     	xdef	_tx_wr_index1
4515  0038               _rx_counter1:
4516  0038 00            	ds.b	1
4517                     	xdef	_rx_counter1
4518  0039               _rx_rd_index1:
4519  0039 00            	ds.b	1
4520                     	xdef	_rx_rd_index1
4521  003a               _rx_wr_index1:
4522  003a 00            	ds.b	1
4523                     	xdef	_rx_wr_index1
4524                     	xdef	_tx_wd_cnt
4525                     	xdef	_crc8tab
4526                     	xref.b	_rx_wr_index
4527                     	xref.b	_power_current
4528                     	xref.b	_power_summary
4529                     	xdef	f_putchar
4530                     	xref.b	_power_cnt_adrh
4531                     	xref.b	_power_cnt_adrl
4532                     	xref.b	_tx_wr_index
4533                     	xref.b	_tx_buffer
4534                     	xref.b	_tx_counter
4535                     	xref.b	c_x
4536                     	xref.b	c_y
4556                     	xref	d_rtol
4557                     	xref	d_uitolx
4558                     	xref	d_imul
4559                     	end
