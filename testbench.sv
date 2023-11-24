`include "wb_if.sv"
`include "wb_sequences_pkg.sv"
`include "wb_standard_slave_agent_pkg.sv"
`include "ahb2wb_env_pkg.sv"
`include "test_params_pkg.sv"
`include "tests_pkg.sv"

module tb;
    timeunit 1ns;
    timeprecision 100ps;

	import uvm_pkg::*;
    import tests_pkg::*;
    import test_params_pkg::*;

    typedef enum bit [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        NONSEQ = 2'b10,
        SEQ = 2'b11
    } ahb_trans_t;

    typedef enum bit [2:0] {
        BYTE = 3'b000,
        HALFWORD = 3'b001,
        WORD = 3'b010,
        DOUBLEWORD = 3'b011,
        FOUR_WORLD_LINE = 3'b100,
        EIGHT_WORLD_LINE = 3'b101
    } ahb_trans_size_t;

    typedef enum bit [2:0] {
        SINGLE = 3'b000,
        INCR = 3'b001,
        WRAP4 = 3'b010,
        INCR4 = 3'b011,
        WRAP8 = 3'b100,
        INCR8 = 3'b101,
        WRAP16 = 3'b110,
        INCR16 = 3'b111
    } ahb_burst_t;

  	localparam ADDR_WIDTH = TEST_WB_ADDR_WIDTH;
  	localparam DATA_WIDTH = TEST_WB_DATA_WIDTH;

    typedef virtual wb_if#(ADDR_WIDTH, DATA_WIDTH) wb_if_t;
  
  	bit clk;
    logic hresetn;
    logic [DATA_WIDTH-1:0] hwdata;
    logic hwrite;
    logic [2:0] hburst;
    logic [2:0] hsize;
    logic [1:0] htrans;
    logic hsel;
    logic [ADDR_WIDTH-1:0] haddr;
    logic [DATA_WIDTH-1:0] hrdata;
    logic [1:0] hresp;
    logic hready;

  	wb_if#(ADDR_WIDTH, DATA_WIDTH) wb_if0(clk);
    ahb2wb#(ADDR_WIDTH, DATA_WIDTH) dut(
        .hclk(clk),
        .hresetn(hresetn),
        .hwdata(hwdata),
        .hwrite(hwrite),
        .hburst(hburst),
        .hsize(hsize),
        .htrans(htrans),
        .hsel(hsel),
        .haddr(haddr),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready),
        .dat_i(wb_if0.rdata),
        .ack_i(wb_if0.ack),
        .clk_i(wb_if0.clk),
        .rst_i(wb_if0.rst),
        .adr_o(wb_if0.addr),
        .dat_o(wb_if0.wdata),
        .cyc_o(wb_if0.cyc),
        .we_o(wb_if0.we),
        .stb_o(wb_if0.stb)
    );

    assign wb_if0.rst = ~hresetn;
  
    task reset();
        hresetn <= 0;
        @(posedge clk) hresetn <= 1;
    endtask: reset

    task automatic insert_idle_cycle();
        @(posedge clk);
        hsel <= 1;
        htrans <= IDLE;
    endtask: insert_idle_cycle

    task automatic write(input bit [ADDR_WIDTH-1:0] addr, input bit [DATA_WIDTH-1:0] data, int max_delays);
        // $display("start write: [%0t] addr=%0h", $time, addr);
        repeat ($urandom_range(0, max_delays)) insert_idle_cycle();
        @(posedge clk);
        // $display("before wait: [%0t] addr=%0h, hready=%0b", $time, addr, hready);
        while (!hready) @(posedge clk);
        // $display("after wait: [%0t] addr=%0h, hready=%0b", $time, addr, hready);
        hsel <= 1;
        hwrite <= 1;
        htrans <= NONSEQ;
        hsize <= BYTE;
        hburst <= SINGLE;
        haddr <= addr;
        fork
            begin
                @(posedge clk);
                while (!hready) @(posedge clk);
                hwdata <= data;
            end
        join_none
    endtask: write

    task automatic multiple_writes(input int n = 10, int max_delays);
        for (int i = 0; i < n; ++i) begin
            write(i, i, max_delays);
        end
    endtask: multiple_writes

    task automatic read(input bit [ADDR_WIDTH-1:0] addr, int max_delays);
        repeat ($urandom_range(0, max_delays)) insert_idle_cycle();
        @(posedge clk);
        // $display("before wait: [%0t] addr=%0h, hready=%0b", $time, addr, hready);
        while (!hready) @(posedge clk);
        // $display("after wait: [%0t] addr=%0h, hready=%0b", $time, addr, hready);
        hsel <= 1;
        hwrite <= 0;
        htrans <= NONSEQ;
        hsize <= BYTE;
        hburst <= SINGLE;
        haddr <= addr;
    endtask: read

    task automatic multiple_reads(input int n = 10, int max_delays);
        for (int i = 0; i < n; ++i) begin
            read(i, max_delays);
        end
    endtask: multiple_reads

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    always #10 clk = ~clk;

    initial begin
        static int max_delays = 0;
        #1 reset();
        multiple_reads(10, max_delays);
        // #34 reset();
        // multiple_reads(3, max_delays);
    end

  	initial begin
        uvm_config_db#(wb_if_t)::set(null, "uvm_test_top", "wb_vif", wb_if0); 
        run_test("ahb2wb_simple_read_test");
    end
  
endmodule
