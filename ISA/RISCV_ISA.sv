/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

// AKARIN_RISCVではRV32I命令セットを利用
// Type-R,Type-I,Type-S,Type-B命令ではopcodeとfunctの組み合わせで命令を解釈
`define SIZE_OPCODE         7
`define SIZE_FUNCT3         3
`define SIZE_FUNCT7         7
`define SIZE_FUNCT12        12

/******************************************************************************/

// オペコード
// ベース命令セットでは下位2ビットは11で固定されているため上位5ビットのみで判別できる
`define OP_OP_IMM           7'b0010011  // 即値命令
`define OP_LUI              7'b0110111  // LUI命令
`define OP_AUIPC            7'b0010111  // AUIPC命令
`define OP_OP               7'b0110011  // 演算命令
`define OP_JAL              7'b1101111  // JAL命令
`define OP_JALR             7'b1100111  // JALR命令
`define OP_BRANCH           7'b1100011  // 分岐命令
`define OP_LOAD             7'b0000011  // LOAD命令
`define OP_STORE            7'b0100011  // STORE命令
`define OP_MISC_MEM         7'b0001111  // メモリ順序命令
`define OP_SYSTEM           7'b1110011  // 特権命令

/******************************************************************************/

// FUNCT3
// 即値命令とレジスタ演算命令で同じ演算を行う命令はFunct3フィールドが同じ
`define FN3_ADD_SUB         3'b000
`define FN3_SLT             3'b010
`define FN3_SLTU            3'b011
`define FN3_AND             3'b111
`define FN3_OR              3'b110
`define FN3_XOR             3'b100
`define FN3_SLL             3'b001
`define FN3_SR              3'b101


`define FN3_BEQ             3'b000
`define FN3_BNE             3'b001
`define FN3_BLT             3'b100
`define FN3_BLTU            3'b110
`define FN3_BGE             3'b101
`define FN3_BGEU            3'b111

`define FN3_LB              3'b000
`define FN3_LH              3'b001
`define FN3_LW              3'b010
`define FN3_LBU             3'b100
`define FN3_LHU             3'b101

`define FN3_SB              3'b000
`define FN3_SH              3'b001
`define FN3_SW              3'b010


`define FN3_FENCE           3'b111

`define FN3_PRIV            3'b000

/******************************************************************************/

// FUNCT7
// SRLI命令およびSRAI命令はIタイプの命令だがシフト量の指定には即値フィールド12ビットのうち
// 下位5ビットのみしか使用しないため例外的に残りの上位7ビットを利用して２つの命令の判別を行っている。
`define FN7_SRL             7'b0000000
`define FN7_SRA             7'b0100000

`define FN7_ADD             7'b0000000
`define FN7_SUB             7'b0100000

/******************************************************************************/

// FUNCT12
`define FN12_ECALL          12'b000000000000
`define FN12_EBREAK         12'b000000000001