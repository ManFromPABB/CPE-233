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
    
    reg [31:0] muxO;
    reg [31:0] PCint = 0; //internal PC
       
    always @ (*)
    begin 
          case (pcSource) //4:1 mux
          0:      muxO = PCint + 32'h4;
          1:      muxO = jalr;
          2:      muxO = branch;
          3:      muxO = jal;
          endcase
	end
          
    always @ (posedge clk)
    begin 
       if (rst == 1) // synchronous clear
          PCint <= 0;
       else if (PCWrite == 1) // synchronous load
          PCint <= muxO; 
    end
    
    assign PC = PCint;
    
endmodule
