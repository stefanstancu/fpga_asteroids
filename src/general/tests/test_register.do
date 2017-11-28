
vlib work

vlog draw_controller.sv draw_sprite.v ../ship/draw_ship.sv ../asteroid/draw_asteroid.v sprite_mem32x32.v entity_controller.sv

vsim -L altera_mf_ver {test_registers}

log {/*}
add wave {/*}

# Run clock every 10ps
force {clk} 0 0, 1 5 -r 10
run 100ps
