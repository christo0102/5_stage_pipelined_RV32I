`timescale 1ns / 1ps  
module mux_alu_srcb( 
input  [31:0] Write_DataE, 
input  [31:0] ImmExtE, 
input         ALUSrcE, 
output [31:0] SrcBE
); 
assign SrcBE = (ALUSrcE) ? ImmExtE : Write_DataE; 
endmodule
