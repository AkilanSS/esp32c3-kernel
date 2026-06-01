.section .text.entry
.type _start, @function
.balign 4
.global _start

_start:
    li a0, 1
    li a1, 1 # a1 = 1
    
    add t0, a0, a1 # t0 = a0 + a1
    
    .loop:
        j .loop  # jump to loop