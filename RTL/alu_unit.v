`timescale 1ns / 1ps         
module ALU #( 
parameter LEN = 32 )
( 
input  wire [LEN-1:0] SrcAE, 
input  wire [LEN-1:0] SrcBE, 
input  wire [3:0]    ALU_CtrlE, 
output reg  [LEN-1:0] ALU_ResultE, 
output wire zeroE ,
output wire LessThanE
); 
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
localparam JALR = 4'b1011;

wire signed_less = ($signed(SrcAE) < $signed(SrcBE));
wire unsigned_less = (SrcAE < SrcBE);

assign LessThanE = (ALU_CtrlE == SLT) ? signed_less : (ALU_CtrlE == SLTU) ? unsigned_less : 1'b0;
always @(*) begin 
case (ALU_CtrlE) 
ADD:   ALU_ResultE = SrcAE + SrcBE; 
SUB:   ALU_ResultE= SrcAE - SrcBE; 
AND:   ALU_ResultE = SrcAE & SrcBE; 
OR:    ALU_ResultE = SrcAE | SrcBE; 
XOR:   ALU_ResultE = SrcAE ^ SrcBE; 
SLL:   ALU_ResultE = SrcAE << SrcBE[4:0]; 
SRL:   ALU_ResultE = SrcAE >> SrcBE[4:0]; 
// logical right
SRA:   ALU_ResultE = ($signed(SrcAE)) >>> SrcBE[4:0]; // arithmetic right 
SLT:   ALU_ResultE = ($signed(SrcAE) < $signed(SrcBE)) ? {{LEN-1{1'b0}}, 1'b1} : 'b0; 
SLTU:  ALU_ResultE = (SrcAE < SrcBE) ? {{LEN-1{1'b0}}, 1'b1} : 'b0; 
PASS:  ALU_ResultE = SrcBE; 
JALR: ALU_ResultE = (SrcAE + SrcBE) & 32'hFFFFFFFE ; 
default: ALU_ResultE = {LEN{1'b0}}; 
endcase 
end 
assign zeroE = (ALU_ResultE == {LEN{1'b0}}); 
endmodule 
