`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2023 03:08:00 PM
// Design Name: 
// Module Name: PC_MOD
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


module PC_MOD(
    input rst,
    input PCWrite,
    input clk,
    input [1:0] pcSource,
    input [31:0] jalr, branch, jal,
    output [31:0] address
    );
    
    logic [31:0] mux_out, input_address;
    
    mux_4t1_nb  #(.n(32)) mux (
        .SEL   (pcSource), 
        .D0    (input_address), 
        .D1    (jalr), 
        .D2    (branch), 
        .D3    (jal),
        .D_OUT (mux_out) );
    
    reg_nb_sclr #(.n(32)) PC (
        .data_in (mux_out),
        .clk (clk),
        .clr (rst),
        .ld (PCWrite),
        .data_out (address)   );
        
    assign input_address = address + 4;
    
endmodule
