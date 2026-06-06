const std = @import("std");

pub fn build(b: *std.Build) void {
    const target_riscv = std.Target.riscv;

    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .riscv32,
            .os_tag = .freestanding,
            .abi = .ilp32,
            .cpu_model = .{
                .explicit = &target_riscv.cpu.generic_rv32,
            },
            .cpu_features_add = target_riscv.featureSet(&.{
                .m,
                .c,
            }),
        },
    });

    const optimize = std.builtin.OptimizeMode.ReleaseSmall;

    const mod = b.addModule("learning_bootloader_linker_frees", .{
        .root_source_file = b.path("src/kernel/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    mod.addAssemblyFile(b.path("src/kernel/boot.S"));

    const elf = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = mod,
    });

    elf.setLinkerScript(b.path("linker_script/common.ld"));
    b.installArtifact(elf);

    //Here we setup generating the flash
    const build_empty_flash = b.addSystemCommand(&.{"dd"});
    build_empty_flash.addArgs(&.{
        "if=/dev/zero",
        "of=zig-out/bin/flash.bin",
        "bs=1M",
        "count=4",
    });

    const generate_bin_from_elf = b.addSystemCommand(&.{"riscv32-esp-elf-objcopy"});
    generate_bin_from_elf.addArgs(&.{
        "-O",
        "binary",
        "zig-out/bin/kernel.elf",
        "zig-out/bin/kernel.bin",
    });

    const build_bin = b.addSystemCommand(&.{"dd"});
    build_bin.addArgs(&.{
        "if=zig-out/bin/kernel.bin",
        "of=zig-out/bin/flash.bin",
        "conv=notrunc",
    });

    build_bin.step.dependOn(&generate_bin_from_elf.step);

    const generate_flash = b.step("bin", "Generates the binary to flash");
    generate_flash.dependOn(&build_empty_flash.step);
    generate_flash.dependOn(&generate_bin_from_elf.step);
    generate_flash.dependOn(&build_bin.step);

    //Run on qemu
    const run_qemu = b.addSystemCommand(&.{"qemu-system-riscv32"});
    run_qemu.addArgs(&.{
        "-nographic",
        "-machine",
        "esp32c3",
        "-drive",
        "file=zig-out/bin/flash.bin,if=mtd,format=raw",
    });
    const qemu = b.step("qemu", "Load the binary and run QEMU");
    qemu.dependOn(&run_qemu.step);

    const run_qemu_debug = b.addSystemCommand(&.{"qemu-system-riscv32"});
    run_qemu_debug.addArgs(&.{
        "-nographic",
        "-machine",
        "esp32c3",
        "-drive file=zig-out/bin/flash.bin,if=mtd,fornat-raw",
        "-s",
        "-S",
    });
    const qemu_debug = b.step("qemu-debug", "Load the binary and run QEMU in debug mode at 1234");
    qemu_debug.dependOn(&run_qemu_debug.step);
}
