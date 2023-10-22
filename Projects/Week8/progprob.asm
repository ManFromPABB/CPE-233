.data              # 16 total values 
my_lut:   .byte    0x00, 0x01, 0x02, 0x03, 0x04, 0x06, 0x07, 0x08, #LED output patterns 
          .byte    0x0C, 0x0E, 0x0F, 0x10, 0x18, 0x1C, 0x1E, 0x1F

.text 
main:  
init:   li     x14,0x11004444  # input port
        li     x15,0x1100C000  # led port
        mv     x31,x0          # number of interrupts done
        li     x16,16          # constant value to compare against number of interrupts
        mv     x20,0           # set accumulator
        la     x5,my_lut       # load address of LUT
        la     x6,ISR          # load address of ISR into x6 
        csrrw  x0,mtvec,x6     # store address as interrupt vector CSR[mtvec] 
         
unmask: li     x10,0x8         # set bit[3] value in x10 
        csrrs  x0,mstatus,x10  # enable interrupts: set MIE in CSR[mstatus] 
 
loop:   lb     x21,0(x14)      # loads switch value while waiting for interrupt
        beq    x8,x0,loop      # wait for interrupt 

        beq    x31,x16,average # if interrupts is 16, go to averaging part
        mv     x8,x0           # clear flag
        add    x20,x20,x21     # accumulate input value
        
        csrrs  x0,mstatus,x10  # enable interrupts: set MIE (bit3) in CSR[mstatus] 
        j      loop            # return to loopville

average: csrrw   x0,mstatus,x0   # disable future interrupts
         srli    x20,x20,4       # divide by 16
         add     x8,x5,x20       # find address for LUT
         lb      x8,0(x8)        # load led value
         sb      x8,0(x15)       # display leds
         ret                     # done


#--------------------------------------------------------------------------------- 
 
#--------------------------------------------------------------------------------- 
#- The ISR: sets bit x8 to act as flag to task code.  
#--------------------------------------------------------------------------------- 
ISR:    li     x8,0x1        # set flag to 1
        addi   x31,x31,1     # increments interrupt counter by 1
 
        li     x9,0x80         # set bit7 in x9 
        csrrc  x0,mstatus,x9   # clear bit7 (MPIE) in CSR[mstatus]          
 
done:   mret                   # return from interrupt 
#---------------------------------------------------------------------------------