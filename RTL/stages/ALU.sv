/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* port description
* 
*******************************************************************/

`include "../include/akarin.svh"

module ALU(
    input logic clk, rst,
    input logic stall,
    input dec2exPkt dec2ex_i,
    output ex2memPkt ex2wb_o
);
    dec2exPkt dec2ex_reg; // Pipelineregister

    always_comb begin
        ex2wb_o = 'bx;
        ex2wb_o.pc = dec2ex_reg.pc;
        ex2wb_o.inst32 = dec2ex_reg.inst32;
        ex2wb_o.instValid = dec2ex_reg.instValid;
        
        if (dec2ex_reg.aluOp == ALU_NOP) begin
            ex2wb_o.destReg = 5'h0;
        end begin
            ex2wb_o.destReg = dec2ex_reg.destReg;
        end

        if (dec2ex_reg.instValid) begin
            `define RES  ex2wb_o.res
            `define SRC1 dec2ex_reg.src1
            `define SRC2 dec2ex_reg.src2

            case (dec2ex_reg.aluOp)
                ALU_ADD :
                    `RES = `SRC1 + `SRC2;
                ALU_SUB :
                    `RES = `SRC1 - `SRC2;
                ALU_AND :
                    `RES = `SRC1 & `SRC2;
                ALU_OR  :
                    `RES = `SRC1 | `SRC2;
                ALU_XOR :
                    `RES = `SRC1 ^ `SRC2;
                ALU_LUI :
                    // 
                ALU_SLT :
                    `RES = ((`SRC1[31] == `SRC2[31]) ?
                                (`SRC1 < `SRC2 ? 1 : 0) : (`SRC1[31]));
                ALU_SLTU :
                    `RES = (`SRC1 < `SRC2) ? 1 : 0;
                ALU_SLL :
                    `RES = `SRC1 << `SRC2;
                ALU_SRL :
                    `RES = `SRC1 >> `SRC2;
                ALU_SRA :
                    `RES = `SRC1 >>> `SRC2;
                default :
                    `RES = 32'hx;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (!rst) begin
            dec2ex_reg <= 0;
        end else begin
            if (!stall) begin
                dec2ex_reg <= dec2ex_i;
            end
        end
    end
endmodule
