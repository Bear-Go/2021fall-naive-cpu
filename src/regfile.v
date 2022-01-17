module regfile(
    input clk,
    input [31:0] busw,
    input [4:0] rd,
    input [4:0] rs1,
    input [4:0] rs2,
    input regwr,
    output reg [31:0] busa,
    output reg [31:0] busb,
    output reg [31:0] dbgregs_0,
	output reg [31:0] dbgregs_1,
	output reg [31:0] dbgregs_2,	
	output reg [31:0] dbgregs_3,
	output reg [31:0] dbgregs_4,
	output reg [31:0] dbgregs_5,
	output reg [31:0] dbgregs_6,	
	output reg [31:0] dbgregs_7,
	output reg [31:0] dbgregs_8,
	output reg [31:0] dbgregs_9,
	output reg [31:0] dbgregs_10,	
	output reg [31:0] dbgregs_11,
	output reg [31:0] dbgregs_12,
	output reg [31:0] dbgregs_13,
	output reg [31:0] dbgregs_14,	
	output reg [31:0] dbgregs_15,
	output reg [31:0] dbgregs_16,
	output reg [31:0] dbgregs_17,	
	output reg [31:0] dbgregs_18,
	output reg [31:0] dbgregs_19,
	output reg [31:0] dbgregs_20,
	output reg [31:0] dbgregs_21,	
	output reg [31:0] dbgregs_22,
	output reg [31:0] dbgregs_23,
	output reg [31:0] dbgregs_24,
	output reg [31:0] dbgregs_25,	
	output reg [31:0] dbgregs_26,
	output reg [31:0] dbgregs_27,
	output reg [31:0] dbgregs_28,
	output reg [31:0] dbgregs_29,	
	output reg [31:0] dbgregs_30,
	output reg [31:0] dbgregs_31
);

    reg [31:0] rf[0:31];

    always @ (posedge clk) begin
        if (regwr) begin
            //$display("busw = 0x%08x", busw);
            rf[rd] = busw;
        end
    end

    always @ (*) begin
        if (rs1 == 0) 
            busa = 0;
        else 
            busa = rf[rs1];

        if (rs2 == 0)
            busb = 0;
        else
            busb = rf[rs2];
    end

    always @ (*) begin
        dbgregs_0 = 0;
        dbgregs_1 = rf[1];
        dbgregs_2 = rf[2];	
        dbgregs_3 = rf[3];
        dbgregs_4 = rf[4];
        dbgregs_5 = rf[5];
        dbgregs_6 = rf[6];	
        dbgregs_7 = rf[7];
        dbgregs_8 = rf[8];
        dbgregs_9 = rf[9];
        dbgregs_10= rf[10];	
        dbgregs_11= rf[11];
        dbgregs_12= rf[12];
        dbgregs_13= rf[13];
        dbgregs_14= rf[14];	
        dbgregs_15= rf[15];
        dbgregs_16= rf[16];
        dbgregs_17= rf[17];	
        dbgregs_18= rf[18];
        dbgregs_19= rf[19];
        dbgregs_20= rf[20];
        dbgregs_21= rf[21];	
        dbgregs_22= rf[22];
        dbgregs_23= rf[23];
        dbgregs_24= rf[24];
        dbgregs_25= rf[25];	
        dbgregs_26= rf[26];
        dbgregs_27= rf[27];
        dbgregs_28= rf[28];
        dbgregs_29= rf[29];	
        dbgregs_30= rf[30];
        dbgregs_31= rf[31];
    end
endmodule