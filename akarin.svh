/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* akarin.svh
*   コア内で利用する構造体、共用体の定義
*******************************************************************/

// ALU Control信号
typedef enum logic [7:0] { 
    ALU_NOP = 0,    // NOPはADDI
    ALU_ADD,        // ADD, ADDI, ADDU, ADDUI
    ALU_SUB,        // SUB, SUBU
    ALU_AND,        // AND, ANDI
    ALU_OR,         // OR, ORI
    ALU_XOR,        // XOR, XORI
    ALU_NOR,        // NOR
    ALU_LUI,        // LUI
    ALU_SLT,        // SLT, SLTI
    ALU_SLTU,       // SLTU, SLTIU
    ALU_SLL,        // SLL, SLLI
    ALU_SRL,        // SRL, SRLI
    ALU_SRA        // SRA, SRAI
} alu_op_t;

typedef enum logic [7:0] { 
    DEC_NOP = 0
} dec_op_t;

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

// デコードステージからフェッチステージへのパケット
typedef struct packed {
    logic [31:2] pc;
    logic [31:0] inst32;
    logic        instValid;
    alu_op_t aluOp;
    logic [4:0] destReg;
    logic [31:0] src1, src2;
} dec2exPkt;

typedef struct packed {
    logic [31:2] pc;
    logic [31:0] inst32;
    logic instValid;

    logic [4:0] destReg;
    logic [31:0] res, aux;
} ex2memPkt;

typedef struct packed {
    logic [31:2] pc;
    logic [31:0] inst32;
    logic instValid;
    logic [4:0] destReg;
    logic [31:0] res;
} mem2wbPkt;