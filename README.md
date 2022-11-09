# AKARIN_RISCV
akarin(AKARIN : Adaptive Kosher Architecture of RIsc processor Next)はCADの利用法学習およびSystemVerilogの学習用に開発されたシンプルな4段のパイプラインで構成されたプロセッサです。

**akarin(AKARIN : Adaptive Kosher Architecture of RIsc Processor Next)** is simple 4-stage pipelined processor developed for study using CAD tools, or writing and reading SystemVerilog.

<!-- 面倒なのでもう英語で書くか -->
directory is consisted show as below
```
___ RTL
    |___ akarin_riscv.sv (top module)
    |
    |___ ISA
    |    |_ (definition of RISC-V ISA)
    |___ include
    |    |_ (include files for akarin_riscv.sv)
    |___ stages
         |_ (pipeline stages)
```

## Quick start
Requirements: Incisive 15.20 (Cadence)
```
$ git clone https://github.com/Foh-k/AKARIN_RISCV.git
$ cd AKARIN_RISCV/RTL
$ make
$ simvision &
```

you can use Quartus Prime (Intel) to compile or simlation, but it's not currentry supported in this Makefile.

## Make Test
You can write test using test generator in `RTL/test` directory.

you should write assembly in test/test.asm. for example 
```
addi x1, x0, 1
sub x2, x0, x1
addi x3, x1, x1
```

Next, run assembler to run command. It's require Dlang compiler dmd (you can install [here](https://dlang.org/download.html))
```
$ rdmd assm.d
```

Last, test binary code is generated in `test/test.txt`

## 2022/11/9 Version0.1 Type-R,I supported subset processor releaseed 
