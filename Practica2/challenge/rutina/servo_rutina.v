module servo_rutina (input clk_fpga, // Reloj fpga
							input on_off, 	//Encendido apagado
							output pwm_servo); //Salida pwm para servo

wire relojtoservo;


reloj U1(	
				.C_50Mhz(clk_fpga),
				.C_1Hz(relojtoservo)

			);
			
servo U2(

				.onoff(on_off),
				.pwm(pwm_servo), 
				.clk(relojtoservo),
				.freq(clk_fpga)
			);
			

endmodule 

module servo (
  input freq,
  input clk,
  input onoff,
  output pwm
  );
	
  reg pwm_q, pwm_d;
  reg [20:0] ctr_q, ctr_d;
  assign pwm = pwm_q;
  reg [11:0]posicion; 

  always @(*) begin
  
	if (onoff==1) 
		begin
				if(clk==1) begin posicion=7'd20500; end
				else begin posicion= 7'd00500; end
	
    ctr_d = ctr_q + 1'b1;
    if (posicion + 9'd065 > ctr_q[20:8]) begin
      pwm_d = 1'b1;
    end else begin
      pwm_d = 1'b0;
    end
  end
  
  end
	
  always @(posedge freq) begin
    ctr_q <= ctr_d;
    pwm_q <= pwm_d;
  end
endmodule

module reloj (	C_50Mhz,
					C_1Hz);
					
						
 input C_50Mhz;         //RELOJ DE LA FPGA
 output reg C_1Hz = 1;  //RELOJ DE SALIDA

 reg[27:0] contador = 0; //Variable Contador equivale a 25 millones de estados. 

 always @(posedge C_50Mhz)
  begin
   contador = contador + 1; 
   if(contador == 12500000)
    begin
      contador = 0;
      C_1Hz = ~C_1Hz;
    end
  end
endmodule