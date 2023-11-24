/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_agent_config.sv
// Short description: This class encapulate the configuration that should be passed
// to a wishbone agent.
/***********************************************************************************/ 

`ifndef WB_AGENT_CONFIG_SV
`define WB_AGENT_CONFIG_SV

class wb_agent_config#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_object;
    `uvm_object_param_utils(wb_agent_config#(ADDR_WIDTH, DATA_WIDTH))

    localparam string type_name = $sformatf("wb_agent_config#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);

    typedef virtual wb_if#(ADDR_WIDTH, DATA_WIDTH)             wb_if_t;
    protected typedef wb_agent_config#(ADDR_WIDTH, DATA_WIDTH) this_type;

    wb_if_t                 vif;
    uvm_active_passive_enum is_active;
    bit                     coverage_enable;
    bit                     checks_enable;

    extern function new(string name = type_name);
    extern function void do_print(uvm_printer printer);
    extern function string convert2string();
    extern function void do_record(uvm_recorder recorder);
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string get_type_name();
endclass: wb_agent_config

function wb_agent_config::new(string name = type_name);
    super.new(name);
    is_active = UVM_ACTIVE;
    coverage_enable = 0;
    checks_enable = 0;
endfunction: new

function void wb_agent_config::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_generic("vif", $sformatf("vif#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH), 0, (vif == null) ? "null" : "valid");
    printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
    printer.print_field_int("coverage_enable", coverage_enable, $bits(coverage_enable));
    printer.print_field_int("checks_enable", checks_enable, $bits(checks_enable));
endfunction: do_print

function string wb_agent_config::convert2string();
    return $sformatf("vif=%s, is_active=%s, coverage_enable=%0b, checks_enable=%0b",
            (vif == null) ? "null" : "valid", is_active.name(), coverage_enable, checks_enable);
endfunction: convert2string

function void wb_agent_config::do_record(uvm_recorder recorder);
    recorder.record_generic("vif", (vif == null) ? "null" : "valid", $sformatf("vif#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH));
    recorder.record_generic("is_active", is_active.name(), "uvm_active_passive_enum");
    recorder.record_field_int("coverage_enable", coverage_enable, $bits(coverage_enable));
    recorder.record_field_int("checks_enable", checks_enable, $bits(checks_enable));
endfunction: do_record

function void wb_agent_config::do_copy(uvm_object rhs);
    this_type tmp;
    $cast(tmp, rhs);
    super.do_copy(tmp);
    vif = tmp.vif;
    is_active = tmp.is_active;
    coverage_enable = tmp.coverage_enable;
    checks_enable = tmp.checks_enable;
endfunction: do_copy

function bit wb_agent_config::do_compare(uvm_object rhs, uvm_comparer comparer);
    this_type tmp;
    $cast(tmp, rhs);
    return super.do_compare(tmp, comparer)
        && (vif == tmp.vif)
        && (is_active == tmp.is_active)
        && (coverage_enable == tmp.coverage_enable)
        && (checks_enable == tmp.checks_enable);
endfunction: do_compare

function string  wb_agent_config::get_type_name();
    return type_name;
endfunction: get_type_name

`endif // WB_AGENT_CONFIG_SV
