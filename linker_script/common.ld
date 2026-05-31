ENTRY(_start)

SECTIONS
{
    /*
    The following commands describe the layout of instructions in the FLASH
    */
    .header : AT(0)
    {
        _irom_start = .;
        LONG(0xaedb041d) /*Magic Number descirbed at https://github.com/espressif/esp32c3-direct-boot-example/blob/main/README.md*/
        LONG(0xaedb041d)
    } > irom
    .text.entry ORIGIN(.irom) + 8
    {
        _text_entry_start = .;
    }
    .text :
    {
        *(.text)
        *(text.*)https://github.com/espressif/esp32c3-direct-boot-example/blob/main/ld/esp32c3/common.ld
    }
    . = ALIGN(4);
    _irom_size = . - _irom_start;
    _etext = .;
    PROVIDE(_etext - .);


    /*
    The following section described readonly data in the FLASH
    */
    _drom_start = ORIGIN(drom) + _irom_size;
    .rodata _drom_start : AT(_irom_size)
    {
        *(.rodata)
        *(.rodata.*)
        *(.srodata)
        *(.srodata.*)
    } > drom
    _drom_size = . - _drom_start;


    /*
    The following commamnds describe the .data, .sdata, .bss, .heap and .stack sections in the SRAM
    */
    .data ORIGIN(.dram) : AT(_irom_size + _drom_size)
    {
        _data_start = .;
        __DATA_BEGIN__ = .;
        *(.data)
        *(.data.*)
    } > dram
    .data1 :
    {
        *(.data1)
    } 
    .sdata :
    {
        __SDATA_BEGIN__ = .;
        *(.sdata)
    }
    . = ALIGN(4);
    _edata = .;
    PROVIDE(_edata = .);
    _data_lma = ORGIN(drom) + LOADADDR(.data);
    _data_size = _edata - _data_start;

    _bss_start = .;
    .sbss
    {
        *(.sbss)
        *(.sbss.*)
        *(.scommon)
    }
    .bss
    {
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
    . = ALIGN(4);
    __BSS_END__ = .;
    __global_pointer$ = MIN(__SDATA_BEGIN__ + 0x800, MAX(__DATA_BEGIN__ + 0x800, __BSS_END__ - 0x800));
    _end = .;
    PROVIDE(end = .);

    /*
    The following sets up stack and heap
    */
    .stack :
    {
        __stack_bottom = .;
        __stack_top = ORIGIN(ram) + LENGTH(ram);
        __stack_size_min = 0x4000;

        ASSERT(__stack_bottom + __stack_size_min < __stack_top, "Error: no space for stack")
    }

}