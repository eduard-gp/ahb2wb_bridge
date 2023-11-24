/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_test_base.sv
// Short description: This is the base class that should be inherited by every test.
/***********************************************************************************/ 

`ifndef AHB2WB_TEST_BASE_SV
`define AHB2WB_TEST_BASE_SV

virtual class ahb2wb_test_base extends uvm_test;
    localparam string type_name = "ahb2_test_base";

    typedef virtual wb_if#(TEST_WB_ADDR_WIDTH, TEST_WB_DATA_WIDTH)      wb_if_t;
    typedef ahb2wb_env_config#(TEST_WB_ADDR_WIDTH, TEST_WB_DATA_WIDTH)  config_t;
    typedef ahb2wb_env#(TEST_WB_ADDR_WIDTH, TEST_WB_DATA_WIDTH)         ahb2wb_env_t;

    wb_if_t             wb_vif;
    config_t            m_config;
    ahb2wb_env_t        m_env;

    extern function new(string name = type_name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function string get_type_name();
endclass: ahb2wb_test_base

function ahb2wb_test_base::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void ahb2wb_test_base::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "build_phase()", UVM_MEDIUM)

    if (!uvm_config_db#(wb_if_t)::get(this, "", "wb_vif", wb_vif))
        `uvm_fatal(get_type_name(), "Couldn't get wb_vif! Check that the context and parametrization are correct!")

    m_env = ahb2wb_env_t::type_id::create("m_env", this);
    m_config = new("m_config");
    m_config.m_wb_agent_config.vif = wb_vif;
    uvm_config_db#(config_t)::set(this, m_env.get_name(), "config", m_config);
endfunction: build_phase

function string ahb2wb_test_base::get_type_name();
    return type_name;
endfunction: get_type_name

`endif // AHB2WB_TEST_BASE_SV
