# Makefile for FIR64_tb simulation

IVERILOG = /ee/166/iverilog/bin/iverilog
VVP = /ee/166/iverilog/bin/vvp
GTKWAVE = gtkwave

# Testbench file
TB_SV = tb.sv

# Simulation files
SIM_BINARY = sim
VCD_FILE = fir64.vcd

# Compilation options
COMPILE_OPTS = -o $(SIM_BINARY) -g2005-sv

# Simulation command
SIM_COMMAND = $(VVP) $(SIM_BINARY)

# View waveform command
VIEW_WAVEFORM = $(GTKWAVE) $(VCD_FILE)

.PHONY: all compile simulate view clean

# Default target
all: compile simulate view

compile:
	$(IVERILOG) $(COMPILE_OPTS) $(TB_SV)

simulate:
	$(SIM_COMMAND)

view:
	$(VIEW_WAVEFORM)

clean:
	rm -rf $(SIM_BINARY) $(VCD_FILE)
