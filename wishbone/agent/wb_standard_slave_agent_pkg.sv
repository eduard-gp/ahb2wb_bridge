/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_standard_slave_agent_pkg.sv
// Short description: This package encasulate all the class necessary to use the
// standard Wishbone agent.
/***********************************************************************************/ 

`ifndef WB_STANDARD_SLAVE_AGENT_PKG_SV
`define WB_STANDARD_SLAVE_AGENT_PKG_SV

package wb_standard_slave_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import wb_sequences_pkg::*;
    `include "wb_agent_config.sv"
    `include "wb_driver_base.sv"
    `include "wb_standard_slave_driver.sv"
    `include "wb_monitor_base.sv"
    `include "wb_standard_monitor.sv"
    `include "wb_agent_base.sv"
    `include "wb_standard_slave_agent.sv"
endpackage: wb_standard_slave_agent_pkg

`endif // WB_STANDARD_SLAVE_AGENT_PKG_SV
