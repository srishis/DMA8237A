
module DmaDatapath(dma_if.DUT dif, DmaControlIf cif, DmaDatapathIf.DATAPATH dpf);

//import DmaPackage::*;

// Data bus logic

// Databus DB as input 
always_ff@(posedge dma_if.CLK) if(IDLE_CYCLE && !dif.IOW_N) dpf.ioDataBuf <= dif.DB;  // @Srini: CPU send register programming during IO Write in IDLE_CYCLE 

// Databus DB as output 
always_comb dif.DB = (IDLE_CYCLE && ~dif.IOR_N) ? dpf.ioDataBuf : 8'bz;  // @Srini: CPU reads data from registers so write data from registers to be driven on DB lines in ioDataBuf

// IO Read logic

always_comb dif.IOR_N = (ACTIVE_CYCLE) ? cif.ior : 1'bz; // access data from peripheral during DMA write transfer

// IO Write logic

always_comb dif.IOW_N = (ACTIVE_CYCLE) ? cif.iow : 1'bz; // load data to peripheral during DMA read transfer

//// MEM Read logic
//always_comb dif.MEMR_N = if(ACTIVE_CYCLE && READ) ? cif.memr : 1'bz;
//
//// MEM Write logic
//always_comb dif.MEMW_N = if(ACTIVE_CYCLE && WRITE) ? cif.memw : 1'bz;


// EOP logic
// pullup resistor logic
assign (pull0, pull1) dif.EOP_N = '1;
// @Janisha: add Autoinitalize logic for TC.and put in state S4
//always@(cif.TC) if(cif.TC == 16'FFFF) cif.eop = 0; else cif.eop = 1;
always_comb dif.EOP_N = (ACTIVE_CYCLE) ? cif.eop : 1'bz;

// AEN & ADSTB functionality: @Janisha: make cif.aen and cif.adstb '1 in FSM state S1 and make cif.aen 0 in SI state and cif.adstb 0 in S2 state 
always_comb dif.AEN <= cif.aen; 
always_comb dif.ADSTB <= cif.adstb;  // when we make ADSTB = 1, MSB address from data lines DB is latched 
//always_ff@(negedge dif.ADSTB) cif.ioDataBuf <= dif.DB; 

// Address Bus logic

always_ff@(posedge dma_if.CLK) if(IDLE_CYCLE) dpf.ioAddrBuf <= dif.ADDR_L;  // @Srini: ioAddrBuf holds the read address of the register to be accessed by CPU in program condition
always_comb dif.ADDR_U = (ACTIVE_CYCLE) ? dpf.outAddrBuf : 4'bz;  // @Srini: write to outAddrBuf upper 4 bits of output address from TEMP ADDRESS REGISTER and this register gets the address from dif.DB lines 
always_comb dif.ADDR_L = (ACTIVE_CYCLE) ? dpf.ioAddrBuf : 4'bz;   //  @Srini: write to ioAddrBuf lower 4 bits of address output from TEMP ADDRESS REGISTER and this register gets the address from dif.DB lines



endmodule
