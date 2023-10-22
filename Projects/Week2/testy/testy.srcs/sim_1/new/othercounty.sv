`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2023 04:48:05 PM
// Design Name: 
// Module Name: othercounty
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


module othercounty(

    );
    
    logic clk, clr, rco, up, load;
    logic [1:0] state;
    logic [2:0] count;
    
    cntr_up_clr_nb #(.n(3)) countpqpq (
        .clk(clk),
        .clr(clr),
        .up(up),
        .ld(load),
        .D(3'b111),
        .count(count),
        .rco(rco)   );
        
    fsm_template fsm (
        .clk(clk),
        .rco(rco),
        .up(up),
        .clr(clr),
        .load(load),
        .state(state)   );
        
       
   always
    begin
        clk = 0;
        #10
        clk = 1;
        #10;
    end
    
    initial
    begin
        clk = 0; count = 3'b000; rco = 0; up = 1; clr = 0; state = 2'b00; load = 0;
    end
    
endmodule
