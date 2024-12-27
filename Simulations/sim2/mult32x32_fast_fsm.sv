// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [5:0] shift_sel, // Shift value of 8-bit mult product
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

	typedef enum { idle_st, transient_st, mult1_st,mult2_st,mult3_st,mult4_st,mult5_st,mult6_st,mult7_st,mult8_st } sm_type;


    sm_type current_state;
    sm_type next_state;

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            current_state <= idle_st;
        end
        else begin
            current_state <= next_state;
        end
    end
    
	always_comb begin

	    next_state = current_state;
	    busy = 1'b0;
	    a_sel = 2'b00;
	    b_sel = 1'b0;
	    shift_sel = 6'b0000;
		upd_prod = 1'b0;
		clr_prod = 1'b0;

	    case (current_state)
	    idle_st: begin
	        if(start == 1'b1) begin
	        	next_state = transient_st;
	        	clr_prod = 1'b1;
	        end
	    end
	    transient_st: begin
	    	next_state = mult1_st;
		   	busy = 1'b1;
		   	upd_prod = 1'b1;
	    end
	    mult1_st: begin
	    	next_state = mult2_st;
		   	busy = 1'b1;
		   	a_sel = 2'b01;
	    	b_sel = 1'b0;
	    	shift_sel = 6'b1000;
			upd_prod = 1'b1;
	    end
	    mult2_st: begin
	    	next_state = mult3_st;
		   	busy = 1'b1;
		   	a_sel = 2'b10;
	    	b_sel = 1'b0;
	    	shift_sel = 6'b10000;
			upd_prod = 1'b1;
	    end
	    mult3_st: begin
	    	busy = 1'b1;
	    	if(a_msb_is_0 == 1 && b_msw_is_0 == 1) begin
	    		next_state = idle_st;
	    	end
	    	else if(a_msb_is_0 == 1 && b_msw_is_0 == 0) begin
	    		next_state = mult5_st;
			   	a_sel = 2'b00;
		    	b_sel = 1'b1;
		    	shift_sel = 6'b10000;
				upd_prod = 1'b1;
	    	end
			else begin
		    	next_state = mult4_st;
			   	a_sel = 2'b11;
		    	b_sel = 1'b0;
		    	shift_sel = 6'b11000;
				upd_prod = 1'b1;
			end
	    end
	    mult4_st: begin
	     	busy = 1'b1;
	    	if(b_msw_is_0 == 1) begin
	    		next_state = idle_st;
	    	end
	    	else begin
	    	next_state = mult5_st;	  
		   	a_sel = 2'b00;
	    	b_sel = 1'b1;
	    	shift_sel = 6'b10000;
			upd_prod = 1'b1;
	    	end

	    end
	    mult5_st: begin
	    	next_state = mult6_st;
		   	busy = 1'b1;
		   	a_sel = 2'b01;
	    	b_sel = 1'b1;
	    	shift_sel = 6'b11000;
			upd_prod = 1'b1;
	    end
	    mult6_st: begin
	    	next_state = mult7_st;
		   	busy = 1'b1;
		   	a_sel = 2'b10;
	    	b_sel = 1'b1;
	    	shift_sel = 6'b100000;
			upd_prod = 1'b1;
	    end
	    mult7_st: begin
	    	busy = 1'b1;
	    	if(a_msb_is_0==1) begin
	    		next_state = idle_st;
	    	end
	    	else begin
	    		next_state = mult8_st;
			   	a_sel = 2'b11;
		    	b_sel = 1'b1;
		    	shift_sel = 6'b101000;
				upd_prod = 1'b1;
	    	end

	    end
	    mult8_st: begin
	    	next_state = idle_st;
	    	busy = 1'b1;
	    	//upd_prod = 1'b1;
	    end
	    endcase
	end



endmodule
