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
    output reg [31:0] PC
    );
    
    reg [31:0] mux_out;
    reg [31:0] PCval = 0; // internal PC
       
    always @ (*)
    begin 
          case (pcSource) // 4t1 mux
          0: mux_out = PCval + 32'h4;
          1: mux_out = jalr;
          2: mux_out = branch;
          3: mux_out = jal;
          endcase
	end
          
    always @ (posedge clk)
    begin 
       if (rst == 1) // synchronous clear
          PCval <= 0;
       else if (PCWrite == 1) // synchronous load
          PCval <= mux_out; 
    end
    
    assign PC = PCval;
    
endmodule
