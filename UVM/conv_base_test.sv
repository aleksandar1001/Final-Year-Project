`ifndef CONV_BASE_TEST_SV
    `define CONV_BASE_TEST_SV
    

// Base test class
class conv_base_test extends uvm_test;
    
    
    // Factory registration
    `uvm_component_utils(conv_base_test)
    
    // Component members
    conv_env env;


    // Object members
    conv_config cfg;
    
    
    // Constructor
    function new(string name = "conv_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new


    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            
        `uvm_info(get_type_name(),"Starting build phase...", UVM_LOW);
       
        cfg = conv_config::type_id::create("cfg", this);
        env = conv_env::type_id::create("env", this);
        cfg.extracting_data();
        uvm_config_db#(conv_config)::set(this, "*", "cfg", cfg);
    endfunction : build_phase


    // End of elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
        env.set_report_verbosity_level (UVM_FULL);
                                       
        // Print the topology.
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase


    // Run phase
    task run_phase(uvm_phase phase);
        // Set a drain time for the environment if desired.
        uvm_test_done.set_drain_time(this, 50);
    endtask: run_phase
     

endclass : conv_base_test


`endif