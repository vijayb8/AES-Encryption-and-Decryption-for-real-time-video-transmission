    ----------------------------------------------------------------------------------
    -- Company:
    -- Engineer: Tibor
    --
    -- Create Date: 07/08/2015 05:46:40 PM
    -- Design Name:
    -- Module Name: aes_control - Behavioral
    -- Project Name:
    -- Target Devices:
    -- Tool Versions:
    -- Description:
    --
    -- Dependencies:
    --
    -- Revision:
    -- Revision 0.01 - File Created
    -- Additional Comments:
    --
    ----------------------------------------------------------------------------------
    
    
    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use work.types.all;
    
    -- Uncomment the following library declaration if using
    -- arithmetic functions with Signed or Unsigned values
    --use IEEE.NUMERIC_STD.ALL;
    
    -- Uncomment the following library declaration if instantiating
    -- any Xilinx leaf cells in this code.
    --library UNISIM;
    --use UNISIM.VComponents.all;
    
    entity control is
        Port (
               tvalid_in: in std_logic;
               start_debuf: out std_logic;
               --start_enc: in std_logic; 
               ctrl_clk : in STD_LOGIC;
               ctrl_reset : in STD_LOGIC;
               data  : in STD_LOGIC_VECTOR(127 downto 0); 
               aes_done_array: in STD_LOGIC_VECTOR(3 downto 0);
               aes_start_array: out STD_LOGIC_VECTOR(3 downto 0);
               ip_mode: out aes_mode;
               --aes_key: in STD_LOGIC_VECTOR(127 downto 0);
               data_to_aes_1 : out std_logic_vector(127 downto 0);
               data_to_aes_2 : out std_logic_vector(127 downto 0);
               data_to_aes_3 : out std_logic_vector(127 downto 0);
               data_to_aes_4 : out std_logic_vector(127 downto 0)
               );
    end control;
    
    architecture Behavioral of control is
    
    signal mode_temp: aes_mode := EXPAND_KEY;
    
    
    
    begin
    
    ip_mode <= mode_temp;
    --signal aes_key: std_logic_vector(127 downto 0);
    --aes_key <= x"000102030405060708090a0b0c0d0e0f";
    
       select_data :process(ctrl_clk,ctrl_reset)
       variable sel: STD_LOGIC_VECTOR (1 downto 0):= (others => '0');
       variable count : integer range 0 to 4 := 0;
       variable aes_start_temp: std_logic_vector(3 downto 0):= (others => '0');
       variable flag : std_logic := '0';
       variable start_debuf_temp: std_logic := '0';
       --variable mode_temp: aes_mode;
       variable aes_key: std_logic_vector(127 downto 0):= x"000102030405060708090a0b0c0d0e0f"; 
       begin
    
            --aes_start_array <= (others => '0');
    
            if ctrl_reset = '1' then
              mode_temp <= EXPAND_KEY;
              ip_mode <= EXPAND_KEY;
              aes_start_array <= (others => '0');
              flag := '0';
              --flag_enc := '0';
              --aes_start_bit <= '0';
              data_to_aes_1  <= (others => '0');
              data_to_aes_2  <= (others => '0');
              data_to_aes_3  <= (others => '0');
              data_to_aes_4  <= (others => '0');
              start_debuf <= '0';
              sel := "00";
              count := 0;
            else
              if rising_edge(ctrl_clk) then
                        aes_start_array(3 downto 0) <= aes_start_temp(3 downto 0) and not(aes_start_temp(3 downto 0));
                        --start_debuf <= start_debuf_temp and not(start_debuf_temp); 

                        if tvalid_in = '1' and mode_temp = ENCRYPT  then
                            if aes_done_array(3 downto 0) = "0000" then
                                start_debuf <= '1';
                                start_debuf_temp := '1';
                            end if;
                            if count = 4 then
                                         count := 0;   
                                              case sel is
                                               when "00" => data_to_aes_1(127 downto 0) <= data(127 downto 0);
                                                            aes_start_array(0) <= '1';
                                                when "01" => data_to_aes_2(127 downto 0) <= data(127 downto 0);
                                                            aes_start_array(1) <= '1';
                                                when "10" => data_to_aes_3(127 downto 0) <= data(127 downto 0);
                                                             aes_start_array(2) <= '1';
                                                when "11" => data_to_aes_4(127 downto 0) <= data(127 downto 0);
                                                             aes_start_array(3) <= '1';
                                                when others => data_to_aes_1  <= (others => '0');
                                                               data_to_aes_2  <= (others => '0');
                                                               data_to_aes_3  <= (others => '0');
                                                               data_to_aes_4  <= (others => '0');
                                              end case;                  
                                              sel(1) := sel(0) xor sel(1);
                                              sel(0) := not sel(0);                  
                             end if;
                                          count := count + 1;
                         end if;   
                        if flag = '0'    then              
                             data_to_aes_1(127 downto 0) <= aes_key;
                             data_to_aes_2(127 downto 0) <= aes_key;
                             data_to_aes_3(127 downto 0) <= aes_key;
                             data_to_aes_4(127 downto 0) <= aes_key;
                             aes_start_temp := "1111";                                                  
                             aes_start_array(3 downto 0) <= aes_start_temp;
                             flag := '1';
                          else
                             if aes_done_array(3 downto 0) = "1111" then
                                 mode_temp <= ENCRYPT;  
                                 ip_mode <= ENCRYPT;                      
                             end if;
                         end if;                      
                        
                            
               end if;
            end if;
    
         end process;
         
--         aes_sync0:  process(aes_done_array(0))    
--         begin
--            if rising_edge(aes_done_array(0)) then
--                aes_start_array(0) <= '0';
--            end if;
--         end process;    
            
            
         
--        aes_sync1:  process(aes_done_array(1))    
--        begin
--           if rising_edge(aes_done_array(1)) then
--               aes_start_array(1) <= '0';
--           end if;
--        end process;    
           
         
--       aes_sync2:  process(aes_done_array(2))    
--       begin
--          if rising_edge(aes_done_array(2)) then
--              aes_start_array(2) <= '0';
--          end if;
--       end process;    
          
         
--      aes_sync3:  process(aes_done_array(3))    
--      begin
--         if rising_edge(aes_done_array(3)) then
--             aes_start_array(3) <= '0';
--         end if;
--      end process;    
         
    
         
         
    end Behavioral;
