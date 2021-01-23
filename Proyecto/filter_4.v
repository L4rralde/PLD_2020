module filter_4(
	input clk_i,	 			//clk with sampling frequency
	input  [9:0] signal_i, //Signal to sample   (No son 12 bit?) 
	output [9:0] signal_o	//Data filtered 
); 
	reg [39:0] signalReg = 40'b0; 
	always @(posedge clk_i)
		signalReg <= {signalReg[29:0], signal_i}; //Shift register
	reg [11:0] acc = 12'b0; //Accumulator 
	always @(signalReg)
		acc = signalReg[39:30]+signalReg[29:20] //...
				+signalReg[19:10]+signalReg[9:0]; //Add
	assign signal_o = acc[11:2]; //Divide by 4
endmodule 