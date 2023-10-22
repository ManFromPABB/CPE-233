`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2023 03:19:32 PM
// Design Name: 
// Module Name: mcu_gen
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


module mcu_gen(
    input rst, PCWrite, clk,
    input [1:0] pcSource,
    output [31:0] u_type_imm, s_type_imm
    );
    
    wire [31:0] pc, ir, i_type_imm, j_type_imm, b_type_imm, jalr, branch, jal;
    
    PC_MOD PC_MOD (
        .rst (rst),
        .clk (clk),
        .PCWrite (PCWrite),
        .pcSource (pcSource),
        .PC (pc),
        .jalr (jalr),
        .branch (branch),
        .jal (jal)   );
        
    Memory OTTER_MEMORY ( 
        .MEM_CLK    (clk), 
        .MEM_RDEN1  (1'b1),  
        .MEM_RDEN2  (1'b0),  
        .MEM_WE2    (1'b0), 
        .MEM_ADDR1  (pc[15:2]), 
        .MEM_ADDR2  (32'd0), 
        .MEM_DIN2   (32'd0),   
        .MEM_SIZE   (2'b10), 
        .MEM_SIGN   (1'b0), 
        .IO_IN      (1'b0), 
        .IO_WR      (), 
        .MEM_DOUT1  (ir), 
        .MEM_DOUT2  ()  );
        
    IMMED_GEN IMMED_GEN (
        .ir (ir),
        .u_type_imm (u_type_imm),
        .i_type_imm (i_type_imm),
        .s_type_imm (s_type_imm),
        .j_type_imm (j_type_imm),
        .b_type_imm (b_type_imm)   );
        
    BRANCH_ADDR_GEN BRANCH_ADDR_GEN (
        .i_type_imm (i_type_imm),
        .j_type_imm (j_type_imm),
        .b_type_imm (b_type_imm),  
        .rs1 (32'h0000000C),
        .pc (pc - 4),
        .jalr (jalr),
        .branch (branch),
        .jal (jal)   );
    
endmodule
