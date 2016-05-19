----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tibor
-- 
-- Create Date: 07/07/2015 03:53:04 PM
-- Design Name: 
-- Module Name: buffer - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer_module_dec is
    Port ( tvalid_in: in std_logic;
           --start_enc: in std_logic;
           din : in STD_LOGIC_VECTOR (31 downto 0);
           dout : out STD_LOGIC_VECTOR (127 downto 0);          
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end buffer_module_dec;

architecture Behavioral of buffer_module_dec is

begin

   counting :process(clk,reset)
   variable counter : integer range 0 to 3 := 0;
   variable dout_tmp : STD_LOGIC_VECTOR (127 downto 0):= (others => '0');
   variable dout_hold : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
   begin
   
   if tvalid_in = '1' then
       if rising_edge(clk) then
            case counter is
                 when 0 => dout_tmp(31 downto 0) := din(31 downto 0);
                           counter := counter + 1;
                 when 1 => dout_tmp(63 downto 32) := din(31 downto 0);
                           counter := counter + 1;                        
                 when 2 => dout_tmp(95 downto 64) := din(31 downto 0);
                           counter := counter + 1;
                 when 3 => dout_tmp(127 downto 96):= din(31 downto 0);
                           dout_hold := dout_tmp;
                           dout <= dout_hold;
                           counter := 0; 
                 --when 4 => counter := 0; dout_hold := dout_tmp;
            end case;
            end if;
       end if;
   
		if reset = '1' then
		  dout  <= (others => '0');
		  counter := 0;
		--elsif falling_edge(clk) then
		  --counter := counter + 1;
		end if;
		

		--if counter = '4' then
		  
		  
		--end if;

        --dout <= dout_hold; 
   end process;

    
       
end Behavioral;
