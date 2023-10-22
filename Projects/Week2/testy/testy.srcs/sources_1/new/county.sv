`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2023 05:41:30 PM
// Design Name: 
// Module Name: county
// Project Name: 
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


module county(
    input clk,
    output [4:0] count
    );
    
    logic rco;
    
    cntr_up_clr_nb #(.n(3)) carry (
     .clk   (clk), 
     .clr   (), 
     .up    (1), 
     .ld    (1), 
     .D     (), 
     .count (), 
     .rco   (rco)   );
     
     cntr_3 #(.n(5)) MY_CNTR (
     .clk   (clk), 
     .clr   (rco), 
     .up    (1), 
     .ld    (1), 
     .D     (0), 
     .count (count), 
     .rco   ()   );
    
endmodule
