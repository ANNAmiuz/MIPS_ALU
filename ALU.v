module alu(input[31:0] instruction, input[31:0] regA, input[31:0] regB, output[31:0] result, output[2:0] flags);
    //address of regA is 00000, address of regB is 00001
    //zero flag: flags[2]
    //negative flag: flags[1]
    //overflow flag: flags[0]
    wire[5:0] opcode,funct;
    wire[4:0] rs,rd,rt,shamt;
    wire[15:0] immediate;

    //for always block
    reg overflow, negative, zero;
    reg[31:0] RS, RT;
    reg[31:0] alu_res;
    
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign shamt = instruction[10:6];
    assign funct = instruction[5:0];
    assign immediate = instruction[15:0];
    
    assign flags[2] = zero; //zero flag
    assign flags[1] = negative; //negative flag
    assign flags[0] = overflow; //overflow flag
    assign result = alu_res;

    always @(*) begin
        if (rs == 5'b00000) begin
            RS = regA;
        end
        else if (rs == 5'b00001) begin
            RS = regB;
        end
        else begin
            RS = 32'b0;
        end
    end
    always @(*) begin
        if (rt == 5'b00000) begin
            RT = regA;
        end
        else if (rt == 5'b00001) begin
            RT = regB;
        end
        else begin
            RT = 32'b0;
        end
    end

    //execution
    always @(*) begin
        zero = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        alu_res = 32'b0;
        case (opcode)
            6'b000000:begin
                case (funct)
                    //add: overflow
                    6'b100000:begin
                        alu_res = RS + RT;
                        overflow = (~(RS[31]^RT[31])) & (RS[31]^alu_res[31]);
                    end
                    //addu: no overflow
                    6'b100001:begin
                        alu_res = RS + RT;
                    end
                    //sub: overflow
                    6'b100010:begin
                        alu_res = RS - RT;
                        overflow = (RS[31]^RT[31]) & (RS[31]^alu_res[31]);
                    end
                    //subu: no overflow
                    6'b100011: begin
                        alu_res = RS - RT;
                    end
                    //and
                    6'b100100:begin
                        alu_res = RS & RT;
                    end
                    //nor
                    6'b100111:begin
                        alu_res = ~(RS | RT);
                    end
                    //or
                    6'b100101:begin
                        alu_res = RS | RT;
                    end
                    //xor
                    6'b100110:begin
                        alu_res = RS ^ RT;
                    end
                    //slt
                    6'b101010:begin
                        alu_res = RS - RT;
                        negative = ($signed(RS) < $signed(RT))? 1'b1:1'b0;
                    end
                    //sltu
                    6'b101011:begin
                        alu_res = RS - RT;
                        negative = (RS < RT)? 1'b1:1'b0;
                    end
                    //sll
                    6'b000000: begin
                        alu_res = RT << shamt;
                    end
                    //sllv
                    6'b000100:begin
                        alu_res = RT << RS;
                    end
                    //srl
                    6'b000010:begin
                        alu_res = RT >> shamt;
                    end
                    //srlv
                    6'b000110:begin
                        alu_res = RT >> RS;
                    end
                    //sra
                    6'b000011:begin
                        alu_res = $signed(RT) >>> shamt;
                    end
                    //srav
                    6'b000111:begin
                        alu_res = $signed(RT) >>> RS;
                    end
                    //default: begin
                        //alu_res = 32'b0;
                    //end
                endcase
            end 
            //addi: overflow
            6'b001000:begin
                alu_res = RS + {{16{immediate[15]}},immediate};
                overflow = (~(RS[31]^immediate[15])) & (RS[31]^alu_res[31]);
            end
            //addiu: no overflow
            6'b001001:begin
                alu_res = RS + {{16{immediate[15]}},immediate};
            end
            //andi
            6'b001100:begin
                alu_res = RS & {{16{1'b0}},immediate};
            end
            //ori
            6'b001101:begin
                alu_res = RS | {{16{1'b0}},immediate};
            end
            //xori
            6'b001110:begin
                alu_res = RS ^ {{16{1'b0}},immediate};
            end
            //beq
            6'b000100:begin
                alu_res = 32'b0;
                zero = (RS^RT)? 1'b0:1'b1;
            end
            //bne
            6'b000101:begin
                alu_res = 32'b0;
                zero = (RS^RT)? 1'b1:1'b0;
            end
            //slti
            6'b001010:begin
                alu_res = RS - {{16{immediate[15]}},immediate};
                negative = ($signed(RS) < $signed({{16{immediate[15]}},immediate}))? 1'b1:1'b0;
            end
            //sltiu
            6'b001011:begin
                alu_res = RS - {{16{immediate[15]}},immediate};
                negative = ($unsigned(RS) < $unsigned({{16{immediate[15]}},immediate}))? 1'b1:1'b0;
            end
            //lw
            6'b100011:begin
                alu_res = RS + {{16{immediate[15]}},immediate};
            end
            //sw
            6'b101011:begin
                alu_res = RS + {{16{immediate[15]}},immediate};
            end
            //default: begin
                //alu_res = 32'b0;;
            //end
        endcase
    end

endmodule








