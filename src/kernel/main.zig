// const std = @import("std");
const uart = @import("drivers/uart.zig");

// This is the start of the kernel.
export fn kmain() void {
    uart.uart_init();
    uart.uart_print("Akilan\n");
}
