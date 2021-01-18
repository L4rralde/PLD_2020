module disp7(
	input 			clk_i, 
	input 			rst_i, 
	input 	[15:0] 	dig_i, //4 digits in BCD to be displayed
	output reg [6:0] seg_o, 
	output reg [3:0] an_o
	);

reg [15:0] div = 16'b0; //frequency divider 
always @(posedge clk_i)
	div <= div+1'b1; 

reg [15:0] dataR = 16'b0; 
always @(posedge div[7]) begin //Register dig_i 
	if(rst_i)
		dataR <= 16'b0; 
	else 
		dataR <= dig_i; 
end 

reg[3:0] BCD = 4'b0; 
always @(div[15:14], dataR) begin 	//Sweeps values to be displayed 
									//for each digit. 
	case(div[15:14]) 
		2'h0: begin 
			an_o <= 4'b1110; 
			BCD <= dataR[3:0];
		end 
		2'h1: begin 
			an_o <= 4'b1101; 
			BCD <= dataR[7:4];
		end 
		2'h2: begin 
			an_o <= 4'b1011; 
			BCD <= dataR[11:8];
		end 
		2'h3: begin 
			an_o <= 4'b0111; 
			BCD <= dataR[15:12];
		end  
		default: begin 
			an_o <= 4'b1111; 
			BCD <= 4'hF;
		end 
	endcase 
end 

always @(BCD) begin //Decoder
	case(BCD)
		4'h0 : seg_o <= 7'b0000001; 
		4'h1 : seg_o <= 7'b1001111; 
		4'h2 : seg_o <= 7'b0010010; 
		4'h3 : seg_o <= 7'b0000110; 
		4'h4 : seg_o <= 7'b1001100; 
		4'h5 : seg_o <= 7'b0100100; 
		4'h6 : seg_o <= 7'b0100000; 
		4'h7 : seg_o <= 7'b0001111; 
		4'h8 : seg_o <= 7'b0000000; 
		4'h9 : seg_o <= 7'b0000100;
		4'hA : seg_o <= 7'b0001000;
		4'hB : seg_o <= 7'b1100000;
		4'hC : seg_o <= 7'b0110001;
		4'hD : seg_o <= 7'b1000010;
		4'hE : seg_o <= 7'b0110000;
		4'hF : seg_o <= 7'b0111000;
		default : seg_o <= 7'b1111111;	
	endcase
end 
endmodule
