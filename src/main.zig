const std = @import("std");

// basic operation
fn rightrotate(x: u32, n: u8) u32 {
    return x << 32 - n | x >> n;
}

// the four sigma functions
fn s0(x: u32) u32 {
    return rightrotate(x, 7) ^ rightrotate(x, 18) ^ x >> 3;
}

fn s1(x: u32) u32 {
    return rightrotate(x, 17) ^ rightrotate(x, 19) ^ x >> 10;
}

fn S0(x: u32) u32 {
    return rightrotate(x, 2) ^ rightrotate(x, 13) ^ rightrotate(x, 22);
}

fn S1(x: u32) u32 {
    return rightrotate(x, 6) ^ rightrotate(x, 11) ^ rightrotate(x, 25);
}

// choice and majority functions
// choice is when the first arg decides whether to take bit from second or third
// choice can be further optimized to only 3 operations (currently is 4)
fn ch(x: u32, y: u32, z: u32) u32 {
    return (x & y) | (~x & z);
}

// majority is when we choose the bit that is most common for each index
fn maj(x: u32, y: u32, z: u32) u32 {
    return (x & (y | z)) | (y & z);
}

// constants - first 32 bits of the fractional parts of the cube roots of each of the first 64 primes

const K: [64]u32 = init: {
    // EvalBranchQuota went from 9400 to 2700 after optimizing with @sqrt
    @setEvalBranchQuota(2700);
    var array: [64]u32 = undefined;
    var n: usize = 2;
    var test_idx: usize = undefined;
    for (array) |*pt, idx| {
        while (true) : (n += 1) {
            test_idx = 0;
            while (test_idx < idx and array[test_idx] <= @sqrt(@as(f32, n))) : (test_idx += 1) {
                if (n % array[test_idx] == 0) {
                    break;
                }
            } else {
                pt.* = n;
                n += 1;
                break;
            }
        }
    }

    // std.math.pow is expensive
    @setEvalBranchQuota(10000);
    for (array) |*pt| {
        pt.* = @floatToInt(u32, std.math.pow(f64, pt.*, 1 / 3.0) % 1 * (1 << 32));
    }
    break :init array;
};
            

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
    std.debug.print("K: {x}\n", .{K});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
