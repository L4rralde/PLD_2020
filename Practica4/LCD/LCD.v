module LCD(
	input clk_i,
	input [7:0]	byteWr_i, 
	output 	reg [7:0]	LCD_D_o,
	output 	reg LCD_E, 
	output 	reg LCD_RW, 
	output 	reg LCD_RS,
	output  clk_o
	
);
	wire PCSrc;
	reg 	[7:0] 	PC = 8'b0;  
	wire 	[31:0]	inst; 
	/**
	---------Instruction----------
	[3:0] "1000" write from outside
			"1100" jal
			"1110" NOP
			if(~inst[3])
				LCD_E = inst[2]
				LCD_RS = inst[1]
				LCD_RW = inst[0]
	[11:4] LCD_Data output
	[19:12] max time to count 
			([19:12])*1.31072 ms (from 1.31072 ms up to 335.54432 ms) //
	[27:20] its used to jump PC_i=Pc_{i-1}+[27:20]
	**/
	always @(posedge clk_o) begin 
		if(PCSrc) 
			PC <= PC+inst[27:20]; 
		else 
			PC <= PC+1; 
	end 	
	pMemory memory_U0(
		.clk_i		(clk_i), 
		.addr_i		(PC), 
		.dataR_o	(inst)
	); 
	timer	timer_U0(
		.clk_i 		(clk_i), 
		.reset_i 	(1'b0), 
		.enable_i	(1'b1), 
		.max_i		(inst[19:12]), 
		.flag_o		(clk_o)
	); 
	wire DSrc; 
	wire NOP; 
	CtrlUnit CtrlUnit_U0(
		.inst_i 	(inst[3:0]), 
		.PCSrc_o 	(PCSrc), 
		.DSrc_o		(DSrc), 
		.NOP_o		(NOP)
	); 
	always @(posedge clk_i) begin
		if(DSrc)
			LCD_D_o <= byteWr_i; 
		else 
			LCD_D_o <= inst[11:4]; 
	end 
	always @(posedge clk_i) begin 
		if(NOP) begin 
			LCD_E 	<= 1'b0; 
			LCD_RS 	<= 1'b0; 
			LCD_RW 	<= 1'b0; 
		end else begin 
			LCD_E 	<= inst[2]; 
			LCD_RS 	<= inst[1]; 
			LCD_RW 	<= inst[0]; 
		end 
	end 
endmodule
/**
module LCD_tb(); 
	reg clk_i_tb; 
	reg  [7:0] 	byteWr_tb; 
	wire [7:0]	LCD_D_tb;
	wire LCD_E_tb;  
	wire LCD_RW_tb; 
	wire LCD_RS_tb; 
	wire clk_o_tb; 

	LCD LCD_U0(clk_i_tb, byteWr_tb, LCD_D_tb, LCD_E_tb, LCD_RW_tb, LCD_RS_tb, clk_o_tb); 
	
	initial begin 
		clk_i_tb 	<= 1'b0; 
		byteWr_tb 	<= 8'hF0; 
	end 
	always begin 
	#50
		clk_i_tb <= ~clk_i_tb; 
	end 
endmodule 
**/
