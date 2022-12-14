/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
*  InstFetch.sv
* 命令をフェッチしてくるステージ
* パイプラインハザードが発生した場合には、ストール時の出力をホールドレジスタに
* 保持しておく。
*******************************************************************/

/******************************************************************* 
* port description
*   clk, rst, stall : クロック, リセット, ストール信号
*   InstBus : 命令メモリとのバス、中身は次
*       addr_o          : メモリへの要求アドレス
*       dataD_o         : メモリへの書き込みデータ (ただし命令メモリに書き込むことはない)
*       dataQ_i         : メモリからの入力データ
*       read_o, write_o : read信号, write信号 (書き込みは行わないのでwrite信号は常に0)
*       ready_i         : メモリからのデータの到達を通知するフラグ
*       byteSel_o       : バイトセレクタ,命令は32ビット固定なので常にオール1
*   stop_o          : 命令が到達するまでパイプラインをストールさせる
*   dec2if_i        : デコードステージからの入力パケット
*   if2dec_o        : デコードステージへの出力パケット
*******************************************************************/

`include "include/akarin.svh"

module InstFetch(
    input   logic clk, rst,
    input   logic stall,
    output  logic stop_o,

    // connect to instruction bus
    memory_bus.master instBus,

    input   dec2ifPkt dec2if_i,
    output  if2decPkt if2dec_o
);
    
    dec2ifPkt dec2if_reg; // Pipeline register
    if2decPkt if2dec; // Raw result
    if2decPkt if2dec_holdReg; // Hold register
    logic if2dec_holdValid; // Hold register valid flag

    always_comb begin
        // Data path for external synchronous unit
        instBus.addr = (dec2if_i.pcValid ? dec2if_i.pc : 30'hx);
        instBus.dataD = 32'hx; // 使わないので適当な値
        instBus.read = dec2if_i.pcValid;
        instBus.write = 1'b0;
        instBus.byteSel = 4'b1111; // 読み出しは32ビット

        // Data path for internal combinational circuits
        if (if2dec_holdValid) begin
            if2dec_o = if2dec_holdReg;
        end else begin
            if2dec_o = if2dec;
        end

        if (instBus.ready) begin
            stop_o = 0;
        end else begin
            stop_o = dec2if_reg.pcValid && ~if2dec_holdValid;
        end
    end

    always_comb begin
        if (instBus.ready) begin
            // 命令キャッシュからデータが到達
            if2dec.pc = dec2if_reg.pc;
            if2dec.instValid = dec2if_reg.pcValid;
            if2dec.inst32 = instBus.dataQ;
        end else begin
            // ストール
            if2dec.pc = 30'h3fffffff;
            if2dec.instValid = 0;
            if2dec.inst32 = 32'h00000000;
        end
    end

    // Hold register
    always_ff @(posedge clk) begin
        if (!rst) begin
            if2dec_holdValid <= 0;
        end else begin
            if (stall) begin
                if (instBus.ready) begin
                    if2dec_holdValid <= 1;
                    if2dec_holdReg <= if2dec_o;
                end
            end else begin
                if2dec_holdValid <= 0;
            end
        end
    end

    // Pipeline register
    always_ff @(posedge clk) begin
        if (!rst) begin
            dec2if_reg <= 0;
        end else begin
            if (!stall) begin
                dec2if_reg <= dec2if_i;
            end
        end
    end
endmodule
