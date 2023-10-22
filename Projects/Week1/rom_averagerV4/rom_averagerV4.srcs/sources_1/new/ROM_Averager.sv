`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2023 10:47:03 PM
// Design Name: 
// Module Name: ROM_Averager
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


module ROM_Averager(
        input clk, btn,
        output reg [3:0] address, an,
        output [7:0] seg
    );
    
    // FSM IO
    logic gt; // Greater than from comparator
    logic sclk; // Slower clock pulse from clock divider
    logic cntr_mux; // Selector for multiplexor that handles current RAM address position
    logic cntr_up; // Allows ROM address counter to increase every clock pulse
    logic re; // ROM Read permissions
    logic we; // RAM Write permissions
    logic clr; // Clears counter when button pressed
    logic size_up; // Allows RAM size counter to increment when high
    logic co; // Ripple carry adder carry out
    logic rco; // Counter carry out for final FSM state
    
    logic [3:0] ram_size, ram_address; // Variables managing current size of ram and current read/write address
    logic [7:0] rom_dataA, rom_dataB, rom_sum, shifted_val, ram_data, ram_display_data; // Intermediate variables for average math operations
    logic [1:0] sel; // Selector for shift register that loads and shifts the rounded value to divide by two
    
    clk_div2 clk_divider ( // Slow clock pulse to observe circuit progress
        .clk (clk),
        .sclk (sclk)   );
    
    FSM FSM1 ( // Control circuit, variables described above
        .btn (btn),
        .gt (gt),
        .rco (rco),
        .clk (sclk),
        .cntr_mux (cntr_mux),
        .cntr_up (cntr_up),
        .re (re),
        .we (we),
        .clr (clr),
        .sel (sel),
        .size_up (size_up)   );
        
    cntr_up_clr_nb #(.n(4)) Address_CNTR ( // Manages ROM address location and LEDs
        .clk   (sclk), 
        .clr   (clr), 
        .up    (cntr_up), 
        .ld    (), 
        .D     (), 
        .count (address), 
        .rco   (rco)   );
        
    ROM_16x8a romA ( // Rom A
        .addr  (address),  
        .data  (rom_dataA),  
        .rd_en (re)    );
        
    ROM_16x8b romB ( // Rom B
        .addr  (address),  
        .data  (rom_dataB),  
        .rd_en (re)    );
        
    rca_nb #(.n(8)) RCA ( // Sums rom data together and saves carry out
        .a   (rom_dataA), 
        .b   (rom_dataB), 
        .cin (), 
        .sum (rom_sum), 
        .co  (co)    );
        
    comp_nb #(.n(9)) Comparator ( // Compares the rounded value to 31 to ensure it's greater than 15 before being divided
        .a  (rom_sum + 1), 
        .b  (31), 
        .eq (), 
        .gt (gt), 
        .lt ()   );
        
    usr_nb #(.n(8)) ShiftReg ( // Completes division operation on rounded value. Compare state in FSM loads value into module, Shift state completes division.
        .data_in (rom_sum + 1), 
        .dbit (co), 
        .sel (sel), 
        .clk (sclk), 
        .clr (), 
        .data_out (shifted_val)   );
        
    ram_single_port #(.n(4),.m(8)) my_ram ( // RAM module that stores the average values
        .data_in  (shifted_val),  // m spec
        .addr     (ram_address),  // n spec 
        .we       (we),
        .clk      (clk),
        .data_out (ram_data)   );
        
    univ_sseg my_univ_sseg ( // Controls output display
        .cnt1    ({6'b0, ram_display_data}), 
        .cnt2    (ram_size), 
        .valid   (1), 
        .dp_en   (0), 
        .dp_sel  (), 
        .mod_sel (2'b01), 
        .sign    (), 
        .clk     (clk), 
        .ssegs   (seg), 
        .disp_en (an)   );
        
    cntr_up_clr_nb #(.n(4)) RAM_Size_CNTR ( // Counts the current size of the RAM module
        .clk   (sclk), 
        .clr   (), 
        .up    (size_up), 
        .ld    (), 
        .D     (), 
        .count (ram_size), 
        .rco   ()   );
        
    mux_2t1_nb  #(.n(4)) ram_display_selector_mux  ( // Inserts averages at correct RAM address then cycles in final FSM state
        .SEL   (cntr_mux), 
        .D0    (ram_size), 
        .D1    (address), 
        .D_OUT (ram_address)   );
        
    mux_2t1_nb  #(.n(8)) ram_display_grounding_mux  ( // Grounds RAM output value at zero while the RAM module is being populated
        .SEL   (cntr_mux), 
        .D0    (8'b0), 
        .D1    (ram_data), 
        .D_OUT (ram_display_data)   );

endmodule
