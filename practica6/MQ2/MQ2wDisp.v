module MQ2wDisp(
	input clk_i,		//@50 MHz
	input rx_i, 		//Rx UART @9600 bps
	output [6:0] seg_o, //7-segments display
	output [3:0] an_o	//4 digits
); 
//--------Baudrate for uart receiver---------
wire baud; 
BaudGen BG_U0(
	.clk	(clk_i), 		
	.baud	(baud)		
); 
//---------------UART receiver---------------
wire [7:0] recR; 	//data received
wire updated;  		//Tells when new data has arrived
uart_rx UART_REC_U0(
	.clk	(baud), 	
	.rx		(rx_i), 							
	.dataR	(recR), 	
	.ready	(updated)
); 	
//-------------Rebuild data------------------
//Data is sent in 2 parts. MSB of byte received indicates if it's 
//the most significant one. The most signifcant part is a 7-bits word
//and the lest significant part is a 3-bits word. 
reg [6:0] MSB_ADC = 7'b0; 
always @(posedge updated) begin 
	if(recR[7])
		MSB_ADC <= recR[6:0];  
end 
reg [2:0] LSB_ADC = 3'b0; 
always @(posedge updated) begin 
	if(~recR[7])
		LSB_ADC <= recR[2:0]; 
end 
wire [9:0] ADC; 
assign ADC = {MSB_ADC,LSB_ADC}; //Both parts are concatenated to 
								//get the 10-bits original value.
//-------------Digital filtering--------------
wire [9:0] ADC_f;  
filter_8 FILTER_U0( //This averages last 4 10-bit ADC values signal 
					//updated changes 2 times per 10-bit ADC value
	.clk_i		(updated), 
	.signal_i	(ADC), 
	.signal_o	(ADC_f)
);
//------Compute equivalent ppm concentration------
wire [13:0] PPM; //Equivalent value for a fiven ADC 10-bits value
MQ2 mq2_U0(
	.adc_i	(ADC_f), 
	.ppm_o	(PPM)
); 
//-------Convert 10 bits to 4 BCD nibbles-------
wire [3:0] UNI; 
wire [3:0] DEC;
wire [3:0] CEN;  
wire [3:0] MIL;
bin2BCD B2BCD_U0(
	.clk_i	(clk_i), 
	.bin_i	({2'b0, PPM}), 
	.uni_o	(UNI), 
	.dec_o	(DEC),	 
	.cen_o	(CEN), 
	.mil_o	(MIL)
); 
//-------Decode each BCD to 7-segments-------
wire [27:0] DIG4_7s; 
BCD27SEG BCD27S_U0(UNI, DIG4_7s[6:0]);
BCD27SEG BCD27S_U1(DEC, DIG4_7s[13:7]);
BCD27SEG BCD27S_U2(CEN, DIG4_7s[20:14]);
BCD27SEG BCD27S_U3(MIL, DIG4_7s[27:21]);
//---------Mux output to be displayed--------
wire outOf; 
assign outOf = &PPM; //mq2 module returns 10'h3FF when ppm>10000
wire [27:0] dispBuff; 
assign dispBuff = outOf? //"out" or ppm value
					{7'b1100010, 7'b1100011, 7'b1110000, 7'b1111111}
					: DIG4_7s;
//---------Display value or message---------
disp7 DISP_U0(
	.clk_i		(clk_i), 
	.number_i	(dispBuff),	 
	.seg_o		(seg_o), 
	.an_o			(an_o)
); 
endmodule 
