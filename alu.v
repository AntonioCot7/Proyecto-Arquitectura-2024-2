module alu (
  //Proceso de Exucute
  SrcA,
  SrcB,
  SrcC,
  ALUControl,
  CarryIn,
  ALUResult,
  ALUFlags
);
  input wire [31:0] SrcA;
  input wire [31:0] SrcB;
  input wire [31:0] SrcC;
  input wire [3:0] ALUControl;
  input wire CarryIn;
  output wire [31:0] ALUResult;
  output wire [3:0] ALUFlags;
  //falta no write

  wire [31:0] sum;
  wire neg, zero, carry, overflow;

  assign ALUResult = 
    (ALUControl == 4'b0000) ? (SrcA + SrcB) :         // ADD
    (ALUControl == 4'b0001) ? (SrcA - SrcB) :         // SUB
    (ALUControl == 4'b0010) ? SrcB :                  // MOV
    (ALUControl == 4'b0011) ? (SrcA & SrcB) :         // AND
    (ALUControl == 4'b0100) ? (SrcA | SrcB) :         // ORR
    (ALUControl == 4'b0101) ? (SrcC - (SrcA * SrcB)) : // MLS
    (ALUControl == 4'b0110) ? (SrcA ^ SrcB) :         // EOR
    (ALUControl == 4'b0111) ? (~SrcB) :               // MVN
    (ALUControl == 4'b1000) ? (SrcC + (SrcA * SrcB)) : // MLA
    (ALUControl == 4'b1001) ? (SrcB - SrcA) :         // RSB
    (ALUControl == 4'b1010) ? (SrcA + SrcB + CarryIn) :// ADC
    (ALUControl == 4'b1011) ? (SrcA - SrcB - ~CarryIn) :// SBC
    (ALUControl == 4'b1100) ? (SrcA * SrcB) :         // MUL
    32'b0;                                             // Default

  assign sum = SrcA + (ALUControl[1] ? ~SrcB + 1 : SrcB);

  assign neg = ALUResult[31];
  assign zero = (ALUResult == 32'b0);
  assign carry = (ALUControl[1] == 1'b0) & sum[31];
  assign overflow = (ALUControl[1] == 1'b0) & ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) & (SrcA[31] ^ sum[31]);
  assign ALUFlags = {neg, zero, carry, overflow};
endmodule