MEMORY{
    irom (rx) : ORIGIN = 0x42000000, LENGTH = 4M
    drom (rx) : ORIGIN = 0x3C000000, LENGTH = 4M
    iram (rwx) : ORIGIN = 0x4037C000, LENGTH = 400K
    dram (rwx) : ORIGIN = 0x3FC80000, LENGTH = 384K
    rtc_ram (rwx) : ORIGIN = 0x50000000, LENGTH = 8K
}