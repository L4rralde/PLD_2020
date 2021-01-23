module messages(
	input clk_i,   
	input 		state0_i, 
	input [3:0] state1_i, 
	input [3:0] state2_i, 
	input [7:0] temp_i, 
	output reg [31:0] SEg_o
); 
	
	wire [6:0] numTemp; 
	BCD27SEG DECOD_U0(
		.bcd_in	(state1_i), 
		.seg_o	(numTemp)
    );
	reg [7:0] numTempR = 8'b0; 
	always @(numTemp, state0_i, state1_i) begin 
		if(state1_i==4'h0)
			numTempR <= {7'b1111110, ~state0_i}; 	
		else 
			numTempR <= {numTemp, ~state0_i}; 	
	end 
		
	wire [6:0] numVel; 
	BCD27SEG DECOD_U1(
		.bcd_in	(state2_i), 
		.seg_o	(numVel)
    );
	 reg [7:0] numVelR = 8'b0; 
	always @(numVel, state0_i, state2_i) begin 
		if(state2_i==4'h0)
			numVelR <= {7'b1111110, state0_i}; 	
		else 
			numVelR <= {numVel, state0_i}; 	
	end 

	wire [3:0] temp_uni;  
	wire [3:0] temp_dec; 
	wire [3:0] temp_cen; 
	
	bin2BCD Bin2BCD_U0(
		.clk_i	(clk_i), 	//Used to register input
		.bin_i 	(temp_i),//16-bits words to 5 BCD coder 
		.uni_o 	(temp_uni), 
		.dec_o 	(temp_dec), 
		.cen_o	(temp_cen)
	); 
	
	
	wire [23:0] SEg;  
	 BCD27SEG DECOD_U2(
		.bcd_in	(temp_uni), 
		.seg_o	(SEg[7:1])
    );
	 
	 BCD27SEG DECOD_U3(
		.bcd_in	(temp_dec), 
		.seg_o	(SEg[15:9])
    );
	 
	BCD27SEG DECOD_U4(
		.bcd_in	(temp_cen), 
		.seg_o	(SEg[23:17])
    ); 
	 
	 assign SEg[0] 	= 1'b1; 
	 assign SEg[8] 	= 1'b1; 
	 assign SEg[16] 	= 1'b1; 
	 
	 reg [27:0] selcnt = 28'b0; 
	 reg [8:0] state = 8'h0; 
	 reg [8:0] stateN = 8'h0; 
	 always @(posedge clk_i) begin 
		stateN <= state; 
		state <= {state2_i, state1_i, state0_i}; 
	end 
	
	reg enableSw = 1'b0; 
	always @(state, stateN) begin 
		if(stateN!=state)  
			enableSw <= 1'b1; 
		else
			enableSw <= 1'b0; 
	end 
	
	always @(posedge clk_i, posedge enableSw) begin 
		if(enableSw)
			selcnt <= 28'b0; 
		else if(selcnt <= 28'hFFFFFF0)
			selcnt <= selcnt +1'b1; 
	end 

	wire sel; 
	assign sel = selcnt[27]; 
	always @(state1_i, state2_i, temp_i, sel, numVelR, numTempR, SEg) begin 
		if((state1_i==3'h0)&&(state2_i==3'h0)&&(temp_i>=8'h32))
			SEg_o <= {8'b11010001, 8'b11000101,8'b11100001, 8'hFF}; 
		else 
			if(~sel)
				SEg_o <= {numVelR, 8'hFF, numTempR, 8'hFF}; 
			else
				SEg_o <= {8'hFF, SEg}; 
	end 
endmodule 


module bin2BCD( 
	input clk_i, //Used to register input
	input	[7:0] bin_i, //16-bits words to 5 BCD coder 
	output reg [3:0] uni_o, 
	output reg [3:0] dec_o, 
	output reg [3:0] cen_o
);
reg [7:0] binR = 8'b0; 	//This way inputs are registered
always @(posedge clk_i)
	binR <= bin_i; 
//-------------How to convert 16 bits to 5 BCD?-------------
reg [3:0] CEN; 
reg [3:0] DEC; 
reg [3:0] UNI; 
integer i; 
always @(binR) begin
	CEN = 4'b0; 
	DEC = 4'b0; 
	UNI = 4'b0; 

	for(i=7; i>=0; i=i-1) begin 
		if(CEN >= 5)
			CEN = CEN+3; 
		if(DEC >= 5)
			DEC = DEC+3; 
		if(UNI >= 5)
			UNI = UNI+3;
		CEN = CEN<<1; 
		CEN[0] = DEC[3]; 
		DEC = DEC<<1; 
		DEC[0] = UNI[3];
		UNI = UNI<<1; 
		UNI[0] = binR[i];  
	end 
end 
//---------------------------------------------------------
always @(posedge clk_i) begin //Outputs are registered
	uni_o <= UNI; 
	dec_o <= DEC;
	cen_o <= CEN;
end
endmodule 
