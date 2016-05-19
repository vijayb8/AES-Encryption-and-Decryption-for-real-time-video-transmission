----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.07.2015 19:26:39
-- Design Name: 
-- Module Name: ip_aes_enc - Behavioral
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

entity ip_aes_enc is
--  Port ( );
Port (
           --start_debuf: out std_logic;
           --start_enc: in std_logic;
           tvalid_in: in std_logic; 
           data_in : IN  std_logic_vector(23 downto 0);
           clk : in STD_LOGIC;
           reset_top : in STD_LOGIC;
           --aes_key: in STD_LOGIC_VECTOR(127 downto 0);
           dout_32bit : out STD_LOGIC_VECTOR (31 downto 0)
           --tvalid_out: out std_logic
           
           --aes_done_array: out STD_LOGIC_VECTOR(3 downto 0);
           --aes_start_array: out STD_LOGIC_VECTOR(3 downto 0);
           --din_enc_1 : out std_logic_vector(127 downto 0);
           --din_enc_2 : out std_logic_vector(127 downto 0);
           --din_enc_3 : out std_logic_vector(127 downto 0);
           --din_enc_4 : out std_logic_vector(127 downto 0)
           --dout_enc_1 : out std_logic_vector(127 downto 0);
           --dout_enc_2 : out std_logic_vector(127 downto 0);
           --dout_enc_3 : out std_logic_vector(127 downto 0);
           --dout_enc_4 : out std_logic_vector(127 downto 0)
           --aes_start_bit: out STD_LOGIC
           );


end ip_aes_enc;

architecture Behavioral of ip_aes_enc is

component buffer_output
    Port ( din0 : in STD_LOGIC_VECTOR (127 downto 0);
    din1 : in STD_LOGIC_VECTOR (127 downto 0);
    din2 : in STD_LOGIC_VECTOR (127 downto 0);
    din3 : in STD_LOGIC_VECTOR (127 downto 0);
    aes_done : in STD_LOGIC_VECTOR (3 downto 0);
    dout : out STD_LOGIC_VECTOR (31 downto 0);          
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    start_demux: in STD_LOGIC);
    --dec_valid: out std_logic);
    
end component;


component control_top
    port(
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
       
signal data_to_aes_1 : std_logic_vector(127 downto 0);
signal data_to_aes_2 : std_logic_vector(127 downto 0);
signal data_to_aes_3 : std_logic_vector(127 downto 0);
signal data_to_aes_4 : std_logic_vector(127 downto 0);

signal data_out_aes_1 : std_logic_vector(127 downto 0);
signal data_out_aes_2 : std_logic_vector(127 downto 0);
signal data_out_aes_3 : std_logic_vector(127 downto 0);
signal data_out_aes_4 : std_logic_vector(127 downto 0);

signal start_debuf_sig: std_logic;
signal mode: aes_mode;

signal aes_start_sig : STD_LOGIC_VECTOR(3 downto 0);
signal aes_done_sig : STD_LOGIC_VECTOR(3 downto 0);

--signal aes_start_bit_sig: std_logic;


begin

    buffer_output_mod: buffer_output port map( din0 => data_out_aes_1,
                                               din1 => data_out_aes_2,
                                               din2 => data_out_aes_3,
                                               din3 => data_out_aes_4,
                                               aes_done => aes_done_sig,
                                               dout => dout_32bit,          
                                               clk => clk,
                                               reset => reset_top,
                                               start_demux => start_debuf_sig);
                                               --dec_valid => tvalid_out);

	control_top_mod: control_top port map ( tvalid_in => tvalid_in,
	                                        start_debuf => start_debuf_sig,
	                                        --start_enc => start_enc,
	                                        ctrl_top_din => data_in,
	                                        ctrl_top_clk => clk,
	                                        ctrl_top_reset => reset_top,
	                                        --aes_key => aes_key,
	                                        aes_done_array => aes_done_sig,
	                                        aes_start_array => aes_start_sig,
	                                        ip_mode => mode,
	                                        d_aes_1 => data_to_aes_1,
	                                        d_aes_2 => data_to_aes_2,
	                                        d_aes_3 => data_to_aes_3,
	                                        d_aes_4 => data_to_aes_4
	                                        
	                                        --aes_start_bit => aes_start_bit_sig                                      
										);
										
	aes1: entity work.aes_module port map (
								clk => clk,
								reset => reset_top,
								din => data_to_aes_1,
								mode => mode,
								aes_start => aes_start_sig(0),
								aes_done => aes_done_sig(0),
								dout => data_out_aes_1
								);
										

	aes2: entity work.aes_module port map (
								clk => clk,
								reset => reset_top,
								din => data_to_aes_2,
								mode => mode,
								aes_start => aes_start_sig(1),
								aes_done => aes_done_sig(1),
								dout => data_out_aes_2
								);									

	aes3: entity work.aes_module port map (
								clk => clk,
								reset => reset_top,
								din => data_to_aes_3,
								mode => mode,
								aes_start => aes_start_sig(2),
								aes_done => aes_done_sig(2),
								dout => data_out_aes_3
								);

	aes4: entity work.aes_module port map (
								clk => clk,
								reset => reset_top,
								din => data_to_aes_4,
								mode => mode,
								aes_start => aes_start_sig(3),
								aes_done => aes_done_sig(3),
								dout => data_out_aes_4
								);
								
	--aes_done_array <= aes_done_sig;
	--aes_start_array <= aes_start_sig;
	--din_enc_1 <= data_to_aes_1;
	--din_enc_2 <= data_to_aes_2;
	--din_enc_3 <= data_to_aes_3;
	--din_enc_4 <= data_to_aes_4;


end Behavioral;
