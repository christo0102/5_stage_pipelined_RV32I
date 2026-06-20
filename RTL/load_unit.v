`timescale 1ns / 1ps
module Load_Unit (
    input  wire [31:0] Read_DataM,
    input  wire [1:0]  ALU_ResultM,
    input  wire [2:0]  funct3M,
    output reg  [31:0] load_dataM
);

reg [7:0]  byte_data;
reg [15:0] half_data;

always @(*) begin
    byte_data = 8'b0;
    half_data = 16'b0;
    load_dataM = 32'b0;

    case (ALU_ResultM)
        2'b00: byte_data = Read_DataM[7:0];
        2'b01: byte_data = Read_DataM[15:8];
        2'b10: byte_data = Read_DataM[23:16];
        2'b11: byte_data = Read_DataM[31:24];
    endcase

    case (ALU_ResultM[1])
        1'b0: half_data = Read_DataM[15:0];
        1'b1: half_data = Read_DataM[31:16];
    endcase

    case (funct3M)
        3'b000: load_dataM = {{24{byte_data[7]}}, byte_data}; 
        3'b001: load_dataM = {{16{half_data[15]}}, half_data};
        3'b010: load_dataM = Read_DataM;
        3'b100: load_dataM = {24'b0, byte_data};
        3'b101: load_dataM = {16'b0, half_data};
        default: load_dataM = Read_DataM;
    endcase
end

endmodule
