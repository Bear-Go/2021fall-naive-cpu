module controlUnit(
    input [4:0] op,
    input [2:0] func3,
    input func7,
    input zero,
    input res0,
    output reg regwr,
    output reg [3:0] aluctr,
    output reg [1:0] alubsrc,
    output reg [2:0] extop,
    output reg aluasrc,
    output reg nxtbsrc,
    output reg [2:0] memop
);

    always @ (*) begin
        case (func3) 
            3'b000: memop = 3'b000;
            3'b001: memop = 3'b001;
            3'b010: memop = 3'b010;
            3'b100: memop = 3'b100;
            3'b101: memop = 3'b101;
            default: memop = 3'b111;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b01101: aluctr = 4'b1111;
            5'b00101: aluctr = 4'b0000;
            5'b00100: begin 
                case (func3)
                    3'b000: aluctr = 4'b0000;
                    3'b010: aluctr = 4'b0010;
                    3'b011: aluctr = 4'b0011;
                    3'b100: aluctr = 4'b0100;
                    3'b110: aluctr = 4'b0110;
                    3'b111: aluctr = 4'b0111;
                    3'b001: aluctr = 4'b0001;
                    3'b101: aluctr = (func7 == 1) ? 4'b1101 : 4'b0101;
                    default: aluctr = 4'b1111;
                endcase
            end
            5'b01100: begin 
                case (func3)
                    3'b000: aluctr = (func7 == 1) ? 4'b1000 : 4'b0000;
                    3'b010: aluctr = 4'b0010;
                    3'b011: aluctr = 4'b0011;
                    3'b100: aluctr = 4'b0100;
                    3'b110: aluctr = 4'b0110;
                    3'b111: aluctr = 4'b0111;
                    3'b001: aluctr = 4'b0001;
                    3'b101: aluctr = (func7 == 1) ? 4'b1101 : 4'b0101;
                    default: aluctr = 4'b1111;
                endcase
            end
            5'b11011: aluctr = 4'b0000;
            5'b11001: aluctr = 4'b0000;
            5'b11000: begin
                case (func3)
                    3'b000: aluctr = 4'b0010;
                    3'b001: aluctr = 4'b0010;
                    3'b100: aluctr = 4'b0010;
                    3'b101: aluctr = 4'b0010;
                    3'b110: aluctr = 4'b0011;
                    3'b111: aluctr = 4'b0011;
                    default: aluctr = 4'b1111;
                endcase
            end
            5'b00000: aluctr = 4'b0000;
            5'b01000: aluctr = 4'b0000;
            default: aluctr = 4'b1111;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b01101: alubsrc = 1;
            5'b00101: alubsrc = 1;
            5'b00100: alubsrc = 1;
            5'b01100: alubsrc = 0;
            5'b11011: alubsrc = 2;
            5'b11001: alubsrc = 2;
            5'b11000: alubsrc = 0;
            5'b00000: alubsrc = 1;
            5'b01000: alubsrc = 1;
            default: alubsrc = 3;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b01101: extop = 3'b001;
            5'b00101: extop = 3'b001;
            5'b00100: extop = 3'b000;
            5'b01100: extop = 3'b000;
            5'b11011: extop = 3'b100;
            5'b11001: extop = 3'b000;
            5'b11000: extop = 3'b011;
            5'b00000: extop = 3'b000;
            5'b01000: extop = 3'b010;
            default: extop = 3;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b11000: regwr = 0;
            5'b01000: regwr = 0;
            default: regwr = 1;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b00101: aluasrc = 1;
            5'b11011: aluasrc = 1;
            5'b11001: aluasrc = 1;
            default: aluasrc = 0;
        endcase
    end

    always @ (*) begin
        case (op) 
            5'b11011: nxtbsrc = 1;
            5'b11001: nxtbsrc = 1;
            5'b11000: begin
                case (func3)
                    3'b000: nxtbsrc = zero;
                    3'b001: nxtbsrc = !zero;
                    3'b100: nxtbsrc = res0;
                    3'b101: nxtbsrc = zero | (!res0);
                    3'b110: nxtbsrc = res0;
                    3'b111: nxtbsrc = zero | (!res0);
                    default: nxtbsrc = 1;
                endcase
            end
            default: nxtbsrc = 0;
        endcase
    end

endmodule