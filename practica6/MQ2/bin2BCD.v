module bin2BCD( 
	input clk_i, //Used to register input
	input	[15:0] bin_i, //16-bits words to 5 BCD coder 
	output reg [3:0] uni_o, 
	output reg [3:0] dec_o, 
	output reg [3:0] cen_o, 
	output reg [3:0] mil_o,
	output reg [3:0] mil10_o
);
reg [15:0] binR = 16'b0; 	//This way inputs are registered
always @(posedge clk_i)
	binR <= bin_i; 
//-------------How to convert 16 bits to 5 BCD?-------------
reg [3:0] MIL10; 
reg [3:0] MIL; 
reg [3:0] CEN; 
reg [3:0] DEC; 
reg [3:0] UNI; 
integer i; 
always @(binR) begin
	MIL10 = 4'b0; 
	MIL = 4'b0; 
	CEN = 4'b0; 
	DEC = 4'b0; 
	UNI = 4'b0; 

	for(i=15; i>=0; i=i-1) begin 
		if(MIL10 >= 5)
			MIL10 = MIL10+3; 
		if(MIL >= 5)
			MIL = MIL+3; 
		if(CEN >= 5)
			CEN = CEN+3; 
		if(DEC >= 5)
			DEC = DEC+3; 
		if(UNI >= 5)
			UNI = UNI+3;
		MIL10 = MIL10<<1; 
		MIL10[0] = MIL[3];
		MIL = MIL<<1; 
		MIL[0] = CEN[3];
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
	mil_o <= MIL; 	
	mil10_o <= MIL10;
end
endmodule 

/**
module bin2BCD_tb(); 
reg clk_tb; 
reg [15:0] bin_tb; 
wire [3:0] uni_tb; 
wire [3:0] dec_tb; 
wire [3:0] cen_tb; 
wire [3:0] mil_tb; 
wire [3:0] mil10_tb; 

bin2BCD_tb b2BCD(clk_tb, bin_tb, uni_tb, dec_tb, cen_tb, mil_tb, mil10_tb);

initial begin 
	clk_tb <= 1'b0; 
	bin_tb <= 16'b0; 
end  

always begin 
	#50
		clk_tb <= ~clk_tb; 
end 

always begin
	#100
		bin_tb <= 16'hBABE; 
	#100
		bin_tb <= 16'hFACE;
	#100
		bin_tb <= 16'hBEEF;
	#100
		bin_tb <= 16'hFEED;
	#100
		bin_tb <= 16'hB00B; 	
end 
endmodule 
**/