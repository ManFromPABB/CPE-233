`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2023 04:56:38 PM
// Design Name: 
// Module Name: PC_Sim
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


module PC_Sim(

    );
    
    logic clk, rst, PCWrite;
    logic [1:0] pcSource;
    
    logic [31:0] ir, pc;
    
    Program_Counter PC (
        .clk (clk),
        .rst (rst),
        .PCWrite (PCWrite),
        .pcSource (pcSource),
        .ir (ir)
    );
        
    always
    begin
        #10
        clk = 0;
        #10
        clk = 1;
    end
    
    initial
    begin
        clk = 0; rst = 0; PCWrite = 0; pcSource = 2'b00;
        #10
        rst = 1;
        #20
        rst = 0;
        #40
        PCWrite = 1;
        #170
        rst = 1;
        #20
        rst = 0;
        pcSource = 2'b01;
        #30
        rst = 1;
        #20
        rst = 0;
        PCWrite = 1;
        pcSource = 2'b10;
        #50
        pcSource = 2'b11;
        #50
        PCWrite = 0;
    end
    
endmodule
