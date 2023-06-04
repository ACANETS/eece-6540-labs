	component board is
		port (
			host_kernel_irq_irq                  : out std_logic;                                         -- irq
			clk_200_clk                          : in  std_logic                      := 'X';             -- clk
			emif_ddr4a_clk_clk                   : in  std_logic                      := 'X';             -- clk
			emif_ddr4b_clk_clk                   : in  std_logic                      := 'X';             -- clk
			global_reset_reset                   : in  std_logic                      := 'X';             -- reset
			kernel_clk_clk                       : out std_logic;                                         -- clk
			kernel_reset_reset_n                 : out std_logic;                                         -- reset_n
			kernel_clk_in_clk                    : in  std_logic                      := 'X';             -- clk
			kernel_cra_waitrequest               : in  std_logic                      := 'X';             -- waitrequest
			kernel_cra_readdata                  : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- readdata
			kernel_cra_readdatavalid             : in  std_logic                      := 'X';             -- readdatavalid
			kernel_cra_burstcount                : out std_logic_vector(0 downto 0);                      -- burstcount
			kernel_cra_writedata                 : out std_logic_vector(63 downto 0);                     -- writedata
			kernel_cra_address                   : out std_logic_vector(29 downto 0);                     -- address
			kernel_cra_write                     : out std_logic;                                         -- write
			kernel_cra_read                      : out std_logic;                                         -- read
			kernel_cra_byteenable                : out std_logic_vector(7 downto 0);                      -- byteenable
			kernel_cra_debugaccess               : out std_logic;                                         -- debugaccess
			kernel_irq_irq                       : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- irq
			ccip_avmm_requestor_rd_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			ccip_avmm_requestor_rd_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			ccip_avmm_requestor_rd_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			ccip_avmm_requestor_rd_burstcount    : out std_logic_vector(2 downto 0);                      -- burstcount
			ccip_avmm_requestor_rd_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			ccip_avmm_requestor_rd_address       : out std_logic_vector(47 downto 0);                     -- address
			ccip_avmm_requestor_rd_write         : out std_logic;                                         -- write
			ccip_avmm_requestor_rd_read          : out std_logic;                                         -- read
			ccip_avmm_requestor_rd_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			ccip_avmm_requestor_rd_debugaccess   : out std_logic;                                         -- debugaccess
			ccip_avmm_requestor_wr_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			ccip_avmm_requestor_wr_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			ccip_avmm_requestor_wr_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			ccip_avmm_requestor_wr_burstcount    : out std_logic_vector(2 downto 0);                      -- burstcount
			ccip_avmm_requestor_wr_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			ccip_avmm_requestor_wr_address       : out std_logic_vector(47 downto 0);                     -- address
			ccip_avmm_requestor_wr_write         : out std_logic;                                         -- write
			ccip_avmm_requestor_wr_read          : out std_logic;                                         -- read
			ccip_avmm_requestor_wr_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			ccip_avmm_requestor_wr_debugaccess   : out std_logic;                                         -- debugaccess
			ccip_avmm_mmio_waitrequest           : out std_logic;                                         -- waitrequest
			ccip_avmm_mmio_readdata              : out std_logic_vector(63 downto 0);                     -- readdata
			ccip_avmm_mmio_readdatavalid         : out std_logic;                                         -- readdatavalid
			ccip_avmm_mmio_burstcount            : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			ccip_avmm_mmio_writedata             : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			ccip_avmm_mmio_address               : in  std_logic_vector(17 downto 0)  := (others => 'X'); -- address
			ccip_avmm_mmio_write                 : in  std_logic                      := 'X';             -- write
			ccip_avmm_mmio_read                  : in  std_logic                      := 'X';             -- read
			ccip_avmm_mmio_byteenable            : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			ccip_avmm_mmio_debugaccess           : in  std_logic                      := 'X';             -- debugaccess
			kernel_ddr4a_waitrequest             : out std_logic;                                         -- waitrequest
			kernel_ddr4a_readdata                : out std_logic_vector(511 downto 0);                    -- readdata
			kernel_ddr4a_readdatavalid           : out std_logic;                                         -- readdatavalid
			kernel_ddr4a_burstcount              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- burstcount
			kernel_ddr4a_writedata               : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			kernel_ddr4a_address                 : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- address
			kernel_ddr4a_write                   : in  std_logic                      := 'X';             -- write
			kernel_ddr4a_read                    : in  std_logic                      := 'X';             -- read
			kernel_ddr4a_byteenable              : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			kernel_ddr4a_debugaccess             : in  std_logic                      := 'X';             -- debugaccess
			emif_ddr4a_waitrequest               : in  std_logic                      := 'X';             -- waitrequest
			emif_ddr4a_readdata                  : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			emif_ddr4a_readdatavalid             : in  std_logic                      := 'X';             -- readdatavalid
			emif_ddr4a_burstcount                : out std_logic_vector(6 downto 0);                      -- burstcount
			emif_ddr4a_writedata                 : out std_logic_vector(511 downto 0);                    -- writedata
			emif_ddr4a_address                   : out std_logic_vector(31 downto 0);                     -- address
			emif_ddr4a_write                     : out std_logic;                                         -- write
			emif_ddr4a_read                      : out std_logic;                                         -- read
			emif_ddr4a_byteenable                : out std_logic_vector(63 downto 0);                     -- byteenable
			emif_ddr4a_debugaccess               : out std_logic;                                         -- debugaccess
			kernel_ddr4b_waitrequest             : out std_logic;                                         -- waitrequest
			kernel_ddr4b_readdata                : out std_logic_vector(511 downto 0);                    -- readdata
			kernel_ddr4b_readdatavalid           : out std_logic;                                         -- readdatavalid
			kernel_ddr4b_burstcount              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- burstcount
			kernel_ddr4b_writedata               : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			kernel_ddr4b_address                 : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- address
			kernel_ddr4b_write                   : in  std_logic                      := 'X';             -- write
			kernel_ddr4b_read                    : in  std_logic                      := 'X';             -- read
			kernel_ddr4b_byteenable              : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			kernel_ddr4b_debugaccess             : in  std_logic                      := 'X';             -- debugaccess
			emif_ddr4b_waitrequest               : in  std_logic                      := 'X';             -- waitrequest
			emif_ddr4b_readdata                  : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			emif_ddr4b_readdatavalid             : in  std_logic                      := 'X';             -- readdatavalid
			emif_ddr4b_burstcount                : out std_logic_vector(6 downto 0);                      -- burstcount
			emif_ddr4b_writedata                 : out std_logic_vector(511 downto 0);                    -- writedata
			emif_ddr4b_address                   : out std_logic_vector(31 downto 0);                     -- address
			emif_ddr4b_write                     : out std_logic;                                         -- write
			emif_ddr4b_read                      : out std_logic;                                         -- read
			emif_ddr4b_byteenable                : out std_logic_vector(63 downto 0);                     -- byteenable
			emif_ddr4b_debugaccess               : out std_logic;                                         -- debugaccess
			acl_internal_snoop_data              : out std_logic_vector(32 downto 0);                     -- data
			acl_internal_snoop_valid             : out std_logic;                                         -- valid
			acl_internal_snoop_ready             : in  std_logic                      := 'X';             -- ready
			msgdma_bbb_0_dma_irq_irq             : out std_logic;                                         -- irq
			msgdma_bbb_1_dma_irq_irq             : out std_logic                                          -- irq
		);
	end component board;

	u0 : component board
		port map (
			host_kernel_irq_irq                  => CONNECTED_TO_host_kernel_irq_irq,                  --        host_kernel_irq.irq
			clk_200_clk                          => CONNECTED_TO_clk_200_clk,                          --                clk_200.clk
			emif_ddr4a_clk_clk                   => CONNECTED_TO_emif_ddr4a_clk_clk,                   --         emif_ddr4a_clk.clk
			emif_ddr4b_clk_clk                   => CONNECTED_TO_emif_ddr4b_clk_clk,                   --         emif_ddr4b_clk.clk
			global_reset_reset                   => CONNECTED_TO_global_reset_reset,                   --           global_reset.reset
			kernel_clk_clk                       => CONNECTED_TO_kernel_clk_clk,                       --             kernel_clk.clk
			kernel_reset_reset_n                 => CONNECTED_TO_kernel_reset_reset_n,                 --           kernel_reset.reset_n
			kernel_clk_in_clk                    => CONNECTED_TO_kernel_clk_in_clk,                    --          kernel_clk_in.clk
			kernel_cra_waitrequest               => CONNECTED_TO_kernel_cra_waitrequest,               --             kernel_cra.waitrequest
			kernel_cra_readdata                  => CONNECTED_TO_kernel_cra_readdata,                  --                       .readdata
			kernel_cra_readdatavalid             => CONNECTED_TO_kernel_cra_readdatavalid,             --                       .readdatavalid
			kernel_cra_burstcount                => CONNECTED_TO_kernel_cra_burstcount,                --                       .burstcount
			kernel_cra_writedata                 => CONNECTED_TO_kernel_cra_writedata,                 --                       .writedata
			kernel_cra_address                   => CONNECTED_TO_kernel_cra_address,                   --                       .address
			kernel_cra_write                     => CONNECTED_TO_kernel_cra_write,                     --                       .write
			kernel_cra_read                      => CONNECTED_TO_kernel_cra_read,                      --                       .read
			kernel_cra_byteenable                => CONNECTED_TO_kernel_cra_byteenable,                --                       .byteenable
			kernel_cra_debugaccess               => CONNECTED_TO_kernel_cra_debugaccess,               --                       .debugaccess
			kernel_irq_irq                       => CONNECTED_TO_kernel_irq_irq,                       --             kernel_irq.irq
			ccip_avmm_requestor_rd_waitrequest   => CONNECTED_TO_ccip_avmm_requestor_rd_waitrequest,   -- ccip_avmm_requestor_rd.waitrequest
			ccip_avmm_requestor_rd_readdata      => CONNECTED_TO_ccip_avmm_requestor_rd_readdata,      --                       .readdata
			ccip_avmm_requestor_rd_readdatavalid => CONNECTED_TO_ccip_avmm_requestor_rd_readdatavalid, --                       .readdatavalid
			ccip_avmm_requestor_rd_burstcount    => CONNECTED_TO_ccip_avmm_requestor_rd_burstcount,    --                       .burstcount
			ccip_avmm_requestor_rd_writedata     => CONNECTED_TO_ccip_avmm_requestor_rd_writedata,     --                       .writedata
			ccip_avmm_requestor_rd_address       => CONNECTED_TO_ccip_avmm_requestor_rd_address,       --                       .address
			ccip_avmm_requestor_rd_write         => CONNECTED_TO_ccip_avmm_requestor_rd_write,         --                       .write
			ccip_avmm_requestor_rd_read          => CONNECTED_TO_ccip_avmm_requestor_rd_read,          --                       .read
			ccip_avmm_requestor_rd_byteenable    => CONNECTED_TO_ccip_avmm_requestor_rd_byteenable,    --                       .byteenable
			ccip_avmm_requestor_rd_debugaccess   => CONNECTED_TO_ccip_avmm_requestor_rd_debugaccess,   --                       .debugaccess
			ccip_avmm_requestor_wr_waitrequest   => CONNECTED_TO_ccip_avmm_requestor_wr_waitrequest,   -- ccip_avmm_requestor_wr.waitrequest
			ccip_avmm_requestor_wr_readdata      => CONNECTED_TO_ccip_avmm_requestor_wr_readdata,      --                       .readdata
			ccip_avmm_requestor_wr_readdatavalid => CONNECTED_TO_ccip_avmm_requestor_wr_readdatavalid, --                       .readdatavalid
			ccip_avmm_requestor_wr_burstcount    => CONNECTED_TO_ccip_avmm_requestor_wr_burstcount,    --                       .burstcount
			ccip_avmm_requestor_wr_writedata     => CONNECTED_TO_ccip_avmm_requestor_wr_writedata,     --                       .writedata
			ccip_avmm_requestor_wr_address       => CONNECTED_TO_ccip_avmm_requestor_wr_address,       --                       .address
			ccip_avmm_requestor_wr_write         => CONNECTED_TO_ccip_avmm_requestor_wr_write,         --                       .write
			ccip_avmm_requestor_wr_read          => CONNECTED_TO_ccip_avmm_requestor_wr_read,          --                       .read
			ccip_avmm_requestor_wr_byteenable    => CONNECTED_TO_ccip_avmm_requestor_wr_byteenable,    --                       .byteenable
			ccip_avmm_requestor_wr_debugaccess   => CONNECTED_TO_ccip_avmm_requestor_wr_debugaccess,   --                       .debugaccess
			ccip_avmm_mmio_waitrequest           => CONNECTED_TO_ccip_avmm_mmio_waitrequest,           --         ccip_avmm_mmio.waitrequest
			ccip_avmm_mmio_readdata              => CONNECTED_TO_ccip_avmm_mmio_readdata,              --                       .readdata
			ccip_avmm_mmio_readdatavalid         => CONNECTED_TO_ccip_avmm_mmio_readdatavalid,         --                       .readdatavalid
			ccip_avmm_mmio_burstcount            => CONNECTED_TO_ccip_avmm_mmio_burstcount,            --                       .burstcount
			ccip_avmm_mmio_writedata             => CONNECTED_TO_ccip_avmm_mmio_writedata,             --                       .writedata
			ccip_avmm_mmio_address               => CONNECTED_TO_ccip_avmm_mmio_address,               --                       .address
			ccip_avmm_mmio_write                 => CONNECTED_TO_ccip_avmm_mmio_write,                 --                       .write
			ccip_avmm_mmio_read                  => CONNECTED_TO_ccip_avmm_mmio_read,                  --                       .read
			ccip_avmm_mmio_byteenable            => CONNECTED_TO_ccip_avmm_mmio_byteenable,            --                       .byteenable
			ccip_avmm_mmio_debugaccess           => CONNECTED_TO_ccip_avmm_mmio_debugaccess,           --                       .debugaccess
			kernel_ddr4a_waitrequest             => CONNECTED_TO_kernel_ddr4a_waitrequest,             --           kernel_ddr4a.waitrequest
			kernel_ddr4a_readdata                => CONNECTED_TO_kernel_ddr4a_readdata,                --                       .readdata
			kernel_ddr4a_readdatavalid           => CONNECTED_TO_kernel_ddr4a_readdatavalid,           --                       .readdatavalid
			kernel_ddr4a_burstcount              => CONNECTED_TO_kernel_ddr4a_burstcount,              --                       .burstcount
			kernel_ddr4a_writedata               => CONNECTED_TO_kernel_ddr4a_writedata,               --                       .writedata
			kernel_ddr4a_address                 => CONNECTED_TO_kernel_ddr4a_address,                 --                       .address
			kernel_ddr4a_write                   => CONNECTED_TO_kernel_ddr4a_write,                   --                       .write
			kernel_ddr4a_read                    => CONNECTED_TO_kernel_ddr4a_read,                    --                       .read
			kernel_ddr4a_byteenable              => CONNECTED_TO_kernel_ddr4a_byteenable,              --                       .byteenable
			kernel_ddr4a_debugaccess             => CONNECTED_TO_kernel_ddr4a_debugaccess,             --                       .debugaccess
			emif_ddr4a_waitrequest               => CONNECTED_TO_emif_ddr4a_waitrequest,               --             emif_ddr4a.waitrequest
			emif_ddr4a_readdata                  => CONNECTED_TO_emif_ddr4a_readdata,                  --                       .readdata
			emif_ddr4a_readdatavalid             => CONNECTED_TO_emif_ddr4a_readdatavalid,             --                       .readdatavalid
			emif_ddr4a_burstcount                => CONNECTED_TO_emif_ddr4a_burstcount,                --                       .burstcount
			emif_ddr4a_writedata                 => CONNECTED_TO_emif_ddr4a_writedata,                 --                       .writedata
			emif_ddr4a_address                   => CONNECTED_TO_emif_ddr4a_address,                   --                       .address
			emif_ddr4a_write                     => CONNECTED_TO_emif_ddr4a_write,                     --                       .write
			emif_ddr4a_read                      => CONNECTED_TO_emif_ddr4a_read,                      --                       .read
			emif_ddr4a_byteenable                => CONNECTED_TO_emif_ddr4a_byteenable,                --                       .byteenable
			emif_ddr4a_debugaccess               => CONNECTED_TO_emif_ddr4a_debugaccess,               --                       .debugaccess
			kernel_ddr4b_waitrequest             => CONNECTED_TO_kernel_ddr4b_waitrequest,             --           kernel_ddr4b.waitrequest
			kernel_ddr4b_readdata                => CONNECTED_TO_kernel_ddr4b_readdata,                --                       .readdata
			kernel_ddr4b_readdatavalid           => CONNECTED_TO_kernel_ddr4b_readdatavalid,           --                       .readdatavalid
			kernel_ddr4b_burstcount              => CONNECTED_TO_kernel_ddr4b_burstcount,              --                       .burstcount
			kernel_ddr4b_writedata               => CONNECTED_TO_kernel_ddr4b_writedata,               --                       .writedata
			kernel_ddr4b_address                 => CONNECTED_TO_kernel_ddr4b_address,                 --                       .address
			kernel_ddr4b_write                   => CONNECTED_TO_kernel_ddr4b_write,                   --                       .write
			kernel_ddr4b_read                    => CONNECTED_TO_kernel_ddr4b_read,                    --                       .read
			kernel_ddr4b_byteenable              => CONNECTED_TO_kernel_ddr4b_byteenable,              --                       .byteenable
			kernel_ddr4b_debugaccess             => CONNECTED_TO_kernel_ddr4b_debugaccess,             --                       .debugaccess
			emif_ddr4b_waitrequest               => CONNECTED_TO_emif_ddr4b_waitrequest,               --             emif_ddr4b.waitrequest
			emif_ddr4b_readdata                  => CONNECTED_TO_emif_ddr4b_readdata,                  --                       .readdata
			emif_ddr4b_readdatavalid             => CONNECTED_TO_emif_ddr4b_readdatavalid,             --                       .readdatavalid
			emif_ddr4b_burstcount                => CONNECTED_TO_emif_ddr4b_burstcount,                --                       .burstcount
			emif_ddr4b_writedata                 => CONNECTED_TO_emif_ddr4b_writedata,                 --                       .writedata
			emif_ddr4b_address                   => CONNECTED_TO_emif_ddr4b_address,                   --                       .address
			emif_ddr4b_write                     => CONNECTED_TO_emif_ddr4b_write,                     --                       .write
			emif_ddr4b_read                      => CONNECTED_TO_emif_ddr4b_read,                      --                       .read
			emif_ddr4b_byteenable                => CONNECTED_TO_emif_ddr4b_byteenable,                --                       .byteenable
			emif_ddr4b_debugaccess               => CONNECTED_TO_emif_ddr4b_debugaccess,               --                       .debugaccess
			acl_internal_snoop_data              => CONNECTED_TO_acl_internal_snoop_data,              --     acl_internal_snoop.data
			acl_internal_snoop_valid             => CONNECTED_TO_acl_internal_snoop_valid,             --                       .valid
			acl_internal_snoop_ready             => CONNECTED_TO_acl_internal_snoop_ready,             --                       .ready
			msgdma_bbb_0_dma_irq_irq             => CONNECTED_TO_msgdma_bbb_0_dma_irq_irq,             --   msgdma_bbb_0_dma_irq.irq
			msgdma_bbb_1_dma_irq_irq             => CONNECTED_TO_msgdma_bbb_1_dma_irq_irq              --   msgdma_bbb_1_dma_irq.irq
		);

