module filter(
	input update,
	input [8:0] newData, 
	output [8:0] filtData
    );

reg [8:0] data0; 
reg [8:0] data1;
reg [8:0] data2;
reg [8:0] data3;
reg [10:0] sum;    
always @(posedge update) begin 
	data0 <= newData; 
	data1 <= data0; 
	data2 <= data1; 
	data3 <= data2;
	sum <= data0+data1+data2+data3; 
end 

assign filtData = sum[10:2]-9'b11;
endmodule
