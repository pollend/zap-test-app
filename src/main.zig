const std = @import("std");
const zap = @import("zap");

fn on_upgrade(r: zap.Request, target_protocol: []const u8) !void {
    // make sure we're talking the right protocol
    if (!std.mem.eql(u8, target_protocol, "websocket")) {
        std.log.warn("received illegal protocol: {s}", .{target_protocol});
        r.setStatus(.bad_request);
        r.sendBody("400 - BAD REQUEST") catch unreachable;
        return;
    }
    std.log.info("connection upgrade OK", .{});
}

pub fn on_request(r: zap.Request) !void {
    if(r.path) |path| {
        if(std.mem.eql(u8, path, "/health")) {
            r.setStatus(.ok);
            try r.setHeader("Content-Type", "text/plain");
            if (r.sendBody("OK")) {} else |err| {
                std.log.err("Unable to send body: {any}", .{err});
            }
            return;
        }
    }
    try r.setHeader("Cache-Control", "no-cache");
    if (r.sendFile("dist/index.html")) {} else |err| {
        std.log.err("Unable to send file: {any}", .{err});
    }
}

pub fn main() !void {
    var listener = zap.HttpListener.init(
        .{
            .port = 8080,
            .on_upgrade = on_upgrade,
            .on_request = on_request,
            .max_clients = null,
            .max_body_size = 1 * 1024,
            .public_folder = "dist",
            .log = true,
        },
    );
    try listener.listen();
    std.log.info("", .{});
    std.log.info("Server configuration:", .{});
    std.log.info("Connect with browser to http://localhost:{d}.", .{8080});
    std.log.info("Connect to websocket on ws://localhost:{d}.", .{8080});
    std.log.info("Terminate with CTRL+C", .{});

    zap.start(.{
        .threads = 1,
        .workers = 1,
    });
}
