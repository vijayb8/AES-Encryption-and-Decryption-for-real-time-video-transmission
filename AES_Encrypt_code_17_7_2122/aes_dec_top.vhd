----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2015 13:39:03
-- Design Name: 
-- Module Name: aes_dec_top - Behavioral
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

entity aes_dec_top is
--  Port ( );
                  
Port(
        start_dec: in std_logic; 
        data_in : IN  std_logic_vector(31 downto 0);
        clk : in STD_LOGIC;
        reset_top : in STD_LOGIC;
        aes_key: in STD_LOGIC_VECTOR(127 downto 0);
        dout_32bit : out STD_LOGIC_VECTOR (31 downto 0)
);


end aes_dec_top;

architecture Behavioral of aes_dec_top is

component buffer_output
    Port ( 
    din0 : in STD_LOGIC_VECTOR (127 downto 0);
    din1 : in STD_LOGIC_VECTOR (127 downto 0);
    din2 : in STD_LOGIC_VECTOR (127 downto 0);
    din3 : in STD_LOGIC_VECTOR (127 downto 0);
    aes_done : in STD_LOGIC_VECTOR (3 downto 0);
    dout : out STD_LOGIC_VECTOR (31 downto 0);          
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    start_demux: in STD_LOGIC);
    
end component;


component control_top
    port(
               start_debuf: out std_logic;
               start_enc: in std_logic;
               ctrl_top_din : IN  std_logic_vector(31 downto 0);
               ctrl_top_clk : in STD_LOGIC;
               ctrl_top_reset : in STD_LOGIC;
               aes_done_array: in STD_LOGIC_VECTOR(3 downto 0);
               aes_key: in STD_LOGIC_VECTOR(127 downto 0);
               aes_start_array: out STD_LOGIC_VECTOR(3 downto 0);
               ip_mode: out aes_mode;
               d_aes_1 : out std_logic_vector(127 downto 0);
               d_aes_2 : out std_logic_vector(127 downto 0);
               d_aes_3 : out std_logic_vector(127 downto 0);
               d_aes_4 : out std_logic_vector(127 downto 0)
               
               --aes_start_bit: out STD_LOGIC
          );
    end component;
    
component aes_module
    port(
                 clk       : in     std_logic;
                 reset     : in     std_logic;
                 din       : in     state; -- 128 bit key or plaintext/cyphertext block
              dout      : out    state; -- 128 bit plaintext/cyphertext block
                 mode      : in     aes_mode;
              aes_start : in     std_logic;
                 aes_done  : out    std_logic
                );
    end component;
       



begin


end Behavioral;
