`timescale 1ns / 1ps
module mux_pc(
    input  [31:0] pc_plus4F,
    input  [31:0] pc_targetE,
    input  [31:0] ALU_ResultE,
    input  [1:0]  PCSrc,
    output reg [31:0] pc_next
);
always @(*) begin
    case (PCSrc)
        2'b00: pc_next = pc_plus4F;
        2'b01: pc_next = pc_targetE;
        2'b10: pc_next = ALU_ResultE;
        default: pc_next = pc_plus4F;
    endcase
end
endmodule
