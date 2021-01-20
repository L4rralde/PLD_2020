module filter_8(
	input clk_i, 			//clk with sampling frequency
	input [9:0] signal_i, 	//Signal to sample
	output [9:0] signal_o   //Data filtered 
); 
	reg [79:0] signalReg = 80'b0; //All 8 datas to be registered.
	always @(posedge clk_i)
		signalReg <= {signalReg[69:0], signal_i}; //Shift register
	reg [12:0] acc = 13'b0; //Accumulator 
	always @(signalReg) //Average last 8 signals 	
		acc = signalReg[79:70]+signalReg[69:60]+signalReg[59:50] //...
				+signalReg[49:40]+signalReg[39:30]+signalReg[29:20] //...
				+signalReg[19:10]+signalReg[9:0]; //Add
	assign signal_o = acc[12:3]; //Divide by 8
endmodule 

/** 
//This is a testbench 
module filter_8_tb(); 
	reg  clk_tb; 
	reg  [9:0] signal_i_tb; 
	wire [9:0] signal_o_tb; 
	
	filter_8 U0_tb(clk_tb, signal_i_tb, signal_o_tb); 
	
	initial begin 
		clk_tb = 1'b0; 
		signal_i_tb = 10'h000; 
	end 
	
	always begin 
		#50
			clk_tb = ~clk_tb; 
	end 
	
	always begin 
		#100
			signal_i_tb = 10'h2BA; 
		#100
			signal_i_tb = 10'h2B4; 	
		#100
			signal_i_tb = 10'h2B8; 
		#100
			signal_i_tb = 10'h2B3; 
		#100
			signal_i_tb = 10'h2BF; 
		#100
			signal_i_tb = 10'h2BE; 
		#100
			signal_i_tb = 10'h2B6; 
		#100
			signal_i_tb = 10'h2BA;	
		#100
			signal_i_tb = 10'h000;	
	end 
endmodule 
**/