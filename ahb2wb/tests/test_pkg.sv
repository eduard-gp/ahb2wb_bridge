/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: tests_pkg.sv
// Short description: This packet was created to containt all the tests that are
// design to test the bridge.
/***********************************************************************************/ 

`ifndef TESTS_PKG_SV
`define TESTS_PKG_SV

package tests_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import test_params_pkg::*;
    import ahb2wb_env_pkg::*;
    import wb_sequences_pkg::*;
    `include "ahb2wb_test_base.sv"
    `include "ahb2wb_simple_read_test.sv"
endpackage: tests_pkg

`endif // TESTS_PKG_SV
