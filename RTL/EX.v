`timescale 1ns / 1ps
module EX (
  input wire clk,
  input wire clr,
  input wire reset,
  input wire RegWriteD,
  input wire auipcD,
  input wire [1:0] ResultSrcD,
  input wire [3:0] ALU_CtrlD,
  input wire ALUSrcD,
  input wire MemWriteD,
  input wire [4:0] rs1D,
  input wire [4:0] rs2D,
  input wire [4:0] rdD,
  input wire branchD,
  input wire jalrD,
  input wire jumpD,
  input wire [2:0] funct3D,
  input wire [31:0] rd1D,
  input wire [31:0] rd2D,
  input wire [31:0] pc_outD,
  input wire [31:0] pc_plus4D,
  input wire [31:0] ImmExtD,
  
  output reg [31:0] ImmExtE,
  output reg [31:0] pc_outE, 
  output reg jumpE,
  output reg branchE,
  output reg jalrE,
  output reg [4:0] rs1E,
  output reg [4:0] rs2E,
  output reg [4:0] rdE,
  output reg auipcE,
  output reg [2:0] funct3E,
  output reg [31:0] rd1E,
  output reg [31:0] rd2E,
  output reg [31:0] pc_plus4E,
  output reg RegWriteE,
  output reg [1:0] ResultSrcE,
  output reg [3:0] ALU_CtrlE,
  output reg ALUSrcE,
  output reg MemWriteE
);

always @(posedge clk) begin
    if ( reset) begin
        ImmExtE   <= 32'b0;
        pc_outE   <= 32'b0;
        rs1E      <= 5'b0;
        rs2E      <= 5'b0;
        rdE       <= 5'b0;
        jalrE     <= 1'b0;
        auipcE    <= 1'b0;
        branchE   <= 1'b0;
        jumpE     <= 1'b0;
        rd1E      <= 32'b0;
        rd2E      <= 32'b0;
        funct3E   <= 3'b0;
        pc_plus4E <= 32'b0;
        RegWriteE <= 1'b0;
        ResultSrcE <= 2'b0;
        ALU_CtrlE  <= 4'b0;
        ALUSrcE    <= 1'b0;
        MemWriteE  <= 1'b0;
    end 
    else  if (clr ) begin
        ImmExtE   <= 32'b0;
        pc_outE   <= 32'b0;
        rs1E      <= 5'b0;
        rs2E      <= 5'b0;
        jalrE     <= 1'b0;
        branchE   <= 1'b0;
        jumpE     <= 1'b0;
        rdE       <= 5'b0;
        rd1E      <= 32'b0;
        rd2E      <= 32'b0;
        auipcE    <= 1'b0;
        funct3E   <= 3'b0;
        pc_plus4E <= 32'b0;
        RegWriteE <= 1'b0;
        ResultSrcE <= 2'b0;
        ALU_CtrlE  <= 4'b0;
        ALUSrcE    <= 1'b0;
        MemWriteE  <= 1'b0;
    end 
    else begin
        ImmExtE   <= ImmExtD;
        pc_outE   <= pc_outD;
        rs1E      <= rs1D;
        rs2E      <= rs2D;
        rdE       <= rdD;
        funct3E   <= funct3D;
        auipcE    <= auipcD;
        rd1E      <= rd1D;
        jalrE     <= jalrD;
        jumpE     <= jumpD;
        branchE   <= branchD;
        rd2E      <= rd2D;
        pc_plus4E <= pc_plus4D;
        RegWriteE <=  RegWriteD;
        ResultSrcE <=  ResultSrcD;
        ALU_CtrlE  <=  ALU_CtrlD;
        ALUSrcE    <=  ALUSrcD;
        MemWriteE  <=  MemWriteD;
    end
end

endmodule
