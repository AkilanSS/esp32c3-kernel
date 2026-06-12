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
    kernel_stack_addr: u32,
    process_size: u32,
    name: []u8,
};

var process_table = [64]Process;
