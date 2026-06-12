const UART_BASE_ADDR: u32 = 0x6000_0000;
const SYSTEM_BASE_ADDR: u32 = 0x600C_0000;

pub fn init() void {
    // • (DEF) enable the clock for UART RAM by setting SYSTEM_UART_MEM_CLK_EN to 1;
    // • (DEF) enable APB_CLK for UARTn by setting SYSTEM_UARTn_CLK_EN to 1;
    // • (DEF) clear SYSTEM_UARTn_RST;
    // • write 1 to UART_RST_CORE;
    // • write 1 to SYSTEM_UARTn_RST;
    // • clear SYSTEM_UARTn_RST;
    // • clear UART_RST_CORE;
    // • enable register synchronization by clearing UART_UPDATE_CTRL.

    // System Register Base Address: 0x600C_0000
    // UART Base Address:            0x6000_0000

    const UART_CLK_CONF_REG: *volatile u32 = @ptrFromInt(UART_BASE_ADDR + 0x0078);
    const UART_ID_REG: *volatile u32 = @ptrFromInt(UART_BASE_ADDR + 0x0080);
    const SYSTEM_PERIP_RST_EN0_REG: *volatile u32 = @ptrFromInt(SYSTEM_BASE_ADDR + 0x0018);

    //Write 1 to UART_RST_CORE at 23rd bit
    UART_CLK_CONF_REG.* |= (1 << 23);

    //Write 1 to SYSTEM_UART_RST at 2nd bit
    SYSTEM_PERIP_RST_EN0_REG.* |= (1 << 2);

    //Clear SYSTEM_UART_RST at 2nd bit
    SYSTEM_PERIP_RST_EN0_REG.* &= ~@as(u32, 1 << 2);

    //Clear UART_RST_CORE at 23rd bit
    UART_CLK_CONF_REG.* &= ~@as(u32, 1 << 23);

    //Enable register synchronization by clearing UART_UPDATE_CTRL
    UART_ID_REG.* &= ~@as(u32, 1 << 30);
}

pub fn write(char: u8) void {
    const UART_FIFO_REG: *volatile u32 = @ptrFromInt(UART_BASE_ADDR + 0x0000);
    UART_FIFO_REG.* = char;
}

pub fn print(string: []const u8) void {
    for (string) |char| {
        write(char);
    }
}
