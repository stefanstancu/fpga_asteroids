vlib work

vlog fill.v sprite_mem32x32.v

vsim -L altera_mf_ver {draw_ship}

log {/*}
add wave {/*}

# Run clock every 10ps
force {clk} 0 0, 1 5 -r 10

force {x_pos} 0
force {y_pos} 0

# Simulate memory to be 101

force {reset_n} 1
force {plot} 0
run 10ps

force {reset_n} 0
run 10ps

force {plot} 1
run 10ps

force {plot} 0
run 32000 ps
