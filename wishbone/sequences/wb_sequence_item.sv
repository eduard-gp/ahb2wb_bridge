/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_sequence_item.sv
// Short description: This parameterized class encapsulates the data necessary to
// represent a transactio packet
/***********************************************************************************/ 

`ifndef WB_SEQUENCE_ITEM_SV
`define WB_SEQUENCE_ITEM_SV


class wb_sequence_item#(ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_sequence_item;
    `uvm_object_param_utils(wb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))

    localparam string type_name = $sformatf("wb_sequence_item#(%0d, %0d)", ADDR_WIDTH, DATA_WIDTH);

    typedef enum bit [1:0] {
        RESET,
        READ,
        WRITE
    } wb_transaction_type_enum;
    typedef bit [ADDR_WIDTH-1:0] wb_addr_t;
    typedef bit [DATA_WIDTH-1:0] wb_data_t;
    typedef int                  wb_delay_t;
    protected typedef wb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) this_type;

    rand wb_transaction_type_enum   m_transaction_type;
    rand wb_addr_t                  m_addr;
    rand wb_data_t                  m_data;
    rand wb_delay_t                 m_delays;

    extern function new(string name = type_name);
    extern function void do_print(uvm_printer printer);
    extern function string convert2string();
    extern function void do_record(uvm_recorder recorder);
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
endclass: wb_sequence_item

function wb_sequence_item::new(string name = type_name);
    super.new(name);
endfunction: new

function void wb_sequence_item::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_generic("m_transaction_type", "wb_transaction_type_enum",
                          $bits(m_transaction_type), m_transaction_type.name());
    printer.print_field_int("m_addr", m_addr, $bits(m_addr));
    printer.print_field_int("m_data", m_data, $bits(m_data));
    printer.print_field_int("m_delays", m_delays, $bits(m_delays));
endfunction: do_print

function string wb_sequence_item::convert2string();
    return $sformatf("m_transaction_type=%s, m_addr=%0h, m_data=%0h, m_delays=%0d",
        m_transaction_type.name(), m_addr, m_data, m_delays);
endfunction: convert2string

function void wb_sequence_item::do_record(uvm_recorder recorder);
    super.do_record(recorder);
    recorder.record_generic("m_transaction_type", m_transaction_type.name(), "wb_transaction_type_enum");
    recorder.record_field_int("m_addr", m_addr, $bits(m_addr));
    recorder.record_field_int("m_data", m_data, $bits(m_data));
    recorder.record_field_int("m_delays", m_delays, $bits(m_delays));
endfunction: do_record

function void wb_sequence_item::do_copy(uvm_object rhs);
    this_type tmp;
    $cast(tmp, rhs);
    super.do_copy(tmp);
    m_transaction_type = tmp.m_transaction_type;
    m_addr = tmp.m_addr;
    m_data = tmp.m_data;
    m_delays = tmp.m_delays;
endfunction: do_copy

function bit wb_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    this_type tmp;
    $cast(tmp, rhs);
    return super.do_compare(tmp, comparer)
        && (m_transaction_type == tmp.m_transaction_type)
        && (m_addr == tmp.m_addr)
        && (m_data == tmp.m_data)
        && (m_delays == tmp.m_delays);
endfunction: do_compare

`endif // WB_SEQUENCE_ITEM_SV
