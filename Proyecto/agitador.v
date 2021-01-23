module agitador(
		input clk_i, //@100MHz
		input onOff_i,
		input selbtn_i, 
		input upbtn_i, 
		input downbtn_i, 
		input rx_i, 
		inout zero_i, 
		output motor_o, 
		output heater_o, 
		output motor_d, 
		output heater_d,
		output tx_o, 
		output [7:0] SEG_o, 
		output [3:0] AN_o
	); 
	
	wire update; 
	wire [9:0] signal; //Actually 12 bits from 0 to 1.25 V.
	PT100_ADC ADC_U0(
		.clk_i	(clk_i),		
		.rx_i		(rx_i),	 		
		.updated	(update), 
		.ADC_o	(signal)
	); 
	
	wire [9:0] signal_f; 
	filter_4 FILTER_U0(
		.clk_i		(update),
		.signal_i	(signal),
		.signal_o 	(signal_f)
	); 
	
	wire [7:0] temp; 
	pt100 PT100_U0(
		.ADC_i 	(signal_f), 
		.temp_o	(temp)
	); 
	
	wire selbtn_deb;
	debouncer DEB_U0(
		.clk_i 		(clk_i), 
		.signal_i 	(selbtn_i),	
		.signal_o 	(selbtn_deb)
   );
	 
	wire upbtn_deb;
	debouncer DEB_U1(
		.clk_i 		(clk_i), 
		.signal_i 	(upbtn_i),	
		.signal_o 	(upbtn_deb)
    );
	
	wire downbtn_deb;
	debouncer DEB_U2(
		.clk_i 		(clk_i), 
		.signal_i 	(downbtn_i),	
		.signal_o 	(downbtn_deb)
    );
	 
	wire [2:0] tempMode; 
	wire [2:0] velMode;  
	wire dot; 
	
	modeCont MCONT_U0(
		.clk_i 		(clk_i), 
		.sel_i 		(~selbtn_deb), 
		.rst_i 		(onOff_i), 
		.up_i		(~upbtn_deb), 
		.down_i		(~downbtn_deb), 
		.tempMode_o	(tempMode), 
		.velMode_o	(velMode), 
		.btnState_d	(dot)
	); 	
	
	tempCont CONT_U0(
		.clk_i		(clk_i), //@100 MHz
		.rst_i		(zero_i), 
		.temp_i		(temp), 
		.tempCase_i (tempMode),//40, 70, 100, 127, 150
		.PWM_o	  	(heater_o)
	); 
	
	velCont CONT_U1(
		.clk_i		(clk_i), 
		.velCase_i	(velMode), 
		.PWM_o		(motor_o)
	); 
	
	wire [31:0] display; 
	messages MESS_U0(
		.clk_i		(clk_i),
		.state0_i 	(dot), 
		.state1_i	(tempMode), 
		.state2_i	(velMode), 
		.temp_i		(temp), 
		.SEg_o		(display)
	); 
	
	
	disp7 DISP_U0(
		.clk_i		(clk_i), 
		.number_i	(display), //4x 7-seg data cluster
		.seg_o		(SEG_o), 
		.an_o		(AN_o)
    );
	 
	 
	 
	BTGUI BT_U0(
		.clk_i		(clk_i), 
		.velMode_i	(velMode), 
		.tempMode_i	(tempMode), 
		.temp_i		(temp), 
		.tx_o		(tx_o)
); 

	assign motor_d = motor_o; 
	assign heater_d = heater_o; 
endmodule
