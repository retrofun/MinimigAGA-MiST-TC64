OBJ_DIR=obj_dir
VERILATOR_DIR=/usr/share/verilator/include
RTL=../../rtl/minimig
TOP=chipset

HDL_FILES = chipset_tb.v ${RTL}/agnus_beamcounter.v $(RTL)/amber.v

all: ${TOP}_tb

clean:
	-rm cpu_${TOP}_tb
	-rm $(OBJ_DIR)/*

AudioMix.v : ${RTL}/../audio/AudioMix.vhd
	ghdl -a $+
	ghdl synth --out=verilog AudioMix > $@

audiofilter.v : ${RTL}/../audio/audiofilter.vhd
	ghdl -a $+
	ghdl synth --out=verilog audiofilter > $@

V${TOP}_tb.cpp: ${OBJ_DIR}/V${TOP}_tb.cpp


${OBJ_DIR}/V${TOP}_tb.cpp: ${HDL_FILES}
	verilator -I${RTL} -cc -exe -MMD --trace --top-module ${TOP}_tb -cc ${TOP}_tb.cpp ${HDL_FILES}

${TOP}_tb: ${OBJ_DIR}/V${TOP}_tb.cpp ${TOP}_tb.cpp
	$(MAKE) -j 4 -C obj_dir -f ../Makefile_obj
#	g++ -I $(OBJ_DIR) -I$(VERILATOR_DIR) $(VERILATOR_DIR)/verilated.cpp $(VERILATOR_DIR)/verilated_vcd_c.cpp ${TOP}_tb.cpp  $(OBJ_DIR)/V${TOP}_tb__Trace.cpp $(OBJ_DIR)/V${TOP}_tb__Trace__Slow.cpp $(OBJ_DIR)/V${TOP}_tb.cpp $(OBJ_DIR)/V${TOP}_tb__Syms.cpp -DOPT=-DVL_DEBUG -o ${TOP}_tb

run: ${TOP}_tb
	${OBJ_DIR}/V${TOP}_tb

