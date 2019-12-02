module dmaTimingControl(dma_if.DUT dif, dmaControlIf cif);
//input logic CLK ,RESET , ready , CS_N , HLDA ,
//input logic [7:0] commandReg, statusReg,modeReg,
//input logic [3:0] validDREQ,
//input logic EOP_N, //external cif.eop
//output logic  cif.hrq ,validDACK,state //for debuging
//output logic cif.eop,cif.aen,adstb,cif.ior,cif.iow,cif.memr,cif.memw, ACTIVE_CYCLE,IDLE_CYCLE,READ,WRITE, //signals Rushi
//output logic Program,enBaseAddr,enBaseWord,enCurrAddr,ldTempCurrAddr,enCurrWord,ldTempCurrWord,ldCurrAddrTemp,ldCurrWordTemp,decr,enModeReg,enCommandReg,enRequestReg,enMaskReg,enStatusReg);//signals by srini
//there is major doubt in load signals and also in decr srini pls confirm 

//enum logic [6:0] {iSI,iS0,iS1,iS2,iS3,iS4} state , nextstate ;
always_ff @(posedge dif.CLK)
   begin
 if (!dif.RESET)
    state <= SI;
 else
	state <= nextstate ;
   end 
   
always_comb begin  // set nextstate 
           nextstate = state; //default condition
              
        unique case(1'b1) // reverse case       
            state[iSI] :
				begin
				if(VALID_DREQ0 || VALID_DREQ1 || VALID_DREQ2 || VALID_DREQ3) 	nextstate = S0;
				else if(!dif.EOP_N) 						nextstate = SI;
				end
				 
            state[iS0] :
				begin
				if(dif.HLDA) 							nextstate = S1;
				else if(!dif.EOP_N) 						nextstate = SI;
				end
				
            state[iS1] : 
				begin
				if(!dif.EOP_N) 						        nextstate = SI;
				else								nextstate = S2;
				end
				
            state[iS2] :          
                                begin
				if(!dif.EOP_N) 						        nextstate = SI;
				else								nextstate = S2;
                                end

            state[iS3] :
                                begin
				if(!dif.EOP_N) 						        nextstate = SI;
				else								nextstate = S2;
                                end 
				
            state[iS4]:										nextstate = SI;
 
														
 endcase
end
	  
always_comb 
begin  // set outputs in each state  
{cif.eop, cif.hrq, cif.Program, ACTIVE_CYCLE, IDLE_CYCLE, cif.iow, cif.ior, cif.memr, cif.memw, READ, WRITE} = 11'b10000111100;  
//{enBaseAddr,enBaseWord,enCurrAddr,ldTempCurrAddr,enCurrWord,ldTempCurrWord,ldCurrAddrTemp,ldCurrWordTemp,decr,enModeReg,enCommandReg,enRequestReg,enMaskReg,enStatusReg} =14'b00000000000000;    		 
    unique case(state)

	    state[iSI]:
			begin  
			IDLE_CYCLE = 1'b1;
			if(VALID_DREQ0 || VALID_DREQ1 || VALID_DREQ2 || VALID_DREQ3) 	cif.hrq = 1'b1;
			else              						cif.hrq = 1'b0;
			
			if(VALID_DREQ0)      CH0_SEL = 1'b1;
			else if(VALID_DREQ1) CH1_SEL = 1'b1;
			else if(VALID_DREQ2) CH2_SEL = 1'b1;
			else if(VALID_DREQ3) CH3_SEL = 1'b1;
			else {CH0_SEL, CH1_SEL, CH2_SEL, CH3_SEL} = '0;

			if (!dif.CS_N && !dif.HLDA) cif.Program = 1'b1;
			else                        cif.Program = 1'b0;
				  //{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b11111111111;
			//else 
			//    begin
			//        cif.Program = 1'b0;
			//	//{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b00000000000;
			//	end
			end
				
        state[iS0]:  
			begin  
			if(!dif.HLDA) begin cif.Program = 1'b1; IDLE_CYCLE = 1'b1; end
			else          begin cif.Program = 1'b0; IDLE_CYCLE = 1'b0; ACTIVE_CYCLE = 1'b1; end
			//{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b11111111111;
			//{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b00000000000;
			//end
		        end
				
        state[iS1]: 
			begin 
			cif.aen = 1'b1;
			cif.adstb = 1'b1;
			if(CH0_SEL == 1'b1)           cif.VALID_DACK0 = 1'b1; 
			else if(CH1_SEL == 1'b1)      cif.VALID_DACK0 = 1'b1; 
			else if(CH2_SEL == 1'b1)      cif.VALID_DACK0 = 1'b1; 
			else if(CH3_SEL == 1'b1)      cif.VALID_DACK0 = 1'b1; 
			cif.ldTempCurrAddr = 1'b1;  
			cif.ldTempCurrWord = 1'b1; //loading the address register on the temporary registers
			end

        state[iS2]:
			begin 
			cif.adstb = 1'b0;
			if (modeReg[3:2] == 2'b01 && commandReg[0] == 1'b0 && commandReg[5] == 1'b1)     //memory to memory disabled and extended write only in iS2 otherwise write in iS3
                        begin cif.iow = 1'b0; WRITE = 1'b1; end
			else if (modeReg[3:2] == 2'b10 && commandReg[0] == 1'b0)                         //memory to memory disabled 
                        begin cif.ior = 1'b0; READ = 1'b1; end

			// MEMORY TRANFERS
			//else if (modeReg[3:2] == 2'b01 && commandReg[0] == 1'b1 &&  commandReg[5] == 1'b1)//memory to memory enabled
                        //begin cif.memw = 1'b0; WRITE = 1'b1; end
			//else if (modeReg[3:2] == 2'b10 && commandReg[0] == 1'b1)
                        //begin cif.memr = 1'b0; READ = 1'b1; end
					
	state[iS3]:
			begin
			if (modeReg[3:2] == 2'b01 && commandReg[0] == 1'b0)     //memory to memory disabled and extended write only in iS2 otherwise write in iS3
                        begin cif.iow = 1'b0; WRITE = 1'b1; end
			//else if (modeReg[3:2] == 2'b01 && commandReg[0] == 1'b1 &&  commandReg[5] == 1'b1)//memory to memory enabled
                        //begin cif.memw = 1'b0; WRITE = 1'b1; end
				                 
        state[iS4]:  
			begin 
			cif.ldCurrAdderTemp = 1'b1; //TODO
			//cif.decr = 1'b0;
			//cif.validDACK = 1'b0;
			if(CH0_SEL == 1'b1)           cif.VALID_DACK0 = 1'b0; 
			else if(CH1_SEL == 1'b1)      cif.VALID_DACK1 = 1'b0; 
			else if(CH2_SEL == 1'b1)      cif.VALID_DACK2 = 1'b0; 
			else if(CH3_SEL == 1'b1)      cif.VALID_DACK3 = 1'b0; 

			//if(CH0_SEL == 1'b1)           cif.VALID_DREQ0 = 1'b0; 
			//else if(CH1_SEL == 1'b1)      cif.VALID_DREQ1 = 1'b0; 
			//else if(CH2_SEL == 1'b1)      cif.VALID_DREQ2 = 1'b0; 
			//else if(CH3_SEL == 1'b1)      cif.VALID_DREQ3 = 1'b0; 

			{cif.hrq, cif.aen, cif.ior, cif.iow, cif.memr, cif.memw} = 6'b001111; // deasserting signals 

			if(statusReg[3:0] == 4'b0) cif.eop = 1;

			if((validDREQ[0] && statusReg[0] && !commandReg[6]) || (!validDREQ[0] && commandReg[6] && statusReg[0])) //checking active dreq and its corresponding TC for EOP_N generation
				cif.eop = 1;                       // DREQ might go low by this time so we might not get the correct DREQ
			else if((validDREQ[1] && statusReg[1] && !commandReg[6]) || (!validDREQ[1] && statusReg[1] && commandReg[6]))
			        cif.eop = 1;
			else if((validDREQ[2] && statusReg[2] && !commandReg[6]) || (!validDREQ[2] && statusReg[2] && commandReg[6]))
			        cif.eop = 1;
			else if((validDREQ[3] && statusReg[3] && !commandReg[6]) || (!validDREQ[3] && statusReg[3] && commandReg[6]))
			        cif.eop = 1;
			else 
				cif.eop = 0;
			end
      
			endcase
                        end
				 
endmodule		
