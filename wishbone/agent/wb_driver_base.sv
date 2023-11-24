/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_driver_base.sv
// Short description: This is the base parameterized class for a wishbone driver.
/***********************************************************************************/ 

`ifndef WB_DRIVER_BASE_SV
`define WB_DRIVER_BASE_SV

virtual class wb_driver_base#(type REQ = wb_sequence_item, type RSP = REQ) extends uvm_driver#(REQ, RSP);
    localparam string type_name = $sformatf("wb_driver_base#(%0d, %0d)", REQ::ADDR_WIDTH, REQ::DATA_WIDTH);

    typedef virtual wb_if#(REQ::ADDR_WIDTH, REQ::DATA_WIDTH)    wb_if_t;

    wb_if_t vif;
    REQ m_req;
    RSP m_rsp;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function string get_type_name();
    extern function void build_phase(uvm_phase phase);
    pure virtual task monitor_reset();
    pure virtual task drive();
endclass: wb_driver_base

function wb_driver_base::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void wb_driver_base::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(wb_if_t)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), "Couldn't get vif!")
endfunction: build_phase

function string wb_driver_base::get_type_name();
    return type_name;
endfunction: get_type_name

`endif // WB_DRIVER_BASE
