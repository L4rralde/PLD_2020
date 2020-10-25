module sirena(
	input clk_in, 
	input [1:0] sel,
	output reg speaker
);	
	reg [1:0] div; 
	wire clk; 
	always @(posedge clk_in)
	begin 
		div <= div+1; 
	end 
	assign clk = div[1];

	wire [1:0] channels; 
	sirena_policia U1(clk, channels[0]); 
	sirena_ambulancia U2(clk, channels[1]); 

	always @(sel, channels)
	begin
		case(sel)
			2'b01 : speaker = channels[0]; 
			2'b10 : speaker = channels[1]; 
			default : speaker = 1'b0; 
		endcase
	end
	
endmodule



module sirena_policia(
	input clk, 
	output reg speaker
);

	reg [22:0] tone;
	always @(posedge clk) tone <= tone+1;
	wire [6:0] ramp = (tone[22] ? tone[21:15] : ~tone[21:15]);
	wire [14:0] clkdivider = {2'b01, ramp, 6'b000000};
	reg [14:0] counter;

	always @(posedge clk) 
	begin
		if(counter==0) 
			counter <= clkdivider; 
		else 
			counter <= counter-1;
	end 

	always @(posedge clk)
	begin 
		if(counter==0)
			speaker <= ~speaker;
	end


endmodule






module sirena_ambulancia(
	input clk, 
	output reg speaker
);

	reg [27:0] tone;
	always @(posedge clk) tone <= tone+1;
	wire [6:0] fastsweep = (tone[22] ? tone[21:15] : ~tone[21:15]);
	wire [6:0] slowsweep = (tone[25] ? tone[24:18] : ~tone[24:18]);
	wire [14:0] clkdivider = {2'b01, (tone[27] ? slowsweep : fastsweep), 6'b000000};
	reg [14:0] counter;

	always @(posedge clk) 
	begin
		if(counter==0) 
			counter <= clkdivider; 
		else 
			counter <= counter-1;
	end 

	always @(posedge clk)
	begin 
		if(counter==0)
			speaker <= ~speaker;
	end


endmodule
