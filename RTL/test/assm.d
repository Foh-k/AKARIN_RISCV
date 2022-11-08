/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

import std;

string assemble(string s)
{
    string ret;

    // 命令は一行で記述して次のフォーマット
    // TYPE-R
    //      INST RegD, Reg1, Reg2
    // TYPE-I
    //      INST RegD, Reg1, IMM
    auto p = s.map!"a.toUpper()".substitute(',', ' ').array.split().array();
    foreach (ref e; p[1 .. $])
        e = e[0].isNumber ? e : e[1 .. $];

    enum TYPES
    {
        R,
        I,
        S,
        B,
        U,
        J
    }

    TYPES t;
    // p[0] = inst, p[1] = RegD, p[2] = Reg1, p[3] = Reg2,IMM
    auto rd = format("%05b", p[1].parse!int());
    // Type-Uが20ビット
    auto rs1 = format("%020b", parse!int(p[2]));
    // Type-Iが12ビット
    auto rs2 = format("%012b", parse!int(p[3]));
    string opcode, fn3, fn7, imm12, imm20;

    switch (p[0])
    {
    case "LUI":
        break;
    
    case "AUIPC":
        break;

    case "JAL":
        break;

    case "JALR":
        break;

    case "BEQ":
        break;

    case "BNE":
        break;

    case "BLT":
        break;

    case "BGE":
        break;

    case "BLTU":
        break;

    case "BGEU":
        break;

    case "LB":
        break;

    case "LH":
        break;

    case "LW":
        break;

    case "LBU":
        break;

    case "LHU":
        break;
    
    case "SB":
        break;
    
    case "SH":
        break;

    case "SW":
        break;

    case "ADDI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "000";
        break;

    case "SLTI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "010";
        break;

    case "SLTIU":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "011";
        break;
    
    case "XORI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "100";
        break;

    case "ORI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "110";
        break;

    case "ANDI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = rs2;
        fn3 = "111";
        break;

    case "SLLI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = "0000000" ~ rs2[($ - 5) .. $];
        fn3 = "001";
        break;

    case "SRLI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = "0000000" ~ rs2[($ - 5) .. $];
        fn3 = "101";
        break;

    case "SRAI":
        t = TYPES.I;
        opcode = "0010011";
        imm12 = "0100000" ~ rs2[($ - 5) .. $];
        fn3 = "101";
        break;

    case "ADD":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "000";
        fn7 = "0000000";
        break;

    case "SUB":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "000";
        fn7 = "0100000";
        break;

    case "SLL":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "001";
        fn7 = "0000000";
        break;

    case "SLT":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "010";
        fn7 = "0000000";
        break;

    case "SLTU":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "011";
        fn7 = "0000000";
        break;

    case "XOR":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "100";
        fn7 = "0000000";
        break;

    case "SRL":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "101";
        fn7 = "0000000";
        break;

    case "SRA":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "101";
        fn7 = "0100000";
        break;

    case "OR":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "110";
        fn7 = "0000000";
        break;

    case "AND":
        t = TYPES.R;
        opcode = "0110011";
        fn3 = "111";
        fn7 = "0000000";
        break;

    // AKARIN-RISCVではちゃんとサポートしてない
    case "FENCE", "ECALL", "EBREAK":
        break;

    default:
        // 存在しない命令
        assert(0);
    }

    // assert(opcode.length == 7);
    // assert(fn3.length == 3);
    // assert(fn7.length == 7);

    switch (t)
    {
    case TYPES.R:
        ret = fn7 ~ rs2[($ - 5) .. $] ~ rs1[($ - 5) .. $] ~ fn3 ~ rd ~ opcode;
        break;
    case TYPES.I:
        ret = imm12 ~ rs1[($ - 5) .. $] ~ fn3 ~ rd ~ opcode;
        break;
    case TYPES.S:
        // あとで書く
        break;
    case TYPES.B:
        // あとで書く
        break;
    case TYPES.U:
        // あとで書く
        break;
    case TYPES.J:
        // あとで書く
        break;
    default:
        assert(0);
    }

    return ret;
}

// run local
void main()
{
    auto f_r = File("test.asm", "r");
    auto f_w = File("test.txt", "w");

    string s;
    while ((s = f_r.readln()) !is null)
    {
        // 空行とコメントを読み飛ばし
        if (s[0] == '#' || s.dup().uniq().array().length <= 2)
            continue;
        f_w.writeln(assemble(s));
    }
}