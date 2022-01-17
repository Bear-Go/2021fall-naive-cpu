module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluctr,
    output reg zero,
    output reg [31:0] res
);

    always @ (*) begin
        case (aluctr) 
            4'b0000: res = a + b;
            4'b0001: res = a << b[4:0];
            4'b0010: res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'b0011: res = (a < b) ? 32'd1 : 32'd0;
            4'b0100: res = a ^ b;
            4'b0101: res = a >> b[4:0];
            4'b0110: res = a | b;
            4'b0111: res = a & b;
            4'b1000: res = a - b;
            4'b1101: res = $signed(a) >>> b[4:0];
            4'b1111: res = b;
            default: res = 32'hffffffff;
        endcase
        if (a == b) zero = 1; else zero = 0;
    end

endmodule