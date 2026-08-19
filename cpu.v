module cpu(
    input clk,
    input reset
);

    // Program Counter
    wire [31:0] current_pc;
    wire [31:0] next_pc;

    pc pc_inst(
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    wire [31:0] pc_plus_4 = current_pc + 4;

    // Fetch instruction
    wire [31:0] instruction;

    instruction_memory imem_inst(
        .address(current_pc),
        .instruction(instruction)
    );

    // Break the instruction
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];

    // Control unit 
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, alu_op;

    control_unit ctrl_inst(
        .opcode(opcode),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_op(alu_op)
    );

    // Register file
    wire [31:0] read_data1, read_data2;
    wire [31:0] write_back_data;

    register_file regfile_inst(
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Immediate generator 
    wire [31:0] imm;

    immediate_generator immgen_inst(
        .instruction(instruction),
        .imm_out(imm)
    );

    // ALU 
    wire [31:0] alu_input_b = alu_src ? imm : read_data2;
    wire [31:0] alu_result;

    alu alu_inst(
        .input_a(read_data1),
        .input_b(alu_input_b),
        .alu_op(alu_op),
        .result(alu_result)
    );

    // Branch decision 
    reg branch_condition_met;
    always @(*) begin
        case (funct3)
            3'b000:  branch_condition_met = (read_data1 == read_data2);
            3'b001:  branch_condition_met = (read_data1 != read_data2);
            3'b100:  branch_condition_met = ($signed(read_data1) < $signed(read_data2));
            default: branch_condition_met = 0;
        endcase
    end

    wire branch_taken = branch & branch_condition_met;

  
    assign next_pc = branch_taken ? (current_pc + imm) : pc_plus_4;

    //Data memory
    wire [31:0] mem_read_data;

    data_memory dmem_inst(
        .clk(clk),
        .address(alu_result),
        .write_data(read_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_read_data)
    );

    // Write-back
    assign write_back_data = mem_to_reg ? mem_read_data : alu_result;

endmodule
