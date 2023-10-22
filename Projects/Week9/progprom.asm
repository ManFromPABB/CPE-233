.text
main:  
init:   li 	x14,0x11008000  # switch port
    	 li 	x15,0x1100C000  # led port
    	 li 	x16,0x6000      # memory pointer
    	 li     x17,0x6003      # end of memory constant
    	 mv 	x20,0       	# set accumulator
    	 la 	x6,ISR      	# load address of ISR into x6
    	 csrrw  x0,mtvec,x6 	# store address as interrupt vector CSR[mtvec]
    	 
unmask: li 	x10,0x8     	# set bit[3] value in x10
    	 csrrs  x0,mstatus,x10  # enable interrupts: set MIE in CSR[mstatus]
 
loop:   lbu 	x21,0(x14)  	# loads switch value while waiting for interrupt
    	 beq	x8,x0,loop  	# wait for interrupt

	 csrrw   x0,mstatus,x0   # disable interrupts temporarily
	 mv 	x8,x0       	# clear flag
	 beq	x16,x17,move_pointer 

store:	 sb     x21,0(x16)
	addi x16,x16,1

average:  mv x20,x0
	li x25,0x6000
     	
loop2:  beq x25,x17,exit
	lb  x28,0(x25)
	add x20,x20,x28
	addi x25,x25,-1
	j loop2
     	
exit:   srli  x20,x20,4
	sw    x20,0(x15)
	j unmask              # return to loop
     	  
move_pointer: li x16,0x6000
	j store


#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
#- The ISR: sets bit x8 to act as flag to task code.  
#---------------------------------------------------------------------------------
ISR:	 li 	x8,0x1    	# set flag to 1	 
 
done:   mret               	# return from interrupt
#---------------------------------------------------------------------------------
