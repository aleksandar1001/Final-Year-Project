`ifndef CONV_SIMPLE_SEQ_SV
    `define CONV_SIMPLE_SEQ_SV
    
    
    // AXI LITE registers parameters
    parameter AXI_BASE = 5'b00000;
    parameter LINES_REG_OFFSET = 0;
    parameter COLUMNS_REG_OFFSET = 4;
    parameter CMD_REG_OFFSET = 8;
    parameter STATUS_REG_OFFSET = 12;
    parameter START_DVA_FROM_JEDAN_REG_OFFSET = 16;
    parameter START_TRI_FROM_DVA_REG_OFFSET = 20;
    parameter START_CETIRI_FROM_TRI_REG_OFFSET = 24;
    
    int cols, rows;
    
    
class conv_simple_seq extends conv_base_seq;


    int i = 0;
    int k1 = 0;
    int k2 = 0;
    int k3 = 0;
    int k4 = 0;
    
    // Item instance
    conv_item req;


    // Constructor
    function new(string name = "conv_simple_seq");
        super.new(name);
    endfunction : new
    
    
    // Factory registration
    `uvm_object_utils(conv_simple_seq)
    
    
    // Body task
    virtual task body();
        rows = 12;
        cols = 12;
          
        req = conv_item::type_id::create("conv_item");

        // Initalization of AXI
        $display("SEKVENCA: AXI LITE inicijalizacija");
        `uvm_do_with(req, {req.bram_axi == 1; req.s00_axi_awaddr == AXI_BASE + CMD_REG_OFFSET; req.s00_axi_wdata == 32'd0;}); 
                   
        // Setting image parameters (rows and columns registers)
        $display("SEKVENCA: Setovanje parametara AXI LITE-a(kolone i linije)");
        `uvm_do_with(req, {req.bram_axi == 1; req.s00_axi_awaddr == AXI_BASE + LINES_REG_OFFSET; req.s00_axi_wdata == rows;});
        `uvm_do_with(req, {req.bram_axi == 1; req.s00_axi_awaddr == AXI_BASE + COLUMNS_REG_OFFSET; req.s00_axi_wdata == cols;}); 

        // Loading the image
        $display("SEKVENCA: rezolucija slike je: %d", rows * cols);
        for(i = 0; i < rows * cols; i++) begin
            start_item(req);
            req.bram_axi = 3'd0;
            req.img_wr = 1'b1;
            req.img_addr = i;
            $display("SEKVENCA: Image adrress: %d", req.img_addr);
            req.img_data = p_sequencer.cfg.image_data[i];
            finish_item(req);
        end
        $display("SEKVENCA: Ulazna slika je upisana... ");
        $display("----------------------------------------");

       // Loading kernel_one
        for(k1 = 0; k1 < 9; k1++) begin
            start_item(req);
            req.bram_axi = 3'd2;
            req.ker_one_wr = 1'b1;
            req.ker_one_addr = k1;
            $display("SEKVECNA: Kernel_one adrress: %d", req.ker_one_addr);
            req.ker_one_data = p_sequencer.cfg.kernel_one_data[k1];
            finish_item(req);
        end
        $display("SEKVECNA: Prvi kernel je upisan...");
        $display("----------------------------------------");
  
       // Loading kernel_two
        for(k2 = 0; k2 < 9; k2++) begin
            start_item(req);
            req.bram_axi = 3'd3; 
            req.ker_two_wr = 1'b1;
            req.ker_two_addr = k2;
            $display("SEKVENCA: Kernel_two adrress: %d", req.ker_two_addr);
            req.ker_two_data = p_sequencer.cfg.kernel_two_data[k2];
            finish_item(req);
        end
        $display("SEKVENCA: Drugi kernel je upisan...");
        $display("----------------------------------------");
        
        // Loading kernel_three
        for(k3 = 0; k3 < 9; k3++) begin
            start_item(req);
            req.bram_axi = 3'd4;   
            req.ker_three_wr = 1'b1;
            req.ker_three_addr = k3;
            $display("SEKVENCA: Kernel_three adrress: %d", req.ker_three_addr);
            req.ker_three_data = p_sequencer.cfg.kernel_three_data[k3];
            finish_item(req);
        end
        $display("SEKVECNA: Treci kernel je upisan...");
        $display("----------------------------------------");

        // Loading kernel_four
        for(k4 = 0; k4 < 9; k4++) begin
            start_item(req);
            req.bram_axi = 3'd5;
            req.ker_four_wr = 1'b1;
            req.ker_four_addr = k4;
            $display("SEKVENCA: Kernel_four adrress: %d", req.ker_four_addr);
            req.ker_four_data = p_sequencer.cfg.kernel_four_data[k4];
            finish_item(req);
        end
        $display("SEKVENCA: Cetvrti kernel je upisan...");
        $display("----------------------------------------");
                 
                         
        // Starting convolution
        $display("SEKVENCA: STARTUJ IP");
        `uvm_do_with(req, {req.bram_axi == 1; req.s00_axi_awaddr == AXI_BASE + CMD_REG_OFFSET; req.s00_axi_wdata == 32'd1;});
        
        $display("SEKVENCA: TESTIRAJ KOCEPT PROTOCNE OBRADE");
        `uvm_do_with(req, {req.bram_axi == 6; req.s00_axi_awaddr == AXI_BASE + CMD_REG_OFFSET; req.s00_axi_wdata == 32'd1;});

    endtask : body

endclass : conv_simple_seq
    
`endif