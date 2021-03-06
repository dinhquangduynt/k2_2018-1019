		INCLUDE stm32l1xx_constants.s       ; Load Constant Definitions

		AREA myCode, CODE, READONLY
		EXPORT __main                       ; make __main visible to linker
		ENTRY

;;;;; MAIN FUNCTION ;;;;;
__main	PROC		
		BL ClockEnableA		; ENABLE CLOCK FOR PORT A
		BL ClockEnableB		; ENABLE CLOCK FOR PORT B
		MOV R0,#6
		BL GPIOB_INIT		; SET UP PIN PB6		
		MOV R0,#7
		BL GPIOB_INIT		; SET UP PIN PB7		
		BL GPIOA_INIT		; SET UP PIN PA0
LOOP	LDR R7,=GPIOA_BASE				; LOAD BASE ADDRESS OF GPIOA
		LDR R1,[R7,#GPIO_IDR]			; R1=GPIOA->IDR
		AND R1,R1,#1					; CHECK R1[0]
		CMP R1,#1						
		BNE LOOP						; BUTTON UNPRESSED -> CHECK AGAIN
		MOV R0,#6
		BL TOGGLE						; TOGGLE PIN PB6 (CONNECTED TO BLUE LED)
		MOV R0,#7
		BL TOGGLE						; TOGGLE PIN PB7 (CONNECTED TO GREEN LED)
		B LOOP
		ENDP
;;;;; END OF MAIN ;;;;;			

;;;;; ENABLE CLOCK FOR PORT A ;;;;;
ClockEnableA PROC
		LDR R7,=RCC_BASE				; LOAD ADDRESS OF RCC
		LDR R1,[R7,#RCC_AHBENR]			; R1=RCC_AHBENR
		ORR R1,R1,#RCC_AHBENR_GPIOAEN   ; SET BIT 1 OF AHBENR
		STR R1,[R7,#RCC_AHBENR]			; GPIO PORT A CLOCK ENABLE		
		BX LR
		ENDP

;;;;; ENABLE CLOCK FOR PORT B ;;;;;
ClockEnableB PROC
		LDR R7,=RCC_BASE				; LOAD ADDRESS OF RCC
		LDR R1,[R7,#RCC_AHBENR]		    ; R1=RCC_AHBENR
		ORR R1,R1,#RCC_AHBENR_GPIOBEN  	; SET BIT 2 OF AHBENR
		STR R1,[R7,#RCC_AHBENR]			; GPIO PORT B CLOCK ENABLE		
		BX LR
		ENDP			

;;;;; SET UP A PIN OF PORT B AS DIGITAL OUTPUT (R0=PIN_ID) ;;;;;
GPIOB_INIT PROC
		MOV R2,R0					;Assume PIN PB6 -> RO=6
		ADD R2,R2,R2				;R2=12		
		LDR R7,=GPIOB_BASE			;LOAD GPIO PORT B BASE ADDRESS
		
		;set pin I/O mode as digital output
		LDR R1,[R7,#GPIO_MODER]    	;R1=GPIOB_MODER
		MOV R3,#0x03
		LSL R3,R3,R2				;R3=0x03<<12
		BIC R1,R1,R3				;BIC R1,R1,#(0X03<<12) -> CLEAR 2 BITs 12 & 13
		MOV R3,#0x01
		LSL R3,R3,R2				;R3=0x01<<12
		ORR R1,R1,R3				;ORR R1,R1,#(0x01<<12) -> SET GPIOB[13:12] = 01 (DIGITAL OUTPUT) 
		STR R1,[R7,#GPIO_MODER]	
		
		;SET PUSH-PULL MODE FOR THE OUTPUT TYPE
		LDR R1, [R7, #GPIO_OTYPER]	;R1=GPIO_OTYPER
		MOV R3,#1
		LSL R3,R3,R0				;R3=1<<6
		BIC R1,R1,R3				;BIC R1, R1, #(1 << 6)				;PUSH PULL 0
		STR R1, [R7, #GPIO_OTYPER]	
		;SET I/O OUT PUT SPEED VALUE AS 2MHZ
		LDR R1, [R7, #GPIO_OSPEEDR]	;R1=GPIOOB->OSPEEDR
		MOV R3,#0X03
		LSL R3,R3,R2
		BIC R1,R1,R3							;BIC R1, R1, #(0x03 << 12)			;CLEAR   BIT
		MOV R3,#0X03
		LSL R3,R3,R2							;R4=0X03<<12
		ORR R1,R1,R3							;ORR R1, R1, #(0x03 << 12)		;SET 01
		STR R1, [R7, #GPIO_OSPEEDR]
		
		;SET I/O AS NO PULL-UP PULL-DOWN
		LDR R1, [R7, #GPIO_PUPDR]		;R1=GPIOB->PUPDR
		MOV R3,#0X03
		LSL R3,R3,R2
		BIC R1,R1,R3							;BIC R1, R1, #(0x03 << 12)			;CLEAR BIT
		MOV R3,#0X00
		LSL R3,R3,R2
		ORR R1,R1,R3							;;ORR R1, R1, #(0X00<<12)			;NO PUPD (00)	
		STR R1, [R7, #GPIO_PUPDR]
		
		LDR R7,=GPIOB_BASE
		LDR R1,[R7,#GPIO_ODR]
		ORR R1,R1,#(1<<7)							;ORR R1,R1,#(1<<6)
		STR R1,[R7,#GPIO_ODR]
		
		BX LR
		ENDP
			
;;;;; SET UP A PIN OF PORT A AS DIGITAL INPUT (R0=PIN_ID) ;;;;;
GPIOA_INIT PROC
		LDR R7,=GPIOA_BASE				;LOAD GPIO PORT A BASE ADDRESS
		LDR	R1, [R7, #GPIO_MODER]	;R1= GPIOA_MODER 
		BIC R1, R1, #(0x03)					;SET MODE AS INPUT (00)
		STR R1, [R7, #GPIO_MODER]		;SAVE
		
		LDR R1, [R7, #GPIO_OTYPER]
		BIC R1, R1, #(0x1)					;0: PUSH PULL,1 OPEN DRAIN
		STR R1, [R7, #GPIO_OTYPER]		;SAVE
		
		LDR R1, [R7, #GPIO_OSPEEDR]	
		BIC R1, R1, #(0x03)					;MARK
		ORR R1, R1, #(0x01)					;SET 01
		STR R1, [R7, #GPIO_OSPEEDR]
		
		LDR R1, [R7, #GPIO_PUPDR]		;SET I/O NO PUPD
		BIC R1, R1, #(0x03)			;00
		STR R1, [R7, #GPIO_PUPDR]		;SAVE
		BX LR
		ENDP
			
TOGGLE PROC ; R0=PIN ID
		LDR R2,=GPIOB_BASE				
		LDR R3,[R2,#GPIO_ODR]			;R3=GPIO_ODR
		MOV R4,#1
		LSL R4,R4,R0				;1<<R0. R0=6 OR 7
		EOR R3,R3,R4				;EOR R3,R3,#(1<<6)
		STR R3,[R2,#GPIO_ODR]
		BX LR
		ENDP			

		END
