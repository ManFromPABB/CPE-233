`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2023 03:01:28 PM
// Design Name: 
// Module Name: OTTER_MCU
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


module OTTER_MCU(
    input rst, intr, clk,
    input reg [31:0] IOBUS_IN,
    output reg [31:0] IOBUS_OUT, IOBUS_ADDR,
    output reg IOBUS_WR
    );
    
    // Program Counter logic
    wire reset, PCWrite;
    wire [2:0] pcSource;
    wire [31:0] jalr, branch, jal, PC;
    
    // Memory Logic
    wire memRDEN1, memRDEN2, MEMWE2;
    wire [31:0] ir, DOUT2;
    
    // Reg File Logic
    wire [31:0] wd, rs1, rs2;
    wire regWrite;
    wire [1:0] rf_wr_sel;
    
    // IMMED_GEN Logic
    wire [31:0] u_type_imm, j_type_imm, b_type_imm, s_type_imm, i_type_imm;
    
    // ALU Logic
    wire [1:0] alu_srcA;
    wire [2:0] alu_srcB;
    wire [3:0] alu_fun;
    wire [31:0] result, srcA, srcB, NOT_RS1;
    
    // BRANCH_COND_GEN Logic
    wire br_eq, br_lt, br_ltu;
    
    // Interrupt Logic
    wire [31:0] mtvec, mepc, csr_out;
    wire mie, csr_we, int_taken;
    
    PC_MOD PC_MOD (
        .rst (reset),
        .PCWrite (PCWrite),
        .clk (clk),
        .pcSource (pcSource),
        .jalr (jalr),
        .branch (branch),
        .jal (jal),
        .mtvec (mtvec),
        .mepc (mepc),
        .PC (PC)   );
    
     Memory OTTER_MEMORY (
        .MEM_CLK   (clk),
        .MEM_RDEN1 (memRDEN1), 
        .MEM_RDEN2 (memRDEN2), 
        .MEM_WE2   (memWE2),
        .MEM_ADDR1 (PC[15:2]),
        .MEM_ADDR2 (result),
        .MEM_DIN2  (rs2),  
        .MEM_SIZE  (ir[13:12]),
        .MEM_SIGN  (ir[14]),
        .IO_IN     (IOBUS_IN),
        .IO_WR     (IOBUS_WR),
        .MEM_DOUT1 (ir),
        .MEM_DOUT2 (DOUT2)  );
        
     RegFile Register (
        .wd   (wd),
        .clk  (clk), 
        .en   (regWrite),
        .adr1 (ir[19:15]),
        .adr2 (ir[24:20]),
        .wa   (ir[11:7]),
        .rs1  (rs1), 
        .rs2  (rs2)  );
     
     mux_4t1_nb  #(.n(32)) reg_mux  (
        .SEL   (rf_wr_sel), 
        .D0    (PC + 4), 
        .D1    (csr_out), 
        .D2    (DOUT2), 
        .D3    (result),
        .D_OUT (wd) );
        
     IMMED_GEN IMMED_GEN (
        .ir (ir),
        .u_type_imm (u_type_imm),
        .i_type_imm (i_type_imm),
        .s_type_imm (s_type_imm),
        .j_type_imm (j_type_imm),
        .b_type_imm (b_type_imm)   );
     
     BRANCH_ADDR_GEN BRANCH_ADDR_GEN (
        .pc (PC),
        .rs1 (rs1),
        .i_type_imm (i_type_imm),
        .j_type_imm (j_type_imm),
        .b_type_imm (b_type_imm),
        .jalr (jalr),
        .branch (branch),
        .jal (jal)   );
        
     mux_4t1_nb  #(.n(32)) alu_muxA  (
        .SEL   (alu_srcA), 
        .D0    (rs1), 
        .D1    (u_type_imm),
        .D2    (NOT_RS1), 
        .D3    (32'h0), 
        .D_OUT (srcA) );
     
     mux_8t1_nb  #(.n(32)) alu_muxB  (
        .SEL   (alu_srcB), 
        .D0    (rs2), 
        .D1    (i_type_imm), 
        .D2    (s_type_imm), 
        .D3    (PC),
        .D4    (csr_out),
        .D5    (32'h0),
        .D6    (32'h0),
        .D7    (32'h0),
        .D_OUT (srcB) );
        
     alu ALU (
        .op_1 (srcA),
        .op_2 (srcB),
        .alu_fun (alu_fun),
        .result (result)   );
        
     BRANCH_COND_GEN my_branch_cond_gen (
        .rs1 (rs1),
        .rs2 (rs2),
        .br_eq (br_eq),
        .br_lt (br_lt),
        .br_ltu (br_ltu)   );
        
     CU_FSM CU_FSM(
        .intr     (fsm_intr),
        .clk      (clk),
        .RST      (rst),
        .opcode   (ir[6:0]),   // ir[6:0]
        .func3    (ir[14:12]),
        .pcWrite  (PCWrite),
        .regWrite (regWrite),
        .memWE2   (memWE2),
        .memRDEN1 (memRDEN1),
        .memRDEN2 (memRDEN2),
        .mret_exec (mret_exec),
        .csr_we (csr_we),
        .int_taken (int_taken),
        .reset    (reset)   );
        
     CU_DCDR CU_DCDR(
        .br_eq     (br_eq), 
        .br_lt     (br_lt), 
        .br_ltu    (br_ltu),
        .opcode    (ir[6:0]),    //-  ir[6:0]
        .func7     (ir[30]),    //-  ir[30]
        .func3     (ir[14:12]),    //-  ir[14:12] 
        .alu_fun   (alu_fun),
        .pcSource  (pcSource),
        .alu_srcA  (alu_srcA),
        .alu_srcB  (alu_srcB),
        .int_taken (int_taken),
        .rf_wr_sel (rf_wr_sel)   );
        
     CSR  my_csr (
        .CLK        (clk),
        .RST        (rst),
        .MRET_EXEC  (mret_exec),
        .INT_TAKEN  (int_taken),
        .ADDR       (ir[31:20]),
        .PC         (PC),
        .WD         (result),
        .WR_EN      (csr_we), 
        .RD         (csr_out),
        .CSR_MEPC   (mepc),  
        .CSR_MTVEC  (mtvec), 
        .CSR_MSTATUS_MIE (mie)    ); 
        
     assign IOBUS_OUT = rs2;
     assign NOT_RS1 = ~rs1;
     assign IOBUS_ADDR = result;
     assign fsm_intr = intr & mie;
    
endmodule
