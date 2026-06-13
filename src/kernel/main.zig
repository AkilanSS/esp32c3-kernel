const Error = @import("error_handler/errors.zig");
const uart = @import("drivers/uart.zig");
const proc = @import("proc/proc.zig");
const PageAllocator = @import("alloc/pool.zig");

// This is the start of the kernel.
export fn kmain() void {

    // Initialize UART
    uart.init();
    uart.print("~~Hewwo from Machine Mode :3 ~~\n");

    // Initialize Pages
    var page_allocator: PageAllocator = .{ .head = null };
    page_allocator.init(@ptrFromInt(0x3FC8_0000));

    // Initialize Process Table
    proc.init();
}
