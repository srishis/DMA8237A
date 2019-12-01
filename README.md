module DMA_FSM;
input logic CLK ,RESET , ready , CS_N , HLDA ;
input logic [7:0] commandReg, statusReg,modeReg;
input logic [3:0] validDREQ ;
input logic EOP; //external eop
output logic  HRQ ,validDACK;
output logic eop,aen,adstb,ior,iow,memr,memw, ACTIVE_CYCLE,IDLE_CYCLE,READ,WRITE; //signals Rushi
output logic enBaseAddr,enBaseWord,enCurrAddr,ldTempCurrAddr,enCurrWord,ldTempCurrWord,ldCurrAddrTemp,ldCurrWordTemp,decr,enModeReg,enCommandReg,enRequestReg,enMaskReg,enStatusReg;//signals by srini
//there is major doubt in load signals and also in decr srini pls confirm 
enum logic [6:0] {SI,S0,S1,S2,S3,S4} state , nextstate ;
always_ff (posedge CLK)
   begin
 if (!RESET)
    state <= SI;
 else
	state <= nextstate ;
   end 
   
always_comb begin : set nextstate 
           nextstate = state; //default condition
              
        unique case(state)       
            state[SI] :
				begin
				 if(validDREQ && ~commandReg[6] || ~validDREQ && commandReg[6]) //DREQ polarity included
					 nextstate = S0;
				 elseif(~EOP)
				     nextstate = SI;
				 else
					 nextstate = SI;
				 end 
				 
            state[S0] :
				begin
				if (HLDA)
					 nextstate = S1;
				 elseif(~EOP)
					 nextstate = SI;
			        else
                                         nextstate = S0;
				end 
				
            state[S1] : 
				begin
				if(!EOP)
					nextstate = SI;
				else
					nextstate = S2;
				end
				
            state[S2] : 
				if(!EOP)
					nextstate = SI;
				else
					nextstate = S3;
				end

            state[S3] :
				if(!EOP)
		                        nextstate = SI;
				else 
					nextstate = S4;
				
            state[S4]: 
					nextstate = SI; //do i need to include a condition for  internal eop ? as next state is anyways SI with or without eop
			end
 endcase
	  
always_comb begin   // set outputs in each state  
{eop ,HRQ,program, ACTIVE_CYCLE ,IDLE_CYCLE,iow,ior,memr,memw,READ,WRITE} = 11'b10101111100;  
{enBaseAddr,enBaseWord,enCurrAddr,ldTempCurrAddr,enCurrWord,ldTempCurrWord,ldCurrAddrTemp,ldCurrWordTemp,decr,enModeReg,enCommandReg,enRequestReg,enMaskReg,enStatusReg} =14'b00000000000000;    		 
    unique case(state);

	    state[SI]:
			begin  
                        eop = 1'b1; //keeping internal eop off
			HRQ = 1'b1;
			 if (~CS_n && ~HLDA)
				begin
			          program = 1'b1;
				  IDLE_CYCLE = 1'b1;
				  {enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b11111111111;
			          //flipflop = 1'b1;  #5 flipflop = 1'b0; //confused about the flipflop bits ,what if we give some delay and then give flipflop flag for lower bits .
			       end
			else 
			    begin
			         program = 1'b0;
				ACTIVE_CYCLE = 1'b1;
				{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b00000000000;
				end
			end
				
        state[S0]:  
			begin  
			 if (~HLDA)  //there can be some timing issue as until HLDA is still zero we are in program condition even if we are in S0 ,
				begin
			    program = 1'b1;
				{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b11111111111;
                                IDLE_CYCLE = 1'b1;
			//flipflop = 1'b1;  #5 flipflop = 1'b0; //confused about the flipflop bits ,what if we give some delay and then give flipflop flag for lower bits .
				end
				else 
				begin
                                ACTIVE_CYCLE = 1'b1;
			    aen = 1'b1;
				program = 1'b0;
				{enBaseAddr,enBaseWord,enCurrAddr,enCurrWord,enModeReg,enCommandReg,enMaskReg,enRequestReg,enStatusReg,ldCurrAddrTemp,ldCurrWordTemp}=11'b00000000000;
				end
		    end
				
        state[S1]: 
			begin 
			adstb = 1'b1;
                        if(commandReg)    //polarity of dack
			validDACK = 1'b1;
                         else validDACK = 1'b0;
			ldTempCurrAddr = 1'b1;  ldTempCurrWord = 1'b1; //loading the address register on the temporary registers
		//lipflop = 1'b0;if needed 
			end

        State[S2]:
				begin 
				adstb = 1'b0;
				flipflop = 1'b0;
				if (modeReg[3:2] =2'b01 && commandReg[0] = 1'b0 && commandReg[5] = 1'b1)//memory to memory disabled
					iow = 1'b0; WRITE = 1'b1; //extended write only in S2 otherwise write in S3
				elseif (modeReg[3:2] = 2'b10 && commandReg[0] = 1'b0)
				    ior = 1'b0; READ = 1'b1;
			    elseif (modeReg[3:2] = 2'b01 && commandReg[0] = 1'b1 &&  commandReg[5] = 1'b1)//memory to memory disabled
					memw = 1'b0; WRITE = 1'b1; //extended write
			    elseif (modeReg[3:2] = 2'b10 && commandReg[0] = 1'b1)
					memr = 1'b0;   READ = 1'b1;
			    else 
				{iow,ior,memw,memr} = 4'b1111;
				end
					
				state[S3]:
				begin
				if (modeReg[3:2] =2'b01 && commandReg[0] = 1'b0)//memory to memory disabled
					iow = 1'b0; WRITE = 1'b1; 
			    elseif (modeReg[3:2] = 2'b01 && commandReg[0] = 1'b1)//memory to memory disabled
					memw = 1'b0; WRITE = 1'b1; 
			    else 
				{iow,ior,memw,memr} = 4'b1111;
				end
				                 
                state[S4]:  
				begin 
				ldCurrAdderTemp; //not sure of this
				decr = 1'b0;
                                if(commandReg)    //polarity of dack
			        validDACK = 1'b0;
                                else validDACK = 1'b1;
				{HRQ,aen,ior,iow,memr,memw} = 6'b(001111);

				if((validDREQ[0] && statusReg[0] ~commandReg[6]) || (~validDREQ[0] && commandReg[6] && statusReg[0])) //checking active dreq and its corresponding TC for EOP generation
					eop = 1;                       // DREQ might go low by this time so we might not get the correct DREQ
			        elseif((validDREQ[1] && statusReg[1] && ~commandReg[6]) || (~validDREQ[1] && statusReg[1] && commandReg[6]))
				        eop = 1;
				elseif((validDREQ[2] && statusReg[2] && ~commandReg[6]) || (~validDREQ[2] && statusReg[2] && commandReg[6]))
				        eop = 1;
				elseif((validDREQ[3] && statusReg[3] && ~commandReg[6]) || (~validDREQ[3] && statusReg[3] && commandReg[6]))
				        eop = 1;
				else 
					eop = 0;
				end
      
				endcase
                 end
				 
endmodule		
