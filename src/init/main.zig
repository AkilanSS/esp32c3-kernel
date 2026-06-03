const std = @import("std");

export fn kmain() void {
    // var arr: [4]f32 = undefined;
    // for (0..arr.len) |i| {
    //     arr[i] = 2 * @as(f32, @floatFromInt(i));
    // }

    const PeakStruct = struct {
        peak: i8,
        bocchi: i8,
    };

    const peak_peak = PeakStruct{
        .bocchi = 10,
        .peak = 10,
    };

    // std.mem.doNotOptimizeAway(&arr);
    std.mem.doNotOptimizeAway(&peak_peak);
}
