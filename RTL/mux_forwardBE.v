`timescale 1ns / 1ps
module mux_forwardBE(
input  [31:0] rd2E,
input  [31:0] ResultW,
input  [31:0] ALU_ResultM,
input  [1:0]  ForwardBE,
output reg [31:0] Write_DataE
);

always @(*) begin
if (ForwardBE == 2'b00)
Write_DataE = rd2E;
else if (ForwardBE == 2'b01)
Write_DataE = ResultW;
else if (ForwardBE == 2'b10)
Write_DataE = ALU_ResultM;
else
Write_DataE = 32'b0;
end

endmodule
