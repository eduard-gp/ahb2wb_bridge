/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_if.sv
// Short description: This file describes the connection medium with the Wishbone component.
/***********************************************************************************/ 

`ifndef WB_IF_SV
`define WB_IF_SV

interface wb_if#(int ADDR_WIDTH = 32, int DATA_WIDTH = 32) (input clk);
    logic rst;
    logic cyc;
    logic stb;
    logic we;
    logic ack;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] rdata;
    logic [DATA_WIDTH-1:0] wdata;
endinterface

`endif // WB_IF_SV
