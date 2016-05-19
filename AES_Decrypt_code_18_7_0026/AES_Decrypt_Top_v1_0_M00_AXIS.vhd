library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AES_Decrypt_Axi_Top_v1_0_M00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 24;
		C_M_AXIS_TSTRB_WIDTH    : integer := 24;
		-- Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.
		C_M_START_COUNT	: integer	:= 32 
	);
	port (
		-- Users to add ports here
        I_FRAME_X : in integer range 0 to 1920;
        I_FRAME_Y : in integer range 0 to 1080;
        I_DATA : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        I_DATA_VALID : in std_logic;
		I_TLAST : in std_logic;
		I_TUSER : in std_logic;	
		O_READY : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TSTRB_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TUSER	: out std_logic;
                -- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
	);
end AES_Decrypt_Axi_Top_v1_0_M00_AXIS;

architecture implementation of AES_Decrypt_Axi_Top_v1_0_M00_AXIS is
	--Total number of output data.
	-- Total number of output data                                              
--	constant NUMBER_OF_OUTPUT_WORDS : integer := 8;                                   

--	 -- function called clogb2 that returns an integer which has the   
--	 -- value of the ceiling of the log base 2.                              
--	function clogb2 (bit_depth : integer) return integer is                  
--	 	variable depth  : integer := bit_depth;                               
--	 	variable count  : integer := 1;                                       
--	 begin                                                                   
--	 	 for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
--	      if (bit_depth <= 2) then                                           
--	        count := 1;                                                      
--	      else                                                               
--	        if(depth <= 1) then                                              
--	 	       count := count;                                                
--	 	     else                                                             
--	 	       depth := depth / 2;                                            
--	          count := count + 1;                                            
--	 	     end if;                                                          
--	 	   end if;                                                            
--	   end loop;                                                             
--	   return(count);        	                                              
--	 end;                                                                    

--	 -- WAIT_COUNT_BITS is the width of the wait counter.                       
--	 constant  WAIT_COUNT_BITS  : integer := clogb2(C_M_START_COUNT-1);               
	                                                                                  
--	-- In this example, Depth of FIFO is determined by the greater of                 
--	-- the number of input words and output words.                                    
--	constant depth : integer := NUMBER_OF_OUTPUT_WORDS;                               
	                                                                                  
--	-- bit_num gives the minimum number of bits needed to address 'depth' size of FIFO
--	constant bit_num : integer := clogb2(depth);                                      
	                                                                                  
--	-- Define the states of state machine                                             
--	-- The control state machine oversees the writing of input streaming data to the FIFO,
--	-- and outputs the streaming data from the FIFO                                   
--	type state is ( IDLE,        -- This is the initial/idle state                    
--	                INIT_COUNTER,  -- This state initializes the counter, ones        
--	                                -- the counter reaches C_M_START_COUNT count,     
--	                                -- the state machine changes state to INIT_WRITE  
--	                SEND_STREAM);  -- In this state the                               
--	                             -- stream data is output through M_AXIS_TDATA        
--	-- State variable                                                                 
--	signal  mst_exec_state : state;                                                   
--	-- Example design FIFO read pointer                                               
--	signal read_pointer : integer range 0 to bit_num-1;                               
--    signal write_pointer : integer range 0 to bit_num-1;
    
--	-- AXI Stream internal signals
--	--wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
--	signal count	: std_logic_vector(WAIT_COUNT_BITS-1 downto 0);
--	--streaming data valid
	signal axis_tvalid	: std_logic;
--	--streaming data valid delayed by one clock cycle
--	signal axis_tvalid_delay	: std_logic;
--	--Last of the streaming data 
	signal axis_tlast	: std_logic;
--	--Last of the streaming data delayed by one clock cycle
--	signal axis_tlast_delay	: std_logic;
--	--FIFO implementation signals
--	signal stream_data_out	: std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
--	signal tx_en	: std_logic;
--	--The master has issued all the streaming data stored in FIFO
--	--signal tx_done	: std_logic;
	--------------- USER DEFINED---------------------
--    type BYTE_FIFO_TYPE is array (0 to (NUMBER_OF_OUTPUT_WORDS-1)) of std_logic_vector((C_M_AXIS_TSTRB_WIDTH - 1) downto 0);
--    signal stream_fifo_data : BYTE_FIFO_TYPE; -- FIFO with depth of 8
--	signal gen_tlast : std_logic;
--	signal tuser : std_logic;
--	signal count_x : integer range 0 to 1920;
--	signal count_y : integer range 0 to 1080;
--	signal fifo_empty_flag : std_logic;
--	signal fifo_full_flag : std_logic;
--	signal stream_fifo_data_d : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	------------------------TEST---------------------------------------------
    constant DELAY_CLOCKS : integer := 24; -- expected delay is 23
	signal data_2d : std_logic_vector(((C_M_AXIS_TDATA_WIDTH * DELAY_CLOCKS)-1) downto 0);
    signal tvalid_2d : std_logic_vector(DELAY_CLOCKS-1 downto 0);
    signal tuser_2d : std_logic_vector(DELAY_CLOCKS-1 downto 0);
    signal tlast_2d : std_logic_vector(DELAY_CLOCKS-1 downto 0);
    -------------------------------------------------------------------------
begin
	-- I/O Connections assignments

	M_AXIS_TVALID	<= tvalid_2d(DELAY_CLOCKS-1);
	M_AXIS_TDATA	<= I_DATA;--data_2d(((C_M_AXIS_TDATA_WIDTH * DELAY_CLOCKS)-1) downto (C_M_AXIS_TDATA_WIDTH * (DELAY_CLOCKS-1)));
	M_AXIS_TLAST	<= tlast_2d(DELAY_CLOCKS-1);
	M_AXIS_TSTRB	<= (others => '1');
    M_AXIS_TUSER    <= tuser_2d(DELAY_CLOCKS-1);
	O_READY         <= M_AXIS_TREADY;

---------------------------------------------------------------------------------------------------------
--    process(M_AXIS_ACLK)                                                                           
--        begin                                                                                          
--          if (rising_edge (M_AXIS_ACLK)) then                                                          
--            if(M_AXIS_ARESETN = '0') then  
--              data_2d <= (others => '0');
--            elsif (I_DATA_VALID = '1') then
--              data_2d(C_M_AXIS_TDATA_WIDTH-1 downto 0) <= I_DATA;
--              data_2d(((C_M_AXIS_TDATA_WIDTH * DELAY_CLOCKS)-1) downto C_M_AXIS_TDATA_WIDTH) <= data_2d(((C_M_AXIS_TDATA_WIDTH * (DELAY_CLOCKS-1))-1) downto 0);                         
--            else
--              data_2d(C_M_AXIS_TDATA_WIDTH-1 downto 0) <= (others => '0');
--              data_2d(((C_M_AXIS_TDATA_WIDTH * DELAY_CLOCKS)-1) downto C_M_AXIS_TDATA_WIDTH) <= data_2d(((C_M_AXIS_TDATA_WIDTH * (DELAY_CLOCKS-1))-1) downto 0);
--            end if;
--          end if;
--        end process;
                        
   process(M_AXIS_ACLK)                                                                           
       begin                                                                                          
         if (rising_edge (M_AXIS_ACLK)) then                                                          
           if(M_AXIS_ARESETN = '0') then  
             tvalid_2d <= (others => '0');
           elsif (I_DATA_VALID = '1') then
             tvalid_2d(0) <= I_DATA_VALID;
             tvalid_2d(DELAY_CLOCKS-1 downto 1) <= tvalid_2d(DELAY_CLOCKS-2 downto 0);
           else
             tvalid_2d(0) <= '0';
             tvalid_2d(DELAY_CLOCKS-1 downto 1) <= tvalid_2d(DELAY_CLOCKS-2 downto 0);
           end if;
         end if;
       end process;
                         
   process(M_AXIS_ACLK)                                                                           
       begin                                                                                          
         if (rising_edge (M_AXIS_ACLK)) then                                                          
           if(M_AXIS_ARESETN = '0') then  
             tuser_2d <= (others => '0');
           elsif (I_DATA_VALID = '1') then
             tuser_2d(0) <= I_DATA_VALID;
             tuser_2d(DELAY_CLOCKS-1 downto 1) <= tuser_2d(DELAY_CLOCKS-2 downto 0);
           else
             tuser_2d(0) <= '0';
             tuser_2d(DELAY_CLOCKS-1 downto 1) <= tuser_2d(DELAY_CLOCKS-2 downto 0);
           end if;
         end if;
       end process;
                            
   process(M_AXIS_ACLK)                                                                           
       begin                                                                                          
         if (rising_edge (M_AXIS_ACLK)) then                                                          
           if(M_AXIS_ARESETN = '0') then  
             tlast_2d <= (others => '0');
           elsif (I_DATA_VALID = '1') then
             tlast_2d(0) <= I_DATA_VALID;
             tlast_2d(DELAY_CLOCKS-1 downto 1) <= tlast_2d(DELAY_CLOCKS-2 downto 0);
           else
             tlast_2d(0) <= '0';
             tlast_2d(DELAY_CLOCKS-1 downto 1) <= tlast_2d(DELAY_CLOCKS-2 downto 0);
           end if;
         end if;
       end process;
--------------------------------------------------------------------------------------------------                            
	-- Control state machine implementation                                               
--	process(M_AXIS_ACLK)                                                                        
--	begin                                                                                       
--	  if (rising_edge (M_AXIS_ACLK)) then                                                       
--	    if(M_AXIS_ARESETN = '0') then                                                           
--	      -- Synchronous reset (active low)                                                     
--	      mst_exec_state      <= IDLE;                                                          
--	      count <= (others => '0');                                                             
--	    else                                                                                    
--	      case (mst_exec_state) is                                                              
--	        when IDLE     =>                                                                    
--	          -- The slave starts accepting tdata when                                          
--	          -- there tvalid is asserted to mark the                                           
--	          -- presence of valid streaming data                                               
--	          --if (count = "0")then                                                            
--	          --  mst_exec_state <= INIT_COUNTER;                                                 
--	          --else                                                                              
--	          --  mst_exec_state <= IDLE;                                                         
--	          --end if;                                                                           
--	          -- USER DEFINED RTL------------------------------------------
--             if (fifo_empty_flag = '0') then
--			    mst_exec_state <= SEND_STREAM;                                                 
--	          else                                                                              
--	            mst_exec_state <= IDLE;
--	            end if;
             -------------------------------------------------------------			  
	          --when INIT_COUNTER =>                                                              
	            -- This state is responsible to wait for user defined C_M_START_COUNT           
	            -- number of clock cycles.                                                      
	           -- if ( count = std_logic_vector(to_unsigned((C_M_START_COUNT - 1), WAIT_COUNT_BITS))) then
	           --   mst_exec_state  <= SEND_STREAM;                                               
	           -- else                                                                            
	           --   count <= std_logic_vector (unsigned(count) + 1);                              
	           --   mst_exec_state  <= INIT_COUNTER;                                              
	           -- end if;                                                                         
	                                                                                            
--	        when SEND_STREAM  =>                                                                
	          -- The example design streaming master functionality starts                       
	          -- when the master drives output tdata from the FIFO and the slave                
	          -- has finished storing the S_AXIS_TDATA                                          
	          --if (tx_done = '1') then                                                           
	          --  mst_exec_state <= IDLE;  
--              if (fifo_empty_flag = '1') then
--               mst_exec_state <= IDLE;			  
--	          else                                                                              
--	            mst_exec_state <= SEND_STREAM;                                                  
--	          end if;                                                                           
	                                                                                            
--	        when others    =>                                                                   
--	          mst_exec_state <= IDLE;                                                           
	                                                                                            
--	      end case;                                                                             
--	    end if;                                                                                 
--	  end if;                                                                                   
--	end process;                                                                                


	--tvalid generation
	--axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	--number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
	--axis_tvalid <= '1' when ((mst_exec_state = SEND_STREAM) and (read_pointer < NUMBER_OF_OUTPUT_WORDS)) else '0';
	--axis_tvalid <= I_DATA_VALID;
		process(M_AXIS_ACLK)                                                                           
        begin                                                                                          
          if (rising_edge (M_AXIS_ACLK)) then                                                          
            if(M_AXIS_ARESETN = '0') then  
              axis_tvalid <= '0';
            else
              axis_tvalid <= I_DATA_VALID;
            end if;
          end if;
        end process;
	                                                                                               
	-- AXI tlast generation                                                                        
	-- axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1          
	-- (0 to NUMBER_OF_OUTPUT_WORDS-1)                                                             
	--axis_tlast <= '1' when (read_pointer = NUMBER_OF_OUTPUT_WORDS-1) else '0'; DVK  
--	gen_tlast <= '1' when ((M_AXIS_TREADY = '1') and (axis_tvalid  = '1') and ((count_x = (I_FRAME_X - 1)) or ((count_x = (I_FRAME_X - 1)) and (count_y = (I_FRAME_Y - 1))))) else '0';
	
--	tuser <= '1' when ((M_AXIS_TREADY = '1') and (axis_tvalid  = '1') and (count_x = 0) and (count_y = 0)) else '0';
	
--	process(M_AXIS_ACLK)                                                                           
--        begin                                                                                          
--          if (rising_edge (M_AXIS_ACLK)) then                                                          
--            if(M_AXIS_ARESETN = '0') then                                                              
--              count_x <= 0;                                                                
--              count_y <= 0;                                                                 
--            elsif ((M_AXIS_TREADY = '1') and (axis_tvalid  = '1') and (count_x /= (I_FRAME_X - 1))) then                                                                             
--              count_x <= count_x + 1;
--            elsif ((M_AXIS_TREADY = '1') and (axis_tvalid  = '1') and (count_x = (I_FRAME_X - 1)) and  (count_y /= (I_FRAME_Y - 1))) then
--              count_x <= 0;
--              count_y <= count_y + 1;
--			elsif ((M_AXIS_TREADY = '1') and (axis_tvalid  = '1') and (count_x = (I_FRAME_X - 1)) and (count_y = (I_FRAME_Y - 1))) then
--			  count_x <= 0;                                                                
--              count_y <= 0; 
--            end if;                                                                                    
--          end if;                                                                                      
--        end process;      
	                                              
    
    
	
	-- Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
	-- to match the latency of M_AXIS_TDATA                                                        
--	process(M_AXIS_ACLK)                                                                           
--	begin                                                                                          
--	  if (rising_edge (M_AXIS_ACLK)) then                                                          
--	    if(M_AXIS_ARESETN = '0') then                                                              
--	      axis_tvalid_delay <= '0';                                                                
--	      axis_tlast_delay <= '0';                                                                 
--	    else                                                                                       
--	      axis_tvalid_delay <= axis_tvalid;                                                        
--	      axis_tlast_delay <= axis_tlast;                                                          
--	    end if;                                                                                    
--	  end if;                                                                                      
--	end process;                                                                                   


	--read_pointer pointer

--	process(M_AXIS_ACLK)                                                       
--	begin                                                                            
--	  if (rising_edge (M_AXIS_ACLK)) then                                            
--	    if(M_AXIS_ARESETN = '0') then                                                
--	      read_pointer <= 0;                                                         
--	      --tx_done  <= '0';                                                           
--	    else                                                                         
--	      if (read_pointer <= NUMBER_OF_OUTPUT_WORDS-1) then                         
--	        if (tx_en = '1') then                                                    
--	          -- read pointer is incremented after every read from the FIFO          
--	          -- when FIFO read signal is enabled.                                   
--	          read_pointer <= read_pointer + 1;                                      
--	          --tx_done <= '0';                                                        
--	        end if;                                                                  
--	      elsif (read_pointer = NUMBER_OF_OUTPUT_WORDS) then                         
--	        -- tx_done is asserted when NUMBER_OF_OUTPUT_WORDS numbers of streaming data
--	        -- has been out.                                                         
--	        --tx_done <= '1';                                                          
--	      end  if;                                                                   
--	    end  if;                                                                     
--	  end  if;                                                                       
--	end process;                                                                     


	--FIFO read enable generation 

	--tx_en <= M_AXIS_TREADY and axis_tvalid; 
--	tx_en <= M_AXIS_TREADY and (not(fifo_empty_flag));                                   
	                                                                                
	-- FIFO Implementation                                                          
--    process(M_AXIS_ACLK)                                                          
--          begin                                                                         
--            if (rising_edge (M_AXIS_ACLK)) then                                         
--              if(M_AXIS_ARESETN = '0') then                                             
--                stream_data_out <= std_logic_vector(to_unsigned(sig_one,C_M_AXIS_TDATA_WIDTH));  
--              elsif (tx_en = '1') then -- && M_AXIS_TSTRB(byte_index)                   
--                stream_data_out <= std_logic_vector( to_unsigned(read_pointer,C_M_AXIS_TDATA_WIDTH) + to_unsigned(sig_one,C_M_AXIS_TDATA_WIDTH));
--              end if;                                                                   
--            end if;                                                                    
--           end process;	                                             
	                                                                                
	-- Streaming output data is read from FIFO                                      
--	  process(M_AXIS_ACLK)                                                          
--	  variable  sig_one : integer := 1;                                             
--	  begin                                                                         
--	    if (rising_edge (M_AXIS_ACLK)) then                                         
--	      if(M_AXIS_ARESETN = '0') then                                             
--	    	stream_data_out <= std_logic_vector(to_unsigned(sig_one,C_M_AXIS_TDATA_WIDTH));  
--	      elsif (tx_en = '1') then -- && M_AXIS_TSTRB(byte_index)                   
--	        stream_data_out <= std_logic_vector( to_unsigned(read_pointer,C_M_AXIS_TDATA_WIDTH) + to_unsigned(sig_one,C_M_AXIS_TDATA_WIDTH));
--	      end if;                                                                   
--	     end if;                                                                    
--	   end process;                                                                 

	-- Add user logic here
--    Full_flag : process(write_pointer, read_pointer)
--          begin
--            if ((write_pointer - read_pointer) = (NUMBER_OF_OUTPUT_WORDS-1)) then  --NUMBER_OF_INPUT_WORDS = 8
--            fifo_full_flag <= '1'; 
--            else 
--            fifo_full_flag <= '0';
--            end if;
--        end process Full_flag;
        
--        Empty_Flag: process(write_pointer, read_pointer)
--              begin
--                if (write_pointer = read_pointer)then
--                fifo_empty_flag <= '1';
--                else 
--                fifo_empty_flag <= '0';
--                end if;
--            end process Empty_Flag;
            
    -- write_pointer
--                process(M_AXIS_ACLK)
--                begin
--                  if (rising_edge (M_AXIS_ACLK)) then
--                    if(M_AXIS_ARESETN = '0') then
--                      write_pointer <= 0;
--                    else
--                      if (I_DATA_VALID = '1') then
--                          write_pointer <= write_pointer + 1;
--                        end if;
--                    end if;
--                  end if;
--                end process;

--	stream_data_out <= stream_fifo_data_d;--stream_fifo_data(read_pointer);
	
-- Delayed output ...check if needed?
--	process(M_AXIS_ACLK)
--          begin
--            if (rising_edge (M_AXIS_ACLK)) then
--              if(M_AXIS_ARESETN = '0') then
--                stream_data_out <= '0';
--              elsif (I_DATA_VALID = '1') then
--                stream_data_out <= stream_fifo_data(read_pointer);
--              end if;          
--            end  if;
--          end process;
         
--	process(M_AXIS_ACLK)
--	  begin
--	    if (rising_edge (M_AXIS_ACLK)) then
--	      if (M_AXIS_ARESETN = '0') then
--	        stream_fifo_data_d <= (others => '0');
--	      else
--	        stream_fifo_data_d <= I_DATA((C_M_AXIS_TDATA_WIDTH - 1) downto 0);
--	      end if;
--	    end if;
--	  end process;
	  
	  
--	process(M_AXIS_ACLK)
--	  begin
--	    if (rising_edge (M_AXIS_ACLK)) then
--	      if (I_DATA_VALID = '1') then
--		    stream_fifo_data(write_pointer) <= I_DATA((C_M_AXIS_TDATA_WIDTH - 1) downto 0);
--		  end if;		  
--	    end  if;
--	  end process;
	  
    
    
	-- User logic ends

end implementation;