//`include "DmaPackage.svh"
module DmaTimingControl(dma_if.DUT dif, DmaControlIf cif, DmaDatapathIf.FSM rif);

//import DmaPackage::*; 
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
	
// Initial state condition
always_ff @(posedge dma_if.CLK) if(dma_if.RESET)  state <= SI;
else		             			  state <= nextstate;
   
// Program condition
always_comb begin
if(!dif.CS_N && !dif.HLDA) cif.Program = 1; 
else if(dif.HLDA)			  cif.Program = 0;
end

// Write extend
always_comb begin
if(cif.checkWriteExtend)
	if (rif.commandReg[5] == 1'b1 && rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0)
	       cif.writeExtend = 1'b1; //fsm read and extended write next state
	else   cif.writeExtend = 1'b0;
else	       cif.writeExtend = 1'b0;
end

// Read or Write operation
always_comb begin
	if(cif.checkWrite)
	if(rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0) 
		cif.iow = 1'b0; 
	else    cif.iow = 1'b1
	else if(cif.checkRead)
		if(rif.modeReg[0][3:2] == 2'b10 || rif.modeReg[1][3:2] == 2'b10 || rif.modeReg[2][3:2] == 2'b10 || rif.modeReg[3][3:2] == 2'b10 && rif.commandReg[0] == 1'b0)    			
		cif.ior = 1'b0;    
		else cif.ior = 1'b1; 
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
{cif.aen, cif.adstb, cif.Program, cif.ACTIVE_CYCLE, cif.IDLE_CYCLE, cif.checkEOP, cif.checkReadWrite, cif.checkWriteExtend} = 8'b00000000;  
{cif.ldCurrAddrTemp, cif.ldCurrWordTemp, cif.ldTempCurrAddr, cif.ldTempCurrWord, cif.enCurrAddr} = 6'b000000; 
{cif.validDACK,  cif.writeExtend} = 2'b00;    		 

    unique case(1'b1)  // reverse case

	    state[iSI]: begin cif.IDLE_CYCLE = 1'b1; cif.hrq = 1'b0;  end

	    state[iS0]: begin  cif.hrq = 1'b1; end
				
	    state[iS1]: begin cif.ACTIVE_CYCLE = 1'b1; cif.aen = 1'b1; cif.adstb = 1'b1; cif.validDACK = 1'b1; cif.enCurrAddr = 1'b1; cif.ldCurrAddrTemp= 1'b1; cif.ldCurrWordTemp = 1'b1; cif.hrq = 1'b1; end
        
	    state[iS2]: begin  cif.aen = 1'b1; cif.adstb = 1'b0; cif.checkRead = 1'b1; cif.hrq = 1'b1; cif.checkWriteExtend = 1'b1; cif.enCurrAddr = 1'b0; cif.ldCurrAddrTemp= 1'b0; cif.ldCurrWordTemp = 1'b0; cif.ldTempCurrAddr= 1'b1; cif.ldTempCurrWord = 1'b1; end
				

	    state[iS3]: begin cif.aen = 1'b1; cif.checkWrite = 1'b1; cif.hrq = 1'b1; end
		
	    state[iS4]: begin  cif.ldTempCurrAddr= 1'b0; cif.ldTempCurrWord = 1'b0; cif.validDACK = 1'b0;
			       cif.checkEOP = 1'b1; {cif.hrq, cif.aen} = 2'b00;
			end
					
    endcase
end
				 
endmodule		
