	component board_irq_ctrl_0 is
		port (
			IrqRead_i         : in  std_logic                     := 'X';             -- read
			IrqReadData_o     : out std_logic_vector(31 downto 0);                    -- readdata
			MaskWrite_i       : in  std_logic                     := 'X';             -- write
			MaskWritedata_i   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			MaskByteenable_i  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			MaskRead_i        : in  std_logic                     := 'X';             -- read
			MaskReaddata_o    : out std_logic_vector(31 downto 0);                    -- readdata
			MaskWaitrequest_o : out std_logic;                                        -- waitrequest
			Clk_i             : in  std_logic                     := 'X';             -- clk
			Rstn_i            : in  std_logic                     := 'X';             -- reset_n
			Irq_i             : in  std_logic_vector(31 downto 0) := (others => 'X'); -- irq
			Irq_o             : out std_logic                                         -- irq
		);
	end component board_irq_ctrl_0;

	u0 : component board_irq_ctrl_0
		port map (
			IrqRead_i         => CONNECTED_TO_IrqRead_i,         --     IRQ_Read_Slave.read
			IrqReadData_o     => CONNECTED_TO_IrqReadData_o,     --                   .readdata
			MaskWrite_i       => CONNECTED_TO_MaskWrite_i,       --     IRQ_Mask_Slave.write
			MaskWritedata_i   => CONNECTED_TO_MaskWritedata_i,   --                   .writedata
			MaskByteenable_i  => CONNECTED_TO_MaskByteenable_i,  --                   .byteenable
			MaskRead_i        => CONNECTED_TO_MaskRead_i,        --                   .read
			MaskReaddata_o    => CONNECTED_TO_MaskReaddata_o,    --                   .readdata
			MaskWaitrequest_o => CONNECTED_TO_MaskWaitrequest_o, --                   .waitrequest
			Clk_i             => CONNECTED_TO_Clk_i,             --              Clock.clk
			Rstn_i            => CONNECTED_TO_Rstn_i,            --             Resetn.reset_n
			Irq_i             => CONNECTED_TO_Irq_i,             -- interrupt_receiver.irq
			Irq_o             => CONNECTED_TO_Irq_o              --   interrupt_sender.irq
		);

