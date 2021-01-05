module uart_tx(
	input clk, 
	input [7:0] data, 	//data to be transmmitted
	input start, 			//Signal which triggers transmision 
	output reg tx, 
	output reg busy		//Indicates that data is being transmitted
);
	reg [3:0] state = 4'h0; //Number of states can be reduced with a counter
									//... for Data states
	reg [3:0] nextS = 4'h0; //Moore FSM 
	always @(posedge clk) 
		case(state)
			4'h0: begin 			//IDLE state
				tx <= 1'b1; 	
				busy <= 1'b0; 		
				if(start)			//wait start pulse
					nextS <= 4'hF; //Detect Failing_edge state
				else 
					nextS <= 4'h0; //Go to IDLE state
			end 
			4'hF: begin  			//Detect Failing_edge state
				tx <= 1'b1; 
				busy <= 1'b0; 
				if(start)			//wait until pulse finishes
					nextS <= 4'hF; //Go to Detect Failing_edge state
				else 
					nextS <= 4'h1; //To Start state
			end 
			4'h1: begin 		//Start state
				tx 	<= 1'b0; 
				busy 	<= 1'b1; //Now, module is busy
				nextS <= 4'h2; //Goto Data_0 state
			end 
			4'h2: begin 			//Data_0 state
				tx 	<= data[0]; //Send LSB data bit
				busy 	<= 1'b1; 
				nextS <= 4'h3; 	//Go to Data_1 state
			end
			4'h3: begin 			//Data_1 state
				tx 	<= data[1]; //Send data bit 1
				busy 	<= 1'b1; 
				nextS <= 4'h4; 	//Go to Data_2 state
			end 	
			4'h4: begin 			//Data_2 state
				tx 	<= data[2]; 
				busy 	<= 1'b1; 
				nextS <= 4'h5; 	//Go to Data_3 state
			end 
			4'h5: begin 			//Data_3 state
				tx 	<= data[3]; 
				busy 	<= 1'b1; 
				nextS <= 4'h6; 	//Go to Data_4 state
			end 
			4'h6: begin 			//Data_4 state
				tx 	<= data[4]; 
				busy 	<= 1'b1; 
				nextS <= 4'h7; 	//Go to Data_5 state
			end 
			4'h7: begin 			//Data_5 state
				tx 	<= data[5]; 
				busy 	<= 1'b1; 
				nextS <= 4'h8; 	//Go to Data_6 state
			end 
			4'h8: begin 			//Data_6 state
				tx 	<= data[6]; 
				busy 	<= 1'b1; 
				nextS <= 4'h9; 	//Go to Data_7 state
			end 
			4'h9: begin 			//Data_7 state
				tx 	<= data[7]; 
				busy 	<= 1'b1; 
				nextS <= 4'hA; 	//Go to Stop_1 state
			end 
			4'hA: begin 		//Stop_1
				tx 	<= 1'b1; //Send stop bit #1
				busy 	<= 1'b1; 
				nextS <= 4'hB; //Goto Stop_2 state
			end 
			4'hB: begin 		//Stop_2 state
				tx 	<= 1'b1; 
				busy 	<= 1'b1; 
				nextS <= 4'h0; //Go to IDLE
			end 
		endcase
	always @(posedge clk)  //Update state
		state <= nextS; 
endmodule 