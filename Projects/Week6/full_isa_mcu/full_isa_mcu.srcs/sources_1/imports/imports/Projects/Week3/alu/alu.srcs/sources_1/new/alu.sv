`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2023 02:50:47 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] op_1, op_2,
    input [3:0] alu_fun,
    output reg [31:0] result
    );
    
    always_comb
    begin
        case(alu_fun)
            4'b0000: result = op_1 + op_2;
            4'b1000: result = op_1 - op_2;
            4'b0110: result = op_1 | op_2;
            4'b0111: result = op_1 & op_2;
            4'b0100: result = op_1 ^ op_2;
            4'b0101: result = op_1 >> op_2[4:0];
            4'b0001: result = op_1 << op_2[4:0];
            4'b1101: result = $signed(op_1) >>> op_2[4:0];
            4'b0010: result = ($signed(op_1) < $signed(op_2));
            4'b0011: result = op_1 < op_2;
            4'b1001: result = op_1;
            default: result = 32'hDEADBEEF;
        endcase
    end
endmodule
