	component msgdma_bbb is
		port (
			clk_clk               : in  std_logic                      := 'X';             -- clk
			reset_reset_n         : in  std_logic                      := 'X';             -- reset_n
			csr_waitrequest       : out std_logic;                                         -- waitrequest
			csr_readdata          : out std_logic_vector(63 downto 0);                     -- readdata
			csr_readdatavalid     : out std_logic;                                         -- readdatavalid
			csr_burstcount        : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			csr_writedata         : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			csr_address           : in  std_logic_vector(6 downto 0)   := (others => 'X'); -- address
			csr_write             : in  std_logic                      := 'X';             -- write
			csr_read              : in  std_logic                      := 'X';             -- read
			csr_byteenable        : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			csr_debugaccess       : in  std_logic                      := 'X';             -- debugaccess
			dma_irq_irq           : out std_logic;                                         -- irq
			host_rd_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			host_rd_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			host_rd_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			host_rd_burstcount    : out std_logic_vector(2 downto 0);                      -- burstcount
			host_rd_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			host_rd_address       : out std_logic_vector(47 downto 0);                     -- address
			host_rd_write         : out std_logic;                                         -- write
			host_rd_read          : out std_logic;                                         -- read
			host_rd_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			host_rd_debugaccess   : out std_logic;                                         -- debugaccess
			host_wr_waitrequest   : in  std_logic                      := 'X';             -- waitrequest
			host_wr_readdata      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			host_wr_readdatavalid : in  std_logic                      := 'X';             -- readdatavalid
			host_wr_burstcount    : out std_logic_vector(2 downto 0);                      -- burstcount
			host_wr_writedata     : out std_logic_vector(511 downto 0);                    -- writedata
			host_wr_address       : out std_logic_vector(48 downto 0);                     -- address
			host_wr_write         : out std_logic;                                         -- write
			host_wr_read          : out std_logic;                                         -- read
			host_wr_byteenable    : out std_logic_vector(63 downto 0);                     -- byteenable
			host_wr_debugaccess   : out std_logic;                                         -- debugaccess
			mem_waitrequest       : in  std_logic                      := 'X';             -- waitrequest
			mem_readdata          : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			mem_readdatavalid     : in  std_logic                      := 'X';             -- readdatavalid
			mem_burstcount        : out std_logic_vector(2 downto 0);                      -- burstcount
			mem_writedata         : out std_logic_vector(511 downto 0);                    -- writedata
			mem_address           : out std_logic_vector(47 downto 0);                     -- address
			mem_write             : out std_logic;                                         -- write
			mem_read              : out std_logic;                                         -- read
			mem_byteenable        : out std_logic_vector(63 downto 0);                     -- byteenable
			mem_debugaccess       : out std_logic                                          -- debugaccess
		);
	end component msgdma_bbb;

	u0 : component msgdma_bbb
		port map (
			clk_clk               => CONNECTED_TO_clk_clk,               --     clk.clk
			reset_reset_n         => CONNECTED_TO_reset_reset_n,         --   reset.reset_n
			csr_waitrequest       => CONNECTED_TO_csr_waitrequest,       --     csr.waitrequest
			csr_readdata          => CONNECTED_TO_csr_readdata,          --        .readdata
			csr_readdatavalid     => CONNECTED_TO_csr_readdatavalid,     --        .readdatavalid
			csr_burstcount        => CONNECTED_TO_csr_burstcount,        --        .burstcount
			csr_writedata         => CONNECTED_TO_csr_writedata,         --        .writedata
			csr_address           => CONNECTED_TO_csr_address,           --        .address
			csr_write             => CONNECTED_TO_csr_write,             --        .write
			csr_read              => CONNECTED_TO_csr_read,              --        .read
			csr_byteenable        => CONNECTED_TO_csr_byteenable,        --        .byteenable
			csr_debugaccess       => CONNECTED_TO_csr_debugaccess,       --        .debugaccess
			dma_irq_irq           => CONNECTED_TO_dma_irq_irq,           -- dma_irq.irq
			host_rd_waitrequest   => CONNECTED_TO_host_rd_waitrequest,   -- host_rd.waitrequest
			host_rd_readdata      => CONNECTED_TO_host_rd_readdata,      --        .readdata
			host_rd_readdatavalid => CONNECTED_TO_host_rd_readdatavalid, --        .readdatavalid
			host_rd_burstcount    => CONNECTED_TO_host_rd_burstcount,    --        .burstcount
			host_rd_writedata     => CONNECTED_TO_host_rd_writedata,     --        .writedata
			host_rd_address       => CONNECTED_TO_host_rd_address,       --        .address
			host_rd_write         => CONNECTED_TO_host_rd_write,         --        .write
			host_rd_read          => CONNECTED_TO_host_rd_read,          --        .read
			host_rd_byteenable    => CONNECTED_TO_host_rd_byteenable,    --        .byteenable
			host_rd_debugaccess   => CONNECTED_TO_host_rd_debugaccess,   --        .debugaccess
			host_wr_waitrequest   => CONNECTED_TO_host_wr_waitrequest,   -- host_wr.waitrequest
			host_wr_readdata      => CONNECTED_TO_host_wr_readdata,      --        .readdata
			host_wr_readdatavalid => CONNECTED_TO_host_wr_readdatavalid, --        .readdatavalid
			host_wr_burstcount    => CONNECTED_TO_host_wr_burstcount,    --        .burstcount
			host_wr_writedata     => CONNECTED_TO_host_wr_writedata,     --        .writedata
			host_wr_address       => CONNECTED_TO_host_wr_address,       --        .address
			host_wr_write         => CONNECTED_TO_host_wr_write,         --        .write
			host_wr_read          => CONNECTED_TO_host_wr_read,          --        .read
			host_wr_byteenable    => CONNECTED_TO_host_wr_byteenable,    --        .byteenable
			host_wr_debugaccess   => CONNECTED_TO_host_wr_debugaccess,   --        .debugaccess
			mem_waitrequest       => CONNECTED_TO_mem_waitrequest,       --     mem.waitrequest
			mem_readdata          => CONNECTED_TO_mem_readdata,          --        .readdata
			mem_readdatavalid     => CONNECTED_TO_mem_readdatavalid,     --        .readdatavalid
			mem_burstcount        => CONNECTED_TO_mem_burstcount,        --        .burstcount
			mem_writedata         => CONNECTED_TO_mem_writedata,         --        .writedata
			mem_address           => CONNECTED_TO_mem_address,           --        .address
			mem_write             => CONNECTED_TO_mem_write,             --        .write
			mem_read              => CONNECTED_TO_mem_read,              --        .read
			mem_byteenable        => CONNECTED_TO_mem_byteenable,        --        .byteenable
			mem_debugaccess       => CONNECTED_TO_mem_debugaccess        --        .debugaccess
		);

