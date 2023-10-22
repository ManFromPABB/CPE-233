.data 
sseg:    .byte  0x03,0x9F,0x25,0x0D,0x99,0x49,0x41,0x1F,0x01,0x09 # LUT for 7-segs

.text 
main:  
init:   li     x15,0x1100C004  # seg port
        li     x16,0x1100C008  # an port
        li     x17,7           # ones anode display code
        li     x18,11          # tens anode display code
        li     x19,15          # blank anode display code
        li     x29,3           # used to check if count should be reversed
        li     x22,9           # used to check if regrouping is needed
        mv     x31,x0          # count tens place
        mv     x30,x0	       # count ones place
        mv     x11,x0          # interrupt status flag for display
        mv     x20,x0          # count direction flag
        la     x5,sseg         # LUT address
        la     x12,ISR         # load address of ISR into x12
        csrrw  x0,mtvec,x12    # store address as interrupt vector CSR[mtvec]
         
unmask: li     x10,0x8         # set bit[3] value in x10 
        csrrs  x0,mstatus,x10  # enable interrupts: set MIE in CSR[mstatus] 
 
loop:   sw     x19,0(x16)      # clear anodes
	add    x8,x5,x30       # find absolute address of sseg data
        lb     x8,0(x8)        # load sseg data
        sb     x8,0(x15)       # display sseg
        sw     x17,0(x16)      # enable anodes for ones
        call   delay           # run delay to brighten display
        sw     x19,0(x16)      # clear anodes
        add    x8,x5,x31       # find absolute address of sseg data
        lb     x8,0(x8)        # load sseg data
        sb     x8,0(x15)       # display sseg
        sw     x18,0(x16)      # enable anodes for tens
        call   delay           # run delay to brighten display
        li     x10,0x8         # set bit[3] value in x10 
        csrrs  x0,mstatus,x10  # enable interrupts: set MIE in CSR[mstatus]
        j loop                 # wait for interrupt
        
delay:      li    x23,0xFF       # load count 
dloop:      beq   x23,x0,exit    # leave if done 
            addi  x23,x23,-1     # decrement count 
            j     dloop          # rinse, repeat 
exit:       ret

#--------------------------------------------------------------------------------- 
 
#--------------------------------------------------------------------------------- 
#- ISR 
#---------------------------------------------------------------------------------     
ISR:        beq    x31,x29,highedge # if interrupts is 30, reverse direction of count
        
            or     x7,x30,x31       # ors to see if bcd count is zero
            beqz   x7,lowedge       # if interrupts is 0, reverse direction of count
            
            beq    x20,x0,cntup     # checks counter direction flag to either count up or down
            j cntdown

highedge: li  x20,1                 # if interrupts is 30, count down instead
          j cntdown

lowedge:  mv  x20,x0                # if interrupts is 0, count up
          j cntup

cntup:    beq    x30,x22,regroupup  # check if decimal value needs regrouping
          addi   x30,x30,1          # add one to ones
          j      done               # return to loop

cntdown:  beq    x30,x0,regroupdown # check if decimal value needs regrouping
          addi   x30,x30,-1         # subtract one from ones
          j      done               # return to loop

regroupup:  mv     x30,x0           # clear ones register
            addi   x31,x31,1        # increase tens register
            j      done             # return to loop

regroupdown: mv     x30,x22         # sets ones register to 9
             addi   x31,x31,-1      # decrease tens register
             j      done            # return to loop                       
 
done:   mret                        # return from interrupt 
#---------------------------------------------------------------------------------
