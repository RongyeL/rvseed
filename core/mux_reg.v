// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : mux4reg.v
// Author        : Rongye
// Created On    : 2022-03-25 02:08
// Last Modified : 2022-04-20 19:26
// ---------------------------------------------------------------------------------
// Description   : Select the data source of reg_file.  
//
//
// -FHDR----------------------------------------------------------------------------
`include "rvseed_defines.v"

module mux_reg ( 
    input                          mem2reg,   // memory or ALU to register

    input      [`CPU_WIDTH-1:0]    alu_res,   // alu result input
    input      [`MEM_OP_WIDTH-1:0] mem_op,    // memory opcode
    input      [`CPU_WIDTH-1:0]    mem_addr,  // memory write/read address
    input      [`CPU_WIDTH-1:0]    mem_rdata, // memory read data input

    output reg [`CPU_WIDTH-1:0]    reg_wdata  // register write data output
);

reg [7:0]  mem_byte;     //memory read byte
reg [15:0] mem_halfword; // memory read half word
reg [31:0] mem_word;     // memory read word
    
always @(*) begin
    if (mem2reg == `ALU2REG)
        reg_wdata = alu_res;
    else
        case (mem_op)
            `MEM_LB: begin
                case (mem_addr[1:0])
                    2'h0: mem_byte = mem_rdata[7:0];
                    2'h1: mem_byte = mem_rdata[15:8];
                    2'h2: mem_byte = mem_rdata[23:16];
                    2'h3: mem_byte = mem_rdata[31:24];
                endcase
                reg_wdata = {{24{mem_byte[7]}},mem_byte};
            end
            `MEM_LH: begin
                case (mem_addr[1])
                    1'h0: mem_halfword = mem_rdata[15:0];
                    1'h1: mem_halfword = mem_rdata[31:16];
                endcase
                reg_wdata = {{16{mem_halfword[15]}},mem_halfword};
            end
            `MEM_LW: begin
                mem_word  = mem_rdata[31:0];
                reg_wdata = mem_word;
            end 
            `MEM_LBU: begin
                case (mem_addr[1:0])
                    2'h0: mem_byte = mem_rdata[7:0];
                    2'h1: mem_byte = mem_rdata[15:8];
                    2'h2: mem_byte = mem_rdata[23:16];
                    2'h3: mem_byte = mem_rdata[31:24];                
                endcase
                reg_wdata = {24'b0,mem_byte};
            end
            `MEM_LHU: begin
                case (mem_addr[1])
                    1'h0: mem_halfword = mem_rdata[15:0];
                    1'h1: mem_halfword = mem_rdata[31:16];
                endcase
                reg_wdata = {16'b0,mem_halfword};
            end
            default:
                reg_wdata = mem_rdata;
        endcase
end
endmodule
