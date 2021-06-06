	component ddr_board_acl_memory_bank_divider_0 is
		port (
			clk_clk                  : in  std_logic                      := 'X';             -- clk
			reset_reset_n            : in  std_logic                      := 'X';             -- reset_n
			acl_bsp_snoop_data       : out std_logic_vector(32 downto 0);                     -- data
			acl_bsp_snoop_valid      : out std_logic;                                         -- valid
			acl_bsp_snoop_ready      : in  std_logic                      := 'X';             -- ready
			kernel_clk_clk           : in  std_logic                      := 'X';             -- clk
			kernel_reset_reset_n     : in  std_logic                      := 'X';             -- reset_n
			s_writedata              : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			s_read                   : in  std_logic                      := 'X';             -- read
			s_write                  : in  std_logic                      := 'X';             -- write
			s_burstcount             : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- burstcount
			s_byteenable             : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			s_waitrequest            : out std_logic;                                         -- waitrequest
			s_readdata               : out std_logic_vector(511 downto 0);                    -- readdata
			s_readdatavalid          : out std_logic;                                         -- readdatavalid
			s_address                : in  std_logic_vector(26 downto 0)  := (others => 'X'); -- address
			acl_bsp_memorg_host_mode : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- mode
			bank1_address            : out std_logic_vector(31 downto 0);                     -- address
			bank1_writedata          : out std_logic_vector(511 downto 0);                    -- writedata
			bank1_read               : out std_logic;                                         -- read
			bank1_write              : out std_logic;                                         -- write
			bank1_burstcount         : out std_logic_vector(4 downto 0);                      -- burstcount
			bank1_byteenable         : out std_logic_vector(63 downto 0);                     -- byteenable
			bank1_waitrequest        : in  std_logic                      := 'X';             -- waitrequest
			bank1_readdata           : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			bank1_readdatavalid      : in  std_logic                      := 'X';             -- readdatavalid
			bank2_address            : out std_logic_vector(31 downto 0);                     -- address
			bank2_writedata          : out std_logic_vector(511 downto 0);                    -- writedata
			bank2_read               : out std_logic;                                         -- read
			bank2_write              : out std_logic;                                         -- write
			bank2_burstcount         : out std_logic_vector(4 downto 0);                      -- burstcount
			bank2_byteenable         : out std_logic_vector(63 downto 0);                     -- byteenable
			bank2_waitrequest        : in  std_logic                      := 'X';             -- waitrequest
			bank2_readdata           : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			bank2_readdatavalid      : in  std_logic                      := 'X'              -- readdatavalid
		);
	end component ddr_board_acl_memory_bank_divider_0;

	u0 : component ddr_board_acl_memory_bank_divider_0
		port map (
			clk_clk                  => CONNECTED_TO_clk_clk,                  --                 clk.clk
			reset_reset_n            => CONNECTED_TO_reset_reset_n,            --               reset.reset_n
			acl_bsp_snoop_data       => CONNECTED_TO_acl_bsp_snoop_data,       --       acl_bsp_snoop.data
			acl_bsp_snoop_valid      => CONNECTED_TO_acl_bsp_snoop_valid,      --                    .valid
			acl_bsp_snoop_ready      => CONNECTED_TO_acl_bsp_snoop_ready,      --                    .ready
			kernel_clk_clk           => CONNECTED_TO_kernel_clk_clk,           --          kernel_clk.clk
			kernel_reset_reset_n     => CONNECTED_TO_kernel_reset_reset_n,     --        kernel_reset.reset_n
			s_writedata              => CONNECTED_TO_s_writedata,              --                   s.writedata
			s_read                   => CONNECTED_TO_s_read,                   --                    .read
			s_write                  => CONNECTED_TO_s_write,                  --                    .write
			s_burstcount             => CONNECTED_TO_s_burstcount,             --                    .burstcount
			s_byteenable             => CONNECTED_TO_s_byteenable,             --                    .byteenable
			s_waitrequest            => CONNECTED_TO_s_waitrequest,            --                    .waitrequest
			s_readdata               => CONNECTED_TO_s_readdata,               --                    .readdata
			s_readdatavalid          => CONNECTED_TO_s_readdatavalid,          --                    .readdatavalid
			s_address                => CONNECTED_TO_s_address,                --                    .address
			acl_bsp_memorg_host_mode => CONNECTED_TO_acl_bsp_memorg_host_mode, -- acl_bsp_memorg_host.mode
			bank1_address            => CONNECTED_TO_bank1_address,            --               bank1.address
			bank1_writedata          => CONNECTED_TO_bank1_writedata,          --                    .writedata
			bank1_read               => CONNECTED_TO_bank1_read,               --                    .read
			bank1_write              => CONNECTED_TO_bank1_write,              --                    .write
			bank1_burstcount         => CONNECTED_TO_bank1_burstcount,         --                    .burstcount
			bank1_byteenable         => CONNECTED_TO_bank1_byteenable,         --                    .byteenable
			bank1_waitrequest        => CONNECTED_TO_bank1_waitrequest,        --                    .waitrequest
			bank1_readdata           => CONNECTED_TO_bank1_readdata,           --                    .readdata
			bank1_readdatavalid      => CONNECTED_TO_bank1_readdatavalid,      --                    .readdatavalid
			bank2_address            => CONNECTED_TO_bank2_address,            --               bank2.address
			bank2_writedata          => CONNECTED_TO_bank2_writedata,          --                    .writedata
			bank2_read               => CONNECTED_TO_bank2_read,               --                    .read
			bank2_write              => CONNECTED_TO_bank2_write,              --                    .write
			bank2_burstcount         => CONNECTED_TO_bank2_burstcount,         --                    .burstcount
			bank2_byteenable         => CONNECTED_TO_bank2_byteenable,         --                    .byteenable
			bank2_waitrequest        => CONNECTED_TO_bank2_waitrequest,        --                    .waitrequest
			bank2_readdata           => CONNECTED_TO_bank2_readdata,           --                    .readdata
			bank2_readdatavalid      => CONNECTED_TO_bank2_readdatavalid       --                    .readdatavalid
		);

