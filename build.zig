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

    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("learning_bootloader_linker_frees", .{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });

    mod.addAssemblyFile(b.path("src/asm/startup.S"));

    const elf = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = mod,
    });

    elf.setLinkerScript(b.path("linker/linker.ld"));
    b.installArtifact(elf);
}
