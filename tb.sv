
module top;

bit CLK, RESET;
	
dma_if dif(CLK, RESET);
	
Dma8237aTop DMT (dif);

// CLock
initial begin
forever #10  CLK = ~CLK; 
end

// Reset
initial begin
	repeat(50)@(negedge CLK); RESET = 1;
	repeat(100)@(negedge CLK); RESET = 0;
end

endmodule




