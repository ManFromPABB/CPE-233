`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 01/07/2020 12:59:51 PM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench file for Exp 5
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module otter_tb(); 

   reg RST; 
   reg intr; 
   reg clk; 
   reg [31:0] iobus_in; 
   wire [31:0] iobus_addr; 
   wire [31:0] iobus_out; 
   wire iobus_wr; 

OTTER_MCU  my_otter(
      .rst         (s_reset),
      .intr        (1'b0),
      .clk         (s_clk),
      .IOBUS_IN    (IOBUS_in),
      .IOBUS_OUT   (IOBUS_out), 
      .IOBUS_ADDR  (IOBUS_addr), 
      .IOBUS_WR    (IOBUS_wr)   );
     
   //- Generate periodic clock signal    
   initial    
      begin       
         clk = 0;   //- init signal        
         forever  #10 clk = ~clk;    
      end                        
         
   initial        
   begin           
      s_reset=1;
      intr=0;
      IOBUS_in = 32'h0000FEED;  
    
      #40

      s_reset = 0;  

    end
        
 endmodule
