module disp7(
	input clk_i, 
	input [31:0] number_i, //4x 7-seg data cluster
	output reg [7:0] seg_o, 
	output reg [7:0] an_o
    );

reg [16:0] div = 17'b0; //frequency divider 
always @(posedge clk_i)
	div <= div+1'b1; 

always @(div[16:14], number_i) begin 	//Sweeps values to be displayed 
									//for each digit. 
	case(div[16:14]) 
		3'h0: begin 
			an_o 	<= 8'b1110; 
			seg_o 	<= number_i[7:0];
		end 
		3'h1: begin 
			an_o 	<= 8'b1101; 
			seg_o 	<= number_i[15:8];
		end 
		3'h2: begin 
			an_o 	<= 8'b1011; 
			seg_o 	<= number_i[23:16];
		end 
		3'h3: begin 
			an_o 	<= 8'b0111; 
			seg_o 	<= number_i[31:24];
		end 

		default: begin 
			an_o 	<= 8'b1111; 
			seg_o 	<= 8'hFF;
		end 
	endcase 
end 

endmodule
