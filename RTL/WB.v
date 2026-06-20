`timescale 1ns / 1ps
module WB(
  input wire clk,
  input wire reset,
  input wire [31:0] load_dataM,
  input wire [31:0] ALU_ResultM,
  input wire [31:0] pc_targetM,
  input wire [4:0] rdM,
  input wire RegWriteM,
  input wire [1:0] ResultSrcM,
  input wire [31:0] pc_plus4M,
  output reg [31:0] load_dataW,
  output reg [31:0] ALU_ResultW,
  output reg [31:0] pc_plus4W,
  output reg [31:0] pc_targetW,
  output reg RegWriteW,
  output reg [1:0] ResultSrcW,
  output reg [4:0]  rdW
);

always @(posedge clk) begin
if (reset) begin
    load_dataW  <= 32'b0;
    ALU_ResultW <= 32'b0;
    pc_plus4W   <= 32'b0;
    RegWriteW   <= 1'b0;
    pc_targetW  <= 32'b0;
    ResultSrcW  <= 2'b0;
    rdW         <= 5'b0;
end
else begin
    load_dataW  <= load_dataM;
    ALU_ResultW <= ALU_ResultM;
    pc_plus4W   <= pc_plus4M;
    pc_targetW  <= pc_targetM;
    RegWriteW   <= RegWriteM;
    ResultSrcW  <= ResultSrcM;
    rdW         <= rdM;
    
end
end
endmodule
