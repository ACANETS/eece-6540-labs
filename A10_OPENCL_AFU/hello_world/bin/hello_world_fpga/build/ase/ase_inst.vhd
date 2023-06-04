	component ase is
		port (
			expanded_master_address       : out std_logic_vector(47 downto 0);                     -- address
			expanded_master_read          : out std_logic;                                         -- read
			expanded_master_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			expanded_master_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			expanded_master_write         : out std_logic;                                         -- write
			expanded_master_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			expanded_master_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			expanded_master_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			expanded_master_burstcount    : out std_logic_vector(3 downto 0);                      -- burstcount
			avmm_pipe_slave_waitrequest   : out std_logic;                                         -- waitrequest
			avmm_pipe_slave_readdata      : out std_logic_vector(63 downto 0);                     -- readdata
			avmm_pipe_slave_readdatavalid : out std_logic;                                         -- readdatavalid
			avmm_pipe_slave_burstcount    : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			avmm_pipe_slave_writedata     : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			avmm_pipe_slave_address       : in  std_logic_vector(12 downto 0)  := (others => 'X'); -- address
			avmm_pipe_slave_write         : in  std_logic                      := 'X';             -- write
			avmm_pipe_slave_read          : in  std_logic                      := 'X';             -- read
			avmm_pipe_slave_byteenable    : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			avmm_pipe_slave_debugaccess   : in  std_logic                      := 'X';             -- debugaccess
			clk_clk                       : in  std_logic                      := 'X';             -- clk
			reset_reset                   : in  std_logic                      := 'X'              -- reset
		);
	end component ase;

	u0 : component ase
		port map (
			expanded_master_address       => CONNECTED_TO_expanded_master_address,       -- expanded_master.address
			expanded_master_read          => CONNECTED_TO_expanded_master_read,          --                .read
			expanded_master_waitrequest   => CONNECTED_TO_expanded_master_waitrequest,   --                .waitrequest
			expanded_master_readdata      => CONNECTED_TO_expanded_master_readdata,      --                .readdata
			expanded_master_write         => CONNECTED_TO_expanded_master_write,         --                .write
			expanded_master_writedata     => CONNECTED_TO_expanded_master_writedata,     --                .writedata
			expanded_master_readdatavalid => CONNECTED_TO_expanded_master_readdatavalid, --                .readdatavalid
			expanded_master_byteenable    => CONNECTED_TO_expanded_master_byteenable,    --                .byteenable
			expanded_master_burstcount    => CONNECTED_TO_expanded_master_burstcount,    --                .burstcount
			avmm_pipe_slave_waitrequest   => CONNECTED_TO_avmm_pipe_slave_waitrequest,   -- avmm_pipe_slave.waitrequest
			avmm_pipe_slave_readdata      => CONNECTED_TO_avmm_pipe_slave_readdata,      --                .readdata
			avmm_pipe_slave_readdatavalid => CONNECTED_TO_avmm_pipe_slave_readdatavalid, --                .readdatavalid
			avmm_pipe_slave_burstcount    => CONNECTED_TO_avmm_pipe_slave_burstcount,    --                .burstcount
			avmm_pipe_slave_writedata     => CONNECTED_TO_avmm_pipe_slave_writedata,     --                .writedata
			avmm_pipe_slave_address       => CONNECTED_TO_avmm_pipe_slave_address,       --                .address
			avmm_pipe_slave_write         => CONNECTED_TO_avmm_pipe_slave_write,         --                .write
			avmm_pipe_slave_read          => CONNECTED_TO_avmm_pipe_slave_read,          --                .read
			avmm_pipe_slave_byteenable    => CONNECTED_TO_avmm_pipe_slave_byteenable,    --                .byteenable
			avmm_pipe_slave_debugaccess   => CONNECTED_TO_avmm_pipe_slave_debugaccess,   --                .debugaccess
			clk_clk                       => CONNECTED_TO_clk_clk,                       --             clk.clk
			reset_reset                   => CONNECTED_TO_reset_reset                    --           reset.reset
		);

