#include "stm32f10x.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wmissing-declarations"
#pragma GCC diagnostic ignored "-Wreturn-type"

void UART1_Init(int);
char UART1_write(char);
char UART1_read(void);

//This is ADC map channel (cannot be remapped):
//	CH[0:7] : PA[0:7]
//	CH[8:9] : PB[0:1]
// 	CH[10:15] : PC[0:5]


int main(){
	UART1_Init(115200);

	//Procedure is as follows:

	//	1: Configure GPIO of channel as analog input
	//		This it: Since CH9 is connected to PB1. I configure
	//		PB1 as analog input.
	RCC->APB2ENR |= 1<<3;	//Enables GPIOB clk
	GPIOB->CRL &= ~0xF0; 	//GPIOB_CRL[7:4] = 0;


	//	2: Enable clock.
	RCC->APB2ENR |= 1<<9;	//Enables ADC clk

	//	3: Disabled ADC while configuration.
	ADC1->CR2 &= ~1; 	//Disables ADC

	//	4: Also, you need to fix the number of conversions that will be performed:
	ADC1->SQR1 &= ~0xF00000;	//ADC1_SQR1[23:20] fix the number. the value of this +1 is
								//the number of conversions to be performed.
	//	5: Configure conversion sequence:
	ADC1->SQR3 = 0x9; 	//Only reads channel 9.
						//SQR3[4:0] defines which is the first channel to convert.
						//SQR3[9:5] is the second one; and so on.

	//	(): Next is not necessary. We can define the number of cycles per conversion.
	//		(since it's an successive approximation ADC):
	//ADC1->SMPR2 = 1; 	//7.5 cycles

	//	6: Finally, enable ADC
	ADC1->CR2 |= 1; 	//Enables ADC

	char analogValue;	//Resolution of 12 bits.
	//float conv; //Change for PLDs homework

	while(1){
		ADC1->CR2 |= 1; 	//In this MCU to start a conversion we enable (again) ADC.
		ADC1->CR2 |= 1<<22;	//However, this bit is included too. I don't know if it does something.
							//I set that bit, but maybe isn't needed at all.

		while(!(ADC1->SR & 2)); 	//ADC_SR[1]=1 when conversion is complete
		analogValue = 0xFF&((ADC1->DR)>>4);
		UART1_write(analogValue);
		for(int i=0; i<10000000; ++i);
	}
	return 0;
}

void UART1_Init(int bps){
	RCC->APB2ENR |= 1<<2;	//PORTA's clock enabled
	GPIOA->CRH &= ~0xFF0; 	//Cleared config of PA9 and PA10.
	GPIOA->CRH |= 0x90;		//PA9 as AFPP output
	GPIOA->CRH |= 0x400; 	//PA10 as floating input

	RCC->APB2ENR |= 1<<14; //USART1's clock enabled
	USART1->BRR = 72000000/bps;
	USART1->CR1 |= 0xC;    //USART1 RX and TX enabled

	USART1->CR1 |= 1<<13; 	//USART1 enbled.
}

char UART1_write(char dig){
	while(!(USART1->SR & 0x80));
	USART1->DR = dig;
	return dig;
}

char UART1_read(void){
	while(!(USART1->SR & 0x20));
	return USART1->DR;
}
#pragma GCC diagnostic pop

// ----------------------------------------------------------------------------
