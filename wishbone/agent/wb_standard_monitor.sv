/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_standard_monitor.sv
// Short description: This is the parameterized class that can monitor the transactions
// between wishbone components that operate in the standard mode.
/***********************************************************************************/ 

`ifndef WB_STANDARD_MONITOR_SV
`define WB_STANDARD_MONITOR_SV

class wb_standard_monitor#(type ITEM = wb_sequence_item) extends wb_monitor_base#(ITEM);
    `uvm_component_param_utils(wb_standard_monitor#(ITEM))

    localparam string type_name = $sformatf("wb_standard_monitor#(%s)", ITEM::type_name);

    extern function new(string name = type_name, uvm_component parent = null);
    extern function string get_type_name();
    extern task run_phase(uvm_phase phase);
    extern task monitor();
    extern task monitor_reset();
endclass: wb_standard_monitor

function wb_standard_monitor::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function string wb_standard_monitor::get_type_name();
    return type_name;
endfunction: get_type_name

task wb_standard_monitor::run_phase(uvm_phase phase);
    monitor_reset();
endtask: run_phase

task wb_standard_monitor::monitor_reset();
    ITEM item;

    `uvm_info(get_type_name(), "Start monitor_reset", UVM_MEDIUM)
    forever begin
        @(posedge vif.rst);
        @(posedge vif.clk);
        if (vif.rst) begin
            `uvm_info(get_type_name(), "Detected reset", UVM_MEDIUM)
            disable monitor;
            item = new("item");
            item.m_transaction_type = ITEM::RESET;
            @(negedge vif.rst) fork monitor(); join_none
            `uvm_info(get_type_name(), "Forked monitor", UVM_MEDIUM)
        end
    end
endtask: monitor_reset

task wb_standard_monitor::monitor();
    ITEM item;

    `uvm_info(get_type_name(), "Start monitor", UVM_MEDIUM)
    forever @(posedge vif.clk) begin
        // wait a transfer cycle to start or for the wait states to end
        while ((vif.cyc !== 1'b1) || (vif.stb !== 1'b1))
            @(posedge vif.clk);    

        if (vif.we === 1'bx || vif.we === 1'bz)
            continue;
    
        item = new("item");
        item.m_addr = vif.addr;
        if (vif.we) begin
            item.m_transaction_type = ITEM::WRITE;
            item.m_data = vif.wdata;
        end else begin
            item.m_transaction_type = ITEM::READ;
            while (vif.ack !== 1'b1)
                @(posedge vif.clk);
            item.m_data = vif.rdata;
        end
        m_analysis_port.write(item);
    end
endtask: monitor

`endif
