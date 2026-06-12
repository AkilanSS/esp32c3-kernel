// const std = @import("std");
const uart = @import("drivers/uart.zig");

// This is the start of the kernel.
export fn kmain() void {
    uart.init();
    uart.print("~~Hewwo from Machine Mode :3 ~~\n");

    // Below will now initialize paging the SRAM and initializing processes
}
