# top module (testbench)
TESTBENCH := test
# module list
FILELIST :=
FILELIST += test_akarin.sv
FILELIST += sram.sv
FILELIST += akarin_riscv.sv
FILELIST += mem_if.sv
FILELIST += ISA/RISCV_ISA.sv
FILELIST += stages/InstFetch.sv
FILELIST += stages/InstDec.sv
FILELIST += stages/RegFile.sv
FILELIST += stages/ALU.sv

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


