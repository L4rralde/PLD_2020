//Replace XADCdemo_2.v with this file 

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2015 03:26:51 PM
// Design Name: 
// Module Name: // Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/** 
B16:  vauxp2; 
B17:  vauxn2; 
**/
module XADCdemo(
   input CLK100MHZ,
   input vauxp2,
   input vauxn2,
   input vp_in,
   input vn_in,
   output reg [15:0] LED
 );
   
   wire enable;
   
   //xadc instantiation connect the eoc_out .den_in to get continuous conversion
   xadc_wiz_0  XLXI_7 (
      .daddr_in(8'h12), //addresses can be found in the artix 7 XADC user guide DRP register space
      .dclk_in(CLK100MHZ), 
       .den_in(enable), 
       .di_in(0), 
       .dwe_in(0), 
       .busy_out(),                    
       .vauxp2(vauxp2),
       .vauxn2(vauxn2),
       .vauxp3(),
       .vauxn3(),
       .vauxp10(),
       .vauxn10(),
       .vauxp11(),
       .vauxn11(),
       .vn_in(vn_in), 
       .vp_in(vp_in), 
       .alarm_out(), 
       .do_out(LED), 
       .reset_in(0),
       .eoc_out(enable),
       .channel_out(),
       .drdy_out()
    );
      
endmodule
