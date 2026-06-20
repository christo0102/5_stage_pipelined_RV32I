`timescale 1ns / 1ps  
module Register_file(
    input clk,
    input reset,
    input RegWriteW,
    input wire [4:0] rs1D,
    input wire [4:0] rs2D,
    input wire [4:0] rdW,
    input wire [31:0] ResultW,
    output wire [31:0] rd1D,
    output wire [31:0] rd2D
);
    reg [31:0] Register[31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Register[i] = 32'b0;
        end
    end

    always @(posedge clk) begin
        if (RegWriteW && (rdW != 5'b0)) begin
            Register[rdW] <= ResultW;
        end
    end

    // Internal Write-Bypass Forwarding (eliminates the need for negedge clk)
    assign rd1D = (rs1D == 5'b0) ? 32'b0 : ( (RegWriteW && (rdW == rs1D)) ? ResultW : Register[rs1D] );
    assign rd2D = (rs2D == 5'b0) ? 32'b0 : ( (RegWriteW && (rdW == rs2D)) ? ResultW : Register[rs2D] );

endmodule
