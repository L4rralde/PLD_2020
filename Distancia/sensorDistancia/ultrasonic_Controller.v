module ultrasonic_Controller(
	input clk, 
	input us10,
	input echo, 
	input overflow,
	output reg reset, 
	output reg update, 
	output reg signal
    );

localparam 
	IDLE = 3'b000, 
	TRIGGER = 3'b001, 
	READY = 3'b010,
	COUNT = 3'b011, 
	LOAD = 3'b100; 

reg [2:0] state = 3'b0; 
reg [2:0] stateNext = 3'b0; 

always @(us10, echo, overflow, state) begin 
	case(state)
		IDLE: begin 
			reset = 1'b1; 
			update = 1'b0;
			signal = 1'b0;
			stateNext = TRIGGER; 
		end 
		TRIGGER: begin 
			reset = 1'b0; 
			update = 1'b0;
			signal = 1'b1;
			if(us10)	
				stateNext = READY; 
			else 
				stateNext = TRIGGER; 
		end 
		READY: begin 
			reset = 1'b1; 
			update = 1'b0;
			signal = 1'b0;
			if(echo)
				stateNext = COUNT; 
			else 
				stateNext = READY;
		end 
		COUNT: begin 
			reset = 1'b0; 
			update = 1'b0;
			signal = 1'b0;
			if(overflow) 
				stateNext = IDLE; 
			else begin 
				if(echo) 
					stateNext = COUNT;
				else
					stateNext = LOAD; 
			end
		end 
		LOAD: begin
			reset = 1'b0; 
			update = 1'b1;
			signal = 1'b0;
			if(overflow) 
				stateNext = IDLE;
			else
				stateNext = LOAD;  
		end
		default: begin 
			reset = 1'b1; 
			update = 1'b0;
			signal = 1'b0;
			stateNext = IDLE; 
		end
	endcase
end 

always @(posedge clk) 
	state <= stateNext; 

endmodule
