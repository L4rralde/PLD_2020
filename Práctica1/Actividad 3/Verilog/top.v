module top(
	input clk,
	input dir, 
	input hab, 
	input res, 
	output [6:0] disp, 
	output [3:0] OnDisp
    );

	wire sec1Clk; 
	wire [3:0] count; 

	seconder U1(clk, sec1Clk); 
	counter U2(sec1Clk, hab, dir, res, count); 
	//counter U2(clk, hab, dir, res, count); 

	decod7_s U3(count, disp);
	assign OnDisp = 4'b0111; 
endmodule
