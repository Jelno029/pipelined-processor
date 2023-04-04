onerror {quit -f}
vlib work
vlog -work work lab3top.vo
vlog -work work pipelined_processor.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.enreg32bit_vlg_vec_tst
vcd file -direction pipelined_processor.msim.vcd
vcd add -internal enreg32bit_vlg_vec_tst/*
vcd add -internal enreg32bit_vlg_vec_tst/i1/*
add wave /*
run -all
