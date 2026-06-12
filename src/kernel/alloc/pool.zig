// Maintain a free list containing 4KB pages to implement a Pool Allocator
// Start at the very top of the SRAM at 0x3FC8_0000
//
// Continue creating 64 pools from 0 to 256KB from 0x3FC8_0000

const CHUNK_SIZE = 1024 * 4;
const POOL_NUM = 64;

const Pool = struct {
    next_pool: *?Pool,
};

pub fn init(memory_space: *anyopaque) *Pool {

    // Map the address 0x3FC8_0000 to the a Pool struct, which stores the address
    // to the next pool
    var self: *Pool = memory_space;
    self.next_pool = null;

    // For every consecutive address, assign those address to the pool and form a
    // linked list
    var node: *Pool = self;
    for (0..POOL_NUM) |i| {
        const new_pool: *Pool = @ptrFromInt(memory_space + CHUNK_SIZE * i);
        node.next_pool = new_pool;
        node = new_pool;
    }
}
