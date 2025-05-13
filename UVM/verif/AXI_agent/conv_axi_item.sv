`ifndef CONV_AXI_ITEM_SV
    `define CONV_AXI_ITEM_SV

    
    // AXI LITE registers parameters
    parameter AXI_BASE = 5'b00000;
    parameter LINES_REG_OFFSET = 0;
    parameter COLUMNS_REG_OFFSET = 4;
    parameter CMD_REG_OFFSET = 8;
    parameter STATUS_REG_OFFSET = 12;
    parameter START_DVA_FROM_JEDAN_REG_OFFSET = 16;
    parameter START_TRI_FROM_DVA_REG_OFFSET = 20;
    parameter START_CETIRI_FROM_TRI_REG_OFFSET = 24;
    
    parameter C_S00_AXI_DATA_WIDTH = 32;
    parameter C_S00_AXI_ADDR_WIDTH = 5;
    
    parameter ADDR = 16;
    parameter WIDTH = 8;

class conv_axi_item extends uvm_sequence_item;

    // Control signal - 0 for bram, 1 for AXI lite registers
    rand logic [1:0] bram_axi;
    
    // Memory - input image
    rand logic [ADDR - 1 : 0] img_addr;
    rand logic [WIDTH - 1 : 0] img_data;
    rand logic img_en;
    
    // Memory - kernel_one
    rand logic [ADDR - 1 : 0] ker_one_addr;
    rand logic [WIDTH - 1 : 0] ker_one_data;
    rand logic ker_one_en;
    
    // Memory - kernel_two
    rand logic [ADDR - 1 : 0] ker_two_addr;
    rand logic [WIDTH - 1 : 0] ker_two_data;
    rand logic ker_two_en;

    // Memory - kernel_one
    rand logic [ADDR - 1 : 0] ker_three_addr;
    rand logic [WIDTH - 1 : 0] ker_three_data;
    rand logic ker_three_en;

    // Memory - kernel_one
    rand logic [ADDR - 1 : 0] ker_four_addr;
    rand logic [WIDTH - 1 : 0] ker_four_data;
    rand logic ker_four_en;

    // Memory - output image
    rand logic [ADDR - 1 : 0] res_addr;
    rand logic [WIDTH - 1 : 0] res_data;
    rand logic res_en;

    // AXI Lite - Main registers
    rand logic [C_S00_AXI_ADDR_WIDTH - 1 : 0] s00_axi_awaddr;
    rand logic [2 : 0] s00_axi_awprot;
    rand logic s00_axi_awvalid;
    rand logic s00_axi_awready;
    rand logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_wdata;
    rand logic [(C_S00_AXI_DATA_WIDTH / 8) - 1 : 0] s00_axi_wstrb;
    rand logic s00_axi_wvalid;
    rand logic s00_axi_wready;
    rand logic [1 : 0] s00_axi_bresp;
    rand logic s00_axi_bvalid;
    rand logic s00_axi_bready;
    rand logic [C_S00_AXI_ADDR_WIDTH - 1 : 0] s00_axi_araddr;
    rand logic [2 : 0] s00_axi_arprot;
    rand logic s00_axi_arvalid;
    rand logic s00_axi_arready;
    rand logic [C_S00_AXI_DATA_WIDTH - 1 : 0] s00_axi_rdata;
    rand logic [1 : 0] s00_axi_rresp;
    rand logic s00_axi_rvalid;
    rand logic s00_axi_rready;

    // Factory registration
    `uvm_object_utils_begin(conv_axi_item)
        `uvm_field_int(img_addr, UVM_ALL_ON);
        `uvm_field_int(img_data, UVM_ALL_ON);
        `uvm_field_int(img_en, UVM_ALL_ON);

        `uvm_field_int(ker_one_addr, UVM_ALL_ON);
        `uvm_field_int(ker_one_data, UVM_ALL_ON);
        `uvm_field_int(ker_one_en, UVM_ALL_ON);

 `uvm_field_int(ker_two_addr, UVM_ALL_ON);
        `uvm_field_int(ker_two_data, UVM_ALL_ON);
        `uvm_field_int(ker_two_en, UVM_ALL_ON);

 `uvm_field_int(ker_three_addr, UVM_ALL_ON);
        `uvm_field_int(ker_three_data, UVM_ALL_ON);
        `uvm_field_int(ker_three_en, UVM_ALL_ON);

 `uvm_field_int(ker_four_addr, UVM_ALL_ON);
        `uvm_field_int(ker_four_data, UVM_ALL_ON);
        `uvm_field_int(ker_four_en, UVM_ALL_ON);

        `uvm_field_int(s00_axi_awaddr, UVM_ALL_ON);
        `uvm_field_int(s00_axi_awprot, UVM_ALL_ON);
        `uvm_field_int(s00_axi_awvalid, UVM_ALL_ON);
        `uvm_field_int(s00_axi_awready, UVM_ALL_ON);
        `uvm_field_int(s00_axi_wdata, UVM_ALL_ON);
        `uvm_field_int(s00_axi_wstrb, UVM_ALL_ON);
        `uvm_field_int(s00_axi_wvalid, UVM_ALL_ON);
        `uvm_field_int(s00_axi_wready, UVM_ALL_ON);
        `uvm_field_int(s00_axi_bresp, UVM_ALL_ON);
        `uvm_field_int(s00_axi_bvalid, UVM_ALL_ON);
        `uvm_field_int(s00_axi_bready, UVM_ALL_ON);
        `uvm_field_int(s00_axi_araddr, UVM_ALL_ON);
        `uvm_field_int(s00_axi_arprot, UVM_ALL_ON);
        `uvm_field_int(s00_axi_arvalid, UVM_ALL_ON);
        `uvm_field_int(s00_axi_arready, UVM_ALL_ON);
        `uvm_field_int(s00_axi_rdata, UVM_ALL_ON);
        `uvm_field_int(s00_axi_rresp, UVM_ALL_ON);
        `uvm_field_int(s00_axi_rvalid, UVM_ALL_ON);
        `uvm_field_int(s00_axi_rready, UVM_ALL_ON);
    `uvm_object_utils_end

    // Constructor
    function new (string name = "conv_axi_item");
        super.new(name);
    endfunction : new

endclass : conv_axi_item       

`endif