library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

use IEEE.NUMERIC_STD.ALL;

entity Convoluer2D is
generic(
    WIDTH : natural := 8;
    SIZE : natural := 12;
    kernelSize : natural := 3;
    Kolone : natural := 12;
    Linije : natural := 12;
    ADDR : natural := 16;
    SIGNED_UNSIGNED: string:= "unsigned";
    COUNTER : natural := 10
);
Port( 
    --standardni signali
    clk : in std_logic;
    reset : in std_logic;
    --komandni interfejs
    start : in std_logic;
    columns : in std_logic_vector(WIDTH - 1 downto 0);
    lines : in std_logic_vector(WIDTH - 1 downto 0);
    --statusni interfejs
    ready : out std_logic;
    start_dva_from_jedan : out std_logic;
    start_tri_from_dva : out std_logic;
    start_cetiri_from_tri : out std_logic;
    --ready_faza_dva : out std_logic;
    --ready_faza_tri : out std_logic;
    --ready_faza_cetiri : out std_logic;
    --konvoluirana slika
    res_addr_o : out std_logic_vector(ADDR - 1 downto 0);
    res_data_o : out std_logic_vector(WIDTH - 1 downto 0);
    res_wr_o : out std_logic;  
    res_en_o : out std_logic;
    --ulazna slika
    img_addr_o : out std_logic_vector(ADDR - 1 downto 0);
    img_data_i : in std_logic_vector(WIDTH - 1 downto 0);
    img_wr_o : out std_logic;
    --Kerneli
    ker_addr1_o : out std_logic_vector(ADDR - 1 downto 0);
    ker_data1_i : in std_logic_vector(WIDTH - 1 downto 0);
    ker_wr1_o : out std_logic;
    
    ker_addr2_o : out std_logic_vector(ADDR - 1 downto 0);
    ker_data2_i : in std_logic_vector(WIDTH - 1 downto 0);
    ker_wr2_o : out std_logic;
    
    ker_addr3_o : out std_logic_vector(ADDR - 1 downto 0);
    ker_data3_i : in std_logic_vector(WIDTH - 1 downto 0);
    ker_wr3_o : out std_logic;
    
    ker_addr4_o : out std_logic_vector(ADDR - 1 downto 0);
    ker_data4_i : in std_logic_vector(WIDTH - 1 downto 0);
    ker_wr4_o : out std_logic
);
end Convoluer2D;

architecture Behavioral of Convoluer2D is

    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";
    
    -- Interni baferi
    type buffer1_t is array(0 to 100) of std_logic_vector(WIDTH - 1 downto 0);
    type buffer2_t is array(0 to 64) of std_logic_vector(WIDTH - 1 downto 0);
    type buffer3_t is array(0 to 36) of std_logic_vector(WIDTH - 1 downto 0);
    
    signal buffer1 : buffer1_t := (others => (others => '0'));
    signal buffer2 : buffer2_t := (others => (others => '0'));
    signal buffer3 : buffer3_t := (others => (others => '0'));
    
    -- Stanja za svaku od faza
    type state_type_faza_jedan is(idle, CONV1_RESET_i, CONV1_RESET_j, CONV1_RESET_m, CONV1_RESET_n, CONV1_INIT, CONV1_ADDR, CONV1_WORK, CONV1_m_PLUS,
CONV1_m_CHECK, CONV1_WRITE_BUFF1, CONV1_DONE);
    signal state_reg_faza_jedan, state_next_faza_jedan : state_type_faza_jedan; 
    
    type state_type_faza_dva is(idle, CONV2_RESET_i, CONV2_RESET_j, CONV2_RESET_m, CONV2_RESET_n, CONV2_INIT, CONV2_ADDR, CONV2_WORK, CONV2_m_PLUS,
CONV2_m_CHECK, CONV2_WRITE_BUFF2, CONV2_DONE);
    signal state_reg_faza_dva, state_next_faza_dva : state_type_faza_dva;
    
     type state_type_faza_tri is(idle, CONV3_RESET_i, CONV3_RESET_j, CONV3_RESET_m, CONV3_RESET_n, CONV3_INIT, CONV3_ADDR, CONV3_WORK, CONV3_m_PLUS,
CONV3_m_CHECK, CONV3_WRITE_BUFF3, CONV3_DONE);
    signal state_reg_faza_tri, state_next_faza_tri : state_type_faza_tri;
    
    type state_type_faza_cetiri is(idle, CONV4_RESET_i, CONV4_RESET_j, CONV4_RESET_m, CONV4_RESET_n, CONV4_INIT, CONV4_ADDR, CONV4_WORK, CONV4_m_PLUS,
CONV4_m_CHECK, CONV4_WRITE_OUTPUT, CONV4_DONE);
    signal state_reg_faza_cetiri, state_next_faza_cetiri : state_type_faza_cetiri;
    
    signal i_reg, i_next : unsigned(WIDTH - 1 downto 0); 
    signal j_reg, j_next : unsigned(WIDTH - 1 downto 0);
    signal m_reg, m_next : unsigned(kernelSize - 1 downto 0);
    signal n_reg, n_next : unsigned(kernelSize - 1 downto 0);
    
    signal i2_reg, i2_next : unsigned(WIDTH - 1 downto 0); 
    signal j2_reg, j2_next : unsigned(WIDTH - 1 downto 0);
    signal m2_reg, m2_next : unsigned(kernelSize - 1 downto 0);
    signal n2_reg, n2_next : unsigned(kernelSize - 1 downto 0);
    
    signal i3_reg, i3_next : unsigned(WIDTH - 1 downto 0); 
    signal j3_reg, j3_next : unsigned(WIDTH - 1 downto 0);
    signal m3_reg, m3_next : unsigned(kernelSize - 1 downto 0);
    signal n3_reg, n3_next : unsigned(kernelSize - 1 downto 0);
    
    signal i4_reg, i4_next : unsigned(WIDTH - 1 downto 0); 
    signal j4_reg, j4_next : unsigned(WIDTH - 1 downto 0);
    signal m4_reg, m4_next : unsigned(kernelSize - 1 downto 0);
    signal n4_reg, n4_next : unsigned(kernelSize - 1 downto 0);
    
    signal sum1_reg, sum1_next : unsigned(WIDTH - 1 downto 0);
    signal sum2_reg, sum2_next : unsigned(WIDTH - 1 downto 0);
    signal sum3_reg , sum3_next : unsigned(WIDTH - 1 downto 0);
    signal sum4_reg, sum4_next : unsigned(WIDTH - 1 downto 0);
    
    signal intermediate_int1, intermediate_int2, intermediate_int3, intermediate_int4 : integer := 0;
    signal intermediate_int5, intermediate_int6, intermediate_int7, intermediate_int8 : integer := 0;
    
    -- Signali za adresiranje bafera, ulazne/izlane slike i kernela
    signal buffer1_counter_reg, buffer1_counter_next : integer;
    signal buffer1_counter_reg_faza_dva, buffer1_counter_next_faza_dva : integer;
    
    signal buffer2_counter_reg, buffer2_counter_next : integer;
    signal buffer2_counter_reg_faza_tri, buffer2_counter_next_faza_tri : integer;
    
    signal buffer3_counter_reg, buffer3_counter_next : integer;
    signal buffer3_counter_reg_faza_cetiri, buffer3_counter_next_faza_cetiri : integer;
     
    signal img_addr_reg, img_addr_next: unsigned(ADDR - 1 downto 0);
    
    signal ker_addr1_reg, ker_addr1_next: unsigned(ADDR - 1 downto 0);
    signal ker_addr2_reg, ker_addr2_next: unsigned(ADDR - 1 downto 0);
    signal ker_addr3_reg, ker_addr3_next: unsigned(ADDR - 1 downto 0);
    signal ker_addr4_reg, ker_addr4_next: unsigned(ADDR - 1 downto 0);
    
    signal res_addr_reg, res_addr_next: unsigned(ADDR - 1 downto 0);
    signal buffer_addr2_reg, buffer_addr2_next : unsigned(ADDR - 1 downto 0);
    
    signal start_dva_from_jedan_s, start_tri_from_dva_S, start_cetiri_from_tri_s : std_logic := '0';
    signal stop_dva_from_dva, stop_tri_from_tri, stop_cetiri_from_cetiri : std_logic := '0';
    
    shared variable faza_jedan_complete_count_v : integer := 0;
    shared variable faza_dva_complete_count_v : integer := 0;
    shared variable faza_tri_complete_count_v : integer := 0;
    
    signal faza_jedan_complete_count_s : integer := 0;
    signal faza_dva_complete_count_s : integer := 0;
    signal faza_tri_complete_count_s : integer := 0;
    signal faza_cetiri_complete_count_s : integer := 0;
    
begin

-------registar stanja(Control Path) + registri podataka(Data Path)-------
process(clk, reset)
begin
    if(reset = '1') then
        state_reg_faza_jedan <= idle;
        state_reg_faza_dva <= idle;
        state_reg_faza_tri <= idle;
        state_reg_faza_cetiri <= idle;
        i_reg <= (others => '0');
        j_reg <= (others => '0');
        m_reg <= (others => '0');
        n_reg <= (others => '0');
        i2_reg <= (others => '0');
        j2_reg <= (others => '0');
        m2_reg <= (others => '0');
        n2_reg <= (others => '0');
        i3_reg <= (others => '0');
        j3_reg <= (others => '0');
        m3_reg <= (others => '0');
        n3_reg <= (others => '0');
        i4_reg <= (others => '0');
        j4_reg <= (others => '0');
        m4_reg <= (others => '0');
        n4_reg <= (others => '0');
        sum1_reg <= (others => '0');
        sum2_reg <= (others => '0');
        sum3_reg <= (others => '0');
        sum3_reg <= (others => '0');
        img_addr_reg <= (others => '0');
        ker_addr1_reg <= (others => '0');
        ker_addr2_reg <= (others => '0');
        ker_addr3_reg <= (others => '0');
        ker_addr4_reg <= (others => '0');
        res_addr_reg <= (others => '0');
        
        buffer1_counter_reg <= 0;
        buffer1_counter_reg_faza_dva <= 0;
        
        buffer2_counter_reg <= 0;
        buffer2_counter_reg_faza_tri <= 0;
        
        buffer3_counter_reg <= 0;
        buffer3_counter_reg_faza_cetiri <= 0;
        
    elsif(clk'event and clk = '1') then
        state_reg_faza_jedan <= state_next_faza_jedan;
        state_reg_faza_dva <= state_next_faza_dva;
        state_reg_faza_tri <= state_next_faza_tri;
        state_reg_faza_cetiri <= state_next_faza_cetiri;
        i_reg <= i_next;
        j_reg <= j_next;
        m_reg <= m_next;
        n_reg <= n_next;
        i2_reg <= i2_next;
        j2_reg <= j2_next;
        m2_reg <= m2_next;
        n2_reg <= n2_next;
        i3_reg <= i3_next;
        j3_reg <= j3_next;
        m3_reg <= m3_next;
        n3_reg <= n3_next;
        i4_reg <= i4_next;
        j4_reg <= j4_next;
        m4_reg <= m4_next;
        n4_reg <= n4_next;
        sum1_reg <= sum1_next;
        sum2_reg <= sum2_next;
        sum3_reg <= sum3_next;
        sum4_reg <= sum4_next;
        img_addr_reg <= img_addr_next;
        ker_addr1_reg <= ker_addr1_next;
        ker_addr2_reg <= ker_addr2_next;
        ker_addr3_reg <= ker_addr3_next;
        ker_addr4_reg <= ker_addr4_next;
        res_addr_reg <= res_addr_next;
        
        buffer1_counter_reg <= buffer1_counter_next;
        buffer1_counter_reg_faza_dva <= buffer1_counter_next_faza_dva;
        
        buffer2_counter_reg <= buffer2_counter_next;
        buffer2_counter_reg_faza_tri <= buffer2_counter_next_faza_tri;
        
        buffer3_counter_reg <= buffer3_counter_next;
        buffer3_counter_reg_faza_cetiri <= buffer3_counter_next_faza_cetiri;
    end if;
end process;

faza_jedan: process(state_reg_faza_jedan, start, img_data_i, i_reg, i_next, j_reg, j_next, m_reg, m_next, n_reg, n_next,
sum1_reg, sum1_next, img_addr_reg, img_addr_next, intermediate_int1, intermediate_int2)
begin
    i_next <= i_reg;
    j_next <= j_reg;
    m_next <= m_reg;
    n_next <= n_reg;
    sum1_next <= sum1_reg;
    img_addr_next <= img_addr_reg;
    img_addr_o <= (others => '0');
    img_wr_o <= '0';
    ker_addr1_next <= ker_addr1_reg;
    ker_addr1_o <= (others => '0');
    ker_wr1_o <= '0';
    ready <= '0';
    buffer1_counter_next <= buffer1_counter_reg;
    
    case state_reg_faza_jedan is 
        when idle =>
            ready <= '1';
            if(start = '1') then
                buffer1_counter_next <= 0;
                state_next_faza_jedan <= CONV1_RESET_i;
            else
                state_next_faza_jedan <= idle;
            end if;
        when CONV1_RESET_i =>
            i_next <= to_unsigned(0, WIDTH);
            state_next_faza_jedan <= CONV1_RESET_j;
        when CONV1_RESET_j => 
            j_next <= to_unsigned(0, WIDTH);
            state_next_faza_jedan <= CONV1_RESET_m; 
        when CONV1_RESET_m =>  
            sum1_next <= to_unsigned(0, WIDTH);
            m_next <= to_unsigned(0, kernelSize);
            state_next_faza_jedan <= CONV1_RESET_n;
        when CONV1_RESET_n => 
            n_next <= to_unsigned(0, kernelSize);
            state_next_faza_jedan <= CONV1_INIT;
        when CONV1_INIT => 
            img_addr_next <= (((i_reg + m_reg) * SIZE + j_reg + n_reg));
            state_next_faza_jedan <= CONV1_ADDR;
        when CONV1_ADDR =>  
                img_addr_o <= std_logic_vector(img_addr_reg);
                ker_addr1_o <= std_logic_vector(ker_addr1_reg);
                state_next_faza_jedan <= CONV1_WORK;
        when CONV1_WORK =>   
            if((i_reg + m_reg) < unsigned(columns) AND (j_reg + n_reg ) < unsigned(lines)) then
                if(SIGNED_UNSIGNED = "Signed") then
                    intermediate_int1 <= to_integer(signed(img_data_i));
                    intermediate_int2 <= to_integer(signed(ker_data1_i));
                    sum1_next <= sum1_reg + to_unsigned(intermediate_int1 * intermediate_int2, sum1_next'length);
                else
                    intermediate_int1 <= to_integer(unsigned(img_data_i));
                    intermediate_int2 <= to_integer(unsigned(ker_data1_i));
                    sum1_next <= sum1_reg + intermediate_int1 * intermediate_int2;
                end if;
            end if;
            n_next <= n_reg + 1;
            ker_addr1_next <= ((ker_addr1_reg + 1)) mod 9; 
            if(n_next = KernelSize) then
                img_addr_next <= (((i_reg + m_reg) * SIZE + j_reg + n_reg));
                state_next_faza_jedan <= CONV1_m_PLUS;
            else
                state_next_faza_jedan <= CONV1_INIT;
            end if;
        when CONV1_m_PLUS =>  
            img_addr_o <= std_logic_vector(img_addr_reg);
            ker_addr1_o <= std_logic_vector(ker_addr1_reg);
            m_next <= m_reg + 1;
            state_next_faza_jedan <= CONV1_m_CHECK;
        when CONV1_m_CHECK =>  
            intermediate_int1 <= to_integer(unsigned(img_data_i));
            intermediate_int2 <= to_integer(unsigned(ker_data1_i));
            sum1_next <= sum1_reg + intermediate_int1 * intermediate_int2;        
            if(m_next = kernelSize) then
                state_next_faza_jedan <= CONV1_WRITE_BUFF1;
            else 
                state_next_faza_jedan <= CONV1_RESET_n;
            end if;
        when CONV1_WRITE_BUFF1 =>  
            if(sum1_next > 255) then
                sum1_next <= to_unsigned(255, sum1_next'length);
            elsif(sum1_next < 0) then
                sum1_next <= to_unsigned(0, sum1_next'length);
            end if;
            buffer1_counter_next <= (buffer1_counter_reg + 1)mod 101;
            buffer1(buffer1_counter_next) <= std_logic_vector(sum1_next);
            j_next <= j_reg + 1;
            if(j_next = unsigned(lines) - 2) then 
                state_next_faza_jedan <= CONV1_DONE;
            else
                state_next_faza_jedan <= CONV1_RESET_m;
            end if;
        when CONV1_DONE => 
            i_next <= i_reg + 1;
            if(i_next = unsigned(columns) - 2) then
                faza_jedan_complete_count_s <= faza_jedan_complete_count_s + 1;
                faza_jedan_complete_count_v := faza_jedan_complete_count_v + 1;
                start_dva_from_jedan_s <= '1';
                state_next_faza_jedan <= idle;  
            else 
                state_next_faza_jedan <= CONV1_RESET_j;
            end if;
    end case;
end process;

faza_dva: process(state_reg_faza_dva, start_dva_from_jedan_s, i2_reg, i2_next, j2_reg, j2_next, m2_reg, m2_next, n2_reg, 
n2_next, sum2_reg, sum2_next, intermediate_int3, intermediate_int4, faza_jedan_complete_count_s)
begin
    i2_next <= i2_reg;
    j2_next <= j2_reg;
    m2_next <= m2_reg;
    n2_next <= n2_reg;
    sum2_next <= sum2_reg;
    ker_addr2_next <= ker_addr2_reg;
    ker_addr2_o <= (others => '0');
    buffer1_counter_next_faza_dva <= buffer1_counter_next_faza_dva;
    buffer2_counter_next <= buffer2_counter_reg;
    
    case state_reg_faza_dva is
         when idle =>
            stop_dva_from_dva <= '0';  --keep in mind that this wont be visiable 'till next clk cycle
            start_tri_from_dva_s <= '0';
            if(start_dva_from_jedan_s = '1' AND stop_dva_from_dva = '0') then 
                buffer2_counter_next <= 0;
                state_next_faza_dva <= CONV2_RESET_i;
            else
                state_next_faza_dva <= idle;
            end if;
            if(faza_jedan_complete_count_v >= 2) then
                faza_jedan_complete_count_v := faza_jedan_complete_count_v - 1;
                buffer2_counter_next <= 0;
                state_next_faza_dva <= CONV2_RESET_i;
            end if;
            
        when CONV2_RESET_i =>
            i2_next <= to_unsigned(0, WIDTH);
            state_next_faza_dva <= CONV2_RESET_j;
        when CONV2_RESET_j => 
            j2_next <= to_unsigned(0, WIDTH);
            state_next_faza_dva <= CONV2_RESET_m; 
        when CONV2_RESET_m =>  
            sum2_next <= to_unsigned(0, WIDTH);
            m2_next <= to_unsigned(0, kernelSize);
            state_next_faza_dva <= CONV2_RESET_n;
        when CONV2_RESET_n => 
            n2_next <= to_unsigned(0, kernelSize);
            state_next_faza_dva <= CONV2_INIT;
        when CONV2_INIT => 
            buffer1_counter_next_faza_dva <= (((to_integer(i2_reg) + to_integer(m2_reg)) * (SIZE - 2) + to_integer(j2_reg) + to_integer(n2_reg)));
            state_next_faza_dva <= CONV2_ADDR;
        when CONV2_ADDR =>  
                ker_addr2_o <= std_logic_vector(ker_addr2_reg);
                state_next_faza_dva <= CONV2_WORK;
        when CONV2_WORK =>   
            if((i2_reg + m2_reg) < (unsigned(columns) - 2) AND (j2_reg + n2_reg ) < (unsigned(lines)- 2)) then
                if(SIGNED_UNSIGNED = "Signed") then
                    intermediate_int3 <=  to_integer(signed(buffer1(buffer1_counter_next_faza_dva)));
                    intermediate_int4 <= to_integer(signed(ker_data2_i));
                    sum2_next <= sum2_reg + to_unsigned(intermediate_int3 * intermediate_int4, sum2_next'length);
                else
                    intermediate_int3 <= to_integer(unsigned(buffer1(buffer1_counter_next_faza_dva)));
                    intermediate_int4 <= to_integer(unsigned(ker_data2_i));
                    sum2_next <= sum2_reg + intermediate_int3 * intermediate_int4;
                end if;
            end if;
 -- Primer koda za debug:
 --           report "Counter accesor value: " & integer'image(buffer1_counter_next_faza_dva);
 --           report "pixel value: " & integer'image(intermediate_int3);
 --           report "kernel pixel value: " & integer'image(intermediate_int4);
            
            n2_next <= n2_reg + 1;
            ker_addr2_next <= ((ker_addr2_reg + 1)) mod 9; 
            if(n2_next = KernelSize) then
                buffer1_counter_next_faza_dva <= (((to_integer(i2_reg) + to_integer(m2_reg)) * (SIZE - 2) + to_integer(j2_reg) + to_integer(n2_reg)));
                state_next_faza_dva <= CONV2_m_PLUS;
            else
                state_next_faza_dva <= CONV2_INIT;
            end if;
        when CONV2_m_PLUS =>  
            ker_addr2_o <= std_logic_vector(ker_addr2_reg);
            m2_next <= m2_reg + 1;
            state_next_faza_dva <= CONV2_m_CHECK;
        when CONV2_m_CHECK =>  
            intermediate_int3 <=  to_integer(unsigned(buffer1(buffer1_counter_next_faza_dva)));
            intermediate_int4 <= to_integer(unsigned(ker_data2_i));
            sum2_next <= sum2_reg + intermediate_int3 * intermediate_int4;      
            if(m2_next = kernelSize) then
                state_next_faza_dva <= CONV2_WRITE_BUFF2;
            else 
                state_next_faza_dva <= CONV2_RESET_n;
            end if;
        when CONV2_WRITE_BUFF2 =>  
            if(sum2_next > 255) then
                sum2_next <= to_unsigned(255, sum2_next'length);
            elsif(sum2_next < 0) then
                sum2_next <= to_unsigned(0, sum2_next'length);
            end if;
            buffer2_counter_next <= (buffer2_counter_reg + 1) mod 65;
            buffer2(buffer2_counter_next) <= std_logic_vector(sum2_next);
            j2_next <= j2_reg + 1;
            if(j2_next = unsigned(lines) - 4) then 
                state_next_faza_dva <= CONV2_DONE;
            else
                state_next_faza_dva <= CONV2_RESET_m;
            end if;
        when CONV2_DONE => 
            i2_next <= i2_reg + 1;
            if(i2_next = unsigned(columns) - 4) then
                faza_dva_complete_count_s <= faza_dva_complete_count_s + 1;
                faza_dva_complete_count_v := faza_dva_complete_count_v + 1;
                start_tri_from_dva_s <= '1';
                stop_dva_from_dva <= '1';
                state_next_faza_dva <= idle; 
            else 
                state_next_faza_dva <= CONV2_RESET_j;
            end if;
    end case;
end process; 

faza_tri: process(state_reg_faza_tri, start_tri_from_dva_s, i3_reg, i3_next, j3_reg, j3_next, m3_reg, m3_next, n3_reg, 
n3_next, sum3_reg, sum3_next, intermediate_int5, intermediate_int6, faza_dva_complete_count_s)
begin
    i3_next <= i3_reg;
    j3_next <= j3_reg;
    m3_next <= m3_reg;
    n3_next <= n3_reg;
    sum3_next <= sum3_reg;
    ker_addr3_next <= ker_addr3_reg;
    ker_addr3_o <= (others => '0');
    buffer2_counter_next_faza_tri <= buffer2_counter_next_faza_tri;
    buffer3_counter_next <= buffer3_counter_reg;
    
    case state_reg_faza_tri is
         when idle =>
            stop_tri_from_tri <= '0';
            start_cetiri_from_tri_s <= '0';
            if(start_tri_from_dva_s = '1' AND stop_tri_from_tri = '0') then
                buffer3_counter_next <= 0;
                state_next_faza_tri <= CONV3_RESET_i;
            else
                state_next_faza_tri <= idle;
            end if;
            if(faza_dva_complete_count_v >= 2) then
                faza_dva_complete_count_v := faza_dva_complete_count_v - 1;
                buffer3_counter_next <= 0;
                state_next_faza_tri <= CONV3_RESET_i;
            end if;
        when CONV3_RESET_i =>
            i3_next <= to_unsigned(0, WIDTH);
            state_next_faza_tri <= CONV3_RESET_j;
        when CONV3_RESET_j => 
            j3_next <= to_unsigned(0, WIDTH);
            state_next_faza_tri <= CONV3_RESET_m; 
        when CONV3_RESET_m =>  
            sum3_next <= to_unsigned(0, WIDTH);
            m3_next <= to_unsigned(0, kernelSize);
            state_next_faza_tri <= CONV3_RESET_n;
        when CONV3_RESET_n => 
            n3_next <= to_unsigned(0, kernelSize);
            state_next_faza_tri <= CONV3_INIT;
        when CONV3_INIT => 
            buffer2_counter_next_faza_tri <= (((to_integer(i3_reg) + to_integer(m3_reg)) * (SIZE - 4) + to_integer(j3_reg) + to_integer(n3_reg)));
            state_next_faza_tri <= CONV3_ADDR;
        when CONV3_ADDR =>  
                ker_addr3_o <= std_logic_vector(ker_addr3_reg);
                state_next_faza_tri <= CONV3_WORK;
        when CONV3_WORK =>   
            if((i3_reg + m3_reg) < (unsigned(columns) - 4) AND (j3_reg + n3_reg ) < (unsigned(lines)- 4)) then
                if(SIGNED_UNSIGNED = "Signed") then
                    intermediate_int5 <=  to_integer(signed(buffer2(buffer2_counter_next_faza_tri)));
                    intermediate_int6 <= to_integer(signed(ker_data3_i));
                    sum3_next <= sum3_reg + to_unsigned(intermediate_int5 * intermediate_int6, sum3_next'length);
                else
                    intermediate_int5 <= to_integer(unsigned(buffer2(buffer2_counter_next_faza_tri)));
                    intermediate_int6 <= to_integer(unsigned(ker_data3_i));
                    sum3_next <= sum3_reg + intermediate_int5 * intermediate_int6;
                end if;
            end if;
            n3_next <= n3_reg + 1;
            ker_addr3_next <= ((ker_addr3_reg + 1)) mod 9; 
            if(n3_next = KernelSize) then
                buffer2_counter_next_faza_tri <= (((to_integer(i3_reg) + to_integer(m3_reg)) * (SIZE - 4) + to_integer(j3_reg) + to_integer(n3_reg)));
                state_next_faza_tri <= CONV3_m_PLUS;
            else
                state_next_faza_tri <= CONV3_INIT;
            end if;
        when CONV3_m_PLUS =>  
            ker_addr3_o <= std_logic_vector(ker_addr3_reg);
            m3_next <= m3_reg + 1;
            state_next_faza_tri <= CONV3_m_CHECK;
        when CONV3_m_CHECK =>  
            intermediate_int5 <=  to_integer(unsigned(buffer2(buffer2_counter_next_faza_tri)));
            intermediate_int6 <= to_integer(unsigned(ker_data3_i));
            sum3_next <= sum3_reg + intermediate_int5 * intermediate_int6;      
            if(m3_next = kernelSize) then
                state_next_faza_tri <= CONV3_WRITE_BUFF3;
            else 
                state_next_faza_tri <= CONV3_RESET_n;
            end if;
        when CONV3_WRITE_BUFF3 =>  
            if(sum3_next > 255) then
                sum3_next <= to_unsigned(255, sum3_next'length);
            elsif(sum3_next < 0) then
                sum3_next <= to_unsigned(0, sum3_next'length);
            end if;
            buffer3_counter_next <= (buffer3_counter_reg + 1) mod 37;
            buffer3(buffer3_counter_next) <= std_logic_vector(sum3_next);
            j3_next <= j3_reg + 1;
            if(j3_next = unsigned(lines) - 6) then 
                state_next_faza_tri <= CONV3_DONE;
            else
                state_next_faza_tri <= CONV3_RESET_m;
            end if;
        when CONV3_DONE => 
            i3_next <= i3_reg + 1;
            if(i3_next = unsigned(columns) - 6) then
                 faza_tri_complete_count_s <= faza_tri_complete_count_s + 1;
                 faza_tri_complete_count_v := faza_tri_complete_count_v + 1;
                 stop_tri_from_tri <= '1';
                 start_cetiri_from_tri_s <= '1';
                 state_next_faza_tri <= idle; 
            else 
                state_next_faza_tri <= CONV3_RESET_j;
            end if;
    end case;
end process;

faza_cetiri: process(state_reg_faza_cetiri, start_cetiri_from_tri_s, i4_reg, i4_next, j4_reg, j4_next, m4_reg, m4_next, n4_reg, 
n4_next, sum4_reg, sum4_next, intermediate_int7, intermediate_int8, faza_tri_complete_count_s)
begin
    i4_next <= i4_reg;
    j4_next <= j4_reg;
    m4_next <= m4_reg;
    n4_next <= n4_reg;
    sum4_next <= sum4_reg;
    ker_addr4_next <= ker_addr4_reg;
    ker_addr4_o <= (others => '0');
    buffer3_counter_next_faza_cetiri <= buffer3_counter_next_faza_cetiri;
    res_en_o <= '0';
    res_addr_o <= (others => '0');
    res_data_o <= (others => '0');
    res_wr_o <= '0';
    
    case state_reg_faza_cetiri is
         when idle =>
            stop_cetiri_from_cetiri <= '0';
            if(start_cetiri_from_tri_s = '1' AND stop_cetiri_from_cetiri = '0') then
                res_addr_next <= to_unsigned(0, ADDR);
                state_next_faza_cetiri <= CONV4_RESET_i;
            else
                state_next_faza_cetiri <= idle;
            end if;
            if(faza_tri_complete_count_v >= 2) then
                faza_tri_complete_count_v := faza_tri_complete_count_v - 1;
                res_addr_next <= to_unsigned(0, ADDR);
                state_next_faza_cetiri <= CONV4_RESET_i;
            end if;
        when CONV4_RESET_i =>
            i4_next <= to_unsigned(0, WIDTH);
            state_next_faza_cetiri <= CONV4_RESET_j;
        when CONV4_RESET_j => 
            j4_next <= to_unsigned(0, WIDTH);
            state_next_faza_cetiri <= CONV4_RESET_m;
        when CONV4_RESET_m =>  
            sum4_next <= to_unsigned(0, WIDTH);
            m4_next <= to_unsigned(0, kernelSize);
            state_next_faza_cetiri <= CONV4_RESET_n;
        when CONV4_RESET_n => 
            n4_next <= to_unsigned(0, kernelSize);
            state_next_faza_cetiri <= CONV4_INIT;
        when CONV4_INIT => 
            buffer3_counter_next_faza_cetiri <= (((to_integer(i4_reg) + to_integer(m4_reg)) * (SIZE - 6) + to_integer(j4_reg) + to_integer(n4_reg)));
            state_next_faza_cetiri <= CONV4_ADDR;
        when CONV4_ADDR =>  
                ker_addr4_o <= std_logic_vector(ker_addr4_reg);
                state_next_faza_cetiri <= CONV4_WORK;
        when CONV4_WORK =>   
            if((i4_reg + m4_reg) < (unsigned(columns) - 6) AND (j4_reg + n4_reg ) < (unsigned(lines)- 6)) then
                if(SIGNED_UNSIGNED = "Signed") then
                    intermediate_int7 <=  to_integer(signed(buffer3(buffer3_counter_next_faza_cetiri)));
                    intermediate_int8 <= to_integer(signed(ker_data4_i));
                    sum4_next <= sum4_reg + to_unsigned(intermediate_int7 * intermediate_int8, sum4_next'length);
                else
                    intermediate_int7 <= to_integer(unsigned(buffer3(buffer3_counter_next_faza_cetiri)));
                    intermediate_int8 <= to_integer(unsigned(ker_data4_i));
                    sum4_next <= sum4_reg + intermediate_int7 * intermediate_int8;
                end if;
            end if;
            n4_next <= n4_reg + 1;
            ker_addr4_next <= ((ker_addr4_reg + 1)) mod 9; 
            if(n4_next = KernelSize) then
                buffer3_counter_next_faza_cetiri <= (((to_integer(i4_reg) + to_integer(m4_reg)) * (SIZE - 6) + to_integer(j4_reg) + to_integer(n4_reg)));
                state_next_faza_cetiri <= CONV4_m_PLUS;
                               --************************** OVDE STIGO SA DEBUGOM *********************************8 --
            else
                state_next_faza_cetiri <= CONV4_INIT;
            end if;
        when CONV4_m_PLUS =>  
            ker_addr4_o <= std_logic_vector(ker_addr4_reg);
            m4_next <= m4_reg + 1;
            state_next_faza_cetiri <= CONV4_m_CHECK;
        when CONV4_m_CHECK =>  
            intermediate_int7 <=  to_integer(unsigned(buffer3(buffer3_counter_next_faza_cetiri)));
            intermediate_int8 <= to_integer(unsigned(ker_data4_i));
            sum4_next <= sum4_reg + intermediate_int7 * intermediate_int8;      
            if(m4_next = kernelSize) then
                state_next_faza_cetiri <= CONV4_WRITE_OUTPUT;
            else 
                state_next_faza_cetiri <= CONV4_RESET_n;
            end if;
        when CONV4_WRITE_OUTPUT =>  
            if(sum4_next > 255) then
                sum4_next <= to_unsigned(255, sum4_next'length);
            elsif(sum4_next < 0) then
                sum4_next <= to_unsigned(0, sum4_next'length);
            end if;
            res_addr_o <= std_logic_vector(res_addr_next mod 16);
            res_wr_o <= '1';
            res_en_o <= '1';
            res_data_o <= std_logic_vector(sum4_next);
            res_addr_next <= res_addr_reg + 1;
            j4_next <= j4_reg + 1;
            if(j4_next = unsigned(lines) - 8) then 
                state_next_faza_cetiri <= CONV4_DONE;
            else
                state_next_faza_cetiri <= CONV4_RESET_m;
            end if;
        when CONV4_DONE => 
            i4_next <= i4_reg + 1;
            if(i4_next = unsigned(columns) - 8) then
                stop_cetiri_from_cetiri <= '1';
                state_next_faza_cetiri <= idle; 
            else 
                state_next_faza_cetiri <= CONV4_RESET_j;
            end if;
    end case;
end process;

start_dva_from_jedan <= start_dva_from_jedan_s;
start_tri_from_dva <= start_tri_from_dva_s;
start_cetiri_from_tri <= start_cetiri_from_tri_s;

end Behavioral;