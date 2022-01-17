
module rv32is(
	input 	clock,
	input 	reset,
	output reg [31:0] imemaddr,
	input  [31:0] imemdataout,
	output reg imemclk,
	output reg [31:0] dmemaddr,
	input  [31:0] dmemdataout,
	output reg [31:0] dmemdatain,
	output reg dmemrdclk,
	output reg dmemwrclk,
	output reg [2:0] dmemop,
	output reg dmemwe,
	output reg [31:0] dbg_pc,
	output reg done,
	output reg wb,
	output [31:0] dbgregs_0,
	output [31:0] dbgregs_1,
	output [31:0] dbgregs_2,	
	output [31:0] dbgregs_3,
	output [31:0] dbgregs_4,
	output [31:0] dbgregs_5,
	output [31:0] dbgregs_6,	
	output [31:0] dbgregs_7,
	output [31:0] dbgregs_8,
	output [31:0] dbgregs_9,
	output [31:0] dbgregs_10,	
	output [31:0] dbgregs_11,
	output [31:0] dbgregs_12,
	output [31:0] dbgregs_13,
	output [31:0] dbgregs_14,	
	output [31:0] dbgregs_15,
	output [31:0] dbgregs_16,
	output [31:0] dbgregs_17,	
	output [31:0] dbgregs_18,
	output [31:0] dbgregs_19,
	output [31:0] dbgregs_20,
	output [31:0] dbgregs_21,	
	output [31:0] dbgregs_22,
	output [31:0] dbgregs_23,
	output [31:0] dbgregs_24,
	output [31:0] dbgregs_25,	
	output [31:0] dbgregs_26,
	output [31:0] dbgregs_27,
	output [31:0] dbgregs_28,
	output [31:0] dbgregs_29,	
	output [31:0] dbgregs_30,
	output [31:0] dbgregs_31
);//add your code here
	
	wire [31:0] busa;
	wire [31:0] busb;
	
	wire zero;
	wire [31:0] res;

	reg rfclk;

	wire [3:0] aluctr;
	wire regwr;
	wire aluasrc;
	wire [1:0] alubsrc;
	wire [2:0] extop;
	wire nxtbsrc;
	wire [2:0] memop;
	controlUnit cu_inst(
		.op(imemdataout[6:2]),
		.func3(imemdataout[14:12]),
		.func7(imemdataout[30]),
		.zero(zero),
		.res0(res[0]),
		.regwr(regwr),
		.aluctr(aluctr),
		.alubsrc(alubsrc),
		.extop(extop),
		.aluasrc(aluasrc),
		.nxtbsrc(nxtbsrc),
		.memop(memop)
	);

	regfile rf_inst(
		.busw(imemdataout[6:2]==5'b00000 ? dmemdataout : res),
		.regwr(regwr),
		.clk(rfclk),
		.rd(imemdataout[11:7]),
		.rs1(imemdataout[19:15]),
		.rs2(imemdataout[24:20]),
		.busa(busa),
		.busb(busb),
		.dbgregs_0(dbgregs_0), 
		.dbgregs_1(dbgregs_1),
		.dbgregs_2(dbgregs_2),	
		.dbgregs_3(dbgregs_3),
		.dbgregs_4(dbgregs_4),
		.dbgregs_5(dbgregs_5),
		.dbgregs_6(dbgregs_6),	
		.dbgregs_7(dbgregs_7),
		.dbgregs_8(dbgregs_8),
		.dbgregs_9(dbgregs_9),
		.dbgregs_10(dbgregs_10),	
		.dbgregs_11(dbgregs_11),
		.dbgregs_12(dbgregs_12),
		.dbgregs_13(dbgregs_13),
		.dbgregs_14(dbgregs_14),	
		.dbgregs_15(dbgregs_15),
		.dbgregs_16(dbgregs_16),
		.dbgregs_17(dbgregs_17),	
		.dbgregs_18(dbgregs_18),
		.dbgregs_19(dbgregs_19),
		.dbgregs_20(dbgregs_20),
		.dbgregs_21(dbgregs_21),	
		.dbgregs_22(dbgregs_22),
		.dbgregs_23(dbgregs_23),
		.dbgregs_24(dbgregs_24),
		.dbgregs_25(dbgregs_25),	
		.dbgregs_26(dbgregs_26),
		.dbgregs_27(dbgregs_27),
		.dbgregs_28(dbgregs_28),
		.dbgregs_29(dbgregs_29),	
		.dbgregs_30(dbgregs_30),
		.dbgregs_31(dbgregs_31)
	);

	wire [31:0] imm;

	instr2imm ii_inst(
		.instr(imemdataout),
		.extop(extop),
		.imm(imm)
	);


	reg [2:0] st;
	reg [31:0] pc;
	reg [31:0] npc;

	alu alu_inst(
		.a(aluasrc==0 ? busa : pc),
		.b(
			(alubsrc==0) ? busb :
			(alubsrc==1) ? imm : 
			(alubsrc==2) ? 4 : 0), 
		.aluctr(aluctr),
		.zero(zero),
		.res(res)
	);

	parameter PC = 3'd0;
	parameter IM = 3'd1;
	parameter DM = 3'd2;
	parameter RF = 3'd3;
	parameter TRAP = 3'd4;


	always @ (Sclock) begin
		if (reset == 1) begin
			//$display("reset");
			pc <= 32'h80000000;
			imemaddr <= 32'h80000000;
			wb <= 0;
			done <= 0;
			imemclk <= 1;	
			st <= IM;
		end
		else begin
			case (st)
				PC: begin
					//$display("PC");
					wb <= 0;
					done <= 0;
					imemaddr <= pc;
					imemclk <= 1;	
					st <= IM;
				end

				IM: begin
					imemclk <= 0;
					//$display("IM");
					//$display("pc = 0x%08x", pc);
					//$display("instr = 0x%08x", imemdataout);
					//$display("memop = %d", memop);
					if (imemdataout == 32'hdead10cc) begin
						done <= 1;
						st <= TRAP;
					end
					else begin
						done <= 0;
						wb <= 0;
						st <= DM;
					end
					rfclk <= 0;
					dmemrdclk <= 1;
					dmemaddr <= res;
					dmemdatain <= busb;
					dmemop <= memop;
					dmemwe <= (imemdataout[6:2]==5'b01000) ? 1 : 0;
				end

				DM: begin

					dmemwrclk <= 1;
					dmemrdclk <= 0;
					//$display("DM");
					//$display("aluctr = %d", aluctr);
					//$display("regwr = %d", regwr);
					//$display("func3 = %d", imemdataout[14:12]);
					//$display("rs1 = %d", imemdataout[19:15]);
					//$display("rs2 = %d", imemdataout[24:20]);
					//$display("rd = %d", imemdataout[11:7]);
					//$display("imm = 0x%08x", imm);
					//$display("aluasrc = %d", aluasrc);
					//$display("alubsrc = %d", alubsrc);
					//$display("busa = 0x%08x", busa);
					//$display("busb = 0x%08x", busb);
					//$display("zero = %d", zero);
					//$display("res = 0x%08x", res);
					//$display("extop = %d", extop);
					//$display("nxtbsrc = %d", nxtbsrc);
					//$display("nxtasrc = %d", imemdataout[6:2]==5'b11001);
					st <= RF;

					dbg_pc <= pc;
					npc <= (imemdataout[6:2]==5'b11001 ? busa : pc) + (nxtbsrc==1 ? imm : 4);

					rfclk <= 1;
				end

				RF: begin
					dmemwrclk <= 0;
					//$display("RF");
					done <= 0;
					wb <= 1;
					st <= PC;
					pc <= npc;
					//$display("");
				end

				TRAP: begin
					st <= TRAP;
				end

				default: begin
					st <= TRAP;
				end
			endcase
		end
	end

endmodule