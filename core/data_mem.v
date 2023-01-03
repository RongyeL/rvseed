// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : data_mem.v
// Author        : Rongye
// Created On    : 2022-03-24 22:11
// Last Modified : 2022-04-20 19:25
// ---------------------------------------------------------------------------------
// Description   : Data memory 
//
//
// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module data_mem (
    input                       clk,

    input                       mem_wen,   // memory write enable
    input                       mem_ren,   // memory read enable
    input      [`CPU_WIDTH-1:0] mem_addr,  // memory write/ read address
    input      [`CPU_WIDTH-1:0] mem_wdata, // memory write data input
    output reg [`CPU_WIDTH-1:0] mem_rdata  // memory read data output
);
    
reg [`CPU_WIDTH-1:0] data_mem_f [0:`DATA_MEM_ADDR_DEPTH-1];

// memory write
always @(posedge clk) begin
    if (mem_wen) 
        data_mem_f[mem_addr[`DATA_MEM_ADDR_WIDTH+2-1:2]][31:0] <= mem_wdata;
end

// memory read
always @(*) begin
    if (mem_ren) 
        mem_rdata = data_mem_f[mem_addr[`DATA_MEM_ADDR_WIDTH+2-1:2]];

end

endmodule
