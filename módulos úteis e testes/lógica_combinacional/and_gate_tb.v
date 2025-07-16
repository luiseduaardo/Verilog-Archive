module and_gate_tb();
    reg a_tb, b_tb;
    wire y_tb;

    and_gate uut (.a(a_tb), .b(b_tb), .y(y_tb));

    initial 
        begin
            a_tb <= 1'b0; b_tb <= 1'b0;
        #10 a_tb <= 1'b0; b_tb <= 1'b1;
        #10 a_tb <= 1'b1; b_tb <= 1'b0;
        #10 a_tb <= 1'b1; b_tb <= 1'b1;         
        end

endmodule