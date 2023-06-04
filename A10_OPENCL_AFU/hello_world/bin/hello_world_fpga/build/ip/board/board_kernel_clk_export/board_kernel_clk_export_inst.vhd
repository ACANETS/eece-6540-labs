	component board_kernel_clk_export is
		port (
			in_clk      : in  std_logic := 'X'; -- clk
			reset_n     : in  std_logic := 'X'; -- reset_n
			clk_out     : out std_logic;        -- clk
			reset_n_out : out std_logic         -- reset_n
		);
	end component board_kernel_clk_export;

	u0 : component board_kernel_clk_export
		port map (
			in_clk      => CONNECTED_TO_in_clk,      --       clk_in.clk
			reset_n     => CONNECTED_TO_reset_n,     -- clk_in_reset.reset_n
			clk_out     => CONNECTED_TO_clk_out,     --          clk.clk
			reset_n_out => CONNECTED_TO_reset_n_out  --    clk_reset.reset_n
		);

