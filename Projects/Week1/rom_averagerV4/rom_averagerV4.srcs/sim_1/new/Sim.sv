`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2023 05:21:12 PM
// Design Name: 
// Module Name: Sim
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


module Sim(

    );
    
    logic clk, btn, gt, rco, sclk, cntr_mux, cntr_up, re, we, clr, size_up = 0;
    logic [1:0] sel = 2'b00;
    
    logic [3:0] address = 4'b0000;
        
    clk_div2 clk_divider (
        .clk (clk),
        .sclk (sclk)   );
    
    FSM FSM1 (
        .btn (btn),
        .gt (gt),
        .rco (rco),
        .clk (sclk),
        .cntr_mux (cntr_mux),
        .cntr_up (cntr_up),
        .re (re),
        .we (we),
        .clr (clr),
        .sel (sel),
        .size_up (size_up)   );
        
    cntr_up_clr_nb #(.n(4)) Address_CNTR (
        .clk   (sclk), 
        .clr   (clr), 
        .up    (cntr_up), 
        .ld    (), 
        .D     (), 
        .count (address), 
        .rco   (rco)   );
        
    ROM_16x8a romA (
        .addr  (address),  
        .data  (rom_dataA),  
        .rd_en (re)    );
        
    ROM_16x8b romB (
        .addr  (address),  
        .data  (rom_dataB),  
        .rd_en (re)    );
        
    rca_nb #(.n(8)) RCA (
        .a   (rom_dataA), 
        .b   (rom_dataB), 
        .cin (), 
        .sum (rom_sum), 
        .co  (co)    );
     
     always
     begin
     clk = ~clk;
     end
     
     initial
     begin
        clk = 0; btn = 0;
        #5
        btn = 1;
        #1000000000
        btn = 0;
     end
endmodule
