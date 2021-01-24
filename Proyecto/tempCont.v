module tempCont(
	input clk_i, //@100 MHz
	input rst_i, 
	input [7:0] temp_i, 
	input [2:0] tempCase_i, //40, 70, 100, 127, 150
	output PWM_o  //30-120 Hz. 
); 
	reg [19:0] div = 20'b0; 
	reg [19:0] maxCount = 20'b0;  

	reg [1:0] statePulse = 2'b0; 
	reg rst = 1'b0; 
	always @(posedge clk_i) begin //Detect crossover FSM 
		case(statePulse)
			2'b0: begin 
				rst <= 1'b0; 
				if(!rst_i) 
					statePulse <= 2'b1; 
				else
					statePulse <= 2'b0; 
			end
			2'b1: begin 
				rst <= 1'b1; 
				statePulse <= 2'b10; 
			end
			2'b10: begin 
				rst <= 1'b0; 
				if(!rst_i) 
					statePulse <= 2'b10; 
				else
					statePulse <= 2'b0; 
			end
			default: begin 
				rst <= 1'b0; 
				statePulse <= 2'b00; 
			end
		endcase
	end 
	always @(posedge clk_i, posedge rst) begin 
		if(rst) 
			div <= 20'h0; 
		else if(!div[19])
			div <= div+1'b1; 
	end 

	assign PWM_o = (div<maxCount); 
	
	reg [7:0] tempS = 8'b0; //Desired temperatures 
	always @(tempCase_i) begin 
		case(tempCase_i)
			3'h1: tempS<= 8'h28; //40°C
			3'h2: tempS<= 8'h46; //70°C
			3'h3: tempS<= 8'h64; //100°C
			3'h4: tempS<= 8'h7F; //127°C
			3'h5: tempS<= 8'h96; //150°C
			default: tempS<= 8'h00;
		endcase 
	end 
	reg [25:0] masterDiv = 26'b0; 
	always @(posedge clk_i)
		masterDiv <= masterDiv+1'b1; 
	always @(posedge masterDiv[17]) begin //On/Off control with small Duty Cycle.
		if((tempS==8'h00)||(tempS<=temp_i))
			maxCount <= 20'b0;
		else  
			maxCount <= 20'h1000; 
	end 
endmodule 