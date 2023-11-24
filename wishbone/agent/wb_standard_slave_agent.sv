/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_standard_slave_agent.sv
// Short description: This parametrized class contains the logic of a standard wishbone agent.
/***********************************************************************************/ 

`ifndef WB_STANDARD_SLAVE_AGENT_SV
`define WB_STANDARD_SLAVE_AGENT_SV

class wb_standard_slave_agent#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends wb_agent_base#(ADDR_WIDTH, DATA_WIDTH);
    `uvm_component_param_utils(wb_standard_slave_agent#(ADDR_WIDTH, DATA_WIDTH))

    localparam string type_name = $sformatf("wb_standard_slave_agent#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);

    typedef wb_standard_slave_driver#(wb_item_t) wb_driver_t;
    typedef wb_standard_monitor#(wb_item_t)      wb_monitor_t;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function uvm_active_passive_enum get_is_active();
    extern function string get_type_name();
endclass: wb_standard_slave_agent

function wb_standard_slave_agent::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void wb_standard_slave_agent::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "build_phase()", UVM_MEDIUM)
    
    super.build_phase(phase);

    m_monitor = wb_monitor_t::type_id::create("m_monitor", this);
    if (m_config.is_active == UVM_ACTIVE) begin
        m_driver = wb_driver_t::type_id::create("m_driver", this);
        m_sequencer = wb_sequencer_t::type_id::create("m_sequncer", this);
    end

    if (m_config.coverage_enable)
        `uvm_warning(get_type_name(), "Converage isn't implemented!")
    if (m_config.checks_enable)
        `uvm_warning(get_type_name(), "Checks aren't implemented")
endfunction: build_phase

function uvm_active_passive_enum wb_standard_slave_agent::get_is_active();
    return m_config.is_active;
endfunction: get_is_active

function string wb_standard_slave_agent::get_type_name();
    return type_name;
endfunction: get_type_name

`endif // WB_STANDARD_SLAVE_AGENT_SV
