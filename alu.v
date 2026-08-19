module alu(
    input [31:0] input_a,
    input [31:0] input_b,
    input alu_op,             // 0 = add, 1 = subtract
    output reg [31:0] result
);

    always @(*) begin
        if (alu_op == 1)
            result = input_a - input_b;
        else
            result = input_a + input_b;
    end

endmodule
