ENTRY(_start)

INCLUDE "linker_script/memory.ld"

SECTIONS
{
    /*
    The following commands describe the layout of instructions and readonly data in the FLASH
    */
    .header ORIGIN(irom) : AT(0)
    {
        _irom_start = .;
        LONG(0xaedb041d); /*Magic Number descirbed at https://github.com/espressif/esp32c3-direct-boot-example/blob/main/README.md */
        LONG(0xaedb041d);
    }
    
    .text.entry ORIGIN(irom) + 8 :
    {
        *(.text.entry)
    }
    .text :
    {
        *(.text)
        *(.text.*)
    }

    . = ALIGN(8);
    _irom_size = . - _irom_start;
    _drom_start = ORIGIN(drom) + _irom_size;
    .rodata _drom_start : AT(_irom_size)
    {
        
        *(.rodata)
        *(.rodata.*)
        *(.srodata)
        *(.srodata.*)
        *(.eh_frame_hdr)
        *(.eh_frame)
    }
    _drom_size = . - _drom_start;
    . = ALIGN(4);
    /* 
    The following commands describe the layout of SRAM 
    */
    .data ORIGIN(dram) :
    {
        *(.data)
        *(.data.*)
    }

    .data1 :
    {
        *(.data1)
    }

    .sdata :
    {
        *(.sdata)
    }

    .sbss :
    {
        *(.sbss)
        *(.sbss.*)
        *(.scommon)
    }
    .bss :
    {
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }

    /*
    Initialize the kernel stack pointer at the end of the SRAM. At 0x3FCDFFFF.
    */
    __stack_pointer = ORIGIN(dram) + LENGTH(dram); 
} 
