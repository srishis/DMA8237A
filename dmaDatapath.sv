
module dmaDatapath(dma_if.DUT dif, dmaControlIf cif);



// Data bus logic

// for DMA transfers between memory and I/O devices
// WRITE: make enIoAddrBuf = 1 from FSM in SI state
always_ff@(posedge dma_if.CLK) if(cif.enIoAddrBuf) cif.ioAddrBuf <= dif.DB;  // sample address from data bus DB into a IO Address Buffer state SI
// MEM READ: if(!dif.IOW_N && !dif.MEMR_N) make enMemRead = 1 in memory to memory transfers state
//always_ff@(posedge dma_if.CLK) if(cif.enMemRead) readDataBuf <= dif.DB;  // put incoming read data for memory to memory into READ buffer!
always_ff@(posedge dma_if.CLK) if(!dif.IOW_N && !dif.MEMR_N) readDataBuf <= dif.DB;  // put incoming read data for memory to memory into READ buffer!
// if(!dif.IOR_N && !dif.MEMW_N) make enDataOut = 1 & enMemWrite from FSM in memory to memory transfer states
//always_comb dif.DB = if(cif.enDataOut && cif.enMemWrite) ? writeDataBuf : 8'bz;  // write data from WRITE buffer on databus
always_comb dif.DB = if(!dif.IOR_N && !dif.MEMW_N) ? writeDataBuf : 8'bz;  // write data from WRITE buffer on databus


// IOR logic

// if (!IOR_N) => DMA is in I/O read mode and thus CPU can read the contents of Address Register, Status Register, Temporary and Word Count Reg.
always_comb dif.IOR_N = if(cif.enIoRead) ? 0 ? 1'bz; // access data from peripheral during DMA write transfer
//always_ff@(posedge dma_if.CLK)
//	if(!IOR_N) // @Srini: CPU can read control registers in program condition
//end


// IOW logic

// if (!IOW_N) => DMA is in I/O write mode and thus CPU can write to control registers like Address Register, Status Register, Temporary and Word Count Reg.
always_comb dif.IOW_N = if(cif.enIoWrite) ? 0 ? 1'bz; // load data to peripheral during DMA read transfer
//always_ff@(posedge dma_if.CLK) begin
//	if(!IOW_N) // @Srini: CPU can write to control registers in program condition
//end

// MEMR logic
always_comb dif.MEMR = if(cif.enMemRead) ? 0 : 1'bz;

// MEMW logic
always_comb dif.MEMW = if(cif.enMemWrite) ? 0 : 1'bz;

// Address Bus logic

always_ff@(posedge dma_if.CLK) if(cif.enRegAddr) cif.ioAddrBuf[3:0] <= dif.ADDR_L;  // address of register to be accessed by CPU in program condition

// make enAddrUp and enAddrLow from FSM when in state S1
always_comb dif.ADDR_U = if(cif.enAddrUp) ? cif.ioAddrBuf[7:4] : 4'bz;  // upper 4 bits of out put address of I/O device or memory to be targeted for transfer
always_comb dif.ADDR_L = if(cif.enAddrLow) ? cif.ioAddrBuf[3:0] : 4'bz; //  lower 4 bits of address output of I/O device or memory

// 8-bit output address
//always_ff@(posedge dma_if.CLK) if(enAddrOut) AddrOut <= {dif.ADDR_U, dif.ADDR_L};  // final output address of IO/memory device granted DMA access


// EOP logic
// pullup resistor logic
assign (pull1, pull0) dif.EOP_N = '1;
always@(cif.TC) if(cif.TC == 16'FFFF) cif.eop = 0; else cif.eop = 1;
always_comb dif.EOP_N = if(cif.checkEOP) ? cif.eop ; 1'bz;
//In States S1,S2,S3 and S4: if(!EOP_N) nextState = SI; else nextState = S1/S2/S3/S4;

// AEN & ADSTB functionality: @Janisha: make AEN in '1 in FSM state S1 and then back to zero using default value above unique case
always_ff@(negedge dma_if.CLK) if(dif.AEN) dif.ADSTB <= 1'b1; else dif.ADTSB <= 1'b0;


endmodule
