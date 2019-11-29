//-------------------------------------------------
// Priority encoder and Rotating priority logic
//-------------------------------------------------

module priorityTop(clk, dma_if.DUT dif, commandReg, maskReg, requestReg);

	input [7:0] commandReg;
	input [3:0] maskReg, requestReg;

	enum logic {
			DREQ0_ACTIVE_HIGH, DREQ0_ACTIVE_LOW,
			DREQ1_ACTIVE_HIGH, DREQ1_ACTIVE_LOW,
			DREQ2_ACTIVE_HIGH, DREQ2_ACTIVE_LOW,
			DREQ3_ACTIVE_HIGH, DREQ3_ACTIVE_LOW
				} DREQ_POLARITY_e;
	enum logic {
			DACK0_ACTIVE_HIGH, DACK0_ACTIVE_LOW,
			DACK1_ACTIVE_HIGH, DACK1_ACTIVE_LOW,
			DACK2_ACTIVE_HIGH, DACK2_ACTIVE_LOW,
			DACK3_ACTIVE_HIGH, DACK3_ACTIVE_LOW
				} DACK_POLARITY_e;

	enum logic {
			CH0_SEL,
			CH1_SEL,
			CH2_SEL,
			CH3_SEL
			} CHANNEL_SELECT_e;
	enum logic {
			CH0_MASK,
			CH1_MASK,
			CH2_MASK,
			CH3_MASK
			} CHANNEL_MASK_e;
	enum logic {
			VALID_DREQ0,
			VALID_DREQ1,
			VALID_DREQ2,
			VALID_DREQ3
			} VALID_DREQ_e;
	enum logic {
			VALID_DACK0,
			VALID_DACK1,
			VALID_DACK2,
			VALID_DACK3
			} VALID_DACK_e;
	enum logic [1:0] {
			   CH0_PRIORITY,
			   CH1_PRIORITY,
			   CH2_PRIORITY,
			   CH3_PRIORITY
			} CHANNEL_PRIORITY_e;


	logic validDREQ;
	logic rotatingPriority, enFixedPriorityEncoder, enRotatingPriorityEncoder;
	logic [7:0] chPriorityReg;

// decoding registers for valid DREQ

	// decode Request register
	always_ff@(posedge clk) begin
		if(requestReg[1:0] == 2'b00 && requestReg[2]) 	       CH0_SEL <= 1;
		else if(requestReg[1:0] == 2'b00 && !requestReg[2]     CH0_SEL <= 0;
		if(requestReg[1:0] == 2'b01 && requestReg[2]) 	       CH1_SEL <= 1;
		else if(requestReg[1:0] == 2'b01 && !requestReg[2]     CH1_SEL <= 0;
		if(requestReg[1:0] == 2'b10 && requestReg[2])          CH2_SEL <= 1;
		else if(requestReg[1:0] == 2'b10 && !requestReg[2]     CH2_SEL <= 0;
		if(requestReg[1:0] == 2'b11 && requestReg[2])          CH3_SEL <= 1;
		else if(requestReg[1:0] == 2'b11 && !requestReg[2]     CH3_SEL <= 0;
	end

	// decode Mask register
	always_ff@(posedge clk) begin
		if(maskReg[1:0] == 2'b00 && maskReg[2]) 	 CH0_MASK <= 1;
		else if(maskReg[1:0] == 2'b00 && !maskReg[2]     CH0_MASK <= 0;
		if(maskReg[1:0] == 2'b01 && maskReg[2]) 	 CH1_MASK <= 1;
		else if(maskReg[1:0] == 2'b01 && !maskReg[2]     CH1_MASK <= 0;
		if(maskReg[1:0] == 2'b10 && maskReg[2])          CH2_MASK <= 1;
		else if(maskReg[1:0] == 2'b10 && !maskReg[2]     CH2_MASK <= 0;
		if(maskReg[1:0] == 2'b11 && maskReg[2])          CH3_MASK <= 1;
		else if(maskReg[1:0] == 2'b11 && !maskReg[2]     CH3_MASK <= 0;
	end

	// setting priority scheme
	always_ff@(posedge clk) begin
		if(commandReg[4]) rotatingPriority <= 1;
		else		  rotatingPriority <= 0;
	end

	// decode Command register
	always_ff@(posedge clk) begin

		// DREQ polarity
		if(!commandReg[6] && CH0_SEL && !CH0_MASK)     DREQ0_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH0_SEL && !CH0_MASK) DREQ0_ACTIVE_LOW <= 1;
		else begin DREQ0_ACTIVE_HIGH <= 0; DREQ0_ACTIVE_LOW <= 0; end

		if(!commandReg[6] && CH1_SEL && !CH1_MASK)     DREQ1_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH1_SEL && !CH1_MASK) DREQ1_ACTIVE_LOW <= 1;
		else begin DREQ1_ACTIVE_HIGH <= 0; DREQ1_ACTIVE_LOW <= 0; end

		if(!commandReg[6] && CH2_SEL && !CH2_MASK)     DREQ2_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH2_SEL && !CH2_MASK) DREQ2_ACTIVE_LOW <= 1;
		else begin DREQ2_ACTIVE_HIGH <= 0; DREQ2_ACTIVE_LOW <= 0; end

		if(!commandReg[6] && CH3_SEL && !CH3_MASK)     DREQ3_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH3_SEL && !CH3_MASK) DREQ3_ACTIVE_LOW <= 1;
		else begin DREQ3_ACTIVE_HIGH <= 0; DREQ3_ACTIVE_LOW <= 0; end

		// DACK polarity
		if(commandReg[7] && CH0_SEL && !CH0_MASK)     DACK0_ACTIVE_HIGH <= 1;
		else if(!commandReg[7] && CH0_SEL && !CH0_MASK) DACK0_ACTIVE_LOW <= 1;
		else begin DACK0_ACTIVE_HIGH <= 0; DACK0_ACTIVE_LOW <= 0; end

		if(commandReg[7] && CH1_SEL && !CH1_MASK)     DACK1_ACTIVE_HIGH <= 1;
		else if(!commandReg[7] && CH1_SEL && !CH1_MASK) DACK1_ACTIVE_LOW <= 1;
		else begin DACK1_ACTIVE_HIGH <= 0; DACK1_ACTIVE_LOW <= 0; end

		if(commandReg[7] && CH2_SEL && !CH2_MASK)     DACK2_ACTIVE_HIGH <= 1;
		else if(!commandReg[7] && CH2_SEL && !CH2_MASK) DACK2_ACTIVE_LOW <= 1;
		else begin DACK2_ACTIVE_HIGH <= 0; DACK2_ACTIVE_LOW <= 0; end

		if(commandReg[7] && CH3_SEL && !CH3_MASK)     DACK3_ACTIVE_HIGH <= 1;
		else if(!commandReg[7] && CH3_SEL && !CH3_MASK) DACK3_ACTIVE_LOW <= 1;
		else begin DACK3_ACTIVE_HIGH <= 0; DACK3_ACTIVE_LOW <= 0; end

	end

	// setting valid DREQ
	always_ff@(posedge clk) begin
		if(DREQ0_ACTIVE_HIGH || DREQ0_ACTIVE_LOW) VALID_DREQ0 <= 1;
		else					  VALID_DREQ0 <= 0;
		if(DREQ1_ACTIVE_HIGH || DREQ1_ACTIVE_LOW) VALID_DREQ1 <= 1;
		else					  VALID_DREQ1 <= 0;
		if(DREQ2_ACTIVE_HIGH || DREQ2_ACTIVE_LOW) VALID_DREQ2 <= 1;
		else					  VALID_DREQ2 <= 0;
		if(DREQ3_ACTIVE_HIGH || DREQ3_ACTIVE_LOW) VALID_DREQ3 <= 1;
		else					  VALID_DREQ3 <= 0;
	end

	// setting DACK output if valid DREQ based on polarity
	// TODO: update DACK based on output from Priority Encoder
	always_ff@(posedge clk) begin
		if(VALID_DACK0 && DACK0_ACTIVE_HIGH) 	  dif.DACK[0] <= 1;
		else if(VALID_DACK0 && DACK0_ACTIVE_LOW)  dif.DACK[0] <= 0;
		if(VALID_DACK1 && DACK1_ACTIVE_HIGH) 	  dif.DACK[1] <= 1;
		else if(VALID_DACK1 && DACK1_ACTIVE_LOW)  dif.DACK[1] <= 0;
		if(VALID_DACK2 && DACK2_ACTIVE_HIGH) 	  dif.DACK[2] <= 1;
		else if(VALID_DACK2 && DACK2_ACTIVE_LOW)  dif.DACK[2] <= 0;
		if(VALID_DACK3 && DACK3_ACTIVE_HIGH) 	  dif.DACK[3] <= 1;
		else if(VALID_DACK	3 && DACK3_ACTIVE_LOW)  dif.DACK[3] <= 0;
	end

	// check for any valid requests on DREQ lines
	always_ff@(posedge clk) begin
		if(VALID_DREQ0 || VALID_DREQ1 || VALID_DREQ2 || VALID_DREQ3) validDREQ <= 1;
		else						       	     validDREQ <= 0;
	end

	// setting HRQ output if valid DREQ based on polarity and select priority encoding
	//TODO: how many encoders?
	always_ff@(posedge clk) begin
		if(validDREQ && HLDA)
		dif.HRQ <= 1;
			if(rotatingPriority) enRotatingPriorityEncoder <= 1;
			else		     enFixedPriorityEncoder <= 1;
	else	dif.HRQ <= 0;
	end

	// Fixed priority encoder
	// TODO: verify priority encoder
	always_comb begin
		if(enFixedPriorityEncoder)
			priority case(1'b1) // reverse case
			 VALID_DREQ0  :  encoderOut <= 4'b0001;
			 VALID_DREQ1  :  encoderOut <= 4'b0010;
			 VALID_DREQ2  :  encoderOut <= 4'b0100;
			 VALID_DREQ3  :  encoderOut <= 4'b1000;
			endcase
		else			encoderOut <= '0;
	end


	// TODO: Rotating priority logic





endmodule
