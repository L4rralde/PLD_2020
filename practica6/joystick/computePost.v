module computePost(
	input clk_i, 
	input rst_i, 
	input [7:0] v_i, 
	output reg [7:0] pos_o
    );
reg en = 1'b0; 
reg sign = 1'b0;
reg	[19:0] div;  
always @(v_i) begin 
	if(v_i<8'b01111100) begin 
		en 		<= 1'b1; 
		sign 	<= 1'b1; 
		div 	<= v_i[6:0];  
	end else if(v_i>8'b10000011) begin 
		en 		<= 1'b1; 
		sign 	<= 1'b0; 
		div 	<= 127-v_i[6:0];
	end else begin 
		en 	 	<= 1'b0; 
		sign 	<= 1'b0; 
		div 	<= 7'b1111100;
	end 
end  
reg [6:0] cnt  = 7'b0;  
always @(posedge div[19], negedge rst_i) begin
	if(!rst_i) begin
		cnt 	<= 7'b0;
		pos_o 	<= 8'b0; 
	end else begin 
		if(en) begin 
			cnt <= cnt+1; 
			if(cnt == div) begin 
				cnt <= 7'b0; 
				if((sign)&&(pos_o>8'h0))
					pos_o <= pos_o-1; 
				else if((!sign)&&pos_o<8'hFF)
					pos_o <= pos_o+1; 
			end  
		end
	end  
end 



endmodule
