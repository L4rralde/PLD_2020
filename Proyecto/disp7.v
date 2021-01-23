module disp7(
	input clk_i, 
	input [55:0] number_i, //4x 7-seg data cluster
	output reg [6:0] seg_o, 
	output reg [7:0] an_o
    );

reg [16:0] div = 17'b0; //frequency divider 
always @(posedge clk_i)
	div <= div+1'b1; 

always @(div[16:14], number_i) begin 	//Sweeps values to be displayed 
									//for each digit. 
	case(div[16:14]) 
		3'h0: begin 
			an_o 	<= 8'b11111110; 
			seg_o 	<= number_i[6:0];
		end 
		3'h1: begin 
			an_o 	<= 8'b11111101; 
			seg_o 	<= number_i[13:7];
		end 
		3'h2: begin 
			an_o 	<= 8'b11111011; 
			seg_o 	<= number_i[20:14];
		end 
		3'h3: begin 
			an_o 	<= 8'b11110111; 
			seg_o 	<= number_i[27:21];
		end 
		3'h4: begin 
			an_o 	<= 8'b11101111; 
			seg_o 	<= number_i[34:28];
		end 
		3'h5: begin 
			an_o 	<= 8'b11011111; 
			seg_o 	<= number_i[41:35];
		end 
		3'h6: begin 
			an_o 	<= 8'b10111111; 
			seg_o 	<= number_i[48:42];
		end 
		3'h7: begin 
			an_o 	<= 8'b01111111; 
			seg_o 	<= number_i[55:49];
		end 
		default: begin 
			an_o 	<= 8'b11111111; 
			seg_o 	<= 7'h7F;
		end 
	endcase 
end 

endmodule
