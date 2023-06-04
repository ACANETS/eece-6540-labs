	component msgdma_bbb_magic_number_rom_0 is
		generic (
			MAGIC_NUMBER_LOW  : integer := 1400467043;
			MAGIC_NUMBER_HIGH : integer := 1467118687
		);
		port (
			clk           : in  std_logic                      := 'X';             -- clk
			reset         : in  std_logic                      := 'X';             -- reset
			address       : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- address
			burst         : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- burstcount
			read          : in  std_logic                      := 'X';             -- read
			readdata      : out std_logic_vector(511 downto 0);                    -- readdata
			waitrequest   : out std_logic;                                         -- waitrequest
			readdatavalid : out std_logic                                          -- readdatavalid
		);
	end component msgdma_bbb_magic_number_rom_0;

	u0 : component msgdma_bbb_magic_number_rom_0
		generic map (
			MAGIC_NUMBER_LOW  => INTEGER_VALUE_FOR_MAGIC_NUMBER_LOW,
			MAGIC_NUMBER_HIGH => INTEGER_VALUE_FOR_MAGIC_NUMBER_HIGH
		)
		port map (
			clk           => CONNECTED_TO_clk,           --   clk.clk
			reset         => CONNECTED_TO_reset,         -- reset.reset
			address       => CONNECTED_TO_address,       -- slave.address
			burst         => CONNECTED_TO_burst,         --      .burstcount
			read          => CONNECTED_TO_read,          --      .read
			readdata      => CONNECTED_TO_readdata,      --      .readdata
			waitrequest   => CONNECTED_TO_waitrequest,   --      .waitrequest
			readdatavalid => CONNECTED_TO_readdatavalid  --      .readdatavalid
		);

