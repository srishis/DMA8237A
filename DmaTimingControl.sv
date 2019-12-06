// DMA Timing Contol Module 


module DmaTimingControl(dma_if.TC dif, DmaControlIf.TC cif,  DmaRegIf.TC rif);
	
// FSM control outputs
logic eop;		
logic aen;		
logic adstb;		
logic ior;		
logic iow;
logic memr;		
logic memw;	
logic hrq;
logic checkWriteExtend;
logic checkEOP;
logic checkRead;
logic checkWrite;
logic ldCurrAddrTemp; 
logic ldCurrWordTemp; 
logic enCurrAddr; 
logic ldTempCurrAddr; 
logic ldTempCurrWord; 


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

	
// Reset condition
always_ff@(posedge dif.CLK) begin
  if(dif.RESET) begin
  	dif.AEN    <= '0;
  	dif.ADSTB  <= '0;
  end
  else begin
// AEN & ADSTB functionality
  	dif.AEN    <= aen;
  	dif.ADSTB  <= adstb;
  end
end

// IO Read logic
  assign dif.IOR_N = (dif.HLDA) ? ior : 1'bz;       // access data from peripheral during DMA write transfer

// IO Write logic
  assign dif.IOW_N = (dif.HLDA) ? iow : 1'bz;       // load data to peripheral during DMA read transfer
	
// MEM Read logic
  assign  dif.MEMR_N = (dif.HLDA) ? memr : 1'bz;   // access data from peripheral during DMA write transfer
	
// MEM Write logic
  assign dif.MEMW_N = (dif.HLDA) ? memw : 1'bz;   // load data to peripheral during DMA read transfer
	
// EOP logic
  assign (pull0, pull1) dif.EOP_N = '1;   // pullup resistor logic
  assign dif.EOP_N = (dif.HLDA) ? eop : 1'bz;

// Initial FSM state condition
always_ff @(posedge dif.CLK)    if(dif.RESET || !dif.CS_N)  state <= SI;
else		             			            state <= nextstate;
   

// Program condition for DMA registers
always_comb begin
if(!dif.CS_N && !dif.HLDA)      cif.Program = 1; 
else if(dif.HLDA)               cif.Program = 0;
end

// Write extend & Read or Write operation
always_comb begin
if(checkWriteExtend)
	if (rif.commandReg[5] == 1'b1 && rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0)
		begin memw = 1'b0; ior = 1'b0; end   
	else    begin memw = 1'b1; ior = 1'b1; end   

else if(checkWrite)
	if(rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0) 
		begin memw = 1'b0; ior = 1'b0; end   
	else    begin memw = 1'b1; ior = 1'b1; end   
	
else if(checkRead)
	if(rif.modeReg[0][3:2] == 2'b10 || rif.modeReg[1][3:2] == 2'b10 || rif.modeReg[2][3:2] == 2'b10 || rif.modeReg[3][3:2] == 2'b10 && rif.commandReg[0] == 1'b0)    			
		begin memr = 1'b0; iow = 1'b0; end   
	else    begin memr = 1'b1; iow = 1'b1; end   
end

// End of process on terminal count 
always_comb begin
if(checkEOP && rif.statusReg[3:0]) eop = 1'b0;  
else		                   eop = 1'b1;
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

// default values for FSM control outputs
{aen, adstb, checkEOP, checkRead, checkWrite, checkWriteExtend} = 6'b000000;  
{cif.ldCurrAddrTemp, cif.ldCurrWordTemp, cif.ldTempCurrAddr, cif.ldTempCurrWord, cif.enCurrAddr, cif.validDACK} = 6'b000000;   		 

    unique case(1'b1)  // reverse case

	    state[iSI]: begin  cif.hrq = 1'b0;  end

	    state[iS0]: begin  cif.hrq = 1'b1; end
				
	    state[iS1]: begin  aen = 1'b1; adstb = 1'b1; cif.validDACK = 1'b1; cif.enCurrAddr = 1'b1; cif.ldCurrAddrTemp= 1'b1; cif.ldCurrWordTemp = 1'b1; cif.hrq = 1'b1; end
        
	    state[iS2]: begin  aen = 1'b1; adstb = 1'b0; checkRead = 1'b1; cif.hrq = 1'b1; checkWriteExtend = 1'b1; cif.enCurrAddr = 1'b0; cif.ldCurrAddrTemp= 1'b0; cif.ldCurrWordTemp = 1'b0; cif.ldTempCurrAddr= 1'b1; cif.ldTempCurrWord = 1'b1; end
				

	    state[iS3]: begin aen = 1'b1; checkWrite = 1'b1; cif.hrq = 1'b1; end
		
	    state[iS4]: begin  cif.ldTempCurrAddr= 1'b0; cif.ldTempCurrWord = 1'b0; cif.validDACK = 1'b0;
			       checkEOP = 1'b1; {cif.hrq, aen} = 2'b00;
			end
					
    endcase
end
				 
endmodule
