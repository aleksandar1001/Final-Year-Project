`ifndef CONV_TEST_SIMPLE_SV
    `define CONV_TEST_SIMPLE_SV
    
class conv_test_simple extends conv_base_test;


    // Factory registration
    `uvm_component_utils(conv_test_simple)
    
    
    // Sequence instance
    conv_simple_seq seq;
    
    
    // Constructor
    function new(string name = "conv_test_simple", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
 
 
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase
     
    
    // Run phase
    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "------------TEST STARTED------------");
        
        seq = conv_simple_seq::type_id::create("conv_simple_seq", this);
        seq.start(env.agent.sqr);
        
        phase.drop_objection(this, "------------TEST FINISHED------------");
    endtask : run_phase


endclass : conv_test_simple
    

`endif