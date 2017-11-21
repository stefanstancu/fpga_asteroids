vlib work

vlog position_mem2x9.v move_rate_divider.v movement_module.v

vsim -L altera_mf_ver memtest

log {/*}
add wave {/*}

# Run clock every 10ps
force {clk} 0 0, 1 5 -r 10

# save 100 to both

force {address} 1
force {writeEn} 1
force {data} 100
run 10ps

force {writeEn} 0
run 10 ps

force {address} 0
run 10ps

force {address} 1
run 10ps
