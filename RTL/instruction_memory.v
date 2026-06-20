`timescale 1ns / 1ps    
module Instruction_Memory ( 
    input  wire [7:0] pc_outF, 
    output wire [31:0] instructionF 
); 
    reg [31:0] inst_memory [0:255]; 
     initial begin
        $readmemh("instruction.mem",inst_memory);
     end
      assign instructionF = inst_memory[pc_outF[7:0]]; 
endmodule
