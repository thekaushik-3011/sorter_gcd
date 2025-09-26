module gcd (
    input clk,
    input rst,           // Added reset input
    input start,
    input [31:0] a, b,   // 32-bit inputs
    output reg [31:0] result,
    output reg done
);

    reg [31:0] x, y;
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            x <= 0;
            y <= 0;
            busy <= 0;
            done <= 0;
            result <= 0;
        end else begin
            if (start && !busy) begin
                // Initialize with input values
                x <= a;
                y <= b;
                busy <= 1;
                done <= 0;
            end else if (busy) begin
                if (y != 0) begin
                    // Euclidean algorithm: subtract the smaller from the larger
                    if (x > y)
                        x <= x - y;
                    else
                        y <= y - x;
                end else begin
                    // GCD found when y becomes 0
                    result <= x;
                    done <= 1;
                    busy <= 0;
                end
            end
        end
    end

endmodule