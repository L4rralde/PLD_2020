module timer(
	input clk_i,
	input reset_i, 
	input enable_i, 
	input [7:0] max_i, 
	output reg 	flag_o
);
	reg [15:0] divider = 16'b0; 
	always @(posedge clk_i) 
		divider <= divider+1; 
	reg [7:0] counter = 8'b0; 
	always @(posedge divider[15] or posedge reset_i) begin 
		if(reset_i)
			counter <= 8'b0; 
		else begin 
			if(enable_i) begin 
				if(counter == max_i) begin 
					counter <= 8'b0; 
					flag_o <= 1'b1; 
				end else begin 
					counter <= counter+1; 
					flag_o <= 1'b0; 
				end 
			end else 
				counter <= counter; 
		end 
	end 
endmodule
