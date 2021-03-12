iverilog -o cpu cpu.v decode-stage/decode_stage.v execute_stage/ALU.v execute_stage/bit_64_addsub.v execute_stage/bit_64_and.v execute_stage/bit_64_xor.v  execute_stage/mux_4x1.v fetch-stage/fetch_stage.v memory-stage/memory.v pipeline_control_logic.v 
vvp cpu
gtkwave cpu.vcd