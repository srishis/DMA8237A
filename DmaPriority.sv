// DMA Priority Module 


module DmaPriority(dma_if.PR dif, DmaControlIf.PR cif, DmaRegIf.PR rif); 
	
	logic validDREQ; 
	logic [3:0] pencoderOut, dack;
	logic enFixedPriority, enRotatingPriority;

	logic DREQ0_ACTIVE_HIGH; 
	logic DREQ1_ACTIVE_HIGH; 
	logic DREQ2_ACTIVE_HIGH; 
	logic DREQ3_ACTIVE_HIGH; 
	logic DACK0_ACTIVE_HIGH; 
	logic DACK1_ACTIVE_HIGH; 
	logic DACK2_ACTIVE_HIGH; 
	logic DACK3_ACTIVE_HIGH; 
	logic DREQ0_ACTIVE_LOW;
	logic DREQ1_ACTIVE_LOW;
	logic DREQ2_ACTIVE_LOW;
	logic DREQ3_ACTIVE_LOW;
	logic DACK0_ACTIVE_LOW;
	logic DACK1_ACTIVE_LOW;
	logic DACK2_ACTIVE_LOW;
	logic DACK3_ACTIVE_LOW;
	logic CH0_SEL; 
	logic CH1_SEL;
	logic CH2_SEL;
	logic CH3_SEL;
	logic CH0_MASK;
	logic CH1_MASK;
	logic CH2_MASK;
	logic CH3_MASK;
	logic VALID_DACK0;
	logic VALID_DACK1;
	logic VALID_DACK2;
	logic VALID_DACK3;
	logic [1:0] CH0_PRIORITY; 
	logic [1:0] CH1_PRIORITY;  
	logic [1:0] CH2_PRIORITY; 
	logic [1:0] CH3_PRIORITY; 
	logic [1:0] NEXT_CH0_PRIORITY;
	logic [1:0] NEXT_CH1_PRIORITY;
	logic [1:0] NEXT_CH2_PRIORITY;
	logic [1:0] NEXT_CH3_PRIORITY; 

	// Reset condition
	always_ff@(posedge dif.CLK) begin
		if(dif.RESET) begin
		dif.HRQ  <= '0; 
		dif.DACK <= '1;
	end
	else begin
	// HRQ and DACK outputs
		dif.HRQ   <= cif.hrq;
		dif.DACK  <= dack;  
	end
	end
		
	// decoding registers for valid DREQ
	// decode Request register	
	always_comb begin
		if(rif.requestReg[1:0] == 2'b00 && rif.requestReg[2]) 	        CH0_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b00 && !rif.requestReg[2])     CH0_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b01 && rif.requestReg[2]) 	        CH1_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b01 && !rif.requestReg[2])     CH1_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b10 && rif.requestReg[2])           CH2_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b10 && !rif.requestReg[2])     CH2_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b11 && rif.requestReg[2])           CH3_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b11 && !rif.requestReg[2])     CH3_SEL = 0; 
	end

	// decode Mask register	
	always_comb begin
		if(rif.maskReg[1:0] == 2'b00 && rif.maskReg[2]) 	 CH0_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b00 && !rif.maskReg[2])    CH0_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b01 && rif.maskReg[2]) 	 CH1_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b01 && !rif.maskReg[2])    CH1_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b10 && rif.maskReg[2])          CH2_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b10 && !rif.maskReg[2])    CH2_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b11 && rif.maskReg[2])          CH3_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b11 && !rif.maskReg[2])    CH3_MASK = 0; 
	end

	
	// decode Command register	
	always_comb begin
		
		// DREQ polarity
		if(!rif.commandReg[6] && CH0_SEL && !CH0_MASK)     DREQ0_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && CH0_SEL && !CH0_MASK) DREQ0_ACTIVE_LOW = 1;
		else begin DREQ0_ACTIVE_HIGH = 0; DREQ0_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && CH1_SEL && !CH1_MASK)     DREQ1_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && CH1_SEL && !CH1_MASK) DREQ1_ACTIVE_LOW = 1;
		else begin DREQ1_ACTIVE_HIGH = 0; DREQ1_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && CH2_SEL && !CH2_MASK)     DREQ2_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && CH2_SEL && !CH2_MASK) DREQ2_ACTIVE_LOW = 1;
		else begin DREQ2_ACTIVE_HIGH = 0; DREQ2_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && CH3_SEL && !CH3_MASK)     DREQ3_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && CH3_SEL && !CH3_MASK) DREQ3_ACTIVE_LOW = 1;
		else begin DREQ3_ACTIVE_HIGH = 0; DREQ3_ACTIVE_LOW = 0; end  		   		

		// DACK polarity
		if(!rif.commandReg[7] && CH0_SEL && !CH0_MASK)     DACK0_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && CH0_SEL && !CH0_MASK) DACK0_ACTIVE_LOW = 1;
		else begin DACK0_ACTIVE_HIGH = 0; DACK0_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && CH1_SEL && !CH1_MASK)     DACK1_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && CH1_SEL && !CH1_MASK) DACK1_ACTIVE_LOW = 1;
		else begin DACK1_ACTIVE_HIGH = 0; DACK1_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && CH2_SEL && !CH2_MASK)     DACK2_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && CH2_SEL && !CH2_MASK) DACK2_ACTIVE_LOW = 1;
		else begin DACK2_ACTIVE_HIGH = 0; DACK2_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && CH3_SEL && !CH3_MASK)     DACK3_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && CH3_SEL && !CH3_MASK) DACK3_ACTIVE_LOW = 1;
		else begin DACK3_ACTIVE_HIGH = 0; DACK3_ACTIVE_LOW = 0; end  
		
	end
	
	// Valid DREQ
	always_ff@(posedge dif.CLK) begin
		if((DREQ0_ACTIVE_HIGH && dif.DREQ[0]) || (DREQ0_ACTIVE_LOW  && !dif.DREQ[0]))   cif.VALID_DREQ0 <= 1;
		else					  					cif.VALID_DREQ0 <= 0;	
		if((DREQ0_ACTIVE_HIGH && dif.DREQ[1]) || (DREQ0_ACTIVE_LOW  && !dif.DREQ[1]))   cif.VALID_DREQ1 <= 1;
		else					 				        cif.VALID_DREQ1 <= 0;	
		if((DREQ0_ACTIVE_HIGH && dif.DREQ[2]) || (DREQ0_ACTIVE_LOW  && !dif.DREQ[2]))   cif.VALID_DREQ2 <= 1;
		else					       					cif.VALID_DREQ2 <= 0;	
		if((DREQ0_ACTIVE_HIGH && dif.DREQ[3]) || (DREQ0_ACTIVE_LOW  && !dif.DREQ[3]))   cif.VALID_DREQ3 <= 1;
		else					  					cif.VALID_DREQ3 <= 0;	
	end

	// DACK output 
        always_ff@(posedge dif.CLK) begin
		if(cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_HIGH) 	    	dack[0] <= 1;
		else if(cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_LOW)       dack[0] <= 0;
		else if(!cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_HIGH)     dack[0] <= 0;
		else if(!cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_LOW)      dack[0] <= 1;

		if(cif.validDACK && VALID_DACK1 && DACK1_ACTIVE_HIGH) 	    	dack[1] <= 1;
		else if(cif.validDACK && VALID_DACK1 && DACK1_ACTIVE_LOW)       dack[1] <= 0;
		else if(!cif.validDACK && VALID_DACK1 && DACK0_ACTIVE_HIGH)     dack[1] <= 0;
		else if(!cif.validDACK && VALID_DACK1 && DACK0_ACTIVE_LOW)      dack[1] <= 1;

		if(cif.validDACK && VALID_DACK2 && DACK2_ACTIVE_HIGH) 	    	dack[2] <= 1;
		else if(cif.validDACK && VALID_DACK2 && DACK2_ACTIVE_LOW)       dack[2] <= 0;
		else if(!cif.validDACK && VALID_DACK2 && DACK0_ACTIVE_HIGH)     dack[2] <= 0;
		else if(!cif.validDACK && VALID_DACK2 && DACK0_ACTIVE_LOW)      dack[2] <= 1;

		if(cif.validDACK && VALID_DACK3 && DACK3_ACTIVE_HIGH) 	    	dack[3] <= 1;
		else if(cif.validDACK && VALID_DACK3 && DACK3_ACTIVE_LOW)       dack[3] <= 0;
		else if(!cif.validDACK && VALID_DACK3 && DACK0_ACTIVE_HIGH)     dack[3] <= 0;
		else if(!cif.validDACK && VALID_DACK3 && DACK0_ACTIVE_LOW)      dack[3] <= 1;
        end
	
	// check for any valid requests on DREQ lines	
	always_comb begin
		if(cif.VALID_DREQ0 || cif.VALID_DREQ1 || cif.VALID_DREQ2 || cif.VALID_DREQ3) validDREQ = 1;
		else						       	                     validDREQ = 0;
	end

	// select priority encoding based on register configuration
	always_comb begin
		if(validDREQ && rif.commandReg[4]) 	      enRotatingPriority <= 1; 
		else if(validDREQ && !rif.commandReg[4])      enFixedPriority    <= 1;
	end
	
	// priority encoder
	always_comb begin
		pencoderOut = '0;   // default value when no request on DREQ lines
		if(enFixedPriority)
			priority case(1'b1) // reverse case
			 cif.VALID_DREQ0  : pencoderOut = 4'b0001; 	 
			 cif.VALID_DREQ1  : pencoderOut = 4'b0010; 	 
			 cif.VALID_DREQ2  : pencoderOut = 4'b0100; 	 
			 cif.VALID_DREQ3  : pencoderOut = 4'b1000; 	 
			endcase

		else if(enRotatingPriority)
			if(CH0_PRIORITY == 2'b11) 	pencoderOut = 4'b0001;
			else if(CH1_PRIORITY == 2'b11)  pencoderOut = 4'b0010;
			else if(CH2_PRIORITY == 2'b11)  pencoderOut = 4'b0100;
			else if(CH3_PRIORITY == 2'b11)  pencoderOut = 4'b1000;
	end	

	always_comb begin
		if(pencoderOut == 4'b0001)      begin VALID_DACK0 = 1'b1; VALID_DACK1 = 1'b0; VALID_DACK2 = 1'b0; VALID_DACK3 = 1'b0; end
		else if(pencoderOut == 4'b0010) begin VALID_DACK1 = 1'b1; VALID_DACK2 = 1'b0; VALID_DACK3 = 1'b0; VALID_DACK0 = 1'b0; end
		else if(pencoderOut == 4'b0100) begin VALID_DACK2 = 1'b1; VALID_DACK3 = 1'b0; VALID_DACK0 = 1'b0; VALID_DACK0 = 1'b0; end
		else if(pencoderOut == 4'b1000) begin VALID_DACK3 = 1'b1; VALID_DACK0 = 1'b0; VALID_DACK1 = 1'b0; VALID_DACK2 = 1'b0; end
	end                                                     

	
	// Rotating priority logic 
	always_ff@(posedge dif.CLK) begin
		if(dif.RESET) begin
			{CH0_PRIORITY, CH1_PRIORITY, CH2_PRIORITY, CH3_PRIORITY} <= {8'b11100100};  // by default CH0 - highest and CH3 - lowest priority
			{NEXT_CH0_PRIORITY, NEXT_CH1_PRIORITY, NEXT_CH2_PRIORITY, NEXT_CH3_PRIORITY} <= '0;
		end
			else {CH0_PRIORITY, CH1_PRIORITY, CH2_PRIORITY, CH3_PRIORITY} <= {NEXT_CH0_PRIORITY, NEXT_CH1_PRIORITY, NEXT_CH2_PRIORITY, NEXT_CH3_PRIORITY};
	end

	always_ff@(posedge dif.CLK) begin
		if(cif.VALID_DREQ0) //begin NEXT_CH0_PRIORITY <= 2'b00; NEXT_CH1_PRIORITY <= CH1_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end//
			begin 
				NEXT_CH0_PRIORITY <= 2'b00;
				if(CH1_PRIORITY != 2'b11)	NEXT_CH1_PRIORITY <= CH1_PRIORITY + 1'b1;
				else				NEXT_CH1_PRIORITY <= CH1_PRIORITY - 1'b1;
				if(CH2_PRIORITY != 2'b11)	NEXT_CH2_PRIORITY <= CH2_PRIORITY + 1'b1;
				else				NEXT_CH2_PRIORITY <= CH2_PRIORITY - 1'b1;
				if(CH3_PRIORITY != 2'b11)	NEXT_CH3_PRIORITY <= CH3_PRIORITY + 1'b1;
				else				NEXT_CH3_PRIORITY <= CH3_PRIORITY - 1'b1;
				
			end
		else if(cif.VALID_DREQ1)//begin NEXT_CH1_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end//
			begin 
				NEXT_CH1_PRIORITY <= 2'b00;
				if(CH0_PRIORITY != 2'b11)	NEXT_C0_PRIORITY  <= CH0_PRIORITY + 1'b1;
				else				NEXT_CH0_PRIORITY <= CH0_PRIORITY - 1'b1;
				if(CH2_PRIORITY != 2'b11)	NEXT_CH2_PRIORITY <= CH2_PRIORITY + 1'b1;
				else				NEXT_CH2_PRIORITY <= CH2_PRIORITY - 1'b1;
				if(CH3_PRIORITY != 2'b11)	NEXT_CH3_PRIORITY <= CH3_PRIORITY + 1'b1;
				else				NEXT_CH3_PRIORITY <= CH3_PRIORITY - 1'b1;
				
			end
		else if(cif.VALID_DREQ2)//begin NEXT_CH2_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end//
			begin 
				NEXT_CH2_PRIORITY <= 2'b00;
				if(CH0_PRIORITY != 2'b11)	NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1;
				else				NEXT_CH0_PRIORITY <= CH0_PRIORITY - 1'b1;
				if(CH1_PRIORITY != 2'b11)	NEXT_CH1_PRIORITY <= CH1_PRIORITY + 1'b1;
				else				NEXT_CH1_PRIORITY <= CH1_PRIORITY - 1'b1;
				if(CH3_PRIORITY != 2'b11)	NEXT_CH3_PRIORITY <= CH3_PRIORITY + 1'b1;
				else				NEXT_CH3_PRIORITY <= CH3_PRIORITY - 1'b1;
				
			end
		else if(cif.VALID_DREQ3)//begin NEXT_CH3_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end//
			begin 
				NEXT_CH3_PRIORITY <= 2'b00;
				if(CH0_PRIORITY != 2'b11)	NEXT_CH0_PRIORITY  <= CH0_PRIORITY + 1'b1;
				else				NEXT_CH0_PRIORITY <= CH0_PRIORITY - 1'b1;
				if(CH1_PRIORITY != 2'b11)	NEXT_CH1_PRIORITY <= CH1_PRIORITY + 1'b1;
				else				NEXT_CH1_PRIORITY <= CH1_PRIORITY - 1'b1;
				if(CH2_PRIORITY != 2'b11)	NEXT_CH2_PRIORITY <= CH2_PRIORITY + 1'b1;
				else				NEXT_CH2_PRIORITY <= CH2_PRIORITY - 1'b1;
				
			end
	end

endmodule
