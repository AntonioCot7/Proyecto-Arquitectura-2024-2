module controller (
  clk,
  reset,
  InstrD,
  ALUFlags,
  RegSrcD,
  RegWriteM,
  RegWriteW,
  ImmSrcD,
  ALUSrcE,
  ALUControlE,
  MemWriteM,
  MemtoRegE,
  MemtoRegW,
  PCSrcW,
  BranchTakenE,
  PCSrcD,
  BranchPredictor,
  PCSrcE,
  PCSrcM,
  FlushE
);

  input wire clk;
  input wire reset;
  input wire [31:0] InstrD;
  input wire [3:0] ALUFlags;
  output wire [1:0] RegSrcD;
  output wire RegWriteW;
  output wire RegWriteM;
  output wire [1:0] ImmSrcD;
  output wire ALUSrcE;
  output wire [1:0] ALUControlE; // Cambiado a 2 bits
  output wire MemWriteM;
  output wire MemtoRegW;
  output wire PCSrcW;
  output wire PCSrcM;
  output wire PCSrcE;
  output wire PCSrcD;
  output wire BranchTakenE;
  output wire BranchPredictor;
  output wire MemtoRegE;
  wire RegWriteD;
  wire MemWriteD;
  wire MemtoRegD;
  wire ALUSrcD;
  wire BranchD;
  wire [1:0] FlagWriteD;
  wire [1:0] ALUControlD;
  wire CondPCSrcE;
  wire RegWriteE;
  wire CondRegWriteE; //dsp de aplicarle cond logic 
  wire MemWriteE;
  wire CondMemWriteE;
  wire BranchE;
  input wire FlushE;
  wire [1:0] FlagWriteE;
  wire [3:0] CondE;
  wire [3:0] FlagsE;
  wire [3:0] FlagsNext;
  wire MemtoRegM;
  assign CondE = InstrD[31:28];

	decode dec (
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.FlagW(FlagWriteD),
		.PCS(PCSrcD),
		.RegW(RegWriteD),
		.MemW(MemWriteD),
		.MemtoReg(MemtoRegD),
		.ALUSrc(ALUSrcD),
		.ALUControl(ALUControlD),
		.ImmSrc(ImmSrcD),
		.RegSrc(RegSrcD),
		.Branch(BranchD)
	);

	//registro entre decode y execute
	  //registro entre decode y execute
  floprCLR #(10) RegDecExec (
    	.clk(clk),
    	.reset(reset),
    	.d({PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD}), // Ajustado a 10 bits
    	.q({PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, BranchE, ALUSrcE, FlagWriteE}), // Ajustado a 10 bits
    	.clr(FlushE)
  	);


	//registro para ALUFlags
	flopr #(4) RegALUFlags (
		.clk(clk), 
		.reset(reset), 
		.d(FlagsNext), 
		.q(FlagsE)
	);

	condlogic cl (
		.clk(clk),
		.reset(reset),
		.Cond(CondE),
		.ALUFlags(ALUFlags),
		.FlagW(FlagWriteE),
		.PCS(PCSrcE),
		.RegW(RegWriteE),
		.MemW(MemWriteE),
		.PCSrc(CondPCSrcE),
		.RegWrite(CondRegWriteE),
		.MemWrite(CondMemWriteE),
		.Branch(BranchE),
		.BranchTakenE(BranchTakenE),
		.FlagsE(FlagsE),
		.BranchPredictor(BranchPredictor),
		.FlagsNext(FlagsNext)
	);

	//registro entre execute y memory
	flopr #(4) RegExecMem(
		.clk(clk), 
		.reset(reset), 
		.d({CondPCSrcE, CondRegWriteE, MemtoRegE, CondMemWriteE}), 
		.q({PCSrcM, RegWriteM, MemtoRegM, MemWriteM})
	);

	//registro entre memory y writeback
  	flopr #(3) RegMemWB (
		.clk(clk), 
		.reset(reset), 
		.d({PCSrcM, RegWriteM, MemtoRegM}), 
		.q({PCSrcW, RegWriteW, MemtoRegW})
	);

endmodule