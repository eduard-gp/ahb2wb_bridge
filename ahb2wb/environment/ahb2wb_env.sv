/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_env.sv
// Short description: This class encapsulates the logic to test the AHB-Wishbone bridge.
/***********************************************************************************/ 

`ifndef AHB2WB_ENV_SV
`define AHB2WB_ENV_SV

class ahb2wb_env#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_env;
    `uvm_component_param_utils(ahb2wb_env#(ADDR_WIDTH, DATA_WIDTH))

    localparam string type_name = $sformatf("ahb2wb_env#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);
    
    typedef ahb2wb_env_config#(ADDR_WIDTH, DATA_WIDTH)                      ahb2wb_config_t;
    typedef wb_standard_slave_agent#(ADDR_WIDTH, DATA_WIDTH)                wb_agent_t;
    typedef ahb2wb_scoreboard#(wb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))   ahb2wb_scoreboard_t;

    ahb2wb_config_t     m_config;
    wb_agent_t          m_wb_agent;
    ahb2wb_scoreboard_t m_scoreboard;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function string get_type_name();
endclass: ahb2wb_env

function ahb2wb_env::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function string ahb2wb_env::get_type_name();
    return type_name;
endfunction: get_type_name

function void ahb2wb_env::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "build_phase()", UVM_MEDIUM)

    if (!uvm_config_db#(ahb2wb_config_t)::get(this, "", "config", m_config))
        `uvm_fatal(get_type_name(), "Couldn't get config")

    uvm_config_db#(wb_agent_t::wb_config_t)::set(this, "m_wb_agent", "config", m_config.m_wb_agent_config);
    m_wb_agent = wb_agent_t::type_id::create("m_wb_agent", this);
    m_scoreboard = ahb2wb_scoreboard_t::type_id::create("m_scoreboard", this);
endfunction: build_phase

function void ahb2wb_env::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "connect_phase()", UVM_MEDIUM)
    m_wb_agent.m_monitor.m_analysis_port.connect(m_scoreboard.m_analysis_export);
endfunction: connect_phase

`endif
