/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* akarin_riscv.sv
* akarin_riscv is open-source RISC-V simple processor.
* This processor is consisted of 4-stage pipelines, 
* that is InstFetch, InstDecode, Excution, Mem stage.
* It written for study pipeline processor and SystemVerilog.
*******************************************************************/

/******************************************************************* 
* port description
*  
*******************************************************************/

`include "akarin.svh"

module akarin_riscv(
   input logic clk, rst,
   memory_bus.master instBus,
   memory_bus.master dataBus
   // output logic run
 );

   logic if_stop, mem_stop; 
   logic stall;
   if2decPkt if2dec;
   dec2ifPkt dec2if;
   dec2exPkt dec2ex;
   ex2memPkt ex2mem;

   assign stall = if_stop | mem_stop;

   InstFetch ifu (
      .clk, .rst, .stall,
      .instBus,
      .stop_o  (if_stop),
      .dec2if_i   (dec2if),
      .if2dec_o   (if2dec)
   );

   InstDec decu (
      .clk, .rst, .stall,
      .if2dec_i   (if2dec),
      .dec2if_o   (dec2if),
      .dec2ex_o   (dec2ex),
      .ex2mem_i   (ex2mem),
      .mem2wb_i   (mem2wb)
   );

   ALU exu (
      .clk, .rst, .stall,
      .dec2ex_i   (dec2ex),
      .ex2mem_o   (ex2mem)
   );
 endmodule