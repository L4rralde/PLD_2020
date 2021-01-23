module messages(
	input clk_i,  
	input [3:0] state1_i, 
	input [3:0] state2_i, 
	input [7:0] temp_i, 
	output [55:0] SEg_o
); 
/**
	wire [6:0] numTemp; 
	BCD27SEG DECOD_U0(
		.bcd_in	(state1_i), 
		.seg_o	(numTemp)
    );
	
	wire [6:0] numVel; 
	BCD27SEG DECOD_U1(
		.bcd_in	(state2_i), 
		.seg_o	(numVel)
    );
	 
**/
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
	
	wire [20:0] SEg;  
	 BCD27SEG DECOD_U1(
		.bcd_in	(temp_uni), 
		.seg_o	(SEg[6:0])
    );
	 
	 BCD27SEG DECOD_U2(
		.bcd_in	(temp_dec), 
		.seg_o	(SEg[13:7])
    );
	 
	BCD27SEG DECOD_U3(
		.bcd_in	(temp_cen), 
		.seg_o	(SEg[20:14])
    ); 
	/**
	 assign SEg_o = {numTemp, 7'h7F, numVel, 7'h7F,	//...
							numVel, 7'h7F, numTemp, 7'h7F}; 
	**/
		assign SEg_o = {7'h7F, 7'h7F, 7'h7F, 7'h7F,	//...
							SEg}; 

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