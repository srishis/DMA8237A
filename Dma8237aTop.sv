// DMA Top module

`timescale 100ns/10ns
module Dma8237aTop(dma_if dif, input logic CLK, RESET);

parameter CLK_PERIOD = 200;
parameter CLK_CYCLES = 20;

// DMA modules instantiation
DmaDatapath D1(dif, CLK, RESET);
DmaTimingControl C1(dif, CLK, RESET);
DmaRegisters R1(dif, CLK, RESET);
DmaPriority P1(dif, CLK, RESET);

// 5 MHz Clock generation 
initial begin
	CLK = 0;
	forever #(CLK_PERIOD) CLK = ~CLK;
end


endmodule
