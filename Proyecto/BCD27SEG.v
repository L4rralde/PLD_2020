module BCD27SEG(
	input 		[3:0] bcd_in, 
	output reg	[6:0] seg_o
    );
always @(bcd_in) begin //BCD to 7-segments decoder
	case(bcd_in)
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