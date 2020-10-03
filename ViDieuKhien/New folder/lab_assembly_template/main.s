;********************************************************************************************************
; file:     main.c
; author:   xxxx, your-email@maine.edu
; date:     mmm-dd-2015
; version:  1.0
; compiler: MDK 5.12
; note:     Warning: L6314W: No section matches pattern *(InRoot$$Sections).
;           It is because this program does not execute the compiler's basic run-time support library. 
; hardware: Discovery kit with STM32L152RCT6 MCU
; description: xxxx
;********************************************************************************************************

;********************************************************************************************************
; STM32L1 Discovery Kit Pin Connections (STM32L152RBT6 or STM32L152RCT6)
;  USER Pushbutton  <------>  PA.0 (clock: RCC_AHBENR_GPIOAEN)
;  RESET Pushbutton <------>  RESET
;  Green LED (LD3)  <------>  PB.7 (clock: RCC_AHBENR_GPIOBEN)
;  Blue LED (LD4)   <------>  PB.6 (clock: RCC_AHBENR_GPIOBEN)
;  Touch Sensors    <------>  6 pins, PA.6,7 (group 2), PB.0,1 (group 3), PC.4,5 (group 9)
;  LCD (24 segments)<------>  28 pins, PA.1,2,3,8,9,10,15, 
;                                      PB.3,4,5,8,9,10,11,12,13,14,15
;                                      PC.0,1,2,3,6,7,8,9,10,11 
;  ST Link          <------>  PA.13,14
;  Boot 1           <------>  PB.2
;  Freely available pins: PA.5, PA.11, PA.12, PC.12, PD.2 
;  A GPIO pin is 5V tolerant and can sink or source up to 8 mA
;********************************************************************************************************


		INCLUDE stm32l1xx_constants.s       ; Load Constant Definitions
		INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants

;********************************************************************************************************
;                                      CODE AREA
;********************************************************************************************************
		AREA main, CODE, READONLY
		EXPORT __main                       ; make __main visible to linker
		ENTRY


;********************************************************************************************************
;                                      MAIN FUNCTION
; Description  : xxxxxx
; C prototype  : void main (void)
; Note         : Has a dead loop and never exit
; Argument(s)  : none
; Return value : none
;********************************************************************************************************
__main	PROC

; khong dung lap
		;LDR  r0, =num		; nap dc cua num vao  r0(0x20000000)
		;MOV  R1, #0			;total =0
		;MOV  R2, #0			;i =0
		;;; xu ly a[0], r0=&a[0]
		;LDR r3, [r0]		;r3<--a[0]
		;ADD r1, r3 			; total +=a[0]
		;LSL r3, #2			; a[0] *=4 ; nhan la dich trai 
		;STR r3, [r0]		; a[0] *=4 store step
		;ADD r2, #1			;i+=1
		
		;;; xu ly a[1], r0+4=&a[1]
		;LDR r3, [r0,#4]		;r3<--a[1]
		;ADD r1, r3 			; total +=a[1]
		;LSL r3, #2			; a[1] *=4 ; nhan la dich trai 
		;STR r3, [r0,#4]		; a[1] *=4 store step
		;ADD r2,#1			;i+=1
		
		;;; xu ly a[2], r0+8=&a[2]
		;LDR r3, [r0,#8]		;r3<--a[2]
		;ADD r1, r3 			; total +=a[2]
		;LSL r3, #2			; a[2] *=4 ; nhan la dich trai 
		;STR r3, [r0,#8]		; a[2] *=4 store step
		;ADD r2,#1			;i+=1
		
		;;luu tong(r3) vao mem total
		;LDR r4, =total
		;STR r1, [r4]
		
;;;;;;;; dung lap		
		LDR  r0, =num		; nap dc cua num vao  r0(0x20000000)
		MOV  r1, #0			;total =0
		MOV  r2, #0			;i =0
		;MOV  r5, #0			; offset = 0
loop	CMP  r2, #10;so sanh i voi 10
		BEQ endloop; neu r2=10 thi re nhanh den endloop
		
		;;; xu ly a[i], base + offset =&a[i]
		LDR r3, [r0, r2, LSL #2]		;r3<--a[i]
		ADD r1, r3 			; total +=a[2]
		LSL r3, #2			; a[i] *=4 ; nhan la dich trai 
		STR r3, [r0,r2, LSL #2]		; a[i] *=4 store step
		ADD r2,#1			;i+=1
		;ADD r5, #4			; tang offset len 4 bytes
		B	loop			; re nhanh den label loop de  tiep tuc lap
		
endloop		
		;;luu tong(r3) vao mem total
		LDR r4, =total
		STR r1, [r4]
		
stop	B    stop                         ; dead loop & program hangs here

		ENDP
		ALIGN

;********************************************************************************************************
;                                      DATA AREA
;********************************************************************************************************
		AREA myData, DATA, READWRITE
		ALIGN
num		DCD 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
total   DCD 1000

;********************************************************************************************************
;                                      ASSEMBLY FILE END
;********************************************************************************************************
		END
