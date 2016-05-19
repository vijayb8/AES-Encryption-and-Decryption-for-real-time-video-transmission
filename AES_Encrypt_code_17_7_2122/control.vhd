----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.07.2015 18:09:07
-- Design Name: 
-- Module Name: control - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port ( ctrl_in: in std_logic_vector(127 downto 0);
        aes_done_ctrl: in STD_LOGIC_VECTOR(3 downto 0);
        clk_ctrl: in std_logic;
        rst_ctrl: in std_logic;        
        
        aes_start_ctrl : out STD_LOGIC_VECTOR(3 downto 0);
        ctrl_mode : out aes_mode;
        ctrl_data_to_aes0: out STD_LOGIC_VECTOR(127 downto 0);
        ctrl_data_to_aes1: out STD_LOGIC_VECTOR(127 downto 0);
        ctrl_data_to_aes2: out STD_LOGIC_VECTOR(127 downto 0);
        ctrl_data_to_aes3: out STD_LOGIC_VECTOR(127 downto 0)
        );
end control;

architecture Behavioral of control is

begin


end Behavioral;
