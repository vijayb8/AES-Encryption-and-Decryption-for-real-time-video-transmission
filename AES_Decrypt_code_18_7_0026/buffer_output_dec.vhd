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

entity buffer_output_dec is
    Port ( din0 : in STD_LOGIC_VECTOR (127 downto 0);
    din1 : in STD_LOGIC_VECTOR (127 downto 0);
    din2 : in STD_LOGIC_VECTOR (127 downto 0);
    din3 : in STD_LOGIC_VECTOR (127 downto 0);
    aes_done : in STD_LOGIC_VECTOR (3 downto 0);
    dout : out STD_LOGIC_VECTOR (23 downto 0);          
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    start_demux: in STD_LOGIC);
end buffer_output_dec;

architecture Behavioral of buffer_output_dec is
signal din : STD_LOGIC_VECTOR (127 downto 0):= (others => '0');
begin
    aes_process: process(aes_done,din,start_demux)
  begin
  case start_demux is
  when '1' => case aes_done is
      when "0001" => din(127 downto 0) <= din0(127 downto 0);
      when "0010" => din(127 downto 0) <= din1(127 downto 0);
      when "0100" => din(127 downto 0) <= din2(127 downto 0);
      when "1000" => din(127 downto 0) <= din3(127 downto 0);
      when others => null;
  end case;
  when others => null;
  end case;
  end process aes_process;

   counting :process(clk,reset,din,start_demux)
   variable counter : integer range 0 to 3 := 0;
   
   variable dout_tmp : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
   variable dout_tmp1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
   variable dout_tmp2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
   variable dout_tmp3 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
   variable dout_hold : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
   variable dout_hold1 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
   variable dout_hold2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); 
   variable dout_hold3 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
   constant dout_worst :   STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
   begin
  case start_demux is
  when '1' => 
        if rising_edge(clk) then
            case counter is
                when 0 =>  dout_tmp(31 downto 0) := din(31 downto 0);
                           counter := counter + 1;
                           dout_hold := dout_tmp;
                           dout <= dout_hold(23 downto 0);
                when 1 =>   dout_tmp1(31 downto 0) := din(63 downto 32);
                            counter := counter + 1;
                            dout_hold1 := dout_tmp1;
                            dout <= dout_hold1(23 downto 0);                        
                when 2 =>   dout_tmp2(31 downto 0) := din(95 downto 64);
                            counter := counter + 1;
                            dout_hold2 := dout_tmp2;
                            dout <= dout_hold2(23 downto 0); 
                 when 3 =>  dout_tmp3(31 downto 0):= din(127 downto 96);
                            dout_hold3 := dout_tmp3;
                            dout <= dout_hold3(23 downto 0);
                            counter := 0; 
             --when 4 => counter := 0; dout_hold := dout_tmp;
        end case;
   end if;
   when others => null;
   end case;
   
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
