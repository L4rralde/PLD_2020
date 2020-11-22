module top(
	input clk, 
	input ultraIn, 
	input enableAlarm, 
	output ultraOut, 
	output [3:0] an, 
	output [6:0] segments, 
	output speaker
);

wire us10; 
wire overflow; 
wire reset; 
wire update; 
wire [8:0] distance; 
wire [8:0] predistance; 

ultrasonic_Controller controller(clk, us10, ultraIn, overflow, reset, update, ultraOut); 
computeDistance counter(clk, reset, update, us10, overflow, predistance); 
filter filter0(update, predistance, distance); 
messages conMess(clk, distance, enableAlarm, an, segments, speaker); 
endmodule
