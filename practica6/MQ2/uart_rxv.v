module uart_rx (
	input clk, 						//8*desired_baudRate
	input rx, 							
	output reg [7:0] dataR, 	//received data
	output reg ready				//Indicates that received data is ready	
); 	
	reg [1:0] state = 2'h0; 
	reg reset = 1'b0; 			//Reset counter which divides clk by 8 (desired_baudRate)
	wire paired; 					//Indicates when to save Rx into dataR
	wire done; 						//Indicates when 8 dataBits have been received
	always @(posedge clk)		
		case(state)
			2'h0: 					//Wait Start state
				if(~rx) begin 		//Start?	
					state <= 2'h1; //Go to Receive Data state
					reset <= 1'b0; //stop resetting counter which divides clk
					ready <= 1'b0; //Indicate that dataR is not ready to be taken
				end else begin  	//Otherwise, stay at Wait Start state
					state <= 2'h0; 
					reset <= 1'b1;
					ready <= 1'b0; 
				end 
				2'h1: 					//Receive Data state
					if(done) begin  	//8 data bits  have ben received?
						state <= 2'h2;	//Remain at Receive Data state
						ready <= 1'b0; 
					end else begin 
						state <= 2'h1; //Go to Receive StopBit 1 state
						ready <= 1'b0; 
					end 
				2'h2: 					//Receive StopBit 1 state 
					if(paired) begin 	
					state <= 2'h3;		//Go to Receive StopBit 2 state
					ready <= 1'b0; 
				end else begin 
					state <= 2'h2;		//Go to Receive StopBit 1 state
					ready <= 1'b0; 
				end 
			2'h3: 						//Receive StopBit 2 state 
				if(paired) begin 		
					state <= 2'h0;		//Go to Wait Start state	
					ready <= 1'b1; 	//Finally, data is ready
				end else begin 
					state <= 2'h3;		//Go to Receive StopBit 2 state
					ready <= 1'b0; 	
				end 
		endcase
			//Counter which divides clk
	reg [2:0] sync = 3'b0;
	always @(posedge clk or posedge reset) begin 
		if(reset) 
			sync <= 3'b0; 
		else 
			sync <= sync+1; 
	end 
	assign paired = (sync==3'b110); 	//Change state 7 clock cycle after fail ...
												//... edge @ start and then each 8 cycles.

	reg [2:0] counter = 3'h0;  //Counts how many data bits have been received. 
	reg [7:0] data = 8'h0; 		//shift register for data receiving. 
	always @(posedge paired or posedge reset) begin //When it's indicated to save rx
		if(reset)
			counter <= 3'h0; 
		else begin 
			if(~ready)	//Not 8 data bits have been received yet?
				counter <= counter+1; 
				data <= {rx, data[7:1]}; //Shift
		end 
	end 
	assign done = &counter; //indicates wether counter == 7 (8 data bits have been received)
	always @(posedge ready) //update dataR when received data is ready. 
		dataR <= data; 
endmodule 