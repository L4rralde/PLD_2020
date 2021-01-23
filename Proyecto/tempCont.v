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
	always @(posedge clk_i) begin 
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
		//else if(PWM_o)
	//	end else begin 
	//always @(posedge clk_i) begin 
		else if(!div[19])
			div <= div+1'b1; 
	//	end 
	end 

	assign PWM_o = (div<maxCount); 
	
	reg [7:0] tempS = 8'b0; 
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

	always @(posedge div[15]) begin
		if(tempS == 8'h00)
			maxCount <= 20'b0;
		else  
			if(((tempS<temp_i)&&(maxCount>20'h96))||((tempS>=temp_i)&&(maxCount<20'hFFF69)))
				maxCount <= maxCount+tempS-temp_i;
	end 
endmodule 

module tempCont_tb(); 

	reg clk_tb; //@100 MHz
	//input rst_i, 
	reg [7:0] temp_tb; 
	reg [2:0] tempCase_tb; //40, 70, 100, 127, 150
	wire PWM_tb;  //30-120 Hz. 
	reg rst_tb; 
	
	tempCont U0_tb(clk_tb, rst_tb, temp_tb, tempCase_tb, PWM_tb); 
	initial begin 
		clk_tb 		= 1'b0; 
		rst_tb 		= 1'b0; 
		temp_tb 		= 8'b0; 
		tempCase_tb = 3'b0; 
	end 
	
	always begin 
		#50
			clk_tb <= ~clk_tb; 
	end 
	always begin 
		#1000
			rst_tb <= ~rst_tb; 
	end
	always begin 
		#100000
			temp_tb <= 8'h20; 
			tempCase_tb <= 3'b1;
		#100000
			temp_tb <= 8'h20; 
			tempCase_tb <= 3'h5;
	end
endmodule 
