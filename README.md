# 5_stage_pipelined_RV32I
This design features a 5-stage pipelined RISC processor in Verilog/Vivado running at 123 MHz ($8.13\text{ ns}$ period) with closed timing. It supports 37+ instructions (R, I, S, B, U, J types) and achieves high throughput via an aggressive data-forwarding network and hazard detection that limits stalls to unavoidable 1-cycle load-use delays.
