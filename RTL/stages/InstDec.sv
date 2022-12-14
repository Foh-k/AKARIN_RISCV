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
*
* pcの計算もこのステージで行う(計算結果のexステージからのフォワーディング)
*******************************************************************/

/******************************************************************* 
* port description
* clk       : クロック
* rst       : リセット信号,pcもリセットする
* stall     : ストール信号
* if2dec_i  : IFステージからのパケット
* dec2if_o  : ifステージへのパケット,次のPC
* ex2mem_i  : 実行ステージからのライトバックパケット
*******************************************************************/

`include "include/akarin.svh"

module InstDec(
    input logic clk, rst,
    input logic stall,
    input if2decPkt if2dec_i,
    output dec2ifPkt dec2if_o,
    output dec2exPkt dec2ex_o,
    input ex2wbPkt ex2wb_i
);

    if2decPkt if2dec_reg; // Pipeline register
    logic [31:0] rs1Val_rf, rs2Val_rf; // レジスタファイルからの値
    logic [31:0] rs1Val, rs2Val; // フォワーディングも考慮した実際に利用する値
    logic [31:2] pc, nextPc; // 下位2ビットは0

    // レジスタファイルのインスタンス化
    RegFile rfu(
        .clk,
        .rs1Num_i (if2dec_i.inst32[19:15]),
        .rs2Num_i (if2dec_i.inst32[24:20]),
        .rs1Val_o (rs1Val_rf),
        .rs2Val_o (rs2Val_rf),
        .rdNum_i (ex2wb_i.destReg),
        .rdVal_i (ex2wb_i.res),
        .regWrite_i (ex2wb_i.instValid)
    );

    always_comb begin
        // IFステージへの書き戻しパケット(PC)
        dec2if_o = 'bx;
        dec2if_o.pc = nextPc;
        dec2if_o.pcValid = ~stall;

        // 出力パケットの初期化
        dec2ex_o.pc         = if2dec_reg.pc;
        dec2ex_o.inst32     = if2dec_reg.inst32;
        dec2ex_o.instValid  = if2dec_reg.instValid;
        dec2ex_o.destReg    = 'bx;
        dec2ex_o.src1       = 'bx;
        dec2ex_o.src2       = 'bx;

        dec2ex_o.aluOp      = 0;

        case (if2dec_reg.inst32[6:0])
            // 演算命令 : Type-R
            `OP_OP : begin
                // Type-R命令で共通
                dec2ex_o.destReg = if2dec_reg.inst32[11:7];
                dec2ex_o.src1 = rs1Val;
                dec2ex_o.src2 = rs2Val;

                // RV32IのタイプR命令はADD,SUB,SRL,SRA以外はFunct3で判別
                case (if2dec_reg.inst32[14:12])
                    `FN3_ADD_SUB : begin
                        case (if2dec_reg.inst32[31:25])
                            `FN7_ADD : begin
                                dec2ex_o.aluOp = ALU_ADD;
                            end
                            
                            `FN7_SUB : begin
                                dec2ex_o.aluOp = ALU_SUB;    
                            end
                        endcase
                    end

                    `FN3_SLT : begin
                        dec2ex_o.aluOp = ALU_SLT;
                    end

                    `FN3_SLTU : begin
                        dec2ex_o.aluOp = ALU_SLTU;
                    end

                    `FN3_AND : begin
                        dec2ex_o.aluOp = ALU_AND;
                    end

                    `FN3_OR : begin
                        dec2ex_o.aluOp = ALU_OR;
                    end

                    `FN3_XOR : begin
                        dec2ex_o.aluOp = ALU_XOR;
                    end

                    `FN3_SLL : begin
                        dec2ex_o.aluOp = ALU_SLL;
                    end

                    `FN3_SR : begin
                        case (if2dec_reg.inst32[31:25])
                            `FN7_SRL : begin
                                dec2ex_o.aluOp = ALU_SRL;
                            end
                                
                            `FN7_SRA : begin
                                dec2ex_o.aluOp = ALU_SRA;
                            end
                        endcase
                    end
                endcase        
            end
            // 即値命令 : Type-I
            `OP_OP_IMM : begin
                // Type-I命令で共通
                // RISC-VではCSR以外の即値は常に符号拡張される
                dec2ex_o.destReg = if2dec_reg.inst32[11:7];
                dec2ex_o.src1 = rs1Val;

                // RV32IのタイプR命令はADD,SUB,SRL,SRA以外はFunct3で判別
                case (if2dec_reg.inst32[14:12])
                    `FN3_ADD_SUB : begin
                        case (if2dec_reg.inst32[31:25])
                            `FN7_ADD : begin
                                dec2ex_o.aluOp = ALU_ADD;
                                dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                            end
                            
                            `FN7_SUB : begin
                                dec2ex_o.aluOp = ALU_SUB; 
                                dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};   
                            end
                        endcase
                    end

                    `FN3_SLT : begin
                        dec2ex_o.aluOp = ALU_SLT;
                        dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                    end

                    `FN3_SLTU : begin
                        dec2ex_o.aluOp = ALU_SLTU;
                        dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                    end

                    `FN3_AND : begin
                        dec2ex_o.aluOp = ALU_AND;
                        dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                    end

                    `FN3_OR : begin
                        dec2ex_o.aluOp = ALU_OR;
                        dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                    end

                    `FN3_XOR : begin
                        dec2ex_o.aluOp = ALU_XOR;
                        dec2ex_o.src2 = {{16{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[31:20]};
                    end

                    `FN3_SLL : begin
                        dec2ex_o.aluOp = ALU_SLL;
                        dec2ex_o.src2 = {{27{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[24:20]};
                    end

                    `FN3_SR : begin
                        case (if2dec_reg.inst32[31:25])
                            `FN7_SRL : begin
                                dec2ex_o.aluOp = ALU_SRL;
                                dec2ex_o.src2 = {{27{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[24:20]};
                            end
                                
                            `FN7_SRA : begin
                                dec2ex_o.aluOp = ALU_SRA;
                                dec2ex_o.src2 = {{27{if2dec_reg.inst32[31]}}, if2dec_reg.inst32[24:20]};
                            end
                        endcase
                    end
                endcase
            end
        endcase
    end

    // Forwarding
    always_comb begin
        // src1がx0
        if (if2dec_reg.inst32[19:15] == 5'h0) begin
            rs1Val = 32'h0;
        end else begin
            // 演算結果のアドレスとrs1が一致
            if (if2dec_reg.inst32[19:15] == ex2wb_i.destReg) begin
                rs1Val = ex2wb_i.res;
            end else begin
                rs1Val = rs1Val_rf;
            end
        end

        // src2がx0
        if (if2dec_reg.inst32[24:20] == 5'h0) begin
            rs2Val = 32'h0;
        end else begin
            // 演算結果のアドレスとrs2が一致
            if (if2dec_reg.inst32[24:20] == ex2wb_i.destReg) begin
                rs2Val = ex2wb_i.res;
            end else begin
                rs2Val = rs2Val_rf;
            end
        end
    end

    // 次のPCを計算
    always_comb begin
        if (stall) begin
            nextPc = pc;
        end else begin
            nextPc = pc + 1;
        end
    end

    // PC更新
    always_ff @ (posedge clk) begin
        if (!rst) begin
            pc <= -1;
        end else begin
            pc <= nextPc;
        end
    end

    // パイプライン受け渡し
    always_ff @(posedge clk) begin
        if (!rst) begin
            if2dec_reg <= 0;
        end else begin
            if (!stall) begin
                if2dec_reg <= if2dec_i;
            end
        end
    end
endmodule
