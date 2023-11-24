/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_env_config.sv
// Short description: This class contains the configuration data that should be passed
// to the environmnet.
/***********************************************************************************/ 

`ifndef AHB2WB_ENV_CONFIG_SV
`define AHB2WB_ENV_CONFIG_SV

class ahb2wb_env_config#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_object;
    `uvm_object_param_utils(ahb2wb_env_config#(ADDR_WIDTH, DATA_WIDTH))

    localparam string type_name = $sformatf("ahb2wb_env_config#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);

    typedef wb_agent_config#(ADDR_WIDTH, DATA_WIDTH)                wb_agent_config_t;
    protected typedef ahb2wb_env_config#(ADDR_WIDTH, DATA_WIDTH)    this_type;

    wb_agent_config_t m_wb_agent_config;

    extern function new(string name = type_name);
    extern function void do_print(uvm_printer printer);
    extern function string convert2string();
    extern function void do_record(uvm_recorder recorder);
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string get_type_name();
endclass: ahb2wb_env_config

function ahb2wb_env_config::new(string name = type_name);
    super.new(name);

    m_wb_agent_config = new("m_wb_agent_config");
endfunction: new

function void ahb2wb_env_config::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_object(m_wb_agent_config.get_name(), m_wb_agent_config);
endfunction: do_print

function string ahb2wb_env_config::convert2string();
    return $sformatf("%s={%s}", m_wb_agent_config.get_name(), m_wb_agent_config.convert2string());
endfunction: convert2string

function void ahb2wb_env_config::do_record(uvm_recorder recorder);
    recorder.record_object(m_wb_agent_config.get_name(), m_wb_agent_config);
endfunction: do_record

function void ahb2wb_env_config::do_copy(uvm_object rhs);
    this_type tmp;
    $cast(tmp, rhs);
    super.do_copy(tmp);
    m_wb_agent_config.copy(tmp.m_wb_agent_config);
endfunction: do_copy

function bit ahb2wb_env_config::do_compare(uvm_object rhs, uvm_comparer comparer);
    this_type tmp;
    $cast(tmp, rhs);
    return super.do_compare(tmp, comparer) && m_wb_agent_config.compare(tmp.m_wb_agent_config);
endfunction: do_compare

function string ahb2wb_env_config::get_type_name();
    return type_name;
endfunction: get_type_name

`endif
