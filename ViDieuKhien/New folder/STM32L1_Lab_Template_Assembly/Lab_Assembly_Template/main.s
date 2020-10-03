;******************** (C) Yifeng ZHU ********************
; @file    main.s
; @author  Yifeng Zhu
; @version V1.0.0
; @date    May-5-2012
; @note    
; @brief   Assembly code for STM32L1xx Discovery Kit
; @note
;          This code is for the book "Embedded Systems with ARM Cortex-M3 
;          Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;          ISBN-10: 0982692625.
; @attension
;          This code is provided for education purpose. The author shall not be 
;          held liable for any direct, indirect or consequential damages, for any 
;          reason whatever. More information can be found from book website: 
;          http://www.eece.maine.edu/~zhu/book
;********************************************************

				
; STM32L1xx Discovery Kit:
;    - USER Pushbutton: connected to PA0 (GPIO Port A, PIN 0), CLK RCC_AHBENR_GPIOAEN
;    - RESET Pushbutton: connected RESET
;    - GREEN LED: connected to PB7 (GPIO Port B, PIN 7), CLK RCC_AHBENR_GPIOBEN 
;    - BLUE LED: connected to PB6 (GPIO Port B, PIN 6), CLK RCC_AHBENR_GPIOBEN
;    - Linear touch sensor/touchkeys: PA6, PA7 (group 2),  PC4, PC5 (group 9),  PB0, PB1 (group 3)

				INCLUDE stm32l1xx_constants.s		; Load Constant Definitions
				INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants

				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY
				
__main			PROC

				;LOAD 
				;LDR R0, =num
				;;LDR R0, =0x20000000 ; nap hang so 32 bit vao r0
				;LDRB R1,[R0] 		; nap byte tu data mem tai dia chi trong r0 vao r1
				;LDRH R2, [R0]		; nap half-word tai dc trong r0 vao r2
				;LDR  R3, [R0]		; nap word tai dc trong r0 vao r3
				;nap byte tai dc trong r0 vao msb cua r4
				;LDRB R4, [R0]
				;LSL  R4, #24         ; dich trai R4 24 bit
				; nap HW tai dc trong r0 vao higher HW cua R5
				;LDRH r5, [R0]
				;LSL  R5, #16   		;dich trai R5 16bit
				
				
				;;;;;;
				; STORE 
				;LDR R6, =0x20000004
				;STRB R3,[R6] 			; luu byte LSB cua R3 vao mem[0x20000004]
				
				;STRH R3, [R6,#1]		; luu (half- word) LSB cua R3 vao mem[0x20000005]
				;STR  R3, [R6,#3]		; luu (word) LSB cua R3 vao mem[0x20000007]
				
				; luu higher HW cua r5  vao mem[0x2000001A]
				;LDR R7, = 0x2000001A
				;LSR R5, #16				;dich phai r5 16bit
				;STRH R5, [r7]			;luu  2LSB bytes cua r5 vao mem [0x2000001A]
				;hoac STRH R5, [R0,#0x1A]
				
				;;;nap mot byte
				;LDR r0, =num1 	; gan dia chi chua num1 sang thanh ghi r0	
				;LDRB r1,[r0]	; nap byte tu data mem tai dia chi r0 vao thanh ghi r1
				;LDRB r2, [r0]	; nap HW tu data mem tai dia chi r0 vao thanh ghi r2
				;LDRB r3, [r0]	; nap W tu data mem tai dia chi r0 vao thanh ghi r2
				
				;;; xoa bit thu 0 va 3 cua dia chi 0x20000004
				LDR r0, =num ; gan dia cua num vao r0
				LDR r1, =mask	;gan gia tri cua mask vao r1
				LDR r2,[r0]		;nap word tu data mem tai dia chi ro vao thanh ghi r2	
				LDR r3, [r1]	;nap word tu datamem tai dia chi r1 vao thanh ghi r2	
				BIC	r4,r2,r3 	;xoa bit 0 va 5 dung mat na bit r4=r2 & ~r3
				
				STR r4,[r0]		;luu word vao bo nho có dia chi tai r0
stop 			B 		stop     					; dead loop & program hangs here

				ENDP
				ALIGN			

				AREA    myData, DATA, READWRITE
				ALIGN
num1			;DCB 0xE1, 0xE3, 0x65, 0x87	;cap nhat tung byte
num				DCD 0x12345678              ; cap nhat 1 word 
;num3			DCW 0x8765, 0xE3E1			;;cap nhat  1/2 word
mask			DCD 0x21
				END
