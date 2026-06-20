`timescale 1ns / 1ps
 
module Hazard_Unit(
    input [4:0] rs1E, rs2E, 
    input [4:0] rs1D, rs2D,
    input [4:0] rdM, rdW,
    input regwriteM, regwriteW,
    input [1:0] ResultSrcE, 
    input [4:0] rdE,
    input [1:0] PCSrc,   
    
   output reg [1:0] ForwardAE,
   output reg [1:0] ForwardBE, 
    output reg stallF,
    output reg stallD,
    output reg flushD,
    output reg flushE
);

  reg lwstall;

    always @(*) begin
        // Default assignments
        ForwardAE   = 2'b00;
        ForwardBE   = 2'b00;
        lwstall     = 1'b0;
        stallF      = 1'b0;
        stallD      = 1'b0;
        flushD      = 1'b0;
        flushE      = 1'b0;

        if ((rs1E == rdM) && regwriteM && (rs1E != 5'b0)) 
            ForwardAE = 2'b10; 
        else if ((rs1E == rdW) && regwriteW && (rs1E != 5'b0)) 
            ForwardAE = 2'b01; 

        // Forward B
        if ((rs2E == rdM) && regwriteM && (rs2E != 5'b0)) 
            ForwardBE = 2'b10; 
        else if ((rs2E == rdW) && regwriteW && (rs2E != 5'b0)) 
            ForwardBE = 2'b01; 

        if ((ResultSrcE == 2'b01) && ((rs1D == rdE) || (rs2D == rdE)) && (rdE != 5'b0)) begin
            lwstall = 1'b1;
        end

        // Apply stalls
        stallD = lwstall;
        stallF = lwstall;

        if (PCSrc != 2'b00) begin
            flushD = 1'b1;
            flushE = 1'b1; 
        end else if (lwstall) begin
          
            flushE = 1'b1; 
        end
    end

endmodule
