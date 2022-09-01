# top module (testbench)
TESTBENCH := testbench
# module list
FILELIST := stages/InstFetch.sv
FILELIST += ISA/RISCV_ISA.sv
FILELIST += stages/InstDec.sv
FILELIST += stages/RegFile.sv

# include directory
INCDIR += ./

#parameters
TIMESCALE :=
MACROS :=

# 初期化処理。一度だけ実行
init: 
	vlog work

compile: 
	vlog -sv $(FILELIST) +incdir+$(INCDIR)

sim: compile
	vsim $(TESTBENCH)