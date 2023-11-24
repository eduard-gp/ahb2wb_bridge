/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: test_params_pkg.sv
// Short description: This package is used to pass global information to tests.
/***********************************************************************************/ 

`ifndef TEST_PARAM_PKG_SV
`define TEST_PARAM_PKG_SV

package test_params_pkg;
    localparam TEST_WB_ADDR_WIDTH = 16;
    localparam TEST_WB_DATA_WIDTH = 32;
endpackage: test_params_pkg

`endif
