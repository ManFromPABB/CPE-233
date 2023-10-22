`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 07/07/2018 08:05:03 AM
// Design Name: 
// Module Name: fsm_template
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic FSM model with both Mealy & Moore outputs. 
//    Note: data widths of state variables are not specified 
//
// Dependencies: 
// 
// Revision:
// Revision 1.00 - File Created (07-07-2018) 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FSM(btn, gt, rco, clk, re, we, clr, cntr_up, cntr_mux, size_up, sel); 
    input btn, gt, rco, clk; 
    output reg [1:0] sel;
    output reg re, we, clr, cntr_up, cntr_mux, size_up;
     
    //- next state & present state variables
    reg [2:0] NS, PS; 
    //- bit-level state representations
    parameter [2:0] hold=3'b000, compare=3'b001, write=3'b011, cycle=3'b010, shift=3'b100;
    

    //- model the state registers
    always @ (posedge clk)
          PS <= NS; 
    
    
    //- model the next-state and output decoders
    always @ (PS)
    begin
       re = 0; we = 0; clr = 0; cntr_up = 0; cntr_mux = 0; size_up = 0; sel = 2'b00;
       case(PS)
          hold: // Waits for user button press to begin calculations
          begin
             re = 0; we = 0; clr = 0; cntr_up = 1; cntr_mux = 0; size_up = 0; sel = 2'b00;
             if (btn == 1)
             begin
                clr = 1;
                NS = compare; 
             end  
             else
             begin
                NS = hold; 
             end  
          end
          
          compare: // Loads rounded ROM sum into shift register and checks if value should be stored in RAM. If rco = 1, moves to final state
             begin
                re = 1; we = 0; clr = 0; cntr_up = 0; cntr_mux = 0; size_up = 0; sel = 2'b01;
                if (rco == 1)
                begin
                    NS = cycle;
                end
                else if (gt == 1)
                begin
                    NS = shift;
                end
                else if (gt == 0)
                begin
                    cntr_up = 1;
                    NS = compare;
                end
             end
             
          shift: // Completes bit shift to find the average
             begin
                re = 1; we = 1; clr = 0; cntr_up = 0; cntr_mux = 0; size_up = 0; sel = 2'b11;
                NS = write;
             end 
             
          write: // Writes the average value to the RAM
             begin
                re = 1; we = 1; clr = 0; cntr_up = 1; cntr_mux = 0; size_up = 1; sel = 2'b00;
                NS = compare;
             end  
             
          cycle: // Cycles through the RAM contents
             begin
                 re = 0; we = 0; clr = 0; cntr_up = 1; cntr_mux = 1; size_up = 0; sel = 2'b00;
                 NS = cycle;
             end
             
          default: NS = hold; 
            
          endcase
      end              
endmodule


