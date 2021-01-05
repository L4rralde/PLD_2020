module transc_uart(
	input clk,   				//Main clk input (50 MHz)
	input rx,					//Rx input of UART comunication
	output tx,					//Tx input of UART comunication
									//Actual baudrate does not matter since both devices FPGAs
									//... are using the same code, hence same baudrate. 
	input [7:0] dataIn, 		//Data to be transmitted
	output [7:0] dataOut, 	//To display received data
	output motor				//Motor to be activated when receive command.
); 
	wire baud; 
	BaudGen BG_U0(	//Generates a baudrate of 8*Desired_BaudRate
		.clk(clk), 
		.baud(baud)
	); 
	reg [11:0] div = 12'h0;	//Used for both as a divisor to generate a baudrate ...
									//... for transmision and a delay between transmisions. 
	wire tx_baud;
	always @(posedge baud)
		div <= div+1; 
	assign tx_baud = div[1];//baudrate for transmision (2 times Desired_BaudRate) . 
	uart_tx uartTx_U0(		//Transmitter module. 
		.clk		(tx_baud), 	//Works @ 2*Desired_BaudRate
		.data		(dataIn), 	//Data to be transmitted
		.start	(div[11]), 	//A pulse is needed to command it to transmit
		.tx		(tx)			
	); 
	uart_rx uartRx_U0(	//Receiver mocule
		.clk	(baud), 		//Works @ 8*Desired_BaudRate
		.rx		(rx), 
		.dataR	(dataOut) //Received data
	); 
	assign motor = dataOut[7]; //MSB of received data drives external motor. 
endmodule 