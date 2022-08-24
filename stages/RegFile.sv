/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* RISC-Vのレジスタファイルについて
*
*******************************************************************/

/******************************************************************* 
* port description
*
*******************************************************************/

module RegFile(
    input logic clk,
    input logic [4:0] rsNum_i, rtNum_i, rdNum_i,
    output logic [31:0] rsVal_o, rtVal_o,
    input logic [31:0] rdVali_i,
    input logic regWrite_i
);

    // 32ビットレジスタが31本,(0レジスタは予約されているため)
    reg [31:0] rf [31:1];

    always_ff @(posedge clk) begin
        if (regWrite_i) begin
            rf[rdNum_i] <= rdVal_
        end
        
    end

    // Synchronous read with internal forwarding
    always_ff @(posedge clk) begin
        if (rsNum_i == rdNum_i) begin
                rsVal_o <= rdVal_i;
        end else begin
            rtVal_o <= rf[rsNum_i];
        end
    end 

    always_ff @(posedge clk) begin
        if (rtNum_i == rdNum_i) begin
        end else begin
            frVali_o <= rt[rfNum_i];
        end
    end
    
endmodule