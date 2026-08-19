`timescale 1ns/1ps

module testbench;

    reg clk;
    reg reset;

    cpu cpu_inst(
        .clk(clk),
        .reset(reset)
    );

  
    initial clk = 0;
    always #5 clk = ~clk;

   
    initial begin
        $readmemh("program.hex", cpu_inst.imem_inst.mem);
    end

   
    initial begin
        reset = 1;
        #12;
        reset = 0;
    end

    
    always @(posedge clk) begin
        if (!reset) begin
            $display("time=%0t  PC=%0d  instruction=%h  rd=x%0d  write_back=%0d  reg_write=%b",
                $time, cpu_inst.current_pc, cpu_inst.instruction,
                cpu_inst.rd, cpu_inst.write_back_data, cpu_inst.reg_write);
        end
    end

    //Detect the halt loop and stop 
    reg [31:0] previous_pc;
    reg first_cycle_after_reset;

    initial first_cycle_after_reset = 1;

    always @(posedge clk) begin
        if (reset) begin
            first_cycle_after_reset = 1;
        end else begin
            if (!first_cycle_after_reset && cpu_inst.current_pc == previous_pc) begin
                #1;
                $display("\n Program finished");
                print_registers;
                print_memory;
                $finish;
            end
            previous_pc = cpu_inst.current_pc;
            first_cycle_after_reset = 0;
        end
    end


    initial begin
        #10000;
        $display("\n TIMEOUT: program never reached a halt loop ");
        print_registers;
        $finish;
    end

  
    task print_registers;
        integer i;
        begin
            $display("Registers");
            for (i = 0; i < 32; i = i + 1) begin
                if (cpu_inst.regfile_inst.registers[i] != 0)
                    $display("x%0d = %0d", i, cpu_inst.regfile_inst.registers[i]);
            end
        end
    endtask

    task print_memory;
        integer i;
        begin
            $display("Data memory");
            for (i = 0; i < 16; i = i + 1) begin
                $display("mem[%0d] = %0d", i, cpu_inst.dmem_inst.mem[i]);
            end
        end
    endtask

endmodule
