module pMemory( 
	input 		clk_i, 
	input 		[7:0]	addr_i,
	output reg 	[31:0]	dataR_o 
);
	reg [31:0] memSync [2**8-1:0]; 
	initial
		$readmemh("program.hex", memSync); 
	always @(posedge clk_i)
		dataR_o <= memSync[addr_i]; 		
endmodule
