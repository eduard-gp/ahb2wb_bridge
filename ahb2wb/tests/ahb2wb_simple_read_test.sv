/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: ahb2wb_simple_read_test.sv
// Short description: Simple read test to test the Wishbone.
/***********************************************************************************/ 

`ifndef AHB2WB_SIMPLE_READ_TEST
`define AHB2WB_SIMPLE_READ_TEST

class ahb2wb_simple_read_test extends ahb2wb_test_base;
    `uvm_component_utils(ahb2wb_simple_read_test)

    typedef wb_sequence_item#(TEST_WB_ADDR_WIDTH, TEST_WB_DATA_WIDTH)   wb_item_t;
    typedef wb_sequence_base#(wb_item_t)                                sequence_t;

    sequence_t m_seq;

    extern function new(string name = "ahb2wb_simple_read_test", uvm_component parent = null);
    extern task run_phase(uvm_phase phase);
endclass: ahb2wb_simple_read_test

function ahb2wb_simple_read_test::new(string name = "ahb2wb_simple_read_test", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

task ahb2wb_simple_read_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);

    m_seq = sequence_t::type_id::create("m_seq");
    m_seq.set_item_context(null, m_env.m_wb_agent.m_sequencer);
    m_seq.m_max_delay = 2;
    assert(m_seq.randomize() with {
        m_num_items == 10;
        m_transaction_type == wb_item_t::READ;
    });
    m_seq.set_starting_phase(phase);
    m_seq.start(m_env.m_wb_agent.m_sequencer, null);

    phase.drop_objection(this);
endtask: run_phase

`endif // AHB2WB_SIMPLE_READ_TEST
