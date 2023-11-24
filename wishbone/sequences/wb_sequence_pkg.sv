/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_sequences_pkg.sv
// Short description: This packet encapsulates the necessary sequence to start a transcation.
/***********************************************************************************/ 

`ifndef WB_SEQUENCES_PKG_SV
`define WB_SEQUENCES_PKG_SV

package wb_sequences_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "wb_sequence_item.sv"
    `include "wb_sequence_base.sv"
endpackage: wb_sequences_pkg

`endif // WB_SEQUENCES_PKG_SV
