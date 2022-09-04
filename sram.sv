/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/


// 4k x 32ワードサイズのSRAM, 命令メモリ(キャッシュ)として利用
module sram_4kx32 (
    input logic clk,
    memory_bus.slave mbus
);
    parameter mem_words = 4096; // 4k

    reg [31:0] mem [mem_words-1:0];
    reg mbus_ready_delay;
    reg [31:0] mbus_dataQ_delay;

    // メモリから結果を読み出すのには遅延が発生する
    assign #10 mbus.ready = mbus_ready_delay;
    assign #10 mbus.dataQ = mbus_dataQ_delay;

    always @ (posedge clk) begin
        // メモリへの書き込み
        if (mbus.write) begin
            if (mbus.byteSel[0]) begin
                mem[mbus.addr][7:0] <= m.bus.dataD[7:0];
            end
            if (mbus.byteSel[1]) begin
                mem[mbus.addr][15:8] <= mbus.dataD[15:8];
            end
            if (mbus.byteSel[2]) begin
                mem[mbus.addr][23:16] <= mbus.dataD[23:16];
            end
            if (mbus.byteSel[3]) begin
                mem[mbus.addr][31:24] <= mbus.dataD[31:24];
            end
            mbus_dataQ_delay <= 'bx;
        end 
        // メモリからの読み出し
        else if (mbus.read) begin
            mbus_dataQ_delay <= mem[mbus.addr];
        end
        else begin
            mbus_dataQ_delay <= 'bx;
        end
        mbus_ready_delay <= (mbus.read | mbus.write);
    end
endmodule
