`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2023 05:44:17 PM
// Design Name: 
// Module Name: countysim
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


module countysim(

    );
    
    logic clk = 0;
    logic [3:0] count;
    logic [3:0] cnt_out;
    
    cntr_up_clr_nb #(.n(4)) county (
        .clk(clk),
        .clr(0),
        .up(1),
        .ld(),
        .D(),
        .count(cnt_out),
        .rco()
    );
    
    mux_2t1_nb  #(.n(4)) my_2t1_mux  (
       .SEL   (cnt_out[0]), 
       .D0    (cnt_out), 
       .D1    (4'b0000), 
       .D_OUT (count) );  
    
    always
    begin
        clk = 0;
        #10
        clk = 1;
        #10;
    end
    
    initial
    begin
        clk = 0; count = 4'b0000; cnt_out = 4'b0000;
    end
    
endmodule
