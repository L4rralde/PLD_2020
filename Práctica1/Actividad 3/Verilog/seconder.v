module seconder( 
    input clk,
    output OneSec_clk
); 
    reg [18:0] pre; 
    reg [12:0] pos; 

    always @(posedge clk)
    begin 
    	pre <= pre+1; 
    end 

    always @(posedge pre[18])
    begin 
    	pos <= pos[11:0]+43; 
    end

    assign OneSec_clk = pos[12];
    endmodule
