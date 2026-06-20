`timescale 1ns / 1ps  
module pc_logic_one ( 
    input  wire [31:0] pc_outF, 
    output wire [31:0] pc_plus4F 
); 
    assign pc_plus4F = pc_outF + 32'd4;
endmodule
