module CtrlUnit(
	input 	[3:0]	inst_i, 
	output 	reg 	PCSrc_o, 
	output	reg 	DSrc_o, 
	output 	reg 	NOP_o
);
	always @(inst_i)
		case(inst_i[3:1]) 
			3'b100: begin 
				PCSrc_o <= 1'b0; 
				DSrc_o 	<= 1'b1; 
				NOP_o 	<= 1'b0; 
			end 
			3'b110: begin
				PCSrc_o <= 1'b1; 
				DSrc_o 	<= 1'b0; 
				NOP_o 	<= 1'b1; 
			end
			3'b111: begin
				PCSrc_o <= 1'b0; 
				DSrc_o 	<= 1'b0; 
				NOP_o 	<= 1'b1; 
			end
			default: begin
				PCSrc_o <= 1'b0; 
				DSrc_o 	<= 1'b0; 
				NOP_o 	<= 1'b0; 
			end 
		endcase 
endmodule
