module computeDistance(
	input clk,  
	input reset,
	input update, 
	output reg us10,
	output overflow, 
	output reg [8:0] data
);

reg [15:0] counter_us = 0; 
reg [5:0] counter_58 = 0;
reg [8:0] counter_cm = 0;
reg [5:0] div = 0; 
always @(posedge clk) begin 
	if(reset) begin 
		counter_us <= 16'b0; 
		counter_58 <= 5'b0; 
		div <= 6'b0; 
		counter_cm <= 9'b0; 
	end else begin 
		div <= div+1; 
		if(div==49) begin //Sí cuenta us
			div <= 6'b0; 
			counter_us <= counter_us+1; 
			if (counter_us==10)
				us10 <= 1'b1; 
			else 
				us10 <= 1'b0;
			counter_58 <= counter_58+1; 
			if (counter_58==57) begin
				counter_58 <= 6'b0; 
				counter_cm <= counter_cm+1; 
			end
		end 
	end
end 
always @(posedge update)
	//data = counter_us[14:0]/58; 
	data <= counter_cm; 
assign overflow = counter_us[15];

endmodule
