module HA_tb;

    logic     ha_a;
    logic     ha_b;

    logic     ha_sum;
    logic     ha_carry;

    HA uut (
        .a(ha_a),
        .b(ha_b),
        .sum(ha_sum),
        .carry(ha_carry)
    );

    initial begin
        ha_a = 1'b0;
        ha_b = 1'b0;
        
        #20
        ha_a = 1'b1;
        ha_b = 1'b0;
        
        #20
        ha_a = 1'b0;
        ha_b = 1'b1;
        
        #20
        ha_a = 1'b1;
        ha_b = 1'b1; 

        #20;        
    end
    
endmodule
