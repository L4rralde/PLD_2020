//Module that computes equivalent tempertature given a ADC value
module pt100( 
	input 	[9:0] 	ADC_i, 
	output 	[7:0] 	temp_o
); 
	parameter ADC_RES = 10; 
	
	//Multiply by rational?
	//Multiply by an integer then divide by an integer too
	//For exmaple x = 150/1023
	//Multiply by a constant
	reg [19:0] mult = 20'b0; 
	always @(ADC_i) 
		mult = ADC_i*10'h96; 			//Multiply by 600
	assign temp_o = mult[ADC_RES+7:ADC_RES]; 	//Divide by 4096
endmodule 

/**
//Testbench 
module pt100_tb(); 
	reg [15:0] ADC_tb; 
	wire [7:0] temp_tb; 
	pt100 PT100_U0(ADC_tb, temp_tb); 
	
	initial 
		ADC_tb = 16'b0; 
	
	always begin 
		#50
			ADC_tb = 16'hFACE; 
		#50
			ADC_tb = 16'hBACE; 
		#50
			ADC_tb = 16'hFFFF; 
	end 
endmodule 
**/ 