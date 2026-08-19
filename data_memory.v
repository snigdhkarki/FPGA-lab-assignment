module data_memory(
    input clk,
    input [31:0] address,   
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output [31:0] read_data
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 0;
    end

    assign read_data = mem[address[31:2]];

    always @(posedge clk) begin
        if (mem_write)
            mem[address[31:2]] <= write_data;
    end

endmodule
