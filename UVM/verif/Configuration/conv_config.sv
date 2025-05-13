`ifndef CONV_CONFIG_SV
    `define CONV_CONFIG_SV


class conv_config extends uvm_object;


    // Enum data type to decide agent type
   // uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    
    // Paths to files for Input image, kernels and golden vector
    string image;
    string kernel_one;
    string kernel_two;
    string kernel_three;
    string kernel_four;
    string golden_vector;
    
    
    // Input image variables and reading files variables
    int rows = 12;
    int cols = 12;
    int i = 0;
    int k_one = 0;
    int k_two = 0;
    int k_three = 0;
    int k_four = 0;
    int gv = 0;
    int fd;
    int tmp;
    int img_doutc_gv[$];
    int coverage_goal_cfg;
    string line_img;
    string line_ker1;
    string line_ker2;
    string line_ker3;
    string line_ker4;
    string line_gv;


    // pixels(data lines)
    logic [7 : 0] image_data[$];
    logic [7 : 0] kernel_one_data[$];
    logic [7 : 0] kernel_two_data[$];
    logic [7 : 0] kernel_three_data[$];
    logic [7 : 0] kernel_four_data[$];
    logic [7 : 0] golden_vector_data[$];
   
    
    // Factory registration and automatic implementations of core methods
    `uvm_object_utils(conv_config)
//        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  //  `uvm_object_utils_end
     
     
     // Constructor
     function new(string name = "conv_config");
         super.new(name);

         // Apsolute paths toward stimulus and golden vector(expected output)
         image = "../../../../../files\/image_bits.txt";
         kernel_one = "../../../../../files\/kernel_one_bits.txt";
         kernel_two = "../../../../../files\/kernel_two_bits.txt";
         kernel_three = "../../../../../files\/kernel_three_bits.txt";
         kernel_four = "../../../../../files\/kernel_four_bits.txt";
         golden_vector = "../../../../../files\/golden_vector_bits.txt";
     endfunction : new
     
          // Function for reading stimulus and golden vector from the files
    function void extracting_data();
         //Load image bits
        image_data.delete();
        fd = $fopen(image, "r");

        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> image_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_img, fd);
                image_data.push_back(line_img.atobin());
                
                $display("Piksel slike[%0d] = %b", i,  image_data[i]);
                i++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Problem pri otvaranju fajla image_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);


    
    // Load kernel1 bits
    kernel_one_data.delete();
    fd = $fopen(kernel_one, "r");

        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> kernel_one_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_ker1, fd);
                kernel_one_data.push_back(line_ker1.atobin());
                
                $display("Piksel kernela_jedan[%0d] = %b", k_one,  kernel_one_data[k_one]);
                k_one++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Problem pri otvaranju fajla kernel_one_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);
    
    // Load kernel2 bits
    kernel_two_data.delete();
    fd = $fopen(kernel_two, "r");

        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> kernel_two_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_ker2, fd);
                kernel_two_data.push_back(line_ker2.atobin());
                
                $display("Piksel kernala_dva[%0d] = %b", k_two,  kernel_two_data[k_two]);
                k_two++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Problem pri otvaranju fajla kernel_two_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);
    
    // Load kernel3 bits
    kernel_three_data.delete();
    fd = $fopen(kernel_three, "r");

        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> kernel_three_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_ker3, fd);
                kernel_three_data.push_back(line_ker3.atobin());
                
                $display("Piksel kernela_tri[%0d] = %b", k_three,  kernel_three_data[k_three]);
                k_three++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Problem pri otvaranju fajla kernel_three_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);
    
    // Load kernel4 bits
    kernel_four_data.delete();
    fd = $fopen(kernel_four, "r");
                                 
        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> kernel_four_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_ker4, fd);
                kernel_four_data.push_back(line_ker4.atobin());
                
                $display("Piksel kernela_cetiri[%0d] = %b", k_four,  kernel_four_data[k_four]);
                k_four++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Error opening kernel_four_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);
    
    // Load golden vector bits
    golden_vector_data.delete();
    fd = $fopen(golden_vector, "r");
    
        if(fd) begin
            `uvm_info(get_name(), $sformatf("Uspesno otvorio fajl -> golden_vector_bits.txt"), UVM_LOW)
            while(!$feof(fd)) begin 
                $fgets(line_gv, fd);
                golden_vector_data.push_back(line_gv.atobin());
                
                $display("Piksel zlatnog_vektora[%0d] = %b", gv,  golden_vector_data[gv]);
                gv++;
            end
        end else begin
            `uvm_info(get_name(), $sformatf("Problem pri otvaranju fajla golden_vector_bits.txt"), UVM_HIGH)
        end
    $fclose(fd);
    
    endfunction : extracting_data

endclass : conv_config

`endif