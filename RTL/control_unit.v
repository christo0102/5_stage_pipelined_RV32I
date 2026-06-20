`timescale 1ns / 1ps      
 module Control_Unit ( 
 input  wire [6:0] opcode, 
 input  wire [2:0] funct3D, 
 input  wire       funct7b5, 
 output wire       jumpD,
 output wire       jalrD,
 output wire       branchD,
 output wire [1:0] ResultSrcD, 
 output wire       MemWriteD, 
 output wire       ALUSrcD, 
 output wire [2:0] ImmSrcD, 
 output wire       RegWriteD, 
 output wire       auipcD,
 output wire [3:0] ALU_CtrlD
 ); 
 // Internal wire to connect the two decoders 
 wire [1:0] ALUOp; 
 wire opcode5; 
 assign opcode5 = opcode[5]; 
 // Instantiate the Main Decoder 
 main_decoder main_dec ( 
 .opcode     (opcode), 
 .branchD     (branchD),
 .jumpD       (jumpD),
 .jalrD        (jalrD),
 .ResultSrcD  (ResultSrcD), 
 .MemWriteD   (MemWriteD), 
 .ALUSrcD    (ALUSrcD), 
 .ImmSrcD     (ImmSrcD), 
 .auipcD        (auipcD),
 .RegWriteD   (RegWriteD), 
 .ALUOp      (ALUOp)      // Connects to the ALU_Decoder 
 ); 
 // Instantiate the ALU Decoder 
 ALU_Decoder alu_dec ( 
 .ALUOp      (ALUOp),     // Input comes from the main_decoder 
 .opcode5    (opcode5), 
 .funct3D     (funct3D),
 .opcode      (opcode), 
 .funct7b5   (funct7b5), 
 .ALU_CtrlD   (ALU_CtrlD) 
 ); 
 endmodule 
 //---------------------------------------------------------------- 
 // MAIN DECODER 
 //---------------------------------------------------------------- 
 module main_decoder ( 
 input  wire [6:0] opcode, 
 output reg  [1:0] ResultSrcD, 
 output reg        MemWriteD, 
 output reg        branchD,
 output reg        jalrD,
 output reg        jumpD,
 output reg        ALUSrcD, 
 output reg  [2:0] ImmSrcD, 
 output reg        RegWriteD, 
 output reg        auipcD,
 output reg  [1:0] ALUOp 
 ); 
 

 always @(*) begin 
 ResultSrcD = 2'b00; 
 MemWriteD  = 1'b0; 
 jalrD     = 1'b0;
 jumpD     = 1'b0;
 branchD   = 1'b0;
 ALUSrcD   = 1'b0; 
 ImmSrcD    = 3'b000; 
 RegWriteD  = 1'b0; 
 auipcD      = 1'b0;
 ALUOp     = 2'b00; // Default to LW/SW behavior 
 case (opcode) 
 7'b0000011: begin // I-type: lw (except for jalr and addi,andi etc) 
 RegWriteD  = 1'b1; 
 jumpD      = 1'b0;
 branchD    = 1'b0;
 ALUSrcD = 1'b1;
 ImmSrcD     = 3'b000;
 ALUOp   = 2'b00;
 ResultSrcD = 2'b01; // Data from memory 
 end 
 7'b0100011: begin // sw, sb, sh 
 ImmSrcD    = 3'b001; // S-type immediate 
 ALUOp = 2'b00;
 jumpD      = 1'b0;
 branchD    = 1'b0;
 ALUSrcD   = 1'b1; 
 ResultSrcD = 2'b00; 
 MemWriteD  = 1'b1;
 end 
 7'b0110011: begin // R-type 
 RegWriteD  = 1'b1; 
 ALUOp     = 2'b10; 
 jumpD      = 1'b0;
 branchD    = 1'b0;
 ALUSrcD  = 1'b0;
 ResultSrcD = 2'b00;
 
 end 
 7'b1100011: begin // Branch-type 
 ImmSrcD    = 3'b010; // B-type immediate 
 ALUOp     = 2'b01; 
 jumpD      = 1'b0;
 branchD    = 1'b1;
 ALUSrcD = 1'b0;
 ResultSrcD = 2'b00; 
 end 
 7'b0010011: begin // I-type (except for lw and jalr) 
 RegWriteD  = 1'b1; 
 ALUOp     = 2'b10; 
 ImmSrcD  = 3'b000;
 jumpD      = 1'b0;
 branchD    = 1'b0;
 ResultSrcD = 2'b00;
 ALUSrcD   = 1'b1; 
 end 
 7'b1101111: begin //  JAL-type 
 RegWriteD  = 1'b1; 
 ResultSrcD = 2'b10;
 jumpD      = 1'b1;
 branchD    = 1'b0;
 ImmSrcD    = 3'b011; 
 end 
 7'b1100111: begin  //  JALR 
 ImmSrcD   = 3'b000;
 ALUSrcD    = 1'b1; 
 jumpD      = 1'b0;
 branchD    = 1'b0;
 jalrD      = 1'b1;
 RegWriteD  = 1'b1; 
 ALUOp     = 2'b11; 
 ResultSrcD = 2'b10; 
 end 
 7'b0110111: begin  // LUI 
 ImmSrcD    = 3'b100; 
 ALUSrcD    = 1'b1; 
 RegWriteD  = 1'b1; 
 jumpD      = 1'b0;
 branchD    = 1'b0;
 ALUOp     = 2'b11; 
 ResultSrcD  = 2'b00;
 end 
 7'b0010111: begin  // AUIPC  
 ImmSrcD    = 3'b100; 
 jumpD      = 1'b0;
 branchD    = 1'b0;
 auipcD      = 1'b1;
 ALUSrcD    = 1'b1; 
 ResultSrcD = 2'b11;
 ALUOp  = 2'b00;
 RegWriteD  = 1'b1; 
 end 
 default: begin // Safe state for unsupported opcodes  
 ResultSrcD = 2'b00; 
 MemWriteD  = 1'b0; 
 ALUSrcD   = 1'b0; 
 auipcD      = 1'b0;
 ImmSrcD    = 3'b000; 
 RegWriteD  = 1'b0; 
 ALUOp     = 2'b00; 
 end 
 endcase 
 end 
 endmodule 
 //---------------------------------------------------------------- 
 // ALU DECODER 
 //---------------------------------------------------------------- 
 module ALU_Decoder ( 
 input  wire [1:0] ALUOp, 
 input  wire       opcode5, 
 input  wire [6:0] opcode,
 input  wire [2:0] funct3D, 
 input  wire       funct7b5, 
 output reg  [3:0] ALU_CtrlD
 ); 
 // ALU operation encodings 
 localparam ADD  = 4'b0000; 
 localparam SUB  = 4'b0001; 
 localparam AND  = 4'b0010; 
 localparam OR   = 4'b0011; 
 localparam XOR  = 4'b0100; 
 localparam SLL  = 4'b0101; 
 localparam SRL  = 4'b0110; 
 localparam SRA  = 4'b0111; 
 localparam SLT  = 4'b1000; 
 localparam SLTU = 4'b1001; 
 localparam PASS = 4'b1010; 
  localparam JALR = 4'b1011; //JALR
 always @(*) begin 
 case (ALUOp) 
 2'b00: ALU_CtrlD = ADD; // For LW/SW address calculation 
 2'b11: ALU_CtrlD = (opcode ==7'b1100111)? JALR: PASS; // For LUI & JALR
 2'b01: begin // For Branch instructions 
 case (funct3D) 
 3'b000: ALU_CtrlD = SUB;  // BEQ 
 3'b001: ALU_CtrlD = SUB;  // BNE 
 3'b100: ALU_CtrlD = SLT;  // BLT 
 3'b101: ALU_CtrlD = SLT;  // BGE 
 3'b110: ALU_CtrlD = SLTU; // BLTU 
 3'b111: ALU_CtrlD = SLTU; // BGEU 
 default: ALU_CtrlD = ADD; 
 endcase 
 end 
 2'b10: begin // For R-Type and I-Type instructions 
 case (funct3D) 
 3'b000: ALU_CtrlD = (funct7b5 & opcode5) ? SUB : ADD; 
 3'b001: ALU_CtrlD = SLL; 
 3'b010: ALU_CtrlD = SLT; 
 3'b011: ALU_CtrlD = SLTU; 
 3'b100: ALU_CtrlD = XOR; 
 3'b101: ALU_CtrlD = (funct7b5) ? SRA : SRL; 
 3'b110: ALU_CtrlD = OR; 
 3'b111: ALU_CtrlD = AND; 
 default: ALU_CtrlD = ADD; 
 endcase 
 end 
 default: ALU_CtrlD = ADD; // Default case for safety 
 endcase 
 end 
 endmodule
