module counter(
	input clk,
	input hab, 
	input dir, 
	input res, 
	output reg [3:0] cnt
 );
	always @(posedge clk or negedge res)
	begin 
		if(~res)
			cnt <= 4'b0;
		else 
			if (hab) cnt <= dir? cnt+1 : cnt-1; 	
	end 
endmodule 