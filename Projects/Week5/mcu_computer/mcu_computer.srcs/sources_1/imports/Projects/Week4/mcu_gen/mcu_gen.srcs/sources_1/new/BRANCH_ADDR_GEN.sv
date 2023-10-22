`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2023 05:09:42 PM
// Design Name: 
// Module Name: BRANCH_ADDR_GEN
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


module BRANCH_ADDR_GEN(
    input [31:0] i_type_imm, j_type_imm, b_type_imm, rs1, pc,
    output [31:0] jalr, branch, jal
    );
    
    assign jalr = rs1 + i_type_imm;
    assign branch = pc + b_type_imm;
    assign jal = pc + j_type_imm;
    
endmodule
