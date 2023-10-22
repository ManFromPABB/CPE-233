`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2023 03:22:14 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input rst,
    input PCWrite,
    input clk,
    input [1:0] pcSource,
    output reg [31:0] ir
    );
    
    wire [31:0] pc;
    
    PC_MOD PC_MOD (
        .rst (rst),
        .PCWrite(PCWrite),
        .clk(clk),
        .pcSource (pcSource),
        .jalr (32'h00004444),
        .branch (32'h00008888),
        .jal (32'h0000CCCC),
        .address (pc)   );
        
   Memory OTTER_MEMORY ( 
        .MEM_CLK   (clk), 
        .MEM_RDEN1 (1'b1),  
        .MEM_RDEN2 (1'b0),  
        .MEM_WE2   (1'b0), 
        .MEM_ADDR1 (pc[15:2]),   // 14-bit signal 
        .MEM_ADDR2 (32'd0), 
        .MEM_DIN2  (32'd0),   
        .MEM_SIZE  (2'b10), 
        .MEM_SIGN  (1'b0), 
        .IO_IN     (1'b0), 
        .IO_WR     (), 
        .MEM_DOUT1 (ir),         // 32-bit signal 
        .MEM_DOUT2 ()   );
    
endmodule
