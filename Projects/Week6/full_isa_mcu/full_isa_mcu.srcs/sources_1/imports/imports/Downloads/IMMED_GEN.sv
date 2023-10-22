`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2023 05:09:42 PM
// Design Name: 
// Module Name: IMMED_GEN
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


module IMMED_GEN(
    input [31:7] ir,
    output [31:0] u_type_imm, i_type_imm, s_type_imm, j_type_imm, b_type_imm
    );
    
    assign u_type_imm = {ir[31:12], 12'b000000000000};
    assign i_type_imm = {{21{ir[31]}}, ir[30:25], ir[24:20]};
    assign s_type_imm = {{21{ir[31]}}, ir[30:25], ir[11:7]};
    assign j_type_imm = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0};
    assign b_type_imm = {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0};
    
endmodule
