// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [5:0] shift_sel, // Shift value of 8-bit mult product
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);


	logic[7:0] A_TO_MULT;
	logic[15:0] A_TO_MULT;
	logic[23:0] MULT_TO_SHIFTER;
	logic[63:0] SHIFTER_TO_ADDER;
	logic[63:0] ADDER_TO_PRODUCT;
	logic[63:0] PRODUCT_TO_ADDER;

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1 || clr_prod == 1'b1) begin
            product <= 64'b0;
        end
        else if (upd_prod == 1'b1 ) begin
        	product <= ADDER_TO_PRODUCT;    
        end
    end

	always_comb begin


		
		assign a_msb_is_0  = a[31:24] == 0;
		assign b_msw_is_0  = b[31:16] == 0;

		if (b_sel == 0) begin // MUX 2->1
			assign  A_TO_MULT = b[15:0];
		end
		else begin
			assign  A_TO_MULT = b[31:16];
		end

		case (a_sel) // MUX 4->1
	    2'b00 : begin
					assign  A_TO_MULT = a[7:0];
				end
	    2'b01 : begin
					assign  A_TO_MULT = a[15:8];
				end
	    2'b10 : begin
					assign  A_TO_MULT = a[23:16];
				end
	    2'b11 : begin
					assign  A_TO_MULT = a[31:24];
				end
	    endcase

		PRODUCT_TO_ADDER = product; 
	    assign MULT_TO_SHIFTER = A_TO_MULT * A_TO_MULT;
		assign  SHIFTER_TO_ADDER = MULT_TO_SHIFTER << shift_sel;
		assign  ADDER_TO_PRODUCT=  SHIFTER_TO_ADDER + PRODUCT_TO_ADDER ;

	end


// End of your code


endmodule
