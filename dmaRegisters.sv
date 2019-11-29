`include "dmaRegPkg.svh"
module dmaRegisters(dma_if.DUT dif, clk, resetN);

import dmaRegPkg::*;

always_ff@(posedge clk) begin
if(resetN)
	currAddrReg[0] <= '0;
	currAddrReg[1] <= '0;
	currAddrReg[2] <= '0;
	currAddrReg[3] <= '0;

	currWordReg[0] <= '0;
	currWordReg[1] <= '0;
	currWordReg[2] <= '0;
	currWordReg[3] <= '0;

	baseAddrReg[0] <= '0;
	baseAddrReg[1] <= '0;
	baseAddrReg[2] <= '0;
	baseAddrReg[3] <= '0;

	baseWordReg[0] <= '0;
	baseWordReg[1] <= '0;
	baseWordReg[2] <= '0;
	baseWordReg[3] <= '0;

	modeReg[0]     <= '0;
	modeReg[1]     <= '0;
	modeReg[2]     <= '0;
	modeReg[3]     <= '0;

	commandReg     <= '0;
	requestReg     <= '0;
	maskReg	       <= '0;
	tempReg        <= '0;
	statusReg      <= '0;

else
	currAddrReg[0] <= currAddrReg[0];
	currAddrReg[1] <= currAddrReg[1];
	currAddrReg[2] <= currAddrReg[2];
	currAddrReg[3] <= currAddrReg[3];

	currWordReg[0] <= currWordReg[0];
	currWordReg[1] <= currWordReg[1];
	currWordReg[2] <= currWordReg[2];
	currWordReg[3] <= currWordReg[3];

	baseAddrReg[0] <= baseAddrReg[0];
	baseAddrReg[1] <= baseAddrReg[1];
	baseAddrReg[2] <= baseAddrReg[2];
	baseAddrReg[3] <= baseAddrReg[3];

	baseWordReg[0] <= baseWordReg[0];
	baseWordReg[1] <= baseWordReg[1];
	baseWordReg[2] <= baseWordReg[2];
	baseWordReg[3] <= baseWordReg[3];

	modeReg[0]     <= modeReg[0];
	modeReg[1]     <= modeReg[1];
	modeReg[2]     <= modeReg[2];
	modeReg[3]     <= modeReg[3];

	commandReg     <= commandReg;
	requestReg     <= requestReg;
	maskReg	       <= maskReg;
	tempReg        <= tempReg;
	statusReg      <= statusReg ;


// TODO: always_ff blocks for each registers

end












endmodule
