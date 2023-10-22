`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2023 01:36:11 PM
// Design Name: 
// Module Name: BRANCH_COND_GEN
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


module BRANCH_COND_GEN(
    input [31:0] rs1, rs2,
    output br_eq, br_lt, br_ltu
    );
    
    assign br_eq = (rs1 == rs2);
    assign br_lt = ($signed(rs1) < $signed(rs2));
    assign br_ltu = (rs1 < rs2);
    
endmodule
