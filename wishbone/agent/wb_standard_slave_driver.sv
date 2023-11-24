/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_standard_slave_driver.sv
// Short description: This parameter class defines the driving logic for a standard
// whishbone slave with synchronous ack responses.
/***********************************************************************************/ 

`ifndef WB_STANDARD_SLAVE_DRIVER_SV
`define WB_STANDARD_SLAVE_DRIVER_SV

class wb_standard_slave_driver#(type REQ = wb_sequence_item, type RSP = REQ) extends wb_driver_base#(REQ, RSP);
    `uvm_component_param_utils(wb_standard_slave_driver#(REQ, RSP))

    localparam string type_name = $sformatf("wb_standard_slave_driver#(%0d, %0d)", REQ::ADDR_WIDTH, REQ::DATA_WIDTH);

    extern function new(string name = type_name, uvm_component parent = null);
    extern task run_phase(uvm_phase phase);
    extern function string get_type_name();

    extern virtual task monitor_reset();
    extern virtual task drive();
endclass: wb_standard_slave_driver

function wb_standard_slave_driver::new(string name = type_name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

task wb_standard_slave_driver::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "run_phase()", UVM_MEDIUM)

    monitor_reset();
endtask: run_phase

function string wb_standard_slave_driver::get_type_name();
    return type_name;
endfunction: get_type_name

task wb_standard_slave_driver::monitor_reset();
    `uvm_info(get_type_name(), "Start monitor_reset", UVM_MEDIUM)
    forever begin
        @(posedge vif.rst);
        @(posedge vif.clk);
        if (vif.rst) begin
            `uvm_info(get_type_name(), "Detected reset", UVM_MEDIUM)
            disable drive;
            @(negedge vif.rst) fork drive(); join_none
            `uvm_info(get_type_name(), "Forked drive signals", UVM_MEDIUM)
        end
    end
endtask: monitor_reset

task wb_standard_slave_driver::drive();
    `uvm_info(get_type_name(), "Start dive_signals", UVM_MEDIUM)
    forever @(posedge vif.clk) begin
        seq_item_port.get(m_req);

        `uvm_info(get_type_name(), $sformatf("drive_signals: %s", m_req.convert2string()), UVM_MEDIUM)

        if (m_req.m_transaction_type inside { REQ::WRITE, REQ::READ }) begin
            // wait a transfer cycle to start or for the wait states to end
            while ((vif.cyc !== 1'b1) || (vif.stb !== 1'b1)) begin
                if (vif.stb === 1'b0)
                    vif.ack <= 1'b0;
                @(posedge vif.clk);    
            end
            // insert wait states
            repeat(m_req.m_delays) @(posedge vif.clk);  

            if (m_req.m_transaction_type == REQ::READ) begin
                vif.rdata <= m_req.m_data;
            end 
            // send ack
            vif.ack <= 1'b1;
            @(posedge vif.clk);
            vif.ack <= 1'b0;
        end else begin
            `uvm_error(get_type_name(), $sformatf("Received unsupported transaction_type_enum item={%s}", m_req.convert2string()))
        end
    end
endtask: drive

`endif // WB_STANDARD_SLAVE_DRIVER
