/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_monitor_base.sv
// Short description: This is the base parameterized class that every wishbone monitor extends.
/***********************************************************************************/ 

`ifndef WB_MONITOR_BASE_SV
`define WB_MONITOR_BASE_SV

virtual class wb_monitor_base#(type ITEM = wb_sequence_item) extends uvm_monitor;
    localparam string type_name = $sformatf("wb_monitor_base#(%s)", ITEM::type_name);

    typedef virtual wb_if#(ITEM::ADDR_WIDTH, ITEM::DATA_WIDTH) wb_if_t;

    uvm_analysis_port#(ITEM)    m_analysis_port;
    wb_if_t                     vif;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function string get_type_name();
    extern function void build_phase(uvm_phase phase);
    pure virtual task monitor();
endclass: wb_monitor_base

function wb_monitor_base::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function string wb_monitor_base::get_type_name();
    return type_name;
endfunction: get_type_name

function void wb_monitor_base::build_phase(uvm_phase phase);
    if (!uvm_config_db#(wb_if_t)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), "Couldn't get vif!")
    m_analysis_port = new("m_analysis_port", this);
endfunction: build_phase

`endif
