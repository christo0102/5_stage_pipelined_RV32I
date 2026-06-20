`timescale 1ns / 1ps    
module mux_result( 
input  [31:0] ALU_ResultW, 
input  [31:0] load_dataW, 
input  [31:0] pc_plus4W, 
input [31:0] pc_targetW,
input  [1:0]  ResultSrcW, 
output reg [31:0] ResultW
); 
always @(*) begin 
case (ResultSrcW) 
2'b00: ResultW = ALU_ResultW; 
2'b01: ResultW = load_dataW; 
2'b10: ResultW = pc_plus4W; 
2'b11: ResultW = pc_targetW; 
default: ResultW = 32'b0; 
endcase 
end 
endmodule
