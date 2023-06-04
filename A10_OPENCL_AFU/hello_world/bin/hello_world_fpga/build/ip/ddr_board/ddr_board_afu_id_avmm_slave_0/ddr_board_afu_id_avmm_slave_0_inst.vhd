	component ddr_board_afu_id_avmm_slave_0 is
		port (
			clk            : in  std_logic                     := 'X';             -- clk
			reset          : in  std_logic                     := 'X';             -- reset
			avmm_readdata  : out std_logic_vector(63 downto 0);                    -- readdata
			avmm_writedata : in  std_logic_vector(63 downto 0) := (others => 'X'); -- writedata
			avmm_address   : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			avmm_write     : in  std_logic                     := 'X';             -- write
			avmm_read      : in  std_logic                     := 'X'              -- read
		);
	end component ddr_board_afu_id_avmm_slave_0;

	u0 : component ddr_board_afu_id_avmm_slave_0
		port map (
			clk            => CONNECTED_TO_clk,            --         clock.clk
			reset          => CONNECTED_TO_reset,          --         reset.reset
			avmm_readdata  => CONNECTED_TO_avmm_readdata,  -- afu_cfg_slave.readdata
			avmm_writedata => CONNECTED_TO_avmm_writedata, --              .writedata
			avmm_address   => CONNECTED_TO_avmm_address,   --              .address
			avmm_write     => CONNECTED_TO_avmm_write,     --              .write
			avmm_read      => CONNECTED_TO_avmm_read       --              .read
		);

