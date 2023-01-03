// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : mux_mem.v
// Author        : Rongye
// Created On    : 2022-03-28 22:35
// Last Modified : 2022-04-20 19:19
// ---------------------------------------------------------------------------------
// Description   : Select the data source of mem.  
//
//
// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module mux_mem (
    input      [`MEM_OP_WIDTH-1:0] mem_op, // memory opcode
    input      [`CPU_WIDTH-1:0]    mem_addr, // memory write/read address
    input      [`CPU_WIDTH-1:0]    reg2_rdata,
    input      [`CPU_WIDTH-1:0]    mem_rdata,

    output reg [`CPU_WIDTH-1:0]    mem_wdata
);

always @(*) begin
    case (mem_op)
        `MEM_SB:
            case (mem_addr[1:0])
                2'h0: mem_wdata = {mem_rdata[31:8],  reg2_rdata[7:0]};
                2'h1: mem_wdata = {mem_rdata[31:16], reg2_rdata[7:0], mem_rdata[7:0]};
                2'h2: mem_wdata = {mem_rdata[31:24], reg2_rdata[7:0], mem_rdata[15:0]};
                2'h3: mem_wdata = {reg2_rdata[7:0],  mem_rdata[23:0]};
            endcase
        `MEM_SH:
            case (mem_addr[1])
                1'h0: mem_wdata = {mem_rdata[31:16], reg2_rdata[15:0]};
                1'h1: mem_wdata = {reg2_rdata[15:0], mem_rdata[15:0]};
            endcase
        `MEM_SW:
                mem_wdata = reg2_rdata;
        default:; // ? 
    endcase
end

endmodule
