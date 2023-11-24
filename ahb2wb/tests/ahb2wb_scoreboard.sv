/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_scoreboard.sv
// Short description: This class should compute the score for a test.
/***********************************************************************************/ 

`ifndef AHB2WB_SCOREBOARD_SV
`define AHB2WB_SCOREBOARD_SV

class ahb2wb_scoreboard#(type ITEM = wb_sequence_item) extends uvm_scoreboard;
    `uvm_component_param_utils(ahb2wb_scoreboard#(ITEM))

    localparam string type_name = $sformatf("ahb2wb_scoreboard#(%s)", ITEM::type_name);

    uvm_analysis_imp#(ITEM, ahb2wb_scoreboard#(ITEM)) m_analysis_export;

    extern function new(string name = type_name, uvm_component parent);
    extern function string get_type_name();
    extern function void build_phase(uvm_phase phase);
    extern virtual function void write(ITEM item);
endclass: ahb2wb_scoreboard

function ahb2wb_scoreboard::new(string name = type_name, uvm_component parent);
    super.new(name, parent);
endfunction: new

function string ahb2wb_scoreboard::get_type_name();
    return type_name;
endfunction: get_type_name

function void ahb2wb_scoreboard::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "build_phase()", UVM_MEDIUM)
    m_analysis_export = new("m_analysis_export", this);
endfunction: build_phase

function void ahb2wb_scoreboard::write(ITEM item);
    `uvm_info(get_type_name(), item.convert2string(), UVM_MEDIUM)
endfunction: write

`endif // AHB2WB_SCOREBOARD_SV
