module dmaRegisters(dma_if.DUT dif, dmaRegIf drf);


always_ff@(posedge drf.CLK) begin
if(drf.RESET)
	drf.currAddrReg[0] <= '0;
	drf.currAddrReg[1] <= '0;
	drf.currAddrReg[2] <= '0;
	drf.currAddrReg[3] <= '0;

	drf.currWordReg[0] <= '0;
	drf.currWordReg[1] <= '0;
	drf.currWordReg[2] <= '0;
	drf.currWordReg[3] <= '0;

	drf.baseAddrReg[0] <= '0;
	drf.baseAddrReg[1] <= '0;
	drf.baseAddrReg[2] <= '0;
	drf.baseAddrReg[3] <= '0;

	drf.baseWordReg[0] <= '0;
	drf.baseWordReg[1] <= '0;
	drf.baseWordReg[2] <= '0;
	drf.baseWordReg[3] <= '0;

	drf.modeReg[0]     <= '0;
	drf.modeReg[1]     <= '0;
	drf.modeReg[2]     <= '0;
	drf.modeReg[3]     <= '0;

	drf.commandReg     <= '0;
	drf.requestReg     <= '0;
	drf.maskReg	       <= '0;
	drf.tempReg        <= '0;
	drf.statusReg      <= '0;

else
	drf.currAddrReg[0] <= drf.currAddrReg[0];
	drf.currAddrReg[1] <= drf.currAddrReg[1];
	drf.currAddrReg[2] <= drf.currAddrReg[2];
	drf.currAddrReg[3] <= drf.currAddrReg[3];

	drf.currWordReg[0] <= drf.currWordReg[0];
	drf.currWordReg[1] <= drf.currWordReg[1];
	drf.currWordReg[2] <= drf.currWordReg[2];
	drf.currWordReg[3] <= drf.currWordReg[3];

	drf.baseAddrReg[0] <= drf.baseAddrReg[0];
	drf.baseAddrReg[1] <= drf.baseAddrReg[1];
	drf.baseAddrReg[2] <= drf.baseAddrReg[2];
	drf.baseAddrReg[3] <= drf.baseAddrReg[3];

	drf.baseWordReg[0] <= drf.baseWordReg[0];
	drf.baseWordReg[1] <= drf.baseWordReg[1];
	drf.baseWordReg[2] <= drf.baseWordReg[2];
	drf.baseWordReg[3] <= drf.baseWordReg[3];

	drf.modeReg[0]     <= drf.modeReg[0];
	drf.modeReg[1]     <= drf.modeReg[1];
	drf.modeReg[2]     <= drf.modeReg[2];
	drf.modeReg[3]     <= drf.modeReg[3];

	drf.commandReg     <= drf.commandReg;
	drf.requestReg     <= drf.requestReg;
	drf.maskReg	       <= drf.maskReg;
	drf.tempReg        <= drf.tempReg;
	drf.statusReg      <= drf.statusReg;


// TODO: always_ff blocks for each registers

end












endmodule
