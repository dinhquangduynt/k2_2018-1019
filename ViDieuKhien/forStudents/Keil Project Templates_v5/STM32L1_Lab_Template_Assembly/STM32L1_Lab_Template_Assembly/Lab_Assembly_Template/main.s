				AREA    main, CODE, READONLY
				EXPORT	__main						; make __main visible to linker
				ENTRY
				
__main			PROC
				LDR		R0, =num	; R0=mem addr cua num
				LDR		R1, =0xFFFFFF00	; set first 24 bits
				LDRB 	R1, [R0]	; load a byte to R1
stop 			B 		stop    ; dead loop & program hangs here
				ENDP		

				AREA    myData, DATA, READWRITE
				ALIGN
num				DCB	0xE1
num1			DCB 0xE3
num2			DCB 0x65
num3			DCB 0x87

				END
