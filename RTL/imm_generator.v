`timescale 1ns / 1ps  
module Extend (
    input  [24:0] instructionD,
    input  [2:0]  ImmSrcD,
    output reg [31:0] ImmExtD
);
    // specified by the Control Unit (ImmSrc).
    always @(*) begin
        case (ImmSrcD)
            // I-Type (for addi, lw, jalr)
            3'b000: ImmExtD = { {20{instructionD[24]}}, instructionD[24:13] };

            // S-Type (for sw, sh, sb)
            3'b001: ImmExtD = { {20{instructionD[24]}}, instructionD[24:18], instructionD[4:0] };

            // B-Type (for beq, bne, etc.)
            3'b010: ImmExtD = { {20{instructionD[24]}}, instructionD[0], instructionD[23:18], instructionD[4:1], 1'b0 };

            // J-Type (for jal)
            3'b011: ImmExtD = { {11{instructionD[24]}}, instructionD[24], instructionD[12:5], instructionD[13], instructionD[23:14], 1'b0 };

            // U-Type (for lui, auipc)
            3'b100: ImmExtD = { instructionD[24:5], 12'b0 };

            // Default case to prevent latches and provide a known safe value
            default: ImmExtD = 32'h00000000;
        endcase
    end
endmodule
