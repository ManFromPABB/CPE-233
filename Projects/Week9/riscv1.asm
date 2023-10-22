.data 
sseg:    .byte  0x03,0x9F,0x25,0x0D,0x99,0x49,0x41,0x1F,0x01,0x09 # LUT for 7-segs

.text 
main:  
init:   li     x12,0x11008004  # button port
        li     x13,0x1100C004  # seg port
        li     x14,0x1100C008  # an port
        li     x10,0x1100D000   # CSR
        li     x11,0x1100D004   # TC In
        li     x15,7
        li     x16,11
        li     x17,15
        la     x5,sseg
        la     x6,ISR
        li     x29,3           # used to check if count should be reversed
        li     x22,9           # used to check if regrouping is needed
        mv     x20,x0
        csrrw  x0,mtvec,x6    # store address as interrupt vector CSR[mtvec]
        li     x7,0x8FF
        sw     x7,0(x11)
        li     x7,1
        sw     x7,0(x10)
        
unmask: li     x8,0x8
        csrrw  x0,mstatus,x8
        
loop:   csrrw  x0,mstatus,x8
	lb     x18,0(x12)
	bnez   x18,debounce
	j loop

debounce: lb   x18,0(x12)
	call   delay
	lb     x19,0(x12)
	bne    x18,x19,count
	j debounce

delay:      li    x23,0x6FFFF    # load count 
dloop:      beq   x23,x0,exit    # leave if done 
            addi  x23,x23,-1     # decrement count 
            j     dloop          # rinse, repeat 
exit:       ret

count:      beq    x31,x29,highedge # if interrupts is 30, reverse direction of count
        
            or     x28,x30,x31       # ors to see if bcd count is zero
            beqz   x28,lowedge       # if interrupts is 0, reverse direction of count
            
            beq    x20,x0,cntup     # checks counter direction flag to either count up or down
            j cntdown

highedge: li  x20,1                 # if interrupts is 30, count down instead
          j cntdown

lowedge:  mv  x20,x0                # if interrupts is 0, count up
          j cntup

cntup:    beq    x30,x22,regroupup  # check if decimal value needs regrouping
          addi   x30,x30,1          # add one to ones
          j      loop               # return to loop

cntdown:  beq    x30,x0,regroupdown # check if decimal value needs regrouping
          addi   x30,x30,-1         # subtract one from ones
          j      loop               # return to loop

regroupup:  mv     x30,x0           # clear ones register
            addi   x31,x31,1        # increase tens register
            j      loop             # return to loop

regroupdown: mv     x30,x22         # sets ones register to 9
             addi   x31,x31,-1      # decrease tens register
             j      loop            # return to loop
	
			
#--------------------------------------------------------------------------------- 
#- ISR 
#--------------------------------------------------------------------------------- 	

ISR:    beq    x7,x0,tens

ones:   sw     x17,0(x14)
	add    x9,x5,x30
	lb     x9,0(x9)
	sw     x9,0(x13)
	sw     x15,0(x14)
	xori   x7,x7,0x1
	j leave
	
tens:   beq    x31,x0,ones
	sw     x17,0(x14)
	add    x9,x5,x31
	lb     x9,0(x9)
	sw     x9,0(x13)
	sw     x16,0(x14)
	xori   x7,x7,0x1
	
leave:  mret