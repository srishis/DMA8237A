// DMA Top module

module Dma8237aTop(dma_if.DUT dif, input logic CLK, RESET);

// DMA interfaces instantiation
DmaDatapathIf dp_if(CLK ,RESET);
DmaControlIf cp_if(CLK ,RESET);
	
// DMA modules instantiation
DmaDatapath D1(dp_if.DP, cp_if);
DmaTimingControl C1(dif.TC, cp_if, dp_if.FSM);
DmaRegisters R1(dif.REG, dp_if.REG, cp_if);
DmaPriority P1(dif.PR, dp_if.PRIORITY);

endmodule
