module joystick(
	input clk_i, 
	input rst_i, 
	input rx_i, 
	input sw_i, 
	output 	reg	 	sel_o, 
	output 	[3:0] 	AN, 
	output 	[6:0] 	DISP,
	output 	reg 	state 
    );

//Debouncing inputs clk_i, rst_i:
wire rst_f;
wire sw_f; 
debouncer DEB_SW(
	.clk_i		(clk_i), 
	.signal_i	(sw_i), 
	.signal_o	(sw_f)
); 
debouncer DEB_RST(
	.clk_i		(clk_i), 
	.signal_i	(rst_i), 
	.signal_o	(rst_f)
); 

//read data and ask for them
wire baud; 
BaudGen BG_U0(
	.clk 	(clk_i), 
	.baud 	(baud)
); 

wire [7:0] dataRx; 
wire updated; 
uart_rx uart_Rx_U0(
	.clk 	(baud),
	.rx  	(rx_i), 
	.dataR	(dataRx), 
	.ready 	(updated) //Tells when new data has arrived
);

reg [7:0] vx; //Voltage of joystick x axis (from 0 to 255)
reg [7:0] vy; //... y axis ...
always @(negedge updated) begin 
	sel_o <= ~sel_o; 	//Tells to microcontroller which 
						//signal is to be sent
	if(sel_o) begin 
		vy <= dataRx; 
		vx <= vx; 
	end else begin 
		vy <= vy; 
		vx <= dataRx;
	end
end 	

reg [19:0] div = 16'b0; 	//Divider to increment coordenates (posX, posY)
always @(posedge clk_i) 
	div <= div+1; 

//Compute posX 
reg enX = 1'b0; 			//Enables counter that drives posX
reg signX = 1'b0;			//Tells whether or not decraese posX. 
reg	[6:0] divX;  			//Tells how fast posX changes.
always @(vx) begin 
	if(vx<8'b01111100) begin //x points towards left? 
		enX 	<= 1'b1; 	//Enable counter that drives posX. 
		signX 	<= 1'b1; 	//Decrease posX
		divX 	<= vx[6:0]; //The near to center, the slower posX changes
	end else if(vx>8'b10000011) begin //x points towards right?
		enX 	<= 1'b1; 	//Enable changes.
		signX 	<= 1'b0; 	//Increase posX
		divX 	<= 127-vx[6:0];	//same as other case
	end else begin //Centered 
		enX 	<= 1'b0; //Don't change posX.
		signX 	<= 1'b0; 
		divX 	<= 7'b1111100;
	end 
end  
reg [6:0] cnt_X = 7'b0; //To control how fast posX changes with a given divX.
reg [7:0] posX = 8'b0; //x coord.
always @(posedge div[19], negedge rst_f) begin
	if(!rst_f) begin
		cnt_X 	<= 7'b0;
		posX 	<= 8'b0; 
	end else begin 
		if(enX) begin //Changes on posX are enabled?
			cnt_X <= cnt_X+1; 
			if(cnt_X == divX) begin 
				cnt_X <= 7'b0; 
				if((signX)&&(posX>8'h0)) //Bounds posX range
					posX <= posX-1; 
				else if((!signX)&&posX<8'hFF)
					posX <= posX+1; 
			end  
		end
	end  
end 

//Compute posY
//It's completely the same as with posX
reg enY = 1'b0; 
reg signY = 1'b0;
reg	[6:0] divY;  
always @(vy) begin 
	if(vy<8'b01111100) begin 
		enY 	<= 1'b1; 
		signY 	<= 1'b1; 
		divY 	<= vy[6:0];  
	end else if(vy>8'b10000011) begin 
		enY 	<= 1'b1; 
		signY 	<= 1'b0; 
		divY 	<= 127-vy[6:0];
	end else begin 
		enY 	<= 1'b0; 
		signY 	<= 1'b0; 
		divY 	<= 7'b1111100;
	end 
end  
reg [6:0] cnt_Y = 7'b0; 
reg [7:0] posY = 8'b0; 
always @(posedge div[19], negedge rst_f) begin 
	if(!rst_f) begin
		cnt_Y 	<= 7'b0; 
		posY 	<= 8'b0; 
	end else begin
		if(enY) begin 
			cnt_Y <= cnt_Y+1; 
			if(cnt_Y == divY) begin 
				cnt_Y <= 7'b0; 
				if((signY)&&(posY>8'h0))
					posY <= posY-1; 
				else if((!signY)&&posY<8'hFF)
					posY <= posY+1; 
			end  
		end 
	end 
end 


//Display data 
disp7 DISP7x4_U0(
	.clk_i	(clk_i), 
	.rst_i	(~rst_f), 
	.dig_i	({posX, posY}), //posX is displayed to the left of posY.
							//(like cartesian coordenates (x,y))
	.seg_o 	(DISP),
	.an_o	(AN) 
); 

//When joystick is being pushed, a 1-bit state changes. 
//This can be used to open/close a menu while playing videogames. 
always @(posedge sw_f, negedge rst_f) begin 
	if(!rst_f)
		state <= 1'b0; 
	else 
		state <= ~state; 
end 

endmodule
