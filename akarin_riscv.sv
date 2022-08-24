/*******************************************************************************
* AKARIN : Adaptive Kosher Architecture of RIsc processor Next
*                                   Copyright(C) 2013 Project YY
*******************************************************************************/

/******************************************************************* 
* akarin_riscv.sv
* xxx
*******************************************************************/

/******************************************************************* 
* port description
*
*******************************************************************/

`include "akarin.svh"

module akarin_riscv(
    input logic clk, rst,
    memory_bus.master instBus,
    memory_bus.master dataBus,
    output logic run
 );

    logic if_stop, mem_stop; 
    logic stall;
    

 endmodule