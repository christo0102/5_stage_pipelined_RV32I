`timescale 1ns / 1ps  
module MEM (
    input wire clk,
    input wire reset,
    input wire [31:0] ALU_ResultE,
    input wire [31:0] Write_DataE,
    input wire [4:0] rdE,
    input wire RegWriteE,
    input wire MemWriteE,
    input wire auipcE,
    input wire [1:0] ResultSrcE,
    input wire [31:0] pc_plus4E,
    input wire [2:0] funct3E,  
    input wire [31:0] pc_targetE,
    output reg [31:0] ALU_ResultM,
    output reg [31:0] pc_targetM,
    output reg [2:0] funct3M,  
    output reg [31:0] Write_DataM,
    output reg [4:0] rdM,
    output reg [31:0] pc_plus4M,
    output reg RegWriteM,
    output reg auipcM,
    output reg MemWriteM,
    output reg [1:0] ResultSrcM
);

always @(posedge clk) begin
if ( reset) begin
    ALU_ResultM <= 32'b0;
    Write_DataM <= 32'b0;
    funct3M    <= 3'b0; 
    rdM         <= 5'b0;
    auipcM     <= 1'b0;
    RegWriteM   <= 1'b0;
    pc_targetM  <= 32'b0;
    MemWriteM   <= 1'b0;
    ResultSrcM  <= 2'b0;
    pc_plus4M   <= 32'b0;
end
else begin
    ALU_ResultM <= ALU_ResultE;
    Write_DataM <= Write_DataE;
    funct3M    <= funct3E; 
    rdM         <= rdE;
    RegWriteM   <= RegWriteE;
    auipcM      <= auipcE;
    pc_targetM  <= pc_targetE;
    MemWriteM   <= MemWriteE;
    ResultSrcM  <= ResultSrcE;
    pc_plus4M   <= pc_plus4E;
end
end
endmodule
