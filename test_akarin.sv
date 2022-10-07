/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
*  test_akarin.sv
* テストモジュール
* テスト回路は論理合成する必要がないのでSystemVerilogの記述力を活かすことができる
*******************************************************************/

`timescale  1ns/100ps

module test;
    logic clk, rst;
    memory_bus instBus();
    memory_bus dataBus();

    initial begin
        clk = 0;
        rst = 0;

        // 3000x1nsで強制終了
        #30000 $finish;    
    end

    // Clock Generator (10MHz)
    always #50 clk = ~clk;


    akarin_riscv core (.clk, .rst, .instBus, .dataBus);

    sram_4kx32 inst_mem (.clk, .mbus(instBus));

    initial begin
        $readmemh ("test.txt", inst_mem.mem);
    end
endmodule
