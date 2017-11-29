vlib work

vlog position_mem2x9.v move_rate_divider.v movement_module.v

vsim -L altera_mf_ver test

log {/*}
add wave {/*}

# Run clock every 10ps
force {clk} 0 0, 1 5 -r 10

force {direction} 010001
force {reset_n} 1
run 10ps

force {reset_n} 0
run 3000 ps
