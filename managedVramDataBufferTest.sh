#!bin/bash

#yosys -p 'synth_ice40 -top top -json fpga_test.json' fpgs_test.v
#nextpnr-ice40 --hx4k --json fpga_test.json --pcf fpga_test.pcf --asc fpga_test.asc --pcf-allow-unconstrained
#icepack fpga_test.asc fpga_test.bin

rm tb_.vcd
rm managedVramDataBuffer_test

iverilog -o managedVramDataBuffer_test managedVramDataBuffer_test.v
vvp managedVramDataBuffer_test
#gtkwave tb_.vcd
