module control_unit(
    input [6:0] opcode,
    input [6:0] funct7,
    output reg reg_write,    
    output reg alu_src,     
    output reg mem_read,    
    output reg mem_write,    
    output reg mem_to_reg,    
    output reg branch,       
    output reg alu_op        
);

    always @(*) begin
        reg_write  = 0;
        alu_src    = 0;
        mem_read   = 0;
        mem_write  = 0;
        mem_to_reg = 0;
        branch     = 0;
        alu_op     = 0;

        case (opcode)

            7'b0110011: begin // R-type: add , sub
                reg_write = 1;
                alu_src   = 0;              
                alu_op    = funct7[5];      
            end

            7'b0010011: begin // addi
                reg_write = 1;
                alu_src   = 1;              
                alu_op    = 0;          
            end

            7'b0000011: begin // lw
                reg_write  = 1;
                alu_src    = 1;            
                mem_read   = 1;
                mem_to_reg = 1;          
                alu_op     = 0;
            end

            7'b0100011: begin // sw
                alu_src   = 1;              
                mem_write = 1;
                alu_op    = 0;
            end

            7'b1100011: begin // beq , bne , blt
                branch  = 1;
                alu_src = 0;
            end

            default: begin
               
            end

        endcase
    end

endmodule
