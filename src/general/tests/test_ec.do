vlib work

vlog draw_controller.sv draw_sprite.v ../ship/draw_ship.v ../asteroid/draw_asteroid.v sprite_mem32x32.v

vsim -L altera_mf_ver {test_ec}

log {/*}
add wave {/*}

# Run clock every 10ps
force {clk} 0 0, 1 5 -r 10

# Reset
force {reset_n} 1
run 10 ps
force {reset_n} 0
run 2000ps
