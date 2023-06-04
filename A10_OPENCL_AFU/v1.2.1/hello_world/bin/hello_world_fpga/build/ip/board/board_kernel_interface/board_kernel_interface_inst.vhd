	component board_kernel_interface is
		port (
			kernel_cra_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			kernel_cra_readdata           : in  std_logic_vector(63 downto 0) := (others => 'X'); -- readdata
			kernel_cra_readdatavalid      : in  std_logic                     := 'X';             -- readdatavalid
			kernel_cra_burstcount         : out std_logic_vector(0 downto 0);                     -- burstcount
			kernel_cra_writedata          : out std_logic_vector(63 downto 0);                    -- writedata
			kernel_cra_address            : out std_logic_vector(29 downto 0);                    -- address
			kernel_cra_write              : out std_logic;                                        -- write
			kernel_cra_read               : out std_logic;                                        -- read
			kernel_cra_byteenable         : out std_logic_vector(7 downto 0);                     -- byteenable
			kernel_cra_debugaccess        : out std_logic;                                        -- debugaccess
			ctrl_waitrequest              : out std_logic;                                        -- waitrequest
			ctrl_readdata                 : out std_logic_vector(31 downto 0);                    -- readdata
			ctrl_readdatavalid            : out std_logic;                                        -- readdatavalid
			ctrl_burstcount               : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			ctrl_writedata                : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			ctrl_address                  : in  std_logic_vector(13 downto 0) := (others => 'X'); -- address
			ctrl_write                    : in  std_logic                     := 'X';             -- write
			ctrl_read                     : in  std_logic                     := 'X';             -- read
			ctrl_byteenable               : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			ctrl_debugaccess              : in  std_logic                     := 'X';             -- debugaccess
			acl_bsp_memorg_host0x018_mode : out std_logic_vector(1 downto 0);                     -- mode
			clk_clk                       : in  std_logic                     := 'X';             -- clk
			reset_reset_n                 : in  std_logic                     := 'X';             -- reset_n
			kernel_irq_from_kernel_irq    : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- irq
			kernel_irq_to_host_irq        : out std_logic;                                        -- irq
			sw_reset_in_reset             : in  std_logic                     := 'X';             -- reset
			kernel_clk_clk                : in  std_logic                     := 'X';             -- clk
			kernel_reset_reset_n          : out std_logic;                                        -- reset_n
			sw_reset_export_reset_n       : out std_logic                                         -- reset_n
		);
	end component board_kernel_interface;

	u0 : component board_kernel_interface
		port map (
			kernel_cra_waitrequest        => CONNECTED_TO_kernel_cra_waitrequest,        --               kernel_cra.waitrequest
			kernel_cra_readdata           => CONNECTED_TO_kernel_cra_readdata,           --                         .readdata
			kernel_cra_readdatavalid      => CONNECTED_TO_kernel_cra_readdatavalid,      --                         .readdatavalid
			kernel_cra_burstcount         => CONNECTED_TO_kernel_cra_burstcount,         --                         .burstcount
			kernel_cra_writedata          => CONNECTED_TO_kernel_cra_writedata,          --                         .writedata
			kernel_cra_address            => CONNECTED_TO_kernel_cra_address,            --                         .address
			kernel_cra_write              => CONNECTED_TO_kernel_cra_write,              --                         .write
			kernel_cra_read               => CONNECTED_TO_kernel_cra_read,               --                         .read
			kernel_cra_byteenable         => CONNECTED_TO_kernel_cra_byteenable,         --                         .byteenable
			kernel_cra_debugaccess        => CONNECTED_TO_kernel_cra_debugaccess,        --                         .debugaccess
			ctrl_waitrequest              => CONNECTED_TO_ctrl_waitrequest,              --                     ctrl.waitrequest
			ctrl_readdata                 => CONNECTED_TO_ctrl_readdata,                 --                         .readdata
			ctrl_readdatavalid            => CONNECTED_TO_ctrl_readdatavalid,            --                         .readdatavalid
			ctrl_burstcount               => CONNECTED_TO_ctrl_burstcount,               --                         .burstcount
			ctrl_writedata                => CONNECTED_TO_ctrl_writedata,                --                         .writedata
			ctrl_address                  => CONNECTED_TO_ctrl_address,                  --                         .address
			ctrl_write                    => CONNECTED_TO_ctrl_write,                    --                         .write
			ctrl_read                     => CONNECTED_TO_ctrl_read,                     --                         .read
			ctrl_byteenable               => CONNECTED_TO_ctrl_byteenable,               --                         .byteenable
			ctrl_debugaccess              => CONNECTED_TO_ctrl_debugaccess,              --                         .debugaccess
			acl_bsp_memorg_host0x018_mode => CONNECTED_TO_acl_bsp_memorg_host0x018_mode, -- acl_bsp_memorg_host0x018.mode
			clk_clk                       => CONNECTED_TO_clk_clk,                       --                      clk.clk
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --                    reset.reset_n
			kernel_irq_from_kernel_irq    => CONNECTED_TO_kernel_irq_from_kernel_irq,    --   kernel_irq_from_kernel.irq
			kernel_irq_to_host_irq        => CONNECTED_TO_kernel_irq_to_host_irq,        --       kernel_irq_to_host.irq
			sw_reset_in_reset             => CONNECTED_TO_sw_reset_in_reset,             --              sw_reset_in.reset
			kernel_clk_clk                => CONNECTED_TO_kernel_clk_clk,                --               kernel_clk.clk
			kernel_reset_reset_n          => CONNECTED_TO_kernel_reset_reset_n,          --             kernel_reset.reset_n
			sw_reset_export_reset_n       => CONNECTED_TO_sw_reset_export_reset_n        --          sw_reset_export.reset_n
		);

