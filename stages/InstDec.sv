/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
*  InstDec.sv
* 命令をデコードするステージ
* 内部にレジスタファイルを持つ
* RISC-Vには6つの命令タイプがありそれぞれR,I,S,B,U,Jタイプに分類される
*
* RV32I Base Instructin Setをサポート
* NOP命令はADDI x0, x0, 0でエンコードされる
*******************************************************************/

/******************************************************************* 
* port description
*
*******************************************************************/

module InstDec(
    input logic clk, rst,
    input logic stall,
    input if2decPkt if2dec_i,
    output dec2ifPkt dec2if_o,
    output dec2exPkt dec2ex_o,
    // ...
);

    // 符号拡張フラグ
    typedef enum logic { T, F } signExt_t;

    if2decPkt if2dec_reg; // Pipeline register
    logic [31:0] rsVal_rf, rtVal_fr; // レジスタファイルからの値
    logic [31:0] rsVal_fwd, rtVal_fwd; // フォワーディングデータ
    // dec_op_t decOp;
    signExt_t signExt;
    logic [31:2] pc, nextPc;
    logic [1:0] initCtr; // ?
    logic run;

    // レジスタファイルのインスタンス化
    RegFile rfu(
        // 
    );

    always_comb begin
        dec2if_o = 'bx;
        // これはあとでちゃんと書く必要があるのでは？
        dec2if_o.pc = nextPc;
        dec2if_o.pcValid = ~stall;
    end

    
endmodule