`timescale 1ns / 1ps      
module RV32I_Pipelined (
    input  clk,
    input  reset,
    output [31:0] ALU ,
    output memory_signal,
    output [31:0] writeing_data
);

    wire [31:0] pc_outF;
    wire [31:0] pc_outD; 
    wire [31:0] pc_outE;
    wire [31:0] instructionF;
    wire [31:0] instructionD;  
    wire [31:0] pc_plus4F;
    wire [31:0] pc_plus4D;
    wire [31:0] pc_targetE;
    wire [31:0] pc_targetM;
    wire [31:0] pc_targetW;
    wire [31:0] pc_next;
    wire [4:0]  rs1D;
    wire [4:0]  rs2D;
    wire        BranchE;
    wire        branchD;
    wire        branchE;
    wire        jumpD;
    wire        jumpE;
    wire        jalrE;
    wire        jalrD;
    wire        auipcE;
    wire        auipcM;
    wire        auipcD;
    wire [4:0]  rdD;
    wire [31:0] rd1D;
    wire [31:0] rd2D;
    wire [31:0] ImmExtD;
    wire [4:0]  rs1E;
    wire [4:0]  rs2E;
    wire [4:0]  rdE;
    wire [4:0]  rdM;
    wire [4:0]  rdW;
    wire [31:0] rd1E;
    wire [31:0] rd2E;
    wire        stallF;
    wire        stallD;
    wire        flushE;
    wire        flushD;
    wire [31:0] pc_plus4E;
    wire [31:0] pc_plus4M;
    wire [31:0] pc_plus4W;
    wire [31:0] Write_DataE;
    wire [31:0] Write_DataM;
    wire [31:0] ImmExtE;
    wire [1:0]  ResultSrcD;
    wire        MemWriteD;
    wire        MemWriteM;
    wire        ALUSrcD;
    wire        ALUSrcE;
    wire [2:0]  ImmSrcD;
    wire        RegWriteD;
    wire        RegWriteE;
    wire        RegWriteM;
    wire        RegWriteW;
    wire [3:0]  ALU_CtrlD;
    wire [3:0]  ALU_CtrlE;
    wire [1:0]  ResultSrcE;
    wire [1:0]  ResultSrcM;
    wire [1:0]  ResultSrcW;
    wire [31:0] ResultW;
    wire [31:0] SrcAE;
    wire [31:0] SrcBE;
    wire [31:0] ALU_ResultE;
    wire [31:0] ALU_ResultM;
    wire [31:0] ALU_ResultW;
    wire [31:0] jalr_target;
    wire        zeroE;
    wire        LessThanE;
    wire [31:0] Read_DataM;
    wire [31:0] load_dataM;
    wire [31:0] load_dataW;
    wire        funct7b5 = instructionD[30];
    wire [2:0]  funct3D  = instructionD[14:12];
    wire [2:0]  funct3E;
    wire [2:0]  funct3M;
    wire [2:0]  funct3W;
    wire [1:0]  ForwardAE;
    wire [1:0]  ForwardBE;
    wire [1:0] PCSrc ;

    assign rdD = instructionD[11:7];
    assign rs2D = instructionD[24:20];
    assign rs1D = instructionD[19:15];

    

    wire take_branchE = (
        (funct3E == 3'b000 &&  zeroE)     |
        (funct3E == 3'b001 && ~zeroE)     |
        (funct3E == 3'b100 &&  LessThanE) |
        (funct3E == 3'b101 && ~LessThanE) |
        (funct3E == 3'b110 &&  LessThanE) |
        (funct3E == 3'b111 && ~LessThanE)
    );

       assign  BranchE = take_branchE & branchE;

    reg [1:0] PCSrcE;
    
    always @(*) begin
        if (jalrE) begin 
            PCSrcE = 2'b10;
        end 
        else if (jumpE || BranchE) begin 
            PCSrcE = 2'b01;
        end 
        else begin
            PCSrcE = 2'b00; 
        end
    end
    
    assign PCSrc = stallF ? 2'b00 : PCSrcE;
   
    IF instruction_fetch (
        .clk(clk),
        .reset(reset),
        .en(stallF),
        .pc_next(pc_next),
        .pc_outF(pc_outF)
    );

    pc_logic_one pc_logic_one (
        .pc_outF(pc_outF),
        .pc_plus4F(pc_plus4F)
    );

    ID instruction_decode (
        .clk(clk),
        .en(stallD),
        .reset(reset),
        .clr(flushD),
        .instructionF(instructionF),
        .instructionD(instructionD),
        .pc_outD(pc_outD),
        .pc_outF(pc_outF),
        .pc_plus4D(pc_plus4D),
        .pc_plus4F(pc_plus4F)
    );

    EX instruction_execute (
        .clk(clk),
        .reset(reset),
        .clr(flushE),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .auipcD(auipcD),
        .auipcE(auipcE),
        .jalrD(jalrD),
        .jumpD(jumpD),
        .branchD(branchD),
        .jumpE(jumpE),
        .jalrE(jalrE),
        .branchE(branchE),
        .rdD(rdD),
        .rd1D(rd1D),
        .rd2D(rd2D),
        .pc_outD(pc_outD),
        .pc_plus4D(pc_plus4D),
        .ImmExtD(ImmExtD),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .funct3D(funct3D),
        .funct3E(funct3E),
        .rdE(rdE),
        .rd1E(rd1E),
        .rd2E(rd2E),
        .pc_outE(pc_outE),
        .pc_plus4E(pc_plus4E),
        .ImmExtE(ImmExtE),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .ALU_CtrlE(ALU_CtrlE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .ALU_CtrlD(ALU_CtrlD),
        .ALUSrcD(ALUSrcD),
        .MemWriteD(MemWriteD)
    );

    MEM ex_mem_register (
        .clk(clk),
        .reset(reset),
        .ALU_ResultE(ALU_ResultE),
        .Write_DataE(Write_DataE),
        .rdE(rdE),
        .auipcM(auipcM),
        .auipcE(auipcE),
        .funct3E(funct3E),
        .funct3M(funct3M),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .pc_targetE(pc_targetE),
        .pc_targetM(pc_targetM),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .ResultSrcE(ResultSrcE),
        .ResultSrcM(ResultSrcM),
        .pc_plus4E(pc_plus4E),
        .ALU_ResultM(ALU_ResultM),
        .Write_DataM(Write_DataM),
        .rdM(rdM),
        .pc_plus4M(pc_plus4M)
    );

    WB mem_wb_register (
        .clk(clk),
        .reset(reset),
        .load_dataM(load_dataM),
        .ALU_ResultM(ALU_ResultM),
        .rdM(rdM),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcM(ResultSrcM),
        .ResultSrcW(ResultSrcW),
        .pc_plus4M(pc_plus4M),
        .load_dataW(load_dataW),
        .ALU_ResultW(ALU_ResultW),
        .pc_plus4W(pc_plus4W),
        .rdW(rdW),
        .pc_targetM(pc_targetM),
        .pc_targetW(pc_targetW)
    );

    mux_pc mux_one (
        .pc_plus4F(pc_plus4F),
        .pc_targetE(pc_targetE),
        .PCSrc(PCSrc),
        .ALU_ResultE(ALU_ResultE),
        .pc_next(pc_next)
    );

    Instruction_Memory imem (
        .pc_outF(pc_outF[9:2]),
        .instructionF(instructionF)
    );

    Control_Unit ctrl_unit (
        .opcode(instructionD[6:0]),
        .funct3D(funct3D),
        .funct7b5(funct7b5),
        .jumpD(jumpD),
        .auipcD(auipcD),
        .jalrD(jalrD),
        .branchD(branchD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .RegWriteD(RegWriteD),
        .ALU_CtrlD(ALU_CtrlD)
    );

    Register_file registers (
        .clk(clk),
        .reset(reset),
        .RegWriteW(RegWriteW),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rdW(rdW),
        .ResultW(ResultW),
        .rd1D(rd1D),
        .rd2D(rd2D)
    );

    Extend immediate_generator (
        .instructionD(instructionD[31:7]),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    mux_forwardAE mux_forwardAE (
        .rd1E(rd1E),
        .ForwardAE(ForwardAE),
        .SrcAE(SrcAE),
        .auipcM(auipcM),
        .pc_targetM(pc_targetM),
        .ALU_ResultM(ALU_ResultM),
        .ResultW(ResultW)
    );

    mux_forwardBE mux_forwardBE (
        .rd2E(rd2E),
        .ForwardBE(ForwardBE),
        .Write_DataE(Write_DataE),
        .ALU_ResultM(ALU_ResultM),
        .ResultW(ResultW)
    );

    mux_alu_srcb mux_alu_two (
        .Write_DataE(Write_DataE),
        .ImmExtE(ImmExtE),
        .ALUSrcE(ALUSrcE),
        .SrcBE(SrcBE)
    );

    ALU #(.LEN(32)) alu_unit (
        .SrcAE(SrcAE),
        .SrcBE(SrcBE),
        .ALU_CtrlE(ALU_CtrlE),
        .ALU_ResultE(ALU_ResultE),
        .zeroE(zeroE),
        .LessThanE(LessThanE)
    );

    Data_Memory dmem (
        .clk(clk),
        .MemWriteM(MemWriteM),
        .ALU_ResultM(ALU_ResultM[9:0]),
        .Write_DataM(Write_DataM),
        .funct3M(funct3M),
        .Read_DataM(Read_DataM)
    );

    mux_result mux_for_result (
        .ALU_ResultW(ALU_ResultW),
        .load_dataW(load_dataW),
        .pc_plus4W(pc_plus4W),
        .ResultSrcW(ResultSrcW),
        .ResultW(ResultW),
        .pc_targetW(pc_targetW)
    );

    Load_Unit load_unit (
        .Read_DataM(Read_DataM),
        .ALU_ResultM(ALU_ResultM[1:0]),
        .funct3M(funct3M),
        .load_dataM(load_dataM)
    );

    Hazard_Unit hazard_unit_inst (
        .rs1E(rs1E),
        .rs2E(rs2E),
        .rdM(rdM),
        .rdW(rdW),
        .regwriteM(RegWriteM),
        .regwriteW(RegWriteW),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rdE(rdE),
        .ResultSrcE(ResultSrcE),
        .PCSrc(PCSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .stallF(stallF),
        .stallD(stallD),
        .flushD(flushD),
        .flushE(flushE)
    );
    
    pc_logic_imm pc_logic_two (
       .pc_outE(pc_outE),
       .ImmExtE(ImmExtE),
       .pc_targetE(pc_targetE)
    );
    
    assign memory_signal = MemWriteM;
    assign ALU = ALU_ResultM;
    assign writeing_data = ResultW;
    
endmodule
