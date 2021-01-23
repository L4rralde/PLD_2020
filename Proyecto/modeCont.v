module modeCont(
	input clk_i, 
	input sel_i, 
	input rst_i, 
	input up_i, 
	input down_i, 
	output reg [2:0] tempMode_o, 
	output reg [2:0] velMode_o, 
	output btnState_d
); 	

	reg btnState = 1'b0; 
	always @(posedge sel_i) 
		btnState <= ~btnState; 

	assign btnState_d = btnState; 

	reg [2:0] modeState = 3'b0; 
	always @(posedge clk_i, negedge rst_i) begin 
		if(~rst_i) begin 
			tempMode_o 	<= 3'b0; 
			velMode_o 	<= 3'b0; 
		end else begin 
			case(modeState) 
				3'h0: begin //IDLE State
					if(up_i)
						modeState <= 3'h1; //To UH State
					else if(down_i) 
						modeState <= 3'h4; //To DH State
				end 
				3'h1: begin //UH State
					if(up_i)
						modeState <= 3'h1; //To UH State
					else 
						modeState <= 3'h2; //To INC State
				end 
				3'h2: begin //INC State
					if(btnState) begin 
						if(tempMode_o < 3'h5)
							tempMode_o <= tempMode_o+1'b1; 
					end else begin 
						if(velMode_o < 3'h5)
							velMode_o <= velMode_o+1'b1; 
					end 
					modeState <= 3'h7; //To NOP State
				end 
				3'h4: begin //DH State
					if(down_i)
						modeState <= 3'h4; //To DH State
					else 
						modeState <= 3'h5; //To DEC State
				end 
				3'h5: begin //DEC State
					if(btnState) begin 
						if(tempMode_o > 3'h0)
							tempMode_o <= tempMode_o-1'b1; 
					end else begin 
						if(velMode_o > 3'h0)
							velMode_o <= velMode_o-1'b1; 
					end 
					modeState <= 3'h7; //To NOP State
				end 
				3'h7: begin //NOP State 
					modeState <= 3'h0; //To IDLE State	
				end
				default: begin 
					modeState <= 3'h0; //To IDLE State
				end 
			endcase
		end
	end 

endmodule 
	