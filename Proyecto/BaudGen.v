//Actual clk_f is 100MHz, so data transfer is @19200 bps
module BaudGen(
	input clk, 		//global clk
	output baud		//BaudRate signal 
); 
	parameter Clk_f = 50000000; 	//Nexys 2 and QMTECH Cyclone Starter Kit xtal frequency.
	parameter exbps = 9600; 		//Desired baudRate
	parameter AccWidth = 20;		//Gives a precision of 2^{-20} 		
	parameter baudgenInc = 1610; //To generate a baudRate of 8*9600
	//parameter baudgenInc = 201; 	//To generate a baudRate of 8*1200
		//baudgenInc = int((8*desired_baudRate*2^{AccWidth})/(clk_f))
	
	reg [AccWidth:0] Acc = {AccWidth+1{1'b0}}; //initiated with 21'b0
	always @(posedge clk)
		Acc <= Acc[AccWidth-1:0]+baudgenInc; 	//Computes a frequency division via addition
	assign baud = Acc[AccWidth]; 					
endmodule 