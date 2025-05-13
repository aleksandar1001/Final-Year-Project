library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.moj_paket.all;

use IEEE.NUMERIC_STD.ALL;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
    -------Fajlovi u koje ce se upisivati i proveravati izlazi-------
    file izlazi : text open write_mode is
    "C:\Users\nisam_trebo_unutra\PSDS_PROJEKAT\Files_For_Tb\izlazi";
    file checker : text open read_mode is
	"C:\Users\nisam_trebo_unutra\PSDS_PROJEKAT\Files_For_Tb\checker.txt";  
    
    -------Konstante za ogranicenja petlji, dimenzije matrica i dimenzije memoriaj-------
    constant WIDTH_c : natural := 8;
    constant SIZE_c : natural := 12;
    constant COUNTER_c : natural := 10;
    constant kernelSize_c : natural := 3;
    constant CONV_4_KER_c : natural := 48;
    constant numKernels_c : natural := 4;
    constant columns_c : integer := 12;
    constant lines_C : integer := 12;
    constant ADDR_c : natural := 16;
    -------Tipovi za memorije i sadrzaj memorija(za sliku i kernele)-------
    type img_mem_t is array(0 to (SIZE_c * SIZE_c) - 1) of std_logic_vector(WIDTH_c - 1 downto 0);
    type ker_mem_t is array(0 to (kernelSize_c * kernelSize_c) - 1) of std_logic_vector(WIDTH_c - 1 downto 0);
    --Ulazna slika
    constant IMG_MEM1_CONTEXT : img_mem_t :=
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
    constant KER_MEM_CONTEXT : ker_mem_t :=
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
    -------Signali za ogranicavace petlji-------
    signal columns_s: std_logic_vector(WIDTH_c - 1 downto 0) := "00001100";
    signal lines_s: std_logic_vector(WIDTH_c - 1 downto 0) := "00001100";
    -------Memorijski interfejsi-------
    --Ulazna slika
    signal mem_img_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
    signal mem_img_data_i_s :  std_logic_vector(WIDTH_c - 1 downto 0);
    signal mem_img_wr_o_s :  std_logic;
    signal img_addr_o_s :  std_logic_vector(ADDR_c - 1 downto 0);
    signal img_data_i_s :  std_logic_vector(WIDTH_c - 1 downto 0);
    signal img_wr_o_s :  std_logic;
    --Kerneli
    signal mem_ker_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
    signal mem_ker_data_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
    signal mem_ker_wr_o_s : std_logic;
    signal ker_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
    signal ker_data_i_s : std_logic_vector(WIDTH_c - 1 downto 0);
    signal ker_wr_o_s : std_logic;
    
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
    
    --konvoluirana slika 
    signal res_addr_o_s : std_logic_vector(ADDR_c - 1 downto 0);
    signal res_data_o_s : std_logic_vector(WIDTH_c - 1 downto 0);
    signal res_wr_o_s : std_logic;
    signal res_en_o_s : std_logic;
    -------Standardni signali-------
    signal clk_s : std_logic;
    signal reset_s : std_logic;
    -------Komandni signal-------
    signal start_s : std_logic := '0';
    signal start_dva_from_jedan_s : std_logic;
    signal start_tri_from_dva_s : std_logic;
    signal start_cetiri_from_tri_s : std_logic;
    -------Statusni signal-------
    signal ready_s : std_logic;
begin

-------Generator takta-------
process
begin
    clk_s <= '0';
    wait for 1 ps;
    clk_s <= '1';
    wait for 1 ps;
end process;

-------Stimulus generator-------
process
begin
    reset_s <= '1';
    wait for 5 ns;
    reset_s <= '0';
    wait until falling_edge(clk_s);
    
    -- Ubacivanje prve slike u img_mem
    mem_img_wr_o_s <= '1';
    for i in 0 to SIZE_c - 1 loop
        for j in 0 to SIZE_c - 1 loop 
            mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
            mem_img_data_i_s <= IMG_MEM1_CONTEXT(i * lines_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_img_wr_o_s <= '0';
    -- Ocitavane podataka iz ker_mem
    mem_ker_wr_o_s <= '1';
    for i in 0 to kernelSize_c - 1 loop
        for j in 0 to kernelSize_C - 1 loop
            mem_ker_addr_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr_o_s'length);
            mem_ker_data_i_s <= KER_MEM_CONTEXT(i * kernelSize_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_ker_wr_o_s <= '0';
    
    --Ucitavanje drugog kernela
    mem_ker_wr2_o_s <= '1';
    for i in 0 to kernelSize_c - 1 loop
        for j in 0 to kernelSize_c - 1 loop
            mem_ker_addr2_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr2_o_s'length);
            mem_ker_data2_i_s <= KER_MEM2_CONTEXT(i * kernelSize_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_ker_wr2_o_s <= '0';
    
    
    -- Ucitavanje treceg kernela
    mem_ker_wr3_o_s <= '1';
    for i in 0 to kernelSize_c - 1 loop
        for j in 0 to kernelSize_c - 1 loop
            mem_ker_addr3_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr3_o_s'length);
            mem_ker_data3_i_s <= KER_MEM3_CONTEXT(i * kernelSize_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_ker_wr3_o_s <= '0';
    
    
    -- Ucitavanje cetvrtog kernela
    mem_ker_wr4_o_s <= '1';
    for i in 0 to kernelSize_c - 1 loop
        for j in 0 to kernelSize_c - 1 loop
            mem_ker_addr4_o_s <= conv_std_logic_vector(i * kernelSize_c + j, mem_ker_addr4_o_s'length);
            mem_ker_data4_i_s <= KER_MEM4_CONTEXT(i * kernelSize_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_ker_wr4_o_s <= '0';
    
    
    report "Beggining of Pipelined Convolution";
    --Zapocni konvoluciju
    start_s <= '1';
    wait until falling_edge(clk_s);
    start_s <= '0';
    
    wait until falling_edge(clk_s);
    
    wait until start_dva_from_jedan_s <= '1';
    
    
    report "Can add new image!";
  
   -- ******* Can add the image here, but do not start phase one in parallel with 2nd phase because of buffer1 overwrite ****** --
   
   
   
   wait until start_tri_from_dva_s <= '1';
   
    --Ubacivanje druge slike u img_mem
    mem_img_wr_o_s <= '1';
    for i in 0 to SIZE_c - 1 loop
        for j in 0 to SIZE_c - 1 loop 
            mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
            mem_img_data_i_s <= IMG_MEM2_CONTEXT(i * lines_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_img_wr_o_s <= '0';
    
    report "New image added -> starting phase one in parallel with phase three";
    
    start_s <= '1';
    wait until falling_edge(clk_s);
    start_s <= '0';
    
    wait until start_cetiri_from_tri_s <= '1';
    
    -- ******* Can add the image here, but do not start phase one in parallel with 4th phase because of buffer2 overwrite ****** --
    
    wait until start_tri_from_dva_s <= '1';
    --Ubacivanje trece slike u img_mem
    mem_img_wr_o_s <= '1';
    for i in 0 to SIZE_c - 1 loop
        for j in 0 to SIZE_c - 1 loop 
            mem_img_addr_o_s <= conv_std_logic_vector(i * columns_c + j, mem_img_addr_o_s'length);
            mem_img_data_i_s <= IMG_MEM1_CONTEXT(i * lines_c + j);
            wait until falling_edge(clk_s);
        end loop;
    end loop;
    mem_img_wr_o_s <= '0';
    
    report "Third image added -> starting phase one in parallel with phase three";
    
    start_s <= '1';
    wait until falling_edge(clk_s);
    start_s <= '0';
    
    wait;
end process;

-------Proces za pisanje rezultata konvolucije u fajl-------
write_to_file: process(clk_S)
    variable line_out : line;
    variable str : string(1 to 8) := (others => '0');
begin
    if rising_edge(clk_s) then
        if res_wr_o_s = '1' then
            str := (others => '0');
           for i in 0 to 7 loop
                if res_data_o_s(i) = '1' then
                    str(8 - i) := '1';
                 else 
                    str(8 - i) := '0';
                  end if;
             end loop;
            write(line_out, str);
            writeline(izlazi, line_out);
        end if;
    end if;
end process;

-----Proces za proveravanje rezultata-------
check : process(clk_s)
    variable tv_izlazi : line;  
    variable tmp: std_logic_vector(WIDTH_c - 1 downto 0); 
begin              

        if rising_edge (clk_s) then
            if res_en_o_s = '1' then
                readline(checker, tv_izlazi);
                tmp := to_std_logic_vector(string(tv_izlazi));
                if (tmp /= res_data_o_s) then
                    report "CHECKER DETECTED BUG -> Results does not match!" severity failure;
                end if;
            end if;
        end if;
end process;

-------Instancioniranja komponenti-------
--Ulazna slika
img_mem: entity work.img_mem
generic map(
    WIDTH => WIDTH_c,
    SIZE => SIZE_c,
    ADDR => ADDR_c)
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => mem_img_addr_o_s,
    p1_data_i => mem_img_data_i_s,
    p1_data_o => open,
    p1_wr_i => mem_img_wr_o_s,
    p2_addr_i => img_addr_o_s,
    p2_data_i => (others => '0'),
    p2_data_o => img_data_i_s,
    p2_wr_i => img_wr_o_s);
--Kerneli
ker_mem_jedan: entity work.ker_mem
generic map(
    WIDTH => WIDTH_c,
    SIZE => kernelSize_c,
    ADDR => ADDR_C)
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => mem_ker_addr_o_s,
    p1_data_i => mem_ker_data_i_s,
    p1_data_o => open,
    p1_wr_i => mem_ker_wr_o_s,
    p2_addr_i => ker_addr_o_s,
    p2_data_i => (others => '0'),
    p2_data_o => ker_data_i_s,
    p2_wr_i => ker_wr_o_s);
    
ker_mem_dva: entity work.ker_mem
generic map(
    WIDTH => WIDTH_c,
    SIZE => kernelSize_c,
    ADDR => ADDR_C)
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => mem_ker_addr2_o_s,
    p1_data_i => mem_ker_data2_i_s,
    p1_data_o => open,
    p1_wr_i => mem_ker_wr2_o_s,
    p2_addr_i => ker_addr2_o_s,
    p2_data_i => (others => '0'),
    p2_data_o => ker_data2_i_s,
    p2_wr_i => ker_wr2_o_s);
    
ker_mem_tri: entity work.ker_mem
generic map(
    WIDTH => WIDTH_c,
    SIZE => kernelSize_c,
    ADDR => ADDR_C)
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => mem_ker_addr3_o_s,
    p1_data_i => mem_ker_data3_i_s,
    p1_data_o => open,
    p1_wr_i => mem_ker_wr3_o_s,
    p2_addr_i => ker_addr3_o_s,
    p2_data_i => (others => '0'),
    p2_data_o => ker_data3_i_s,
    p2_wr_i => ker_wr3_o_s);
    
    
ker_mem_cetiri: entity work.ker_mem
generic map(
    WIDTH => WIDTH_c,
    SIZE => kernelSize_c,
    ADDR => ADDR_C)
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => mem_ker_addr4_o_s,
    p1_data_i => mem_ker_data4_i_s,
    p1_data_o => open,
    p1_wr_i => mem_ker_wr4_o_s,
    p2_addr_i => ker_addr4_o_s,
    p2_data_i => (others => '0'),
    p2_data_o => ker_data4_i_s,
    p2_wr_i => ker_wr4_o_s);
  
--Konvoluirana slika
conv_img_mem: entity work.img_mem
generic map(
    WIDTH =>  WIDTH_c,
    SIZE =>  SIZE_c,
    ADDR => ADDR_c
    )
port map(
    clk => clk_s,
    reset => reset_s,
    p1_addr_i => (others => '0'),
    p1_data_i => (others => '0'),
    p1_data_o => open,
    p1_wr_i => '0',
    p2_addr_i => res_addr_o_s,
    p2_data_i => res_data_o_s,
    p2_data_o => open,
    p2_wr_i => res_wr_o_s);
--DUV
Convoluer2D: entity work.Convoluer2D
generic map(
    WIDTH => WIDTH_c,
    SIZE => SIZE_c,
    COUNTER => COUNTER_c,
    kernelSize => kernelSize_c,
    ADDR => ADDR_c)
port map(
    clk => clk_s,
    reset => reset_s,
    
    img_addr_o => img_addr_o_s,
    img_data_i => img_data_i_s,
    img_wr_o => img_wr_o_s,
    
    ker_addr1_o => ker_addr_o_s,
    ker_data1_i => ker_data_i_s,
    ker_wr1_o => ker_wr_o_s,
    ker_addr2_o => ker_addr2_o_s,
    ker_data2_i => ker_data2_i_s,
    ker_wr2_o => ker_wr2_o_s,
    
    ker_addr3_o => ker_addr3_o_s,
    ker_data3_i => ker_data3_i_s,
    ker_wr3_o => ker_wr3_o_s,
    ker_addr4_o => ker_addr4_o_s,
    ker_data4_i => ker_data4_i_s,
    ker_wr4_o => ker_wr4_o_s,
    
    res_addr_o => res_addr_o_s,
    res_data_o => res_data_o_s,
    res_wr_o => res_wr_o_s,
    res_en_o => res_en_o_s,
    
    start => start_s,
    ready => ready_s,
    start_dva_from_jedan => start_dva_from_jedan_s,
    start_tri_from_dva => start_tri_from_dva_s,
    start_cetiri_from_tri => start_cetiri_from_tri_s,

    columns => columns_s,
    lines => lines_s
    );
    
    
process
    variable simulation_time : time := 0 ns;
begin
    wait until start_s = '1';
    while true loop
        wait until falling_edge(clk_s);
        simulation_time := simulation_time + 25ns;
        if(ready_s = '1') then
            report "First phase is done within: " & time'image(simulation_time);
            exit;
       end if;
    end loop;
    
    wait;
end process;

process
    variable simulation_time : time := 0 ns;
begin
    wait until start_dva_from_jedan_s = '1';
    while true loop
        wait until falling_edge(clk_s);
        simulation_time := simulation_time + 25ns;
        if(start_tri_from_dva_s = '1') then
            report "Secound phase is done within: " & time'image(simulation_time);
            exit;
       end if;
    end loop;
    
    wait;
end process;

process
    variable simulation_time : time := 0 ns;
begin
    wait until start_tri_from_dva_s = '1';
    while true loop
        wait until falling_edge(clk_s);
        simulation_time := simulation_time + 25ns;
        if(start_cetiri_from_tri_s = '1') then
            report "Third phase is done within: " & time'image(simulation_time);
            exit;
       end if;
    end loop;
    
    wait;
end process;

    
end architecture Behavioral;
