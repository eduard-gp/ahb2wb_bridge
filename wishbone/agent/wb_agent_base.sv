/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_agent_base.sv
// Short description: This is the paramemtrized class that every Wishbone agent should inherit.
/***********************************************************************************/ 

`ifndef WB_AGENT_BASE_SV
`define WB_AGENT_BASE_SV

virtual class wb_agent_base#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_agent;
    localparam string type_name = $sformatf("wb_agent_base#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);

    typedef wb_agent_config#(ADDR_WIDTH, DATA_WIDTH)  wb_config_t;
    typedef wb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) wb_item_t;
    typedef wb_driver_base#(wb_item_t)                wb_driver_t;
    typedef uvm_sequencer#(wb_item_t)                 wb_sequencer_t;
    typedef wb_monitor_base#(wb_item_t)               wb_monitor_t;

    wb_config_t     m_config;
    wb_driver_t     m_driver;
    wb_sequencer_t  m_sequencer;
    wb_monitor_t    m_monitor;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function string get_type_name();
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass: wb_agent_base

function wb_agent_base::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function string wb_agent_base::get_type_name();
    return type_name;
endfunction: get_type_name

function void wb_agent_base::build_phase(uvm_phase phase);
    wb_config_t config_handle;

    `uvm_info(get_type_name(), "build_phase()", UVM_MEDIUM)
    
    if (!uvm_config_db#(wb_config_t)::get(this, "", "config", config_handle))
        `uvm_fatal(get_type_name(), "Couldn't get config!")
    else if (config_handle == null)
        `uvm_fatal(get_type_name(), "Config is null!")
    else if (config_handle.vif == null)
        `uvm_fatal(get_type_name(), "vif is null!")
    m_config = new("m_config");
    m_config.copy(config_handle);

    uvm_config_db#(wb_config_t::wb_if_t)::set(this, "m_monitor", "vif", m_config.vif);    
    if (m_config.is_active == UVM_ACTIVE) begin
        uvm_config_db#(wb_config_t::wb_if_t)::set(this, "m_driver", "vif", m_config.vif);
    end
endfunction: build_phase

function void wb_agent_base::connect_phase(uvm_phase phase);
    if (m_config.is_active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
endfunction: connect_phase

`endif
