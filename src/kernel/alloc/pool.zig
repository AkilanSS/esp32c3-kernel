const Self = @This();

// Maintain a free list containing 4KB pages to implement a Pool Allocator
// Start at the very top of the SRAM at 0x3FC8_0000
// Continue creating 64 pools from 0 to 256KB from 0x3FC8_0000

const CHUNK_SIZE = 1024 * 4;
const POOL_COUNT = 64;

const Pool = struct {
    next_pool: ?*Pool,
};

head: ?*Pool, // points to first free page

// Initializes the SRAM which can be allocated to the kernel
pub fn init(self: *Self, memory_space: *anyopaque) *Pool {

    // Map the address 0x3FC8_0000 to the a Pool struct, which stores the address
    // to the next pool
    self.head = memory_space;
    self.head.next_pool = null;

    // For every consecutive address, assign those address to the pool and form a
    // linked list
    var node: *Pool = self.head;
    for (1..POOL_COUNT) |i| {
        const new_pool: *Pool = @ptrFromInt(@intFromPtr(memory_space) + CHUNK_SIZE * i);
        node.next_pool = new_pool;
        node = new_pool;
    }
}

// Allocates a page of size 4KB by returning a pointer to it
pub fn alloc(self: *Self) *anyopaque {
    const node: *Pool = self.head orelse 0;
    self.head.* = self.head.next_pool;
    return node;
}

// Frees a page
pub fn free(self: *Self, page: *anyopaque) noreturn {
    const page_to_free: *Pool = page;
    page_to_free.next_pool = self.head;
    self.head = page_to_free;
}
