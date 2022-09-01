/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* RISC-Vのレジスタファイルについて
* 1. x0は常に0
* 2. 汎用レジスタはx1-31まで
* 3. RISC-Vのベース命令セットではレジスタの利用に関して制約を特に課していない
*       a. ただし一般的にx1はリターンアドレス用に
*       b. x2がスタックポインタ用に
*       c. x5はalternate link registerに利用されることが多い
* 4. 特殊用途のレジスタとしてPC記憶用のpcレジスタが存在
*******************************************************************/

/******************************************************************* 
* port description
*   clk         : クロック信号 
*   rs1Num_i     : 第1オペランドのレジスタ番号
*   rs2Num_i     : 第2オペランドのレジスタ番号
*   rdNum_i     : 書き込まれるレジスタの番号
*   rs1Val_o     : 第1オペランドの値
*   rs2Val_o     : 第2オペランドの値
*   rdVal_i     : レジスタへ書き込まれる値
*   regWrite_i  : 書き込み信号
*******************************************************************/

module RegFile(
    input logic clk,
    input logic [4:0] rs1Num_i, rs2Num_i, rdNum_i,
    output logic [31:0] rs1Val_o, rs2Val_o,
    input logic [31:0] rdVal_i,
    input logic regWrite_i
);

    // 32ビットレジスタが31本,(0レジスタは予約されているため)
    // 値がオーバーフローするのは嫌なのでアンパック配列
    reg [31:0] rf [31:1];

    always_ff @(posedge clk) begin
        if (regWrite_i) begin
            rf[rdNum_i] <= rdVal_i;
        end
    end

    // フォワーディングが可能ならフォワーディングを内部で行う
    always_ff @(posedge clk) begin
        if (rs1Num_i == rdNum_i) begin
            rs1Val_o <= rdVal_i;
        end else begin
            rs1Val_o <= rf[rs1Num_i];
        end
    end 
    always_ff @(posedge clk) begin
        if (rs2Num_i == rdNum_i) begin
            rs2Val_o <= rdVal_i;
        end else begin
            rs2Val_o <= rf[rs2Num_i];
        end
    end
endmodule