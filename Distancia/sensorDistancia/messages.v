module messages(
	input clk, 
	input [8:0] distance,
	input enableAlarm,  
	output reg [3:0] an, 
	output reg [6:0] segments,
	output reg speaker
);

reg [3:0] UNI = 0; 
reg [3:0] DEC = 0; 
reg [3:0] CEN = 0; 
reg [3:0] BCD = 0; 
reg [16:0] divClk = 0; 
//How to convert 9 bits to 4 BCD?
integer i; 
always @(distance) begin
	DEC = 4'b0; 
	CEN = 4'b0; 
	UNI = 4'b0; 

	for(i=8; i>=0; i=i-1) begin 
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
		UNI[0] = distance[i];  
	end
end 

always @(posedge clk)
	divClk <= divClk+1; 

always @(divClk[16:15], UNI, DEC, CEN) begin
	case(divClk[16:15]) 
		2'b00 : begin
			BCD = UNI; 
			an = 4'b1110; 
		end 
		2'b01 : begin
			BCD = DEC; 
			an = 4'b1101; 
		end 
		2'b10 : begin
			BCD = CEN; 
			an = 4'b1011; 
		end 
		default: begin
			BCD = 4'b0; 
			an = 4'b1111; 
		end
	endcase
end  

always @(BCD) begin 
	case(BCD)
		4'b0000 : segments = 7'b0000001; 
		4'b0001 : segments = 7'b1001111; 
		4'b0010 : segments = 7'b0010010; 
		4'b0011 : segments = 7'b0000110; 
		4'b0100 : segments = 7'b1001100; 
		4'b0101 : segments = 7'b0100100; 
		4'b0110 : segments = 7'b0100000; 
		4'b0111 : segments = 7'b0001111; 
		4'b1000 : segments = 7'b0000000; 
		4'b1001 : segments = 7'b0000100;
		default : segments = 7'b1111111;
	endcase	
end 

//Generate beep A-B tone 
parameter Adivider = 50000000/440/2;
parameter divider2 = 50000000/381/2;
reg [15:0] counterA;
reg [15:0] counter2;
reg soundA; 
reg sound2; 
always @(posedge clk) if(counterA==0) counterA <= Adivider-1; else counterA <= counterA-1;
always @(posedge clk) if(counter2==0) counter2 <= divider2-1; else counter2 <= counter2-1;

always @(posedge clk) if(counterA==0) soundA <= ~soundA;
always @(posedge clk) if(counter2==0) sound2 <= ~sound2;

reg [24:0] clksound; 
always @(posedge clk)
	clksound <= clksound+1; 

always @(clksound[24], enableAlarm, distance, soundA, sound2) begin 
	if(enableAlarm&&(distance<=30)) 
		if(clksound[24])
			speaker = soundA; 
		else 	
			speaker = sound2; 
	else 
		speaker = 1'b0; 
end 	

endmodule
