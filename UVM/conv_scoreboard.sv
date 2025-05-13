`ifndef CONV_SCOREBOARD_SV
    `define CONV_SCOREBOARD_SV
    
     
class conv_scoreboard extends uvm_scoreboard;

    // Enable checking
    bit checks_enable = 1;
    
    // Config object
    conv_config cfg;

    // TLM import port
    uvm_analysis_imp#(conv_item, conv_scoreboard) item_collected_import;
                                               
    // Number of transactions     
    int num_of_tr = 1;
       
    `uvm_component_utils(conv_scoreboard)
  
    // Constructor
    function new(string name = "conv_monitor", uvm_component parent = null);
        super.new(name, parent);
                    
        // TLM import port instance
        item_collected_import = new("item_collected_import", this);
    endfunction : new
    
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

     if(!uvm_config_db#(conv_config)::get(this, "", "cfg", cfg))
         `uvm_fatal(get_full_name(), "Failed to get config object")
    endfunction : build_phase
    
    
    // Connect phase
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase
    
    
    // Write function
 function void write(conv_item req);
    if(checks_enable) begin
        `uvm_info(get_type_name(),
		$sformatf("[Scoreboard] Scoreboard function write called..."), UVM_MEDIUM);
                 
        // Compare the computed output with a golden vector 
        asrt_img_output : assert(req.res_data == cfg.golden_vector_data[req.res_addr])
		$display("SKORDBORD: Uspesno poredjenje. Monitorovana vrednost je: %d, a ocekivana je: %d", 
		req.res_data,cfg.golden_vector_data[req.res_addr]); 
                 
        else // assert else
		`uvm_fatal(get_type_name(),
		$sformatf("Observed mismatch for img_output[%0d]. Observed value is %0d, expected is %0d.\n", 
		req.res_addr, req.res_data, cfg.golden_vector_data[req.res_addr]))
		++num_of_tr;              
    end
 endfunction : write
    

    // Report phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Seg scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
    endfunction
   
endclass : conv_scoreboard
    
    
`endif