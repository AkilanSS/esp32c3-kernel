# Plans for getting things up
Alr, so after reading some repos, i understood that to get things started, I should probably start with writing routines in assembly to blink an LED or smth. This time instead of disabling the watchdog timer (WDT), I'll feed to it occassionally. 

## Stuff to do
1. Write procedures for initializing and sending out a signal to a pin
2. Include the procedure in the _entry method inside an infinite loop.
3. Feed the watchdog timer.

## Now how the heck do i do all of these??

### Setting up GPIO (TRM - Pg164)
1. To output perripheral signal Y to particular GPIO pin X:
    -  Configure register `GPIO_FUNCx_OUT_SEL_CFG_REG` and `GPIO_ENABLE_REG[x]`. (Recommended to use `W1TC` or `W1TS` to clear or set `GPIO_ENABLE_REG`)
        - Set the `GPIO_FUNCx_OUT_SEL` field in register `GPIO_FUNCx_OUT_SEL_CFG_REG` to the index of the desired peripheral output signal Y
        - If the signal should always be enabled as output, set the `GPIO_FUNCx_OEN_SEL` bit in register `GPIO_FUNCx_OUT_SEL_CFG_REG`, and the bit in register `GPIO_ENABLE_W1TS_REG`. Clear the `GPIO_FUNCx_OEN_SEL` to 0 otherwise (if you need to control with some logic)
        - Set corresponding bit in `GPIO_ENABLE_W1TC_REG` to disable the output from GPIO pin.
    - For an open drain output, set the `GPIO_PINx_PAD_DRIVER` bit in regsiter `GPIO_PINx_REG` corresponding to GPIO pin X.
    - Configure IO MUX register to enable output via GPIO matrix. Set `IO_MUX_GPIOx_REG`corresponding to pin x as following:
        - Set the field `IO_MUX_GPIOx_MCU_SEL` to desired IO MUX function corresponding to GPIO pinX. (Function 1 -> GPIO for all pins)
        - Set the `IO_MUX_GPIOx_FUN_DRV` field for desired current strength
        - If using open drain mode, set/clear `IO_MUX_GPIOx_FUN_WPU` and `IO_MUX_GPIOx_FUN_WPD` bits to enable or disable the pull up/down resistors.

2. A simpler control would be:
    - Set GPIO matrix `GPIO_FUNCn_OUT_SEL` with a special peripheral inde 128 (0x80)
    - Set the corresponding bit in `GPIO_OUT_REG` register to the desired GPIO output value.s
