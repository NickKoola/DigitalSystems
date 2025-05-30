// 32X32 Iterative Multiplier template
module mult32x32 (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);

    logic [1:0] a_sel;
    logic b_sel;
    logic [5:0] shift_val;
    logic upd_prod;
    logic clr_prod ;

    mult32x32_fsm FSM (.clk(clk), .reset(reset), .start(start),.a_sel(a_sel),.b_sel(b_sel),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.busy(busy));
    mult32x32_arith ARIC (.clk(clk), .reset(reset),.a(a),.b(b), .a_sel(a_sel),.b_sel(b_sel),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.product(product));
    
endmodule
