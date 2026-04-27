.include "inc/register.inc"

.section .text

/**
 * @brief Enables the GPIO pin
 * 
 * @param   a0: pin number
 * @retval  None
 */
.global gpio_output_enable
.type gpio_output_enable, %function
gpio_output_enable:
    li t0, 0x60004554   # Base address of GPIO_FUNC0_OUT_SEL_CFG_REG
    slli t1, a0, 2      # Take the pin number and multiply it by 4
    add t0, t0, t1      # Add this offset to the base address to get GPIO_FUNCn_OUT_SEL
    li t2, 0x80         # To route only GPIO, set the last peripheral field to 0x80
    sw t2, 0(t0)        # Update the register

    li t0, 0x60004024   # GPIO_ENABLE_W1TS_REG
    li t1, 1            # t1 = 1
    sll t1, t1, a0      # 0000_0001_0000 @a0
    sw t1, 0(t0)        # Set to enable
    ret
.size gpio_output_enable, .-gpio_output_enable


/**
 * @brief sends high to the gpio pin
 * 
 * @param   a0: pin number
 * @retval  None
 */
.global gpio_write
.type gpio_write, %function
gpio_write:
    li t0, 0x60004004  # address of GPIO_OUT_W1TS_REG
    li t1, 1           # load to set the bit
    sll t1, t1, a0     # moves the 1 to that specific pin bit
    sw t1, 0(t0)       # set the bit
    ret
.size gpio_write, .-gpio_write



.global _start
.type _start, %function
_start:
    li t0, 0x60000000   # UART0 FIFO Base Address
    li t1, 65           # ASCII value for 'A'

    loop:
        sw t1, 0(t0)    # 'A'

        # li t4, 0x600080a4   # RTC WDT feed
        # li t5, 0x600080a8   # RTC WDT protect
        # li t6, 0x50d83aa1   # unlock key
        # sw t6, 0(t5)        
        # li t6, 0x80000000   
        # sw t6, 0(t4)        
        # sw zero, 0(t5)      #lock key

        j loop              
.size _start, .-_start