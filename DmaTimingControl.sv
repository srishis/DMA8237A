// DMA Timing Control module

module DmaTimingControl(dma_if.TC dif, DmaControlIf cif, commandReg, modeReg);

// registers as inputs from Data path
input logic [7:0] commandReg;
input logic [5:0] modeReg[4];
	
 // index for each state in the state register
 enum logic [2:0] {
  	iSI   = 0,
  	iS0   = 1,
  	iS1   = 2,
  	iS2   = 3,
  	iS3   = 4,
  	iS4   = 5
  } stateIndex;
  
  // declaration of fsm states onehot encoding
 enum logic [5:0] {
  	SI   = 6'b000001 << iSI, 
  	S0   = 6'b000001 << iS0, 
  	S1   = 6'b000001 << iS1, 
  	S2   = 6'b000001 << iS2, 
  	S3   = 6'b000001 << iS3, 
  	S4   = 6'b000001 << iS4 
  	} state, nextstate;
	
// IO Read logic
  always_comb dif.IOR_N = (dif.CS_N) ? cif.ior : 1'bz; // access data from peripheral during DMA write transfer

// IO Write logic

  always_comb dif.IOW_N = (dif.CS_N) ? cif.iow : 1'bz; // load data to peripheral during DMA read transfer

// MEM Read logic
  always_comb dif.MEMR_N = (dif.CS_N) ? cif.memr : 1'bz; // access data from peripheral during DMA write transfer

// MEM Write logic

  always_comb dif.MEMW_N = (dif.CS_N) ? cif.memw : 1'bz; // load data to peripheral during DMA read transfer

// EOP logic
  assign (pull0, pull1) dif.EOP_N = '1;   // pullup resistor logic
  always_comb dif.EOP_N = (dif.CS_N) ? cif.eop : 1'bz;

// AEN & ADSTB functionality
  always_comb dif.AEN <= cif.aen; 
  always_comb dif.ADSTB <= cif.adstb;  // when we make ADSTB = 1, MSB address from data lines DB is latched

// Initial state condition
always_ff @(posedge dma_if.CLK)    if(dma_if.RESET || !dif.CS_N)  state <= SI;
else		             			                  state <= nextstate;
   
// TODO: Try to remove HLDA for Program condition
// Program bit for DMA registers
always_comb begin
if(!dif.CS_N && !dif.HLDA)           cif.Program = 1; 
else if(dif.HLDA)		     cif.Program = 0;
end

// Write extend & Read or Write operation
always_comb begin
if(cif.checkWriteExtend)
	if (rif.commandReg[5] == 1'b1 && rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0)
	       cif.iow = 1'b0; 
	else   cif.iow = 1'b1;	       

else if(cif.checkWrite)
	if(rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0) 
		cif.iow = 1'b0; 
	else    cif.iow = 1'b1;
	
else if(cif.checkRead)
	if(rif.modeReg[0][3:2] == 2'b10 || rif.modeReg[1][3:2] == 2'b10 || rif.modeReg[2][3:2] == 2'b10 || rif.modeReg[3][3:2] == 2'b10 && rif.commandReg[0] == 1'b0)    			
		cif.ior = 1'b0;    
	else    cif.ior = 1'b1; 
end

// End of process by terminal count 
always_comb begin
if(cif.checkEOP )
	if(rif.statusReg[3:0]) cif.eop = 1'b0;  
	else		       cif.eop = 1'b1;
else			       cif.eop = 1'b1;
end

// Next state logic
always_comb begin   

        nextstate = state;      //default value for nextstate
              
        unique case(1'b1)       // reverse case       
            state[iSI] :
			begin
			if(cif.VALID_DREQ0 || cif.VALID_DREQ1 || cif.VALID_DREQ2 || cif.VALID_DREQ3) 	nextstate = S0;
			else  										nextstate = SI;
			end
			 
            state[iS0] :
			begin
			if(dif.HLDA) 									nextstate = S1;
			else if(!dif.HLDA) 								nextstate = S0;
			else if(!dif.EOP_N) 								nextstate = SI;
			end
			
            state[iS1] :
			begin
			if(!dif.EOP_N) 						        		nextstate = SI;
			else										nextstate = S2;
			end
			
            state[iS2] :  
                        begin
			if(!dif.EOP_N) 						          		nextstate = SI;
                        else					  		                        nextstate = S3;
                        end

            state[iS3] :
                        begin
			if(!dif.EOP_N) 						        		nextstate = SI;
			else										nextstate = S4;
                        end 
			
            state[iS4] :										nextstate = SI;
 
														
        endcase
end
	  
// Output logic
always_comb begin 

// default values for control outputs
{cif.aen, cif.adstb, cif.checkEOP, cif.checkRead, cif.checkWrite, cif.checkWriteExtend} = 8'b000000;  
{cif.ldCurrAddrTemp, cif.ldCurrWordTemp, cif.ldTempCurrAddr, cif.ldTempCurrWord, cif.enCurrAddr} = 5'b00000; 
cif.validDACK = 1'b0;    		 

    unique case(1'b1)  // reverse case

	    state[iSI]: begin  cif.hrq = 1'b0;  end

	    state[iS0]: begin  cif.hrq = 1'b1; end
				
	    state[iS1]: begin  cif.aen = 1'b1; cif.adstb = 1'b1; cif.validDACK = 1'b1; cif.enCurrAddr = 1'b1; cif.ldCurrAddrTemp= 1'b1; cif.ldCurrWordTemp = 1'b1; cif.hrq = 1'b1; end
        
	    state[iS2]: begin  cif.aen = 1'b1; cif.adstb = 1'b0; cif.checkRead = 1'b1; cif.hrq = 1'b1; cif.checkWriteExtend = 1'b1; cif.enCurrAddr = 1'b0; cif.ldCurrAddrTemp= 1'b0; cif.ldCurrWordTemp = 1'b0; cif.ldTempCurrAddr= 1'b1; cif.ldTempCurrWord = 1'b1; end
				

	    state[iS3]: begin cif.aen = 1'b1; cif.checkWrite = 1'b1; cif.hrq = 1'b1; end
		
	    state[iS4]: begin  cif.ldTempCurrAddr= 1'b0; cif.ldTempCurrWord = 1'b0; cif.validDACK = 1'b0;
			       cif.checkEOP = 1'b1; {cif.hrq, cif.aen} = 2'b00;
			end
					
    endcase
end
				 
endmodule

