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
    li t0, 0x60040024   # GPIO_ENABLE_W1TS_REG
    li t1, 1
    sll t1, t1, a0
    lw t2, 0(t0) 
    or t2, t2, t1 # t2 = t2 | t1
    sw t2, 0(t0) # 
    .size gpio_output_enable .-gpio_output_enable


/**
 * @brief sends high to the gpio pin
 * 
 * @param   a0: pin number
 * @retval  None
 */
.global gpio_write
.type gpio_write, %function
gpio_write:
    li t0, 0x60004008  # address of GPIO_OUT_W1TS_REG
    li t1, 1           # set the bit
    sll t1, t1, a0     # moves the 1 to that specific pin bit
