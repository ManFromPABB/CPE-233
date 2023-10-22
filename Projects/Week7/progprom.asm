.data
sseg: .byte 0x03,0x9F,0x25,0x0D,0x99,0x49,0x41,0x1F,0x01,0x09 # LUT for 7-segs
.text
init: li x20,0x11008004 # button input port addr
li x21,0x1100C004 # seg output port addr
li x22,0x1100C008 # an output port addr
la x5, sseg # constant upper value
li x30, 7 # anode pattern when on
li x31, 15 # anode pattern when off
li x10, 0 # value of the segs
li x9, 9 # constant upper value
loop: add x15, x5, x10 # find address to search in LUT
lb x14, 0(x15) # load byte from LUT
sb x14, 0(x21) # store byte to segs
sw x30, 0(x22) # activates an
lw x25, 0(x20) # loads button IO
bnez x25, pick # checks if button pressed
sw x31, 0(x22) # deactivates an
j loop
unpress: add x15, x5, x10 # find address to search in LUT
lb x14, 0(x15) # load byte from LUT
sb x14, 0(x21) # store byte to segs
sw x30, 0(x22) # activates an
lw x25, 0(x20) # loads button IO
beqz x25, loop # checks if button unpressed
sw x31, 0(x22) # deactivates an
j unpress
pick: beq x10, x0, LtoH # decides whether to change value from low->high or high->low
j HtoL
HtoL: beq x10, x0, unpress # checks if done
sw x30, 0(x22) # activates an
addi x10, x10, -1 # decrements value
add x15, x5, x10 # finds new address for LUT
lb x14, 0(x15) # get new value
sb x14, 0(x21) # reassigns seg to new byte
j HtoL
LtoH: beq x10, x9, unpress # checks if done
sw x30, 0(x22) # activates an
addi x10, x10, 1 # increments value
add x15, x5, x10 # finds new address for LUT
lb x14, 0(x15) # get new value
sb x14, 0(x21) # reassigns seg
j LtoH