onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk_rst_if0/clk
add wave -noupdate /top/clk_rst_if0/rst
add wave -noupdate /top/risc_v_if0/pc_reg
add wave -noupdate /top/dut0/risc_v_instance/instruction_decode/INSTRUCTION_ID
add wave -noupdate /top/dut0/risc_v_instance/Mem/address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {454365 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {288750 ps} {866250 ps}
