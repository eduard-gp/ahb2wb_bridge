# AHB-Wishbone Bridge

This repository contains the files to test an AHB-Wishbone bridge using UVM.
UVM (Universal Verification Methdology) is a standardized methodology for
verifying integrated circuit designs. The UVM library is written in
SystemVerilog.

To run the project someone can find it on edaplayground [here](https://www.edaplayground.com/x/t2vB).

The rtl implementation of the bridge is in the file *ahb2wb.v*.

The testbench starts with the top level module from the file *testbench.sv*.

The project focuses on the Wisbhone component. It contains the necessary files
to create an Wishbone agent and modern testing environemnt, which focuses on
modularization and efficiency.

## Project strucutre

The wisbone directory contains the logic to implement a Wishbone agent that
works in standard mode according to the [Wishbone specification](https://cdn.opencores.org/downloads/wbspec_b3.pdf).
The agent direcotry contains the wishbone package that should be imported to
use a Wishbone in standard mode. The classes were implented to be easy to reuse
and extend so it is possible to create another Wishbone agent that works in a
differnt mode. For example, pipeline mode. The sequences directory contains the
wishbone sequence package. This is the place where the transaction data is
described for a Wisbone device.

wishbone/  
├── agent  
│   ├── wb_agent_base.sv  
│   ├── wb_agent_config.sv  
│   ├── wb_driver_base.sv  
│   ├── wb_monitor_base.sv  
│   ├── wb_standard_monitor.sv  
│   ├── wb_standard_slave_agent_pkg.sv  
│   ├── wb_standard_slave_agent.sv  
│   └── wb_standard_slave_driver.sv  
├── sequences  
│   ├── wb_sequence_base.sv  
│   ├── wb_sequence_item.sv  
│   └── wb_sequence_pkg.sv  
└── wb_if.sv  

The ahb2wb directory has the necessary logic to build a modern test
infrastracture. The environment directory contains the environment package that
should be imported when an ahb2wb_env component has to be used. The test
directory contains the basic building blocks to create a test.

ahb2wb  
├── environment  
│   ├── ahb2wb_env_config.sv  
│   ├── ahb2wb_env_pkg.sv  
│   └── ahb2wb_env.sv  
└── tests  
&nbsp;&nbsp;&nbsp;&nbsp;├── ahb2wb_scoreboard.sv  
&nbsp;&nbsp;&nbsp;&nbsp;├── ahb2wb_simple_read_test.sv  
&nbsp;&nbsp;&nbsp;&nbsp;├── ahb2wb_test_base.sv  
&nbsp;&nbsp;&nbsp;&nbsp;├── test_params_pkg.sv  
&nbsp;&nbsp;&nbsp;&nbsp;└── test_pkg.sv  

### How it can be improved

An AHB component could be implemented to complete the testing environment. At
the moment AHB transaction data is transmited from the top module
*testbench.sv*.
