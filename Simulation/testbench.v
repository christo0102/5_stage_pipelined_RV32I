`timescale 1ns / 1ps  

module tb_RV32I_Pipelined;

    reg clk;
    reg reset;
    
  
    wire [31:0] tb_ALU;
    wire        tb_mem_sig;
    wire [31:0] tb_wr_data;


    RV32I_Pipelined dut (
        .clk           (clk),
        .reset         (reset),
        .ALU           (tb_ALU),
        .memory_signal (tb_mem_sig),
        .writeing_data (tb_wr_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer total_cycles = 0;
    integer fetched_instructions = 0;
    integer flushed_instructions = 0;
    integer valid_instructions = 0;
    real calculated_cpi = 0.0;

    always @(posedge clk) begin
        if (!reset) begin
            total_cycles = total_cycles + 1;
            
        
            if (!dut.stallF) begin
                fetched_instructions = fetched_instructions + 1;
            end
            
     
            if (dut.flushD) flushed_instructions = flushed_instructions + 1;
            if (dut.flushE) flushed_instructions = flushed_instructions + 1;
            
        
            if (fetched_instructions > flushed_instructions + 4) begin
                valid_instructions = fetched_instructions - flushed_instructions - 4;
                calculated_cpi = $itor(total_cycles) / $itor(valid_instructions);
            end
        end
    end

    initial begin
        reset = 1;
        #20;             // Reset held active for 2 full cycles (20ns)
        reset = 0;
        #270;            // Run processor execution window for an additional 270ns
        
        $display("==================================================");
        $display("Simulation Finished at %0t ns", $time);
        $display("Total Cycles: %0d", total_cycles);
        $display("Valid Executed Instructions: %0d", valid_instructions);
        $display("Calculated Core CPI: %f", calculated_cpi);
        $display("==================================================");
        $finish;
    end

endmodule
