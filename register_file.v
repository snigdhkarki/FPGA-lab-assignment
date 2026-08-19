module register_file(
    input clk,
    input reg_write,           // 1 = write write_data into write_reg
    input [4:0] read_reg1,     // which register to read (port 1)
    input [4:0] read_reg2,     // which register to read (port 2)
    input [4:0] write_reg,     // which register to write
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 0;
    end

    assign read_data1 = (read_reg1 == 0) ? 0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 0) ? 0 : registers[read_reg2];

    always @(posedge clk) begin
        if (reg_write && write_reg != 0)
            registers[write_reg] <= write_data;
    end

endmodule
