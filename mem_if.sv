/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* mem_if.sv
* メモリ(キャッシュ)とやり取りをするためのインターフェースの定義
*******************************************************************/

/******************************************************************* 
* port description
*    addr    : 読み出し/書き込みアドレス.下位2ビットは0固定なので切り捨て
*    dataD   : メモリへの書き込みデータ
*    dataQ   : メモリからの読み出しデータ
*    read    : 1のとき読み出し
*    write   : 1のとき書き込み
*    ready   : readyフラグ
*    byteSel : 値の書き込みバイトを指定する
*******************************************************************/

interface memory_bus();
    logic [31:2] addr;
    logic [31:0] dataD;
    logic [31:0] dtaQ;
    logic read, write;
    logic ready;
    logic [3:0] byteSel;

    modport master (
        output addr,
        output dataD,
        input dataQ,
        output read, write,
        input ready,
        output byteSel
    );

    modport slave (
        input addr, 
        input dataD,
        output dataQ,
        input read, write,
        output ready,
        input byteSel
    );
endinterface