/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* akarin.svh
*   コア内で利用する構造体、共用体の定義
*******************************************************************/

// デコードステージからフェッチステージへのパケット
typedef struct packed {
    logic [31:2] pc;
    logic pcValid;
} dec2ifPkt;

// フェッチステージからデコードステージへのパケット
typedef struct packed {
    logic [31:2] pc;
    logic [31:0] inst32;
    logic instValid;
} if2decPkt;