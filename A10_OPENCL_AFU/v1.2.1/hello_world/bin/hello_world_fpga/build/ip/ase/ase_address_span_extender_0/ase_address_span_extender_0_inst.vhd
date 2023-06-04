	component ase_address_span_extender_0 is
		generic (
			SYNC_RESET : integer := 0
		);
		port (
			clk                  : in  std_logic                      := 'X';             -- clk
			reset                : in  std_logic                      := 'X';             -- reset
			avs_s0_address       : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- address
			avs_s0_read          : in  std_logic                      := 'X';             -- read
			avs_s0_readdata      : out std_logic_vector(511 downto 0);                    -- readdata
			avs_s0_write         : in  std_logic                      := 'X';             -- write
			avs_s0_writedata     : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			avs_s0_readdatavalid : out std_logic;                                         -- readdatavalid
			avs_s0_waitrequest   : out std_logic;                                         -- waitrequest
			avs_s0_byteenable    : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			avs_s0_burstcount    : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- burstcount
			avm_m0_address       : out std_logic_vector(47 downto 0);                     -- address
			avm_m0_read          : out std_logic;                                         -- read
			avm_m0_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			avm_m0_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			avm_m0_write         : out std_logic;                                         -- write
			avm_m0_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			avm_m0_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			avm_m0_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			avm_m0_burstcount    : out std_logic_vector(3 downto 0);                      -- burstcount
			avs_cntl_read        : in  std_logic                      := 'X';             -- read
			avs_cntl_readdata    : out std_logic_vector(63 downto 0);                     -- readdata
			avs_cntl_write       : in  std_logic                      := 'X';             -- write
			avs_cntl_writedata   : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			avs_cntl_byteenable  : in  std_logic_vector(7 downto 0)   := (others => 'X')  -- byteenable
		);
	end component ase_address_span_extender_0;

	u0 : component ase_address_span_extender_0
		generic map (
			SYNC_RESET => INTEGER_VALUE_FOR_SYNC_RESET
		)
		port map (
			clk                  => CONNECTED_TO_clk,                  --           clock.clk
			reset                => CONNECTED_TO_reset,                --           reset.reset
			avs_s0_address       => CONNECTED_TO_avs_s0_address,       --  windowed_slave.address
			avs_s0_read          => CONNECTED_TO_avs_s0_read,          --                .read
			avs_s0_readdata      => CONNECTED_TO_avs_s0_readdata,      --                .readdata
			avs_s0_write         => CONNECTED_TO_avs_s0_write,         --                .write
			avs_s0_writedata     => CONNECTED_TO_avs_s0_writedata,     --                .writedata
			avs_s0_readdatavalid => CONNECTED_TO_avs_s0_readdatavalid, --                .readdatavalid
			avs_s0_waitrequest   => CONNECTED_TO_avs_s0_waitrequest,   --                .waitrequest
			avs_s0_byteenable    => CONNECTED_TO_avs_s0_byteenable,    --                .byteenable
			avs_s0_burstcount    => CONNECTED_TO_avs_s0_burstcount,    --                .burstcount
			avm_m0_address       => CONNECTED_TO_avm_m0_address,       -- expanded_master.address
			avm_m0_read          => CONNECTED_TO_avm_m0_read,          --                .read
			avm_m0_waitrequest   => CONNECTED_TO_avm_m0_waitrequest,   --                .waitrequest
			avm_m0_readdata      => CONNECTED_TO_avm_m0_readdata,      --                .readdata
			avm_m0_write         => CONNECTED_TO_avm_m0_write,         --                .write
			avm_m0_writedata     => CONNECTED_TO_avm_m0_writedata,     --                .writedata
			avm_m0_readdatavalid => CONNECTED_TO_avm_m0_readdatavalid, --                .readdatavalid
			avm_m0_byteenable    => CONNECTED_TO_avm_m0_byteenable,    --                .byteenable
			avm_m0_burstcount    => CONNECTED_TO_avm_m0_burstcount,    --                .burstcount
			avs_cntl_read        => CONNECTED_TO_avs_cntl_read,        --            cntl.read
			avs_cntl_readdata    => CONNECTED_TO_avs_cntl_readdata,    --                .readdata
			avs_cntl_write       => CONNECTED_TO_avs_cntl_write,       --                .write
			avs_cntl_writedata   => CONNECTED_TO_avs_cntl_writedata,   --                .writedata
			avs_cntl_byteenable  => CONNECTED_TO_avs_cntl_byteenable   --                .byteenable
		);

