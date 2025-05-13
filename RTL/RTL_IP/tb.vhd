library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.utils_pkg.all;
use std.textio.all;
use IEEE.NUMERIC_STD.ALL;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

    --file izlazi : text open write_mode is
    --"C:\Users\Veljko_Miric\PSDS_PROJEKAT\Files_For_Tb\izlazi_axi";
   
    constant WIDTH_c : natural := 8;
    constant ADDR_C : natural := 16;
	constant kernelSize_c : natural := 3;
    constant numKernels_c : natural := 4;
    constant kerMem_c : natural := 6;
    constant SIZE_c : natural := 12;
    constant size_small : natural := 4;
    constant SIZE : natural := 8;
    constant columns_c : natural := 12;
    constant lines_c : natural := 12;
    constant start1_c : natural := 1;
    constant start2_c : natural := 2;
    constant start3_c : natural := 4;
    constant start4_c : natural := 5;
    
     -------Tipovi za memorije i sadrzaj memorija(za sliku i kernele)-------
    type img_mem_t is array(0 to (SIZE_c * SIZE_c) - 1) of std_logic_vector(WIDTH_c - 1 downto 0);
    type buff_mem2_t is array(0 to 64 - 1) of std_logic_vector(WIDTH_c - 1 downto 0);
    type ker_mem_t is array(0 to (kernelSize_c * kernelSize_c) - 1) of std_logic_vector(WIDTH_c - 1 downto 0);
    --Ulazna slika
    constant IMG_MEM_CONTEXT : img_mem_t :=
                             (conv_std_logic_vector(0, WIDTH_c),
                              conv_std_logic_vector(1, WIDTH_c),
                              conv_std_logic_vector(2, WIDTH_c),
                              conv_std_logic_vector(3, WIDTH_c),
                              conv_std_logic_vector(4, WIDTH_c),
                              conv_std_logic_vector(5, WIDTH_c),
                              conv_std_logic_vector(6, WIDTH_c),
                              conv_std_logic_vector(7, WIDTH_c),
                              conv_std_logic_vector(8, WIDTH_c),
                              conv_std_logic_vector(9, WIDTH_c),
                              conv_std_logic_vector(10, WIDTH_c),
                              conv_std_logic_vector(11, WIDTH_c),
                              conv_std_logic_vector(12, WIDTH_c),
                              conv_std_logic_vector(13, WIDTH_c),
                              conv_std_logic_vector(14, WIDTH_c),
                              conv_std_logic_vector(15, WIDTH_c),
                              conv_std_logic_vector(16, WIDTH_c),
                              conv_std_logic_vector(17, WIDTH_c),
                              conv_std_logic_vector(18, WIDTH_c),
                              conv_std_logic_vector(19, WIDTH_c),
                              conv_std_logic_vector(20, WIDTH_c),
                              conv_std_logic_vector(21, WIDTH_c),
                              conv_std_logic_vector(22, WIDTH_c),
                              conv_std_logic_vector(23, WIDTH_c),
                              conv_std_logic_vector(24, WIDTH_c),
                              conv_std_logic_vector(25, WIDTH_c),
                              conv_std_logic_vector(26, WIDTH_c),
                              conv_std_logic_vector(27, WIDTH_c),
                              conv_std_logic_vector(28, WIDTH_c),
                              conv_std_logic_vector(29, WIDTH_c),
                              conv_std_logic_vector(30, WIDTH_c),
                              conv_std_logic_vector(31, WIDTH_c),
                              conv_std_logic_vector(32, WIDTH_c),
                              conv_std_logic_vector(33, WIDTH_c),
                              conv_std_logic_vector(34, WIDTH_c),
                              conv_std_logic_vector(35, WIDTH_c),
                              conv_std_logic_vector(36, WIDTH_c),
                              conv_std_logic_vector(37, WIDTH_c),
                              conv_std_logic_vector(38, WIDTH_c),
                              conv_std_logic_vector(39, WIDTH_c),
                              conv_std_logic_vector(40, WIDTH_c),
                              conv_std_logic_vector(41, WIDTH_c),
                              conv_std_logic_vector(42, WIDTH_c),
                              conv_std_logic_vector(43, WIDTH_c),
                              conv_std_logic_vector(44, WIDTH_c),
                              conv_std_logic_vector(45, WIDTH_c),
                              conv_std_logic_vector(46, WIDTH_c),
                              conv_std_logic_vector(47, WIDTH_c),
                              conv_std_logic_vector(48, WIDTH_c),
                              conv_std_logic_vector(49, WIDTH_c),
                              conv_std_logic_vector(50, WIDTH_c),
                              conv_std_logic_vector(51, WIDTH_c),
                              conv_std_logic_vector(52, WIDTH_c),
                              conv_std_logic_vector(53, WIDTH_c),
                              conv_std_logic_vector(54, WIDTH_c),
                              conv_std_logic_vector(55, WIDTH_c),
                              conv_std_logic_vector(56, WIDTH_c),
                              conv_std_logic_vector(57, WIDTH_c),
                              conv_std_logic_vector(58, WIDTH_c),
                              conv_std_logic_vector(59, WIDTH_c),
                              conv_std_logic_vector(60, WIDTH_c),
                              conv_std_logic_vector(61, WIDTH_c),
                              conv_std_logic_vector(62, WIDTH_c),
                              conv_std_logic_vector(63, WIDTH_c),
                              conv_std_logic_vector(64, WIDTH_c),
                              conv_std_logic_vector(65, WIDTH_c),
                              conv_std_logic_vector(66, WIDTH_c),
                              conv_std_logic_vector(67, WIDTH_c),
                              conv_std_logic_vector(68, WIDTH_c),
                              conv_std_logic_vector(69, WIDTH_c),
                              conv_std_logic_vector(70, WIDTH_c),
                              conv_std_logic_vector(71, WIDTH_c),
                              conv_std_logic_vector(72, WIDTH_c),
                              conv_std_logic_vector(73, WIDTH_c),
                              conv_std_logic_vector(74, WIDTH_c),
                              conv_std_logic_vector(75, WIDTH_c),
                              conv_std_logic_vector(76, WIDTH_c),
                              conv_std_logic_vector(77, WIDTH_c),
                              conv_std_logic_vector(78, WIDTH_c),
                              conv_std_logic_vector(79, WIDTH_c),
                              conv_std_logic_vector(80, WIDTH_c),
                              conv_std_logic_vector(81, WIDTH_c),
                              conv_std_logic_vector(82, WIDTH_c),
                              conv_std_logic_vector(83, WIDTH_c),
                              conv_std_logic_vector(84, WIDTH_c),
                              conv_std_logic_vector(85, WIDTH_c),
                              conv_std_logic_vector(86, WIDTH_c),
                              conv_std_logic_vector(87, WIDTH_c),
                              conv_std_logic_vector(88, WIDTH_c),
                              conv_std_logic_vector(89, WIDTH_c),
                              conv_std_logic_vector(90, WIDTH_c),
                              conv_std_logic_vector(91, WIDTH_c),
                              conv_std_logic_vector(92, WIDTH_c),
                              conv_std_logic_vector(93, WIDTH_c),
                              conv_std_logic_vector(94, WIDTH_c),
                              conv_std_logic_vector(95, WIDTH_c),
                              conv_std_logic_vector(96, WIDTH_c),
                              conv_std_logic_vector(97, WIDTH_c),
                              conv_std_logic_vector(98, WIDTH_c),
                              conv_std_logic_vector(99, WIDTH_c),
                              conv_std_logic_vector(100, WIDTH_c),
                              conv_std_logic_vector(101, WIDTH_c),
                              conv_std_logic_vector(102, WIDTH_c),
                              conv_std_logic_vector(103, WIDTH_c),
                              conv_std_logic_vector(104, WIDTH_c),
                              conv_std_logic_vector(105, WIDTH_c),
                              conv_std_logic_vector(106, WIDTH_c),
                              conv_std_logic_vector(107, WIDTH_c),
                              conv_std_logic_vector(108, WIDTH_c),
                              conv_std_logic_vector(109, WIDTH_c),
                              conv_std_logic_vector(110, WIDTH_c),
                              conv_std_logic_vector(111, WIDTH_c),
                              conv_std_logic_vector(112, WIDTH_c),
                              conv_std_logic_vector(113, WIDTH_c),
                              conv_std_logic_vector(114, WIDTH_c),
                              conv_std_logic_vector(115, WIDTH_c),
                              conv_std_logic_vector(116, WIDTH_c),
                              conv_std_logic_vector(117, WIDTH_c),
                              conv_std_logic_vector(118, WIDTH_c),
                              conv_std_logic_vector(119, WIDTH_c),
                              conv_std_logic_vector(120, WIDTH_c),
                              conv_std_logic_vector(121, WIDTH_c),
                              conv_std_logic_vector(122, WIDTH_c),
                              conv_std_logic_vector(123, WIDTH_c),
                              conv_std_logic_vector(124, WIDTH_c),
                              conv_std_logic_vector(125, WIDTH_c),
                              conv_std_logic_vector(126, WIDTH_c),
                              conv_std_logic_vector(127, WIDTH_c),
                              conv_std_logic_vector(128, WIDTH_c),
                              conv_std_logic_vector(129, WIDTH_c),
                              conv_std_logic_vector(130, WIDTH_c),
                              conv_std_logic_vector(131, WIDTH_c),
                              conv_std_logic_vector(132, WIDTH_c),
                              conv_std_logic_vector(133, WIDTH_c),
                              conv_std_logic_vector(134, WIDTH_c),
                              conv_std_logic_vector(135, WIDTH_c),
                              conv_std_logic_vector(136, WIDTH_c),
                              conv_std_logic_vector(137, WIDTH_c),
                              conv_std_logic_vector(138, WIDTH_c),
                              conv_std_logic_vector(139, WIDTH_c),
                              conv_std_logic_vector(140, WIDTH_c),
                              conv_std_logic_vector(141, WIDTH_c),
                              conv_std_logic_vector(142, WIDTH_c),
                              conv_std_logic_vector(143, WIDTH_c));
                              
    constant IMG_MEM2_CONTEXT : img_mem_t :=
                             (conv_std_logic_vector(1, WIDTH_c),
                              conv_std_logic_vector(4, WIDTH_c),
                              conv_std_logic_vector(12, WIDTH_c),
                              conv_std_logic_vector(33, WIDTH_c),
                              conv_std_logic_vector(40, WIDTH_c),
                              conv_std_logic_vector(21, WIDTH_c),
                              conv_std_logic_vector(0, WIDTH_c),
                              conv_std_logic_vector(2, WIDTH_c),
                              conv_std_logic_vector(12, WIDTH_c),
                              conv_std_logic_vector(7, WIDTH_c),
                              conv_std_logic_vector(0, WIDTH_c),
                              conv_std_logic_vector(21, WIDTH_c),
                              conv_std_logic_vector(112, WIDTH_c),
                              conv_std_logic_vector(0, WIDTH_c),
                              conv_std_logic_vector(1, WIDTH_c),
                              conv_std_logic_vector(3, WIDTH_c),
                              conv_std_logic_vector(109, WIDTH_c),
                              conv_std_logic_vector(43, WIDTH_c),
                              conv_std_logic_vector(98, WIDTH_c),
                              conv_std_logic_vector(109, WIDTH_c),
                              conv_std_logic_vector(210, WIDTH_c),
                              conv_std_logic_vector(221, WIDTH_c),
                              conv_std_logic_vector(2, WIDTH_c),
                              conv_std_logic_vector(100, WIDTH_c),
                              conv_std_logic_vector(120, WIDTH_c),
                              conv_std_logic_vector(225, WIDTH_c),
                              conv_std_logic_vector(26, WIDTH_c),
                              conv_std_logic_vector(27, WIDTH_c),
                              conv_std_logic_vector(28, WIDTH_c),
                              conv_std_logic_vector(29, WIDTH_c),
                              conv_std_logic_vector(30, WIDTH_c),
                              conv_std_logic_vector(45, WIDTH_c),
                              conv_std_logic_vector(255, WIDTH_c),
                              conv_std_logic_vector(240, WIDTH_c),
                              conv_std_logic_vector(230, WIDTH_c),
                              conv_std_logic_vector(3, WIDTH_c),
                              conv_std_logic_vector(1, WIDTH_c),
                              conv_std_logic_vector(209, WIDTH_c),
                              conv_std_logic_vector(109, WIDTH_c),
                              conv_std_logic_vector(128, WIDTH_c),
                              conv_std_logic_vector(40, WIDTH_c),
                              conv_std_logic_vector(142, WIDTH_c),
                              conv_std_logic_vector(187, WIDTH_c),
                              conv_std_logic_vector(69, WIDTH_c),
                              conv_std_logic_vector(208, WIDTH_c),
                              conv_std_logic_vector(45, WIDTH_c),
                              conv_std_logic_vector(46, WIDTH_c),
                              conv_std_logic_vector(47, WIDTH_c),
                              conv_std_logic_vector(48, WIDTH_c),
                              conv_std_logic_vector(49, WIDTH_c),
                              conv_std_logic_vector(50, WIDTH_c),
                              conv_std_logic_vector(51, WIDTH_c),
                              conv_std_logic_vector(52, WIDTH_c),
                              conv_std_logic_vector(53, WIDTH_c),
                              conv_std_logic_vector(54, WIDTH_c),
                              conv_std_logic_vector(55, WIDTH_c),
                              conv_std_logic_vector(56, WIDTH_c),
                              conv_std_logic_vector(57, WIDTH_c),
                              conv_std_logic_vector(58, WIDTH_c),
                              conv_std_logic_vector(59, WIDTH_c),
                              conv_std_logic_vector(60, WIDTH_c),
                              conv_std_logic_vector(61, WIDTH_c),
                              conv_std_logic_vector(62, WIDTH_c),
                              conv_std_logic_vector(63, WIDTH_c),
                              conv_std_logic_vector(64, WIDTH_c),
                              conv_std_logic_vector(65, WIDTH_c),
                              conv_std_logic_vector(66, WIDTH_c),
                              conv_std_logic_vector(67, WIDTH_c),
                              conv_std_logic_vector(68, WIDTH_c),
                              conv_std_logic_vector(123, WIDTH_c),
                              conv_std_logic_vector(120, WIDTH_c),
                              conv_std_logic_vector(210, WIDTH_c),
                              conv_std_logic_vector(209, WIDTH_c),
                              conv_std_logic_vector(199, WIDTH_c),
                              conv_std_logic_vector(209, WIDTH_c),
                              conv_std_logic_vector(255, WIDTH_c),
                              conv_std_logic_vector(236, WIDTH_c),
                              conv_std_logic_vector(77, WIDTH_c),
                              conv_std_logic_vector(78, WIDTH_c),
                              conv_std_logic_vector(79, WIDTH_c),
                              conv_std_logic_vector(80, WIDTH_c),
                              conv_std_logic_vector(81, WIDTH_c),
                              conv_std_logic_vector(82, WIDTH_c),
                              conv_std_logic_vector(83, WIDTH_c),
                              conv_std_logic_vector(84, WIDTH_c),
                              conv_std_logic_vector(85, WIDTH_c),
                              conv_std_logic_vector(86, WIDTH_c),
                              conv_std_logic_vector(87, WIDTH_c),
                              conv_std_logic_vector(88, WIDTH_c),
                              conv_std_logic_vector(209, WIDTH_c),
                              conv_std_logic_vector(90, WIDTH_c),
                              conv_std_logic_vector(9, WIDTH_c),
                              conv_std_logic_vector(92, WIDTH_c),
                              conv_std_logic_vector(255, WIDTH_c),
                              conv_std_logic_vector(94, WIDTH_c),
                              conv_std_logic_vector(95, WIDTH_c),
                              conv_std_logic_vector(192, WIDTH_c),
                              conv_std_logic_vector(97, WIDTH_c),
                              conv_std_logic_vector(98, WIDTH_c),
                              conv_std_logic_vector(99, WIDTH_c),
                              conv_std_logic_vector(100, WIDTH_c),
                              conv_std_logic_vector(101, WIDTH_c),
                              conv_std_logic_vector(102, WIDTH_c),
                              conv_std_logic_vector(103, WIDTH_c),
                              conv_std_logic_vector(104, WIDTH_c),
                              conv_std_logic_vector(105, WIDTH_c),
                              conv_std_logic_vector(106, WIDTH_c),
                              conv_std_logic_vector(107, WIDTH_c),
                              conv_std_logic_vector(108, WIDTH_c),
                              conv_std_logic_vector(109, WIDTH_c),
                              conv_std_logic_vector(32, WIDTH_c),
                              conv_std_logic_vector(239, WIDTH_c),
                              conv_std_logic_vector(112, WIDTH_c),
                              conv_std_logic_vector(113, WIDTH_c),
                              conv_std_logic_vector(114, WIDTH_c),
                              conv_std_logic_vector(115, WIDTH_c),
                              conv_std_logic_vector(116, WIDTH_c),
                              conv_std_logic_vector(117, WIDTH_c),
                              conv_std_logic_vector(118, WIDTH_c),
                              conv_std_logic_vector(119, WIDTH_c),
                              conv_std_logic_vector(120, WIDTH_c),
                              conv_std_logic_vector(121, WIDTH_c),
                              conv_std_logic_vector(122, WIDTH_c),
                              conv_std_logic_vector(123, WIDTH_c),
                              conv_std_logic_vector(124, WIDTH_c),
                              conv_std_logic_vector(125, WIDTH_c),
                              conv_std_logic_vector(126, WIDTH_c),
                              conv_std_logic_vector(127, WIDTH_c),
                              conv_std_logic_vector(128, WIDTH_c),
                              conv_std_logic_vector(129, WIDTH_c),
                              conv_std_logic_vector(98, WIDTH_c),
                              conv_std_logic_vector(11, WIDTH_c),
                              conv_std_logic_vector(13, WIDTH_c),
                              conv_std_logic_vector(6, WIDTH_c),
                              conv_std_logic_vector(32, WIDTH_c),
                              conv_std_logic_vector(255, WIDTH_c),
                              conv_std_logic_vector(36, WIDTH_c),
                              conv_std_logic_vector(9, WIDTH_c),
                              conv_std_logic_vector(18, WIDTH_c),
                              conv_std_logic_vector(69, WIDTH_c),
                              conv_std_logic_vector(67, WIDTH_c),
                              conv_std_logic_vector(1, WIDTH_c),
                              conv_std_logic_vector(140, WIDTH_c),
                              conv_std_logic_vector(14, WIDTH_c));

                             
    --Kerneli
    constant KER_MEM1_CONTEXT : ker_mem_t :=
                           (conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(1, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c));
                            
    constant KER_MEM2_CONTEXT : ker_mem_t :=
                           (conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(1, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c));
    constant KER_MEM3_CONTEXT : ker_mem_t :=
                           (conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(1, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c));
    constant KER_MEM4_CONTEXT : ker_mem_t :=
                           (conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(1, WIDTH_c),
                            conv_std_logic_vector(1, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c),
                            conv_std_logic_vector(0, WIDTH_c));
                                                                             
     signal clk_s: std_logic;
     signal reset_s: std_logic;
     
     constant COLUMNS_REG_ADDR_C : integer := 0;
     constant LINES_REG_ADDR_C : integer := 4;
     constant CMD_REG_ADDR_C : integer := 8;
     constant STATUS_REG_ADDR_C : integer := 12;
     constant START_DVA_FROM_JEDAN_REG_ADDR_C : integer := 16;
     constant START_TRI_FROM_DVA_REG_ADDR_C : integer := 20;
     constant START_CETIRI_FROM_DVA_REG_ADDR_C : integer := 24;
     
     --Ulazna slika
     signal mem_img_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal mem_img_data_i_s :  std_logic_vector(WIDTH_c - 1 downto 0);
     signal mem_img_wr_o_s :  std_logic;
     signal img_addr_o_s :  std_logic_vector(ADDR_c - 1 downto 0);
     signal img_data_i_s :  std_logic_vector(WIDTH_c - 1 downto 0);
     signal img_wr_o_s :  std_logic;
     
     signal mem_ker_addr1_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal mem_ker_data1_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal mem_ker_wr1_o_s : std_logic;
     signal ker_addr1_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal ker_data1_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal ker_wr1_o_s : std_logic;
     
     signal mem_ker_addr2_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal mem_ker_data2_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal mem_ker_wr2_o_s : std_logic;
     signal ker_addr2_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal ker_data2_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal ker_wr2_o_s : std_logic;
     
     signal mem_ker_addr3_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal mem_ker_data3_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal mem_ker_wr3_o_s : std_logic;
     signal ker_addr3_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal ker_data3_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal ker_wr3_o_s : std_logic;
     
     signal mem_ker_addr4_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal mem_ker_data4_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal mem_ker_wr4_o_s : std_logic;
     signal ker_addr4_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal ker_data4_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal ker_wr4_o_s : std_logic;
     
     signal res_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
     signal res_data_o_s : std_logic_vector(WIDTH_c - 1 downto 0);
     signal res_wr_o_s : std_logic;
     signal res_en_o_s : std_logic;
    
    -- Parameters of Axi-Lite Slave Bus Interface S00_AXI
    constant C_S00_AXI_DATA_WIDTH_c : integer := 32;
    constant C_S00_AXI_ADDR_WIDTH_c : integer := 5;
    
    -- Ports of Axi-Lite Slave Bus Interface S00_AXI
    signal s00_axi_aclk_s : std_logic := '0';
    signal s00_axi_aresetn_s : std_logic := '1';
    signal s00_axi_awaddr_s : std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0) := (others => '0');
    signal s00_axi_awprot_s : std_logic_vector(2 downto 0) := (others => '0');
    signal s00_axi_awvalid_s : std_logic := '0';
    signal s00_axi_awready_s : std_logic := '0';
    signal s00_axi_wdata_s : std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0) := (others => '0');
    signal s00_axi_wstrb_s : std_logic_vector((C_S00_AXI_DATA_WIDTH_c/8)-1 downto 0) := (others => '0');
    signal s00_axi_wvalid_s : std_logic := '0';
    signal s00_axi_wready_s : std_logic := '0';
    signal s00_axi_bresp_s : std_logic_vector(1 downto 0) := (others => '0');
    signal s00_axi_bvalid_s : std_logic := '0';
    signal s00_axi_bready_s : std_logic := '0';
    signal s00_axi_araddr_s : std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0) := (others => '0');
    signal s00_axi_arprot_s : std_logic_vector(2 downto 0) := (others => '0');
    signal s00_axi_arvalid_s : std_logic := '0';
    signal s00_axi_arready_s : std_logic := '0';
    signal s00_axi_rdata_s : std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0) := (others => '0');
    signal s00_axi_rresp_s : std_logic_vector(1 downto 0) := (others => '0');
    signal s00_axi_rvalid_s : std_logic := '0';
    signal s00_axi_rready_s : std_logic := '0';

begin

    reset_s <= not s00_axi_aresetn_s;
    
    clk_generator: process is
    begin
        clk_s <= '0';
        wait for 1 ps;
        clk_s <= '1';
        wait for 1 ps;
    end process;


    stimulus_generator: process 
        variable axi_read_data_v : std_logic_vector(31 downto 0);
        variable transfer_size_v : integer;
    begin
        report "Start !";
        
        s00_axi_aresetn_s <= '0';
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        s00_axi_aresetn_s <= '1';
        wait until falling_edge(clk_s);
        
        report "Ocitavanje kolona!";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(COLUMNS_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(columns_c, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s); 
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        
        report "Ocitavanje redova!";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(LINES_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(lines_c, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        
        report "Ucitavanje piksela slike!";
         mem_img_wr_o_s <= '1';
         for i in 0 to SIZE_c - 1 loop
            for j in 0 to SIZE_c - 1 loop 
                mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
                mem_img_data_i_s <= IMG_MEM_CONTEXT(i * lines_c + j);
                wait until falling_edge(clk_s);
            end loop;
         end loop;
        mem_img_wr_o_s <= '0';
       

        report "Ucitavanje piksela prvog kernela!";
        mem_ker_wr1_o_s <= '1';
        for i in 0 to kernelSize_c - 1 loop
            for j in 0 to kernelSize_c - 1 loop
                mem_ker_addr1_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr1_o_s'length);
                mem_ker_data1_i_s <= KER_MEM1_CONTEXT(i * kernelSize_c + j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_ker_wr1_o_s <= '0';
        
        report "Ucitavanje piksela drugog kernela!";
        mem_ker_wr2_o_s <= '1';
        for i in 0 to kernelSize_c - 1 loop
            for j in 0 to kernelSize_c - 1 loop
                mem_ker_addr2_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr2_o_s'length);
                mem_ker_data2_i_s <= KER_MEM2_CONTEXT(i * kernelSize_c + j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_ker_wr2_o_s <= '0';
     
     report "Ucitavanje piksela treceg kernela!";
        mem_ker_wr3_o_s <= '1';
        for i in 0 to kernelSize_c - 1 loop
            for j in 0 to kernelSize_c - 1 loop
                mem_ker_addr3_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr3_o_s'length);
                mem_ker_data3_i_s <= KER_MEM3_CONTEXT(i * kernelSize_c + j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_ker_wr3_o_s <= '0';
        
        report "Ucitavanje piksela cetvrtog kernela!";
        mem_ker_wr4_o_s <= '1';
        for i in 0 to kernelSize_c - 1 loop
            for j in 0 to kernelSize_c - 1 loop
                mem_ker_addr4_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr4_o_s'length);
                mem_ker_data4_i_s <= KER_MEM4_CONTEXT(i * kernelSize_c + j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_ker_wr4_o_s <= '0';
        
    -- Set the start signal to 1
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(1, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        
         -- wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        
        report "Ciscenje start bit-a!";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        
        
        loop
            wait until falling_edge(clk_s);
            s00_axi_araddr_s <= conv_std_logic_vector(STATUS_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c); 
            s00_axi_arvalid_s <= '1';
            s00_axi_rready_s <= '1';
            wait until s00_axi_arready_s = '1';
            wait until s00_axi_arready_s = '0';
            wait until falling_edge(clk_s);
            s00_axi_araddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
            s00_axi_arvalid_s <= '0';
            s00_axi_rready_s <= '0';
            -- Proveri da li je ready_axi 1
            if (s00_axi_rdata_s(0) = '1') then
                report "Prva faza je gotova, naredna slika se moze ubaciti!";
                exit;
            else
                wait for 1000 ps;
            end if;
        end loop;
        
        report "Ucitavanje piksela druge slike!";
         mem_img_wr_o_s <= '1';
         for i in 0 to SIZE_c - 1 loop
            for j in 0 to SIZE_c - 1 loop 
                mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
                mem_img_data_i_s <= IMG_MEM2_CONTEXT(i * lines_c + j);
                wait until falling_edge(clk_s);
            end loop;
         end loop;
        mem_img_wr_o_s <= '0';
        
     
        
        -- Set the start signal to 1
        report "Paralelizam=m  -> start bit je ponovo jedan";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(1, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        
         -- wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        
        report "Ciscenje start bit-a!(drugi put)";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        
        loop
            wait until falling_edge(clk_s);
            s00_axi_araddr_s <= conv_std_logic_vector(STATUS_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c); 
            s00_axi_arvalid_s <= '1';
            s00_axi_rready_s <= '1';
            wait until s00_axi_arready_s = '1';
            wait until s00_axi_arready_s = '0';
            wait until falling_edge(clk_s);
            s00_axi_araddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
            s00_axi_arvalid_s <= '0';
            s00_axi_rready_s <= '0';
            -- Proveri da li je ready_axi 1
            if (s00_axi_rdata_s(0) = '1') then
                report "Prva faza je gotova, naredna slika se moze ubaciti!";
                exit;
            else
                wait for 1000 ps;
            end if;
        end loop;
        
        report "Ucitavanje piksela druge slike!";
         mem_img_wr_o_s <= '1';
         for i in 0 to SIZE_c - 1 loop
            for j in 0 to SIZE_c - 1 loop 
                mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
                mem_img_data_i_s <= IMG_MEM_CONTEXT(i * lines_c + j);
                wait until falling_edge(clk_s);
            end loop;
         end loop;
        mem_img_wr_o_s <= '0';
        
        -- Set the start signal to 1
        report "Paralelizam=m  -> start bit je ponovo jedan";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(1, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
        
         -- wait for 5 falling edges of AXI-lite clock signal
        for i in 1 to 5 loop
            wait until falling_edge(clk_s);
        end loop;
        
        report "Ciscenje start bit-a!(drugi put)";
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(CMD_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '1';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '1';
        s00_axi_wstrb_s <= "1111";
        s00_axi_bready_s <= '1';
        wait until s00_axi_awready_s = '1';
        wait until s00_axi_awready_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
        s00_axi_awvalid_s <= '0';
        s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
        s00_axi_wvalid_s <= '0';
        s00_axi_wstrb_s <= "0000";
        wait until s00_axi_bvalid_s = '0';
        wait until falling_edge(clk_s);
        s00_axi_bready_s <= '0';
        wait until falling_edge(clk_s);
 
        report "zavrsene tri slike(treca je ista kao i prva)!";
        wait; 
    end process;


DUT: entity work.axi_convoluer_v1_0 
    generic map(
        WIDTH => WIDTH_c,
        ADDR => ADDR_c,
        SIZE => SIZE_c,
        kernelSize => kernelSize_c,
        numKernels => numKernels_c,
        kolone => columns_c,
        linije => lines_c
    )
    port map(
        img_data_i => img_data_i_s, 
        img_addr_o => img_addr_o_s,
        img_wr_o => img_wr_o_s,
        ker_data1_i => ker_data1_i_s,
        ker_addr1_o => ker_addr1_o_s,
        ker_wr1_o => ker_wr1_o_s,
        ker_data2_i => ker_data2_i_s,
        ker_addr2_o => ker_addr2_o_s,
        ker_wr2_o => ker_wr2_o_s,
        ker_data3_i => ker_data3_i_s,
        ker_addr3_o => ker_addr3_o_s,
        ker_wr3_o => ker_wr3_o_s,
        ker_data4_i => ker_data4_i_s,
        ker_addr4_o => ker_addr4_o_s,
        ker_wr4_o => ker_wr4_o_s,
        res_data_o => res_data_o_s,
        res_addr_o => res_addr_o_s,
        res_wr_o => res_wr_o_s,
        res_en_o => res_en_o_s,
    
        s00_axi_aclk    => clk_s,
        s00_axi_aresetn => s00_axi_aresetn_s,
        s00_axi_awaddr  => s00_axi_awaddr_s,
        s00_axi_awprot  => s00_axi_awprot_s, 
        s00_axi_awvalid => s00_axi_awvalid_s,
        s00_axi_awready => s00_axi_awready_s,
        s00_axi_wdata   => s00_axi_wdata_s,
        s00_axi_wstrb   => s00_axi_wstrb_s,
        s00_axi_wvalid  => s00_axi_wvalid_s,
        s00_axi_wready  => s00_axi_wready_s,
        s00_axi_bresp   => s00_axi_bresp_s,
        s00_axi_bvalid  => s00_axi_bvalid_s,
        s00_axi_bready  => s00_axi_bready_s,
        s00_axi_araddr  => s00_axi_araddr_s,
        s00_axi_arprot  => s00_axi_arprot_s,
        s00_axi_arvalid => s00_axi_arvalid_s,
        s00_axi_arready => s00_axi_arready_s,
        s00_axi_rdata   => s00_axi_rdata_s,
        s00_axi_rresp   => s00_axi_rresp_s,
        s00_axi_rvalid  => s00_axi_rvalid_s,
        s00_axi_rready  => s00_axi_rready_s
    );
    
img_mem: entity work.BRAM
    generic map(
        WIDTH => WIDTH_c,
        SIZE => SIZE_c,
        ADDR => ADDR_c
    )
    port map(
        clka => clk_s,
        reseta => reset_s,
        addra => mem_img_addr_o_s,
        dia => mem_img_data_i_s,
        doa => open,
        wea => mem_img_wr_o_s,
        addrb => img_addr_o_s,
        dib => (others => '0'),
        dob => img_data_i_s,
        web => img_wr_o_s
    );
    
ker_mem_jedan: entity work.BRAM
    generic map(
        WIDTH => WIDTH_c,
        SIZE => kernelSize_c,
        ADDR => ADDR_c
    )
    port map(
        clka => clk_s,
        reseta => reset_s,
        addra => mem_ker_addr1_o_s,
        dia => mem_ker_data1_i_s,
        doa => open,
        wea => mem_ker_wr1_o_s,
        addrb => ker_addr1_o_s,
        dib => (others => '0'),
        dob => ker_data1_i_s,
        web => ker_wr1_o_s
    );

ker_mem_dva: entity work.BRAM
    generic map(
        WIDTH => WIDTH_c,
        SIZE => kernelSize_c,
        ADDR => ADDR_c
    )
    port map(
        clka => clk_s,
        reseta => reset_s,
        addra => mem_ker_addr2_o_s,
        dia => mem_ker_data2_i_s,
        doa => open,
        wea => mem_ker_wr2_o_s,
        addrb => ker_addr2_o_s,
        dib => (others => '0'),
        dob => ker_data2_i_s,
        web => ker_wr2_o_s
    );

ker_mem_tri: entity work.BRAM
    generic map(
        WIDTH => WIDTH_c,
        SIZE => kernelSize_c,
        ADDR => ADDR_c
    )
    port map(
        clka => clk_s,
        reseta => reset_s,
        addra => mem_ker_addr3_o_s,
        dia => mem_ker_data3_i_s,
        doa => open,
        wea => mem_ker_wr3_o_s,
        addrb => ker_addr3_o_s,
        dib => (others => '0'),
        dob => ker_data3_i_s,
        web => ker_wr3_o_s
    );
    
ker_mem_cetiri: entity work.BRAM
    generic map(
        WIDTH => WIDTH_c,
        SIZE => kernelSize_c,
        ADDR => ADDR_c
    )
    port map(
        clka => clk_s,
        reseta => reset_s,
        addra => mem_ker_addr4_o_s,
        dia => mem_ker_data4_i_s,
        doa => open,
        wea => mem_ker_wr4_o_s,
        addrb => ker_addr4_o_s,
        dib => (others => '0'),
        dob => ker_data4_i_s,
        web => ker_wr4_o_s
    );  
    
conv_img_mem: entity work.BRAM
generic map(
    WIDTH => WIDTH_c,
    SIZE =>  size_small,
    ADDR => ADDR_c)
port map(
    clka => clk_s,
    reseta => reset_s,
    addra => (others => '0'),
    dia => (others => '0'),
    doa => open,
    wea => '0',
    addrb => res_addr_o_s,
    dib => res_data_o_s,
    dob => open,
    web => res_wr_o_s);
    
end Behavioral;
