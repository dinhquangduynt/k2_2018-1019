//******************** (C) Yifeng ZHU ********************
// @file    main.c
// @author  Yifeng Zhu
// @version V1.0.0
// @date    November-11-2012
// @note    
// @brief   C code for STM32L1xx Discovery Kit
// @note
//          This code is for the book "Embedded Systems with ARM Cortex-M3 
//          Microcontrollers in Assembly Language and C, Yifeng Zhu, 
//          ISBN-10: 0982692625.
// @attension
//          This code is provided for education purpose. The author shall not be 
//          held liable for any direct, indirect or consequential damages, for any 
//          reason whatever. More information can be found from book website: 
//          http://www.eece.maine.edu/~zhu/book
//********************************************************

#include <stdint.h>

/* Standard STM32L1xxx driver headers */
#include "stm32l1xx.h"

/* STM32L1xx Discovery Kit:
    - USER Pushbutton: connected to PA0 (GPIO Port A, PIN 0), CLK RCC_AHBENR_GPIOAEN
    - RESET Pushbutton: connected RESET
    - GREEN LED: connected to PB7 (GPIO Port B, PIN 7), CLK RCC_AHBENR_GPIOBEN 
    - BLUE LED: connected to PB6 (GPIO Port B, PIN 6), CLK RCC_AHBENR_GPIOBEN
    - Linear touch sensor/touchkeys: PA6, PA7 (group 2),  PC4, PC5 (group 9),  PB0, PB1 (group 3)
*/

// Enable the clock to GPIO Ports A&B
void GPIO_Clock_Enable() {
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	RCC->AHBENR	|= RCC_AHBENR_GPIOBEN;
	RCC->AHBENR	|= RCC_AHBENR_GPIOCEN;
	RCC->AHBENR	|= RCC_AHBENR_GPIODEN;
}

/* Init a pin of Port B as digital output, output type of push-pull */
void GPIO_PortB_Output_Pin_Init(int pinID) {
	// Set pin as digital output (01)
	GPIOB->MODER &= ~(0x03<<(2*pinID)); // dich trai 0x03 sang 2*pinid bit sau do clear bit da dich ve 0
	GPIOB->MODER |=   0x01<<(2*pinID);//dich trai 0x02 sang 2*pinid bit sau do set bit len 1 de duoc 01
	
	// Set output type of pin as push-pull (0)
	GPIOB->OTYPER &= ~(0x01<<pinID); // clear o bit thu ... ve 0 // thiet lap lai trang thai
	
	// Set pin's output speed (01 = 2MHz, 10 = 10MHz)
	GPIOB->OSPEEDR &= ~(0x03<<(2*pinID)); // Speed mask  11= 50mhz
	GPIOB->OSPEEDR |=   0x02<<(2*pinID); 
	
	// Set I/O as no pull-up pull-down (00)
	GPIOB->PUPDR &= ~(0x03<<(2*pinID));
}

void GPIO_PortC_Output_Pin_Init(int pinID) {
	// Set pin as digital output (01)
	GPIOC->MODER &= ~(0x03<<(2*pinID)); // dich trai 0x03 sang 2*pinid bit sau do clear bit da dich ve 0
	GPIOC->MODER |=   0x01<<(2*pinID);//dich trai 0x02 sang 2*pinid bit sau do set bit len 1 de duoc 01
	
	// Set output type of pin as push-pull (0)
	GPIOC->OTYPER &= ~(0x01<<pinID); // clear o bit thu ... ve 0 // thiet lap lai trang thai
	
	// Set pin's output speed (01 = 2MHz, 10 = 10MHz)
	GPIOC->OSPEEDR &= ~(0x03<<(2*pinID)); // Speed mask  11= 50mhz
	GPIOC->OSPEEDR |=   0x02<<(2*pinID); 
	
	// Set I/O as no pull-up pull-down (00)
	GPIOC->PUPDR &= ~(0x03<<(2*pinID));
}

/* Toggle an output pin of Port B */
void GPIO_PortB_Pin_Toggle(int pinID) {
	GPIOB->ODR ^= 1<<pinID; // thanh ghi odr có 16bit
}


void GPIO_PortC_Pin_Toggle(int pinID) {
	GPIOC->ODR ^= 1<<pinID; // thanh ghi odr có 16bit
}


void GPIO_PortD_Input_Pin_Init(int pinID) {
	// Set pin as digital input (00)
	GPIOD->MODER &= ~(0x03<<(2*pinID));
	
	// Set output type of pin as push-pull (0)
	GPIOD->OTYPER &= ~(0x01<<pinID); // thanh ghi OTYPER co 16 bit dau 
	
	// Set pin's output speed (01 = 2MHz, 10 = 10MHz)
	GPIOD->OSPEEDR &= ~(0x03<<(2*pinID)); // Speed mask
	GPIOD->OSPEEDR |=   0x02<<(2*pinID);
	
	// Set I/O as no pull-up pull-down (00)
	GPIOD->PUPDR &= ~(0x03<<(2*pinID));
}

/* delay */
void delay(int t) {
	int count = 0;
	while (count < t) {
		count++;
	};
}

//******************************************************************************************
//* The main program starts here:
//* Toggle two LEDs when the user button is pressed.
//******************************************************************************************

/* LED definitions */
#define GREEN_LED 7	// GREEN LED: connected to PB7
//#define BLUE_LED  6	// BLUE  LED: connected to PB6
#define BLUE_LED  13	// BLUE  LED: connected to PB6

int main(void){
	int pinPA0=0;
	
	GPIO_Clock_Enable();							// Enable the clock for ports A&B
  //GPIO_PortB_Output_Pin_Init(GREEN_LED); 	// Init the pins attached to the LEDs as digital outputs
	GPIO_PortC_Output_Pin_Init(BLUE_LED); 		
	
	GPIO_PortD_Input_Pin_Init(2);	// Init the pin PD2 attached to the user button as digital input
	
	// turn-on BLUE led, turn-off GREEN led
	GPIOC->ODR  |= 1<<BLUE_LED;
		
	// Loop forever
	while(1) {		
		if (GPIOD->IDR & (1<<2)) {		// User button pressed
			while (GPIOD->IDR & (0x01<<2)) {} // wait until button released
			//GPIO_PortB_Pin_Toggle(GREEN_LED);	// Toggle the green LED
			//GPIO_PortB_Pin_Toggle(BLUE_LED);	// Toggle the blue LED			
			//GPIO_PortB_Pin_Toggle(GREEN_LED);	// Toggle the green LED
			GPIO_PortC_Pin_Toggle(BLUE_LED);	// Toggle the blue LED	
			//GPIOC->ODR  |= 1<<BLUE_LED;
		}		
		//GPIOC->ODR  &=~ (1<<BLUE_LED);
	};
}