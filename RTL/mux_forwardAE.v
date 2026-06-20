`timescale 1ns / 1ps
module mux_forwardAE(
    input  [31:0] ResultW,
    input  [31:0] ALU_ResultM,
    input  [31:0] rd1E,
    input         auipcM,
    input  [31:0] pc_targetM,
    input  [1:0]  ForwardAE,
    output reg [31:0] SrcAE
);

    always @(*) begin
 
        if (ForwardAE == 2'b00) begin
            SrcAE = rd1E;
        end 
        else if (ForwardAE == 2'b01) begin
            SrcAE = ResultW;
        end 
        else if (ForwardAE == 2'b10 && auipcM == 1'b0) begin
            SrcAE = ALU_ResultM;
        end 
        else if (ForwardAE == 2'b10 && auipcM == 1'b1) begin
            SrcAE = pc_targetM;
        end 
        else begin
            SrcAE = rd1E; // Safe fallback default
        end
    end

endmodule
