module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

    reg [31:0] mem [0:255];
    assign instruction = mem[address[31:2]];

endmodule
