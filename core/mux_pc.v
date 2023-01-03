// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_next.v
// Author        : Rongye
// Created On    : 2022-03-21 22:56
// Last Modified : 2022-04-22 19:49
// ---------------------------------------------------------------------------------
// Description   : Determine the update value of the pc. 
//
//
// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module mux_pc (
    input                        ena,
    input      [`BRAN_WIDTH-1:0] branch,     // branch type 
    input                        zero,       // alu result is zero
    input      [`JUMP_WIDTH-1:0] jump,       // jump type 
    input      [`CPU_WIDTH-1:0]  reg1_rdata, // register 1 read data
    input      [`CPU_WIDTH-1:0]  imm,        // immediate  

    input      [`CPU_WIDTH-1:0]  curr_pc,    // current pc addr
    output reg [`CPU_WIDTH-1:0]  next_pc     // next pc addr
    );

always @(*) begin
    if (~ena) 
        next_pc = curr_pc;
    else if ((branch == `BRAN_TYPE_A) &&  zero) // beq/bge/bgeu : branch if the zero flag is high.
        next_pc = curr_pc + imm;
    else if ((branch == `BRAN_TYPE_B) && ~zero) // bne/blt/bltu : branch if the zero flag is low.
        next_pc = curr_pc + imm;
    else if (jump == `JUMP_JAL)                 // jal 
        next_pc = curr_pc + imm;
    else if (jump == `JUMP_JALR)                // jalr 
        next_pc = reg1_rdata + imm;
    else 
        next_pc = curr_pc + `CPU_WIDTH'h4;      // pc + 4  
end
endmodule
