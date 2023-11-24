/***********************************************************************************/ 
// Created by: Eduard Popescu
// File name: wb_sequence_base.sv
// Short description: This is the base parameterized class for a wishbone sequence.
/***********************************************************************************/ 

`ifndef WB_SEQUENCE_BASE_SV
`define WB_SEQUENCE_BASE_SV

class wb_sequence_base#(type REQ = wb_sequence_item, type RSP = REQ) extends uvm_sequence#(REQ, RSP);
   `uvm_object_param_utils(wb_sequence_base#(REQ, RSP))

   localparam string type_name = $sformatf("wb_sequence_base#(%s)", REQ::type_name);

   typedef REQ::wb_transaction_type_enum  wb_transaction_type_t;
   typedef REQ::wb_addr_t                 wb_addr_t;
   typedef REQ::wb_data_t                 wb_data_t;
   typedef REQ::wb_delay_t                wb_delay_t;

   // random properties 
   rand int                            m_num_items;
   rand wb_transaction_type_t  m_transaction_type;

   // state properties
   wb_addr_t   m_min_addr;
   wb_addr_t   m_max_addr;
   wb_data_t   m_min_data;
   wb_data_t   m_max_data;
   wb_delay_t  m_min_delay;
   wb_delay_t  m_max_delay;

   extern function new(string name = type_name);
   extern task body();
   extern function string get_type_name();

   constraint addr_c { m_min_addr <= m_max_addr; }

   constraint data_c { m_min_data <= m_max_data; }

   constraint delay_c { m_min_delay <= m_max_delay; }
endclass: wb_sequence_base

function wb_sequence_base::new(string name = type_name);
    super.new(name);
    m_min_addr = '0;
    m_max_addr = '1;
    m_min_data = '0;
    m_max_data = '1;
    m_min_delay = '0;
    // wb_delay_t is a signed integral type
    // the max value has the MSB bit is 0 the rest of the bits are 1
    m_max_delay = {1'b0, {($bits(wb_delay_t)-1){1'b1}}};
endfunction: new

task wb_sequence_base::body();
   REQ req;
   
   repeat (m_num_items) begin
      req = new();
      start_item(req);
      if (!req.randomize() with {
         m_addr inside {[m_min_addr:m_max_addr]};
         m_data inside {[m_min_data:m_max_data]};
         m_delays inside {[m_min_delay:m_max_delay]};
         m_transaction_type == local::m_transaction_type;
      }) begin
         `uvm_fatal(get_type_name(), "Failed to randomize request!")
      end
      finish_item(req);
   end
endtask: body

function string wb_sequence_base::get_type_name();
   return type_name;
endfunction: get_type_name

`endif // WB_SEQUENCE_BASE_SV
