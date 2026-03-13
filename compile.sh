#!bin/bash

yosys -p 'synth_ice40 -top top -json fpga_videocard.json' fpga_videocard.v
nextpnr-ice40 --hx4k --json fpga_videocard.json --pcf fpga_videocard.pcf --asc fpga_videocard.asc --pcf-allow-unconstrained --package tq144
icepack fpga_videocard.asc fpga_videocard.bin
