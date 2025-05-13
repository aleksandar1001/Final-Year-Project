`ifndef CONV_BASE_SEQ_SV
    `define CONV_BASE_SEQ_SV
  

// Base Sequence
class conv_base_seq extends uvm_sequence #(conv_item);


    // UVM automation macros for sequences
    `uvm_object_utils(conv_base_seq)


    // Decla base sequencer
    `uvm_declare_p_sequencer(conv_sequencer)
   
   
    // Constructor
    function new(string name = "conv_base_seq");
        super.new(name);
    endfunction
          
                 
     // Pre body task
     task pre_body();
    if(starting_phase != null)
        starting_phase.raise_objection(this);
    endtask : pre_body
    

    // Post body task
    task post_body();
    if(starting_phase != null)
        starting_phase.drop_objection(this);
    endtask : post_body
     

endclass : conv_base_seq 


`endif