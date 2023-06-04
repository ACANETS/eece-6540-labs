	component ddr_board is
		port (
			kernel_ddr4a_waitrequest            : out std_logic;                                         -- waitrequest
			kernel_ddr4a_readdata               : out std_logic_vector(511 downto 0);                    -- readdata
			kernel_ddr4a_readdatavalid          : out std_logic;                                         -- readdatavalid
			kernel_ddr4a_burstcount             : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- burstcount
			kernel_ddr4a_writedata              : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			kernel_ddr4a_address                : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- address
			kernel_ddr4a_write                  : in  std_logic                      := 'X';             -- write
			kernel_ddr4a_read                   : in  std_logic                      := 'X';             -- read
			kernel_ddr4a_byteenable             : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			kernel_ddr4a_debugaccess            : in  std_logic                      := 'X';             -- debugaccess
			emif_ddr4a_waitrequest              : in  std_logic                      := 'X';             -- waitrequest
			emif_ddr4a_readdata                 : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			emif_ddr4a_readdatavalid            : in  std_logic                      := 'X';             -- readdatavalid
			emif_ddr4a_burstcount               : out std_logic_vector(6 downto 0);                      -- burstcount
			emif_ddr4a_writedata                : out std_logic_vector(511 downto 0);                    -- writedata
			emif_ddr4a_address                  : out std_logic_vector(31 downto 0);                     -- address
			emif_ddr4a_write                    : out std_logic;                                         -- write
			emif_ddr4a_read                     : out std_logic;                                         -- read
			emif_ddr4a_byteenable               : out std_logic_vector(63 downto 0);                     -- byteenable
			emif_ddr4a_debugaccess              : out std_logic;                                         -- debugaccess
			kernel_ddr4b_waitrequest            : out std_logic;                                         -- waitrequest
			kernel_ddr4b_readdata               : out std_logic_vector(511 downto 0);                    -- readdata
			kernel_ddr4b_readdatavalid          : out std_logic;                                         -- readdatavalid
			kernel_ddr4b_burstcount             : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- burstcount
			kernel_ddr4b_writedata              : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			kernel_ddr4b_address                : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- address
			kernel_ddr4b_write                  : in  std_logic                      := 'X';             -- write
			kernel_ddr4b_read                   : in  std_logic                      := 'X';             -- read
			kernel_ddr4b_byteenable             : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			kernel_ddr4b_debugaccess            : in  std_logic                      := 'X';             -- debugaccess
			emif_ddr4b_waitrequest              : in  std_logic                      := 'X';             -- waitrequest
			emif_ddr4b_readdata                 : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			emif_ddr4b_readdatavalid            : in  std_logic                      := 'X';             -- readdatavalid
			emif_ddr4b_burstcount               : out std_logic_vector(6 downto 0);                      -- burstcount
			emif_ddr4b_writedata                : out std_logic_vector(511 downto 0);                    -- writedata
			emif_ddr4b_address                  : out std_logic_vector(31 downto 0);                     -- address
			emif_ddr4b_write                    : out std_logic;                                         -- write
			emif_ddr4b_read                     : out std_logic;                                         -- read
			emif_ddr4b_byteenable               : out std_logic_vector(63 downto 0);                     -- byteenable
			emif_ddr4b_debugaccess              : out std_logic;                                         -- debugaccess
			acl_bsp_memorg_host_mode            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- mode
			acl_bsp_snoop_data                  : out std_logic_vector(32 downto 0);                     -- data
			acl_bsp_snoop_valid                 : out std_logic;                                         -- valid
			acl_bsp_snoop_ready                 : in  std_logic                      := 'X';             -- ready
			ddr_clk_a_clk                       : in  std_logic                      := 'X';             -- clk
			ddr_clk_b_clk                       : in  std_logic                      := 'X';             -- clk
			host_rd_waitrequest                 : in  std_logic                      := 'X';             -- waitrequest
			host_rd_readdata                    : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			host_rd_readdatavalid               : in  std_logic                      := 'X';             -- readdatavalid
			host_rd_burstcount                  : out std_logic_vector(2 downto 0);                      -- burstcount
			host_rd_writedata                   : out std_logic_vector(511 downto 0);                    -- writedata
			host_rd_address                     : out std_logic_vector(47 downto 0);                     -- address
			host_rd_write                       : out std_logic;                                         -- write
			host_rd_read                        : out std_logic;                                         -- read
			host_rd_byteenable                  : out std_logic_vector(63 downto 0);                     -- byteenable
			host_rd_debugaccess                 : out std_logic;                                         -- debugaccess
			host_wr_waitrequest                 : in  std_logic                      := 'X';             -- waitrequest
			host_wr_readdata                    : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			host_wr_readdatavalid               : in  std_logic                      := 'X';             -- readdatavalid
			host_wr_burstcount                  : out std_logic_vector(2 downto 0);                      -- burstcount
			host_wr_writedata                   : out std_logic_vector(511 downto 0);                    -- writedata
			host_wr_address                     : out std_logic_vector(48 downto 0);                     -- address
			host_wr_write                       : out std_logic;                                         -- write
			host_wr_read                        : out std_logic;                                         -- read
			host_wr_byteenable                  : out std_logic_vector(63 downto 0);                     -- byteenable
			host_wr_debugaccess                 : out std_logic;                                         -- debugaccess
			global_reset_reset                  : in  std_logic                      := 'X';             -- reset
			host_clk_clk                        : in  std_logic                      := 'X';             -- clk
			kernel_clk_clk                      : in  std_logic                      := 'X';             -- clk
			kernel_reset_reset                  : in  std_logic                      := 'X';             -- reset
			null_dfh_afu_id_readdata            : out std_logic_vector(63 downto 0);                     -- readdata
			null_dfh_afu_id_writedata           : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			null_dfh_afu_id_address             : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- address
			null_dfh_afu_id_write               : in  std_logic                      := 'X';             -- write
			null_dfh_afu_id_read                : in  std_logic                      := 'X';             -- read
			ase_0_avmm_pipe_slave_waitrequest   : out std_logic;                                         -- waitrequest
			ase_0_avmm_pipe_slave_readdata      : out std_logic_vector(63 downto 0);                     -- readdata
			ase_0_avmm_pipe_slave_readdatavalid : out std_logic;                                         -- readdatavalid
			ase_0_avmm_pipe_slave_burstcount    : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			ase_0_avmm_pipe_slave_writedata     : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			ase_0_avmm_pipe_slave_address       : in  std_logic_vector(12 downto 0)  := (others => 'X'); -- address
			ase_0_avmm_pipe_slave_write         : in  std_logic                      := 'X';             -- write
			ase_0_avmm_pipe_slave_read          : in  std_logic                      := 'X';             -- read
			ase_0_avmm_pipe_slave_byteenable    : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			ase_0_avmm_pipe_slave_debugaccess   : in  std_logic                      := 'X';             -- debugaccess
			msgdma_bbb_0_csr_waitrequest        : out std_logic;                                         -- waitrequest
			msgdma_bbb_0_csr_readdata           : out std_logic_vector(63 downto 0);                     -- readdata
			msgdma_bbb_0_csr_readdatavalid      : out std_logic;                                         -- readdatavalid
			msgdma_bbb_0_csr_burstcount         : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			msgdma_bbb_0_csr_writedata          : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			msgdma_bbb_0_csr_address            : in  std_logic_vector(6 downto 0)   := (others => 'X'); -- address
			msgdma_bbb_0_csr_write              : in  std_logic                      := 'X';             -- write
			msgdma_bbb_0_csr_read               : in  std_logic                      := 'X';             -- read
			msgdma_bbb_0_csr_byteenable         : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			msgdma_bbb_0_csr_debugaccess        : in  std_logic                      := 'X';             -- debugaccess
			msgdma_bbb_0_dma_irq_irq            : out std_logic;                                         -- irq
			msgdma_bbb_1_csr_waitrequest        : out std_logic;                                         -- waitrequest
			msgdma_bbb_1_csr_readdata           : out std_logic_vector(63 downto 0);                     -- readdata
			msgdma_bbb_1_csr_readdatavalid      : out std_logic;                                         -- readdatavalid
			msgdma_bbb_1_csr_burstcount         : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			msgdma_bbb_1_csr_writedata          : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			msgdma_bbb_1_csr_address            : in  std_logic_vector(6 downto 0)   := (others => 'X'); -- address
			msgdma_bbb_1_csr_write              : in  std_logic                      := 'X';             -- write
			msgdma_bbb_1_csr_read               : in  std_logic                      := 'X';             -- read
			msgdma_bbb_1_csr_byteenable         : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			msgdma_bbb_1_csr_debugaccess        : in  std_logic                      := 'X';             -- debugaccess
			msgdma_bbb_1_dma_irq_irq            : out std_logic                                          -- irq
		);
	end component ddr_board;

	u0 : component ddr_board
		port map (
			kernel_ddr4a_waitrequest            => CONNECTED_TO_kernel_ddr4a_waitrequest,            --          kernel_ddr4a.waitrequest
			kernel_ddr4a_readdata               => CONNECTED_TO_kernel_ddr4a_readdata,               --                      .readdata
			kernel_ddr4a_readdatavalid          => CONNECTED_TO_kernel_ddr4a_readdatavalid,          --                      .readdatavalid
			kernel_ddr4a_burstcount             => CONNECTED_TO_kernel_ddr4a_burstcount,             --                      .burstcount
			kernel_ddr4a_writedata              => CONNECTED_TO_kernel_ddr4a_writedata,              --                      .writedata
			kernel_ddr4a_address                => CONNECTED_TO_kernel_ddr4a_address,                --                      .address
			kernel_ddr4a_write                  => CONNECTED_TO_kernel_ddr4a_write,                  --                      .write
			kernel_ddr4a_read                   => CONNECTED_TO_kernel_ddr4a_read,                   --                      .read
			kernel_ddr4a_byteenable             => CONNECTED_TO_kernel_ddr4a_byteenable,             --                      .byteenable
			kernel_ddr4a_debugaccess            => CONNECTED_TO_kernel_ddr4a_debugaccess,            --                      .debugaccess
			emif_ddr4a_waitrequest              => CONNECTED_TO_emif_ddr4a_waitrequest,              --            emif_ddr4a.waitrequest
			emif_ddr4a_readdata                 => CONNECTED_TO_emif_ddr4a_readdata,                 --                      .readdata
			emif_ddr4a_readdatavalid            => CONNECTED_TO_emif_ddr4a_readdatavalid,            --                      .readdatavalid
			emif_ddr4a_burstcount               => CONNECTED_TO_emif_ddr4a_burstcount,               --                      .burstcount
			emif_ddr4a_writedata                => CONNECTED_TO_emif_ddr4a_writedata,                --                      .writedata
			emif_ddr4a_address                  => CONNECTED_TO_emif_ddr4a_address,                  --                      .address
			emif_ddr4a_write                    => CONNECTED_TO_emif_ddr4a_write,                    --                      .write
			emif_ddr4a_read                     => CONNECTED_TO_emif_ddr4a_read,                     --                      .read
			emif_ddr4a_byteenable               => CONNECTED_TO_emif_ddr4a_byteenable,               --                      .byteenable
			emif_ddr4a_debugaccess              => CONNECTED_TO_emif_ddr4a_debugaccess,              --                      .debugaccess
			kernel_ddr4b_waitrequest            => CONNECTED_TO_kernel_ddr4b_waitrequest,            --          kernel_ddr4b.waitrequest
			kernel_ddr4b_readdata               => CONNECTED_TO_kernel_ddr4b_readdata,               --                      .readdata
			kernel_ddr4b_readdatavalid          => CONNECTED_TO_kernel_ddr4b_readdatavalid,          --                      .readdatavalid
			kernel_ddr4b_burstcount             => CONNECTED_TO_kernel_ddr4b_burstcount,             --                      .burstcount
			kernel_ddr4b_writedata              => CONNECTED_TO_kernel_ddr4b_writedata,              --                      .writedata
			kernel_ddr4b_address                => CONNECTED_TO_kernel_ddr4b_address,                --                      .address
			kernel_ddr4b_write                  => CONNECTED_TO_kernel_ddr4b_write,                  --                      .write
			kernel_ddr4b_read                   => CONNECTED_TO_kernel_ddr4b_read,                   --                      .read
			kernel_ddr4b_byteenable             => CONNECTED_TO_kernel_ddr4b_byteenable,             --                      .byteenable
			kernel_ddr4b_debugaccess            => CONNECTED_TO_kernel_ddr4b_debugaccess,            --                      .debugaccess
			emif_ddr4b_waitrequest              => CONNECTED_TO_emif_ddr4b_waitrequest,              --            emif_ddr4b.waitrequest
			emif_ddr4b_readdata                 => CONNECTED_TO_emif_ddr4b_readdata,                 --                      .readdata
			emif_ddr4b_readdatavalid            => CONNECTED_TO_emif_ddr4b_readdatavalid,            --                      .readdatavalid
			emif_ddr4b_burstcount               => CONNECTED_TO_emif_ddr4b_burstcount,               --                      .burstcount
			emif_ddr4b_writedata                => CONNECTED_TO_emif_ddr4b_writedata,                --                      .writedata
			emif_ddr4b_address                  => CONNECTED_TO_emif_ddr4b_address,                  --                      .address
			emif_ddr4b_write                    => CONNECTED_TO_emif_ddr4b_write,                    --                      .write
			emif_ddr4b_read                     => CONNECTED_TO_emif_ddr4b_read,                     --                      .read
			emif_ddr4b_byteenable               => CONNECTED_TO_emif_ddr4b_byteenable,               --                      .byteenable
			emif_ddr4b_debugaccess              => CONNECTED_TO_emif_ddr4b_debugaccess,              --                      .debugaccess
			acl_bsp_memorg_host_mode            => CONNECTED_TO_acl_bsp_memorg_host_mode,            --   acl_bsp_memorg_host.mode
			acl_bsp_snoop_data                  => CONNECTED_TO_acl_bsp_snoop_data,                  --         acl_bsp_snoop.data
			acl_bsp_snoop_valid                 => CONNECTED_TO_acl_bsp_snoop_valid,                 --                      .valid
			acl_bsp_snoop_ready                 => CONNECTED_TO_acl_bsp_snoop_ready,                 --                      .ready
			ddr_clk_a_clk                       => CONNECTED_TO_ddr_clk_a_clk,                       --             ddr_clk_a.clk
			ddr_clk_b_clk                       => CONNECTED_TO_ddr_clk_b_clk,                       --             ddr_clk_b.clk
			host_rd_waitrequest                 => CONNECTED_TO_host_rd_waitrequest,                 --               host_rd.waitrequest
			host_rd_readdata                    => CONNECTED_TO_host_rd_readdata,                    --                      .readdata
			host_rd_readdatavalid               => CONNECTED_TO_host_rd_readdatavalid,               --                      .readdatavalid
			host_rd_burstcount                  => CONNECTED_TO_host_rd_burstcount,                  --                      .burstcount
			host_rd_writedata                   => CONNECTED_TO_host_rd_writedata,                   --                      .writedata
			host_rd_address                     => CONNECTED_TO_host_rd_address,                     --                      .address
			host_rd_write                       => CONNECTED_TO_host_rd_write,                       --                      .write
			host_rd_read                        => CONNECTED_TO_host_rd_read,                        --                      .read
			host_rd_byteenable                  => CONNECTED_TO_host_rd_byteenable,                  --                      .byteenable
			host_rd_debugaccess                 => CONNECTED_TO_host_rd_debugaccess,                 --                      .debugaccess
			host_wr_waitrequest                 => CONNECTED_TO_host_wr_waitrequest,                 --               host_wr.waitrequest
			host_wr_readdata                    => CONNECTED_TO_host_wr_readdata,                    --                      .readdata
			host_wr_readdatavalid               => CONNECTED_TO_host_wr_readdatavalid,               --                      .readdatavalid
			host_wr_burstcount                  => CONNECTED_TO_host_wr_burstcount,                  --                      .burstcount
			host_wr_writedata                   => CONNECTED_TO_host_wr_writedata,                   --                      .writedata
			host_wr_address                     => CONNECTED_TO_host_wr_address,                     --                      .address
			host_wr_write                       => CONNECTED_TO_host_wr_write,                       --                      .write
			host_wr_read                        => CONNECTED_TO_host_wr_read,                        --                      .read
			host_wr_byteenable                  => CONNECTED_TO_host_wr_byteenable,                  --                      .byteenable
			host_wr_debugaccess                 => CONNECTED_TO_host_wr_debugaccess,                 --                      .debugaccess
			global_reset_reset                  => CONNECTED_TO_global_reset_reset,                  --          global_reset.reset
			host_clk_clk                        => CONNECTED_TO_host_clk_clk,                        --              host_clk.clk
			kernel_clk_clk                      => CONNECTED_TO_kernel_clk_clk,                      --            kernel_clk.clk
			kernel_reset_reset                  => CONNECTED_TO_kernel_reset_reset,                  --          kernel_reset.reset
			null_dfh_afu_id_readdata            => CONNECTED_TO_null_dfh_afu_id_readdata,            --       null_dfh_afu_id.readdata
			null_dfh_afu_id_writedata           => CONNECTED_TO_null_dfh_afu_id_writedata,           --                      .writedata
			null_dfh_afu_id_address             => CONNECTED_TO_null_dfh_afu_id_address,             --                      .address
			null_dfh_afu_id_write               => CONNECTED_TO_null_dfh_afu_id_write,               --                      .write
			null_dfh_afu_id_read                => CONNECTED_TO_null_dfh_afu_id_read,                --                      .read
			ase_0_avmm_pipe_slave_waitrequest   => CONNECTED_TO_ase_0_avmm_pipe_slave_waitrequest,   -- ase_0_avmm_pipe_slave.waitrequest
			ase_0_avmm_pipe_slave_readdata      => CONNECTED_TO_ase_0_avmm_pipe_slave_readdata,      --                      .readdata
			ase_0_avmm_pipe_slave_readdatavalid => CONNECTED_TO_ase_0_avmm_pipe_slave_readdatavalid, --                      .readdatavalid
			ase_0_avmm_pipe_slave_burstcount    => CONNECTED_TO_ase_0_avmm_pipe_slave_burstcount,    --                      .burstcount
			ase_0_avmm_pipe_slave_writedata     => CONNECTED_TO_ase_0_avmm_pipe_slave_writedata,     --                      .writedata
			ase_0_avmm_pipe_slave_address       => CONNECTED_TO_ase_0_avmm_pipe_slave_address,       --                      .address
			ase_0_avmm_pipe_slave_write         => CONNECTED_TO_ase_0_avmm_pipe_slave_write,         --                      .write
			ase_0_avmm_pipe_slave_read          => CONNECTED_TO_ase_0_avmm_pipe_slave_read,          --                      .read
			ase_0_avmm_pipe_slave_byteenable    => CONNECTED_TO_ase_0_avmm_pipe_slave_byteenable,    --                      .byteenable
			ase_0_avmm_pipe_slave_debugaccess   => CONNECTED_TO_ase_0_avmm_pipe_slave_debugaccess,   --                      .debugaccess
			msgdma_bbb_0_csr_waitrequest        => CONNECTED_TO_msgdma_bbb_0_csr_waitrequest,        --      msgdma_bbb_0_csr.waitrequest
			msgdma_bbb_0_csr_readdata           => CONNECTED_TO_msgdma_bbb_0_csr_readdata,           --                      .readdata
			msgdma_bbb_0_csr_readdatavalid      => CONNECTED_TO_msgdma_bbb_0_csr_readdatavalid,      --                      .readdatavalid
			msgdma_bbb_0_csr_burstcount         => CONNECTED_TO_msgdma_bbb_0_csr_burstcount,         --                      .burstcount
			msgdma_bbb_0_csr_writedata          => CONNECTED_TO_msgdma_bbb_0_csr_writedata,          --                      .writedata
			msgdma_bbb_0_csr_address            => CONNECTED_TO_msgdma_bbb_0_csr_address,            --                      .address
			msgdma_bbb_0_csr_write              => CONNECTED_TO_msgdma_bbb_0_csr_write,              --                      .write
			msgdma_bbb_0_csr_read               => CONNECTED_TO_msgdma_bbb_0_csr_read,               --                      .read
			msgdma_bbb_0_csr_byteenable         => CONNECTED_TO_msgdma_bbb_0_csr_byteenable,         --                      .byteenable
			msgdma_bbb_0_csr_debugaccess        => CONNECTED_TO_msgdma_bbb_0_csr_debugaccess,        --                      .debugaccess
			msgdma_bbb_0_dma_irq_irq            => CONNECTED_TO_msgdma_bbb_0_dma_irq_irq,            --  msgdma_bbb_0_dma_irq.irq
			msgdma_bbb_1_csr_waitrequest        => CONNECTED_TO_msgdma_bbb_1_csr_waitrequest,        --      msgdma_bbb_1_csr.waitrequest
			msgdma_bbb_1_csr_readdata           => CONNECTED_TO_msgdma_bbb_1_csr_readdata,           --                      .readdata
			msgdma_bbb_1_csr_readdatavalid      => CONNECTED_TO_msgdma_bbb_1_csr_readdatavalid,      --                      .readdatavalid
			msgdma_bbb_1_csr_burstcount         => CONNECTED_TO_msgdma_bbb_1_csr_burstcount,         --                      .burstcount
			msgdma_bbb_1_csr_writedata          => CONNECTED_TO_msgdma_bbb_1_csr_writedata,          --                      .writedata
			msgdma_bbb_1_csr_address            => CONNECTED_TO_msgdma_bbb_1_csr_address,            --                      .address
			msgdma_bbb_1_csr_write              => CONNECTED_TO_msgdma_bbb_1_csr_write,              --                      .write
			msgdma_bbb_1_csr_read               => CONNECTED_TO_msgdma_bbb_1_csr_read,               --                      .read
			msgdma_bbb_1_csr_byteenable         => CONNECTED_TO_msgdma_bbb_1_csr_byteenable,         --                      .byteenable
			msgdma_bbb_1_csr_debugaccess        => CONNECTED_TO_msgdma_bbb_1_csr_debugaccess,        --                      .debugaccess
			msgdma_bbb_1_dma_irq_irq            => CONNECTED_TO_msgdma_bbb_1_dma_irq_irq             --  msgdma_bbb_1_dma_irq.irq
		);

