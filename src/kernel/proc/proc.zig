// To make my life easier, we only allow an arbitrary number of process
// to exist. The count should not be greater than 16. The entire SRAM can
// fit 96 4K pages, and 64 pages were allocated for user pages (with kalloc).
//
// From the remaining 32 pages, PROCESS_COUNT + 1 pages will be allocated
// for the induvidual kernel stacks. Hence a limitation of 16.
const PROCESS_COUNT = 8;

// Let us assign 4K size memory regions for kernel stacks
// for each processes
//
// This will be assigned in the below fashion
//
//    --- SRAM ---
// +----------------+
// |                |
// |                |
// |                |
// |                |
// | 0x3FCC_8FFF    |   <- kstack2 (The kernel stack (pointer) for the 0th process
// +----------------+   4K
// | 0x3FCC_FFFF    |   <- kstack1 (The kernel stack (pointer) for the 0th process
// +----------------+   4K
// | 0x3FCD_8FFF    |   <- kstack0 (The kernel stack (pointer) for the 0th process
// +----------------+   4K
// | 0x3FCD_FFFF    |   <- sp (The stack pointer for the kernel)
// +----------------+

const sp_addr: *volatile anyopaque = @ptrFromInt(0x3FCD_FFFF);

const ProcessState = enum {
    unused,
    used,
    sleeping,
    runnable,
    running,
    zombie,
};

const Process = struct {
    pid: u8,
    process_state: ProcessState,
    parent_process: *Process,
    kernel_stack_addr: *anyopaque,
    process_size: u32,
    name: []u8,
};

var process_table: [PROCESS_COUNT]Process = undefined;

pub fn init() void {
    // for (process_table, 1..) |proc, i| {
    //     proc.process_state = .unused;
    //     proc.kernel_stack_addr = @ptrFromInt(@intFromPtr(sp_addr) - 4096 * i);
    // }

    for (0..PROCESS_COUNT) |i| {
        process_table[i].process_state = .unused;
        process_table[i].kernel_stack_addr = @ptrFromInt(@intFromPtr(sp_addr) - 4096 * (i + 1));
    }
}
