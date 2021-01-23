module velCont(
	input 		clk_i, 
	input [2:0]	velCase_i, 
	output PWM_o	
); 
	reg [15:0] max = 16'b0; 
	always @(velCase_i) begin 
		case(velCase_i)
			3'h1: max = 16'h5000; 
			3'h2: max = 16'h6800;
			3'h3: max = 16'h8000; 	
			3'h4: max = 16'h8800;
			3'h5: max = 16'hA000; 
			default: max = 16'h00; 
		endcase
	end 
	
	reg [15:0] div = 16'b0; 
	always @(posedge clk_i) 
		div <= div+1'b1; 
	
	assign PWM_o = (div<max); 
endmodule 