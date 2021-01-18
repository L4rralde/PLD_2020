module debouncer(
	input clk_i, 
	input signal_i, 		//signal to filter (debounce) 
	output reg signal_o 	
    );

reg [1:0] sync = 2'b0;
always @(posedge clk_i) //2-bit flip flip based register
	sync <= {sync[0], ~signal_i};   
	
reg [15:0] counter = 16'b0; 

wire idle = (signal_o==sync[1]); //determines when signal is IDLE 
								 //(i.e. its state has no changed)
wire counter_max = &counter; 	//equals 1 when reaches FFFF
always @(posedge clk_i) begin 
	if(idle)
		counter <= 16'b0; 
	else begin 	//change signal_o state until signal has remained stable 
				//for 2**16 cycles.
		counter <= counter+16'b1; 
		if(counter_max) signal_o <= ~signal_o; 
	end
end 

endmodule
