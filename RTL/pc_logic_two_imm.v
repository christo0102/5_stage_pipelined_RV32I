`timescale 1ns / 1ps
module pc_logic_imm(
input wire [31:0] pc_outE,
input wire [31:0]  ImmExtE,
output wire [31:0]  pc_targetE  );
assign pc_targetE = pc_outE + ImmExtE;
endmodule
