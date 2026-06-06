.section .text.entry
.type _start, @function
.balign 4
.global _start

_start:
    li sp, 0x3FCDFFFF

    /*
        ESP32C3 implements only User Mode (U) and Machine Mode(M). This means that we have to run our kernel
        in Machine Mode to set up memory protection for userland processes. This also means that there is no
        intermediate initialization of control and status register (CSR). Hence we do not have a start.c unlike
        the xv6-riscv implementation.

        The `mepc` and `mret` registers are not required to be configured until we switch to userland.
    */

    j kmain 