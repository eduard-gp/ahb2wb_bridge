/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_env_pkg.sv
// Short description: This package encapsulates the necessary classes to use the 
// AHB-Wishbone environment.
/***********************************************************************************/ 

`ifndef AHB2WB_ENV_PKG_SV
`define AHB2WB_ENV_PKG_SV

package ahb2wb_env_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import wb_standard_slave_agent_pkg::*;
    import wb_sequences_pkg::*;
    `include "ahb2wb_env_config.sv"
    `include "ahb2wb_scoreboard.sv"
    `include "ahb2wb_env.sv"
endpackage: ahb2wb_env_pkg

`endif // AHB2WB_ENV_PKG_SV
