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
__main			PROC
;==================doi little endian sang big endian==================================== 
				LDR    R0, =word          			; nap dia chi tu word vao thanh ghi R0 
				MOV    R1, #0x00000000				;khoi tao gia tri ban dau cho thanh ghi R1
				MOV    R2, #0 						;khoi tao gia tri ban dau cho thanh ghi R2 (index=0)
				MOV    R4, #0						;khoi tao gia tri ban dau cho thanh ghi R4  
loop            CMP    R2,#4        ; dieu kien cua vong lap kiem tra index, R2 dem so sanh voi 4
                BEQ    stoploop                     ;neu index= 4 thì ket thuc vong lap ,nhay den nhan stoploop
				LDRB   R1, [R0], #1 				;nap 1 byte du lieu tai o nho co dia chi R0 vao thanh ghi R0, sau lenh nay offset cua R0 tang len 1				
				LSL    R4,#8                        ; dich trai 8 bit tuong duong voi nhan 2 ^ 8 , dich trai so hexa 2 so
				ADD    R4, R1	                    ; cong don R1 vao R4
				ADD	   R2,#1  ; tang index len 1
				
				B	   loop                         ; tiep tuc vongg lap tiep theo
				
stoploop        
	            LDR		R3,=word1
				LDR     R0,=word
				STR		R4, [R0]
;==================================================================================

stop 			B 		stop     					; dead loop & program hangs here

				ENDP			
				ALIGN
				AREA    myData, DATA, READWRITE
				ALIGN
word            DCD    0x8765E3E1
word1			DCD    0
;num              DCD  1,2,3,4,5,6,7,8,9, 10 
;sum              DCD  100 ; tong 
				END
