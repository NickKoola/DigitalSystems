.text
main:   # Start of your code

        lw t4, 8(x0)
        addi t5, t4, 12 
        sw t5, 16(x0)
        # End of your code
        add		t6, x0, x0
        beq		t6, x0, finish

deadend: beq	t6, x0, deadend        

finish:
        lw		t4, 0(x0)
        lw		t5, 4(x0)
        sw		t5, 0xFF(t4)
        beq		t6, x0, deadend


