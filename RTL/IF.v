`timescale 1ns / 1ps  
module IF( 
    input clk, 
    input reset, 
    input en,       
    input [31:0] pc_next, 
    output wire [31:0] pc_outF
); 
    reg [31:0] pc_reg;

    always @(posedge clk) begin 
        if (reset) begin
            pc_reg <= 32'h00000000;
        end else if (~en) begin
            pc_reg <= pc_next;
        end
    end 
    assign pc_outF = pc_reg;

endmodule
