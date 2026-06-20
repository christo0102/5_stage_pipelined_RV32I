`timescale 1ns / 1ps
module ID (
 input wire clk,
 input wire reset,
 input wire clr,
 input wire en,
 input wire [31:0] instructionF,
 input wire [31:0] pc_outF,
 input wire [31:0] pc_plus4F,
 output reg [31:0] instructionD,
 output reg [31:0] pc_outD,
 output reg [31:0] pc_plus4D
);

always @(posedge clk) begin
 if (reset ) begin
     instructionD <= 32'b0;
     pc_outD <= 32'b0;
     pc_plus4D <= 32'b0;
 end 
 else if (clr) begin
     instructionD <= 32'b0;
     pc_outD <= 32'b0;
     pc_plus4D <= 32'b0;
 end
 else if (~en) begin
     instructionD <= instructionF;
     pc_outD <= pc_outF;
     pc_plus4D <= pc_plus4F;
 end
end
endmodule
