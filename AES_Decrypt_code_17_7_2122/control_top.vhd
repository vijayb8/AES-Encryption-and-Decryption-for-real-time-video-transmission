----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2015 23:52:28
-- Design Name: 
-- Module Name: control_top - Behavioral
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

entity control_top is
--  Port ( );
Port (
           tvalid_in: in std_logic;
           start_debuf: out std_logic;
           --start_enc: in std_logic; 
           ctrl_top_din : IN  std_logic_vector(23 downto 0);
           ctrl_top_clk : in STD_LOGIC;
           ctrl_top_reset : in STD_LOGIC;
           aes_done_array: in STD_LOGIC_VECTOR(3 downto 0);
           --aes_key: in STD_LOGIC_VECTOR(127 downto 0);
           aes_start_array: out STD_LOGIC_VECTOR(3 downto 0);
           ip_mode: out aes_mode;
           d_aes_1 : out std_logic_vector(127 downto 0);
           d_aes_2 : out std_logic_vector(127 downto 0);
           d_aes_3 : out std_logic_vector(127 downto 0);
           d_aes_4 : out std_logic_vector(127 downto 0)
           
           --aes_start_bit : out std_logic
           );

end control_top;

architecture Behavioral of control_top is

    component buffer_module
        PORT(
         tvalid_in : in std_logic;
         --start_enc : in std_logic;
         din : IN  std_logic_vector(23 downto 0);
         dout : OUT  std_logic_vector(127 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic
        );
    end component;
    
    component control
        PORT(
        tvalid_in: in std_logic;
        start_debuf: out std_logic;
        --start_enc: in STD_LOGIC;
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
                   
                   --aes_start_bit : out std_logic
        );
    end component;
    
    signal dout_to_data :  STD_LOGIC_VECTOR(127 downto 0);

begin

	buffer_mod: buffer_module port map (--start_enc => start_enc,
	                                    tvalid_in => tvalid_in,
	                                    clk => ctrl_top_clk,    
										reset => ctrl_top_reset,    
										din => ctrl_top_din,
			 						    dout => dout_to_data
										);
										
	control_mod: control port map (tvalid_in => tvalid_in,
	                               start_debuf => start_debuf,
	                               --start_enc => start_enc,
	                               ctrl_clk => ctrl_top_clk,    
                                   ctrl_reset => ctrl_top_reset,    
                                   data => dout_to_data,
                                   aes_done_array => aes_done_array,
                                   aes_start_array => aes_start_array,
                                   ip_mode => ip_mode,
                                   --aes_key => aes_key,
                                   data_to_aes_1 => d_aes_1,
                                   data_to_aes_2 => d_aes_2,
                                   data_to_aes_3 => d_aes_3,
                                   data_to_aes_4 => d_aes_4
                                  );										


end Behavioral;
