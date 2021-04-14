`timescale 1ns/1ps

module alu_test;
//signal declaration
reg[31:0] instruction, RegA, RegB;
wire[31:0] result;
wire[2:0] flags;

//alu module instantiation
alu testalu(
    .instruction(instruction),
    .regA(RegA),
    .regB(RegB),
    .result(result),
    .flags(flags));

//simulation
initial
begin
    instruction = 32'b0;
    RegA = 32'b0;
    RegB = 32'b0;

    //$dumpfile("wave.vcd");
    //$dumpvars(0, RegA,RegB,result,flags);
    $display("Instruction                        RegA        RegB        result     zero negative overflow");
    $monitor("%b:  %h    %h    %h    %h       %h       %h",
    instruction, RegA, RegB, testalu.result, testalu.flags[2], testalu.flags[1], testalu.flags[0]);

//add
#10 
$display("----------------------------------------------------------------------------------------------");
$display("add: A + B = 1 + 1 = 2, flags: 000.");
RegA <= 32'd1;
RegB <= 32'd1;
instruction <= 32'b000000_00000_00001_00000_00000_100000;
//overflow negative
#10 
$display("add: A + B = Min_INT+Min_INT = overflow, flags: 001.");
RegA <= 32'h8000_0000;
RegB <= 32'h8000_0000;
instruction <= 32'b000000_00001_00000_00000_00000_100000;
//overflow positive
#10 
$display("add: A + B = Max_INT + Max_INT = overflow, flags: 001.");
RegA <= 32'b0111_1111_1111_1111_1111_1111_1111_1111;
RegB <= 32'b0111_1111_1111_1111_1111_1111_1111_1111;
instruction <= 32'b000000_00001_00000_00000_00000_100000;

//addi
#10 
$display("----------------------------------------------------------------------------------------------");
$display("addi: A + I = 1 + 1 = 2, flags: 000.");
RegA <= 32'd1;
instruction <= 32'b001000_00000_00001_00000000_00000001;
//overflow negative
#10 
$display("addi: A + I = Min_INT+(-1) = overflow, flags: 001.");
RegA <= 32'h8000_0000;
instruction <= 32'b001000_00000_00001_11111111_11111111;
//overflow positive
#10 
$display("addi: A + I = Max_INT + 1 = overflow, flags: 001.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b001000_00000_00001_00000000_00000001;

//addu
#10 
$display("----------------------------------------------------------------------------------------------");
$display("addu: A + A = 1 + 1 = 2, flags: 000.");
RegA <= 32'b00000000_00000000_00000000_00000001;
instruction <= 32'b000000_00000_00000_00000_00000_100001;
#10 
$display("addu: A + A = 0xffffffff + 0xffffffff = 0xfffffffe, flags: 000.");
RegA <= 32'hffff_ffff;
instruction <= 32'b000000_00000_00000_00000_00000_100001;

//addiu
#10 
$display("----------------------------------------------------------------------------------------------");
$display("addiu: A + I = 1 + 1 = 2, flags: 000.");
RegA <= 32'd1;
instruction <= 32'b001000_00000_00001_00000000_00000001;
#10
$display("addiu: A + I = 1 + (-1) = 0, flags: 000.");
RegA <= 32'd1;
instruction <= 32'b001000_00000_00001_11111111_11111111;

//sub
#10 
$display("----------------------------------------------------------------------------------------------");
$display("sub: A - A = 1 - 1 = 0, flags: 000.");
RegA <= 32'b1;
instruction <= 32'b000000_00000_00000_00000_00000_100010;
//overflow positive
#10
$display("sub: A - B = Max_INT - (-1) = overflow, flags: 001.");
RegA <= 32'h7fff_ffff;
RegB <= 32'hffff_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_100010;
//overflow negative
#10
$display("sub: A - B = Min_INT - 1 = overflow, flags: 001.");
RegA <= 32'h8000_0000;
RegB <= 32'h0000_0001;
instruction <= 32'b000000_00000_00001_00000_00000_100010;

//subu
#10 
$display("----------------------------------------------------------------------------------------------");
$display("subu: A - B = 0xffffffff - 0xffffffff = 0x00000000, flags: 000.");
RegA <= 32'hffff_ffff;
RegB <= 32'hffff_ffff;
instruction <= 32'b000000_00001_00001_00000_00000_100011;

//and
#10 
$display("----------------------------------------------------------------------------------------------");
$display("and: A & B = 0x00000001 & 0x00000001 = 0x00000001, flags: 000.");
RegA <= 32'b00000000_00000000_00000000_00000001;
RegB <= 32'b00000000_00000000_00000000_00000001;
instruction <= 32'b000000_00000_00001_00000_00000_100100;

//andi
#10 
$display("----------------------------------------------------------------------------------------------");
$display("andi: A & I = 0xffff0000 & 0x0000ffff = 0x00000000, flags: 000.");
RegA <= 32'hffff_0000;
instruction <= 32'b001100_00000_00001_11111111_11111111;

//nor
#10 
$display("----------------------------------------------------------------------------------------------");
$display("nor: A nor B = 0x0 nor 0x0 = 0xffffffff, flags: 000.");
RegA <= 32'b0;
RegB <= 32'b0;
instruction <= 32'b000000_00000_00001_00000_00000_100111;

//or
#10
$display("----------------------------------------------------------------------------------------------");
$display("or: A | B = 0xffff0000 | 0x0000ffff = 0xffffffff, flags: 000.");
RegA <= 32'hffff_0000;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_100101;
#10
$display("or: A | B = 0x00000000 | 0x0000ffff = 0x0000ffff, flags: 000.");
RegA <= 32'h0000_0000;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_100101;

//ori
#10
$display("----------------------------------------------------------------------------------------------");
$display("ori: A | I = 0xffff0000 | 0xffff = 0xffffffff, flags: 000.");
RegA <= 32'hffff_0000;
instruction <= 32'b001101_00000_00001_11111111_11111111;

//xor
#10 
$display("----------------------------------------------------------------------------------------------");
$display("xor: A ^ B = 0xffff0000 ^ 0x0000ffff = 0xffffffff, flags: 000.");
RegA <= 32'hffff_0000;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_100110;

//xori
#10 
$display("----------------------------------------------------------------------------------------------");
$display("xori: B ^ I = 0x0000ffff ^ 0xffff = 0x00000000, flags: 000.");
RegB <= 32'h0000_ffff;
instruction <= 32'b001110_00001_00001_11111111_11111111;

//beq
#10
$display("----------------------------------------------------------------------------------------------");
$display("beq (A B): A = 0xffff0000, B = 0xffff0000, flags: 100.");
RegA <= 32'hffff_0000;
RegB <= 32'hffff_0000;
instruction <= 32'b000100_00000_00001_11111111_11111111;
#10
$display("beq (A B): A = 0x00000000, B = 0xffff0000, flags: 000.");
RegA <= 32'h0000_0000;
RegB <= 32'hffff_0000;
instruction <= 32'b000100_00000_00001_11111111_11111111;

//bne
#10
$display("----------------------------------------------------------------------------------------------");
$display("bne (A B): A = 0xffff0000, B = 0xffff0000, flags: 000.");
RegA <= 32'hffff_0000;
RegB <= 32'hffff_0000;
instruction <= 32'b000101_00000_00001_11111111_11111111;
#10
$display("bne (A B): A = 0x00000000, B = 0xffff0000, flags: 100.");
RegA <= 32'h0000_0000;
RegB <= 32'hffff_0000;
instruction <= 32'b000101_00000_00001_11111111_11111111;

//slt
#10
$display("----------------------------------------------------------------------------------------------");
$display("slt (A < B): A = 0xffff_0000, B = 0x0000_ffff, result < 0, flags: 010.");
RegA <= 32'hffff_0000;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101010;
#10
$display("slt (A < B): A = 0x0000_ffff, B = 0x0000_ffff, result = 0, flags: 000.");
RegA <= 32'h0000_ffff;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101010;
#10
$display("slt (A < B): A = 0x0000_ffff, B = 0xffff_ffff, result > 0, flags: 000.");
RegA <= 32'h0000_ffff;
RegB <= 32'hffff_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101010;

//slti
#10
$display("----------------------------------------------------------------------------------------------");
$display("slti (A < I): A = 0xffff_0000, I = 0x0000_0000, result < 0, flags: 010.");
RegA <= 32'hffff_0000;
instruction <= 32'b001010_00000_00001_00000_00000_000000;
#10
$display("slti (A < I): A = 0xffff_ffff, I = 0xffff, result = 0, flags: 000.");
RegA <= 32'hffff_ffff;
instruction <= 32'b001010_00000_00001_11111111_11111111;
#10
$display("slti (A < I): A = 0x7fff_ffff, I = 0xffff, result > 0 (overflow), flags: 000.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b001010_00000_00001_11111111_11111111;

//sltiu
#10
$display("----------------------------------------------------------------------------------------------");
$display("sltiu (A < I): A = 0xffff_0000, I = 0x0000_0000, result > 0, flags: 000.");
RegA <= 32'hffff_0000;
instruction <= 32'b001011_00000_00001_00000_00000_000000;
#10
$display("sltiu (A < I): A = 0xffff_ffff, I = 0xffff, result = 0, flags: 000.");
RegA <= 32'hffff_ffff;
instruction <= 32'b001011_00000_00001_11111111_11111111;
#10
$display("sltiu (A < I): A = 0x7fff_ffff, I = 0xffff, result > 0, flags: 010.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b001011_00000_00001_11111111_11111111;

//sltu
#10
$display("----------------------------------------------------------------------------------------------");
$display("sltu (A < B): A = 0xffff_0000, B = 0x0000_ffff, result > 0, flags: 000.");
RegA <= 32'hffff_0000;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101011;
#10
$display("sltu (A < B): A = 0x0000_ffff, B = 0x0000_ffff, result = 0, flags: 000.");
RegA <= 32'h0000_ffff;
RegB <= 32'h0000_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101011;
#10
$display("sltu (A < B): A = 0x0000_ffff, B = 0xffff_ffff, result < 0, flags: 010.");
RegA <= 32'h0000_ffff;
RegB <= 32'hffff_ffff;
instruction <= 32'b000000_00000_00001_00000_00000_101011;

//lw
#10
$display("----------------------------------------------------------------------------------------------");
$display("lw: A + I = 0xffff_0000 + 0x0000_0000 = 0xffff_0000, flags: 000.");
RegA <= 32'hffff_0000;
instruction <= 32'b100011_00000_00001_00000_00000_000000;

//sw
#10
$display("----------------------------------------------------------------------------------------------");
$display("sw: A + I = 0x7fff_ffff + 0xffff = 0x7fff_fffe, flags: 000.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b101011_00000_00001_11111111_11111111;
#10
$display("----------------------------------------------------------------------------------------------");
$display("sw: A + I = 0x7fff_ffff + 0x0001 = 0x7fff_fffe, flags: 000.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b101011_00000_00001_00000000_00000001;

//sll
#10
$display("----------------------------------------------------------------------------------------------");
$display("sll: A << shamt = 0x7fff_ffff << 0b00001 = 0xffff_fffe, flags: 000.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b000000_00001_00000_00000_00001_000000;

//sllv
#10
$display("----------------------------------------------------------------------------------------------");
$display("sllv: A << B = 0x7fff_ffff << 0x0000_0001 = 0xffff_fffe, flags: 000.");
RegA <= 32'h7fff_ffff;
RegB <= 32'h0000_0001;
instruction <= 32'b000000_00001_00000_00000_00001_000100;

//srl
#10
$display("----------------------------------------------------------------------------------------------");
$display("srl: A >> shamt = 0xffff_ffff >> 0b00001 = 0x7fff_ffff, flags: 000.");
RegA <= 32'hffff_ffff;
instruction <= 32'b000000_00001_00000_00000_00001_000010;

//srlv
#10
$display("----------------------------------------------------------------------------------------------");
$display("srlv: A >> B = 0xffff_ffff >> 0x0000_0001 = 0x7fff_ffff, flags: 000.");
RegA <= 32'hffff_ffff;
RegB <= 32'h0000_0001;
instruction <= 32'b000000_00001_00000_00000_00000_000110;

//sra
#10
$display("----------------------------------------------------------------------------------------------");
$display("sra: A >> shamt = 0xffff_ffff >> 0b00001 = 0xffff_ffff, flags: 000.");
RegA <= 32'hffff_ffff;
instruction <= 32'b000000_00001_00000_00000_00001_000011;
#10
$display("sra: A >> shamt = 0x7fff_ffff >> 0b00001 = 0x3fff_ffff, flags: 000.");
RegA <= 32'h7fff_ffff;
instruction <= 32'b000000_00001_00000_00000_00001_000011;

//srav
#10
$display("----------------------------------------------------------------------------------------------");
$display("srav: A >> B = 0xffff_ffff >> 0x0000_0001 = 0xffff_ffff, flags: 000.");
RegA <= 32'hffff_ffff;
RegB <= 32'h0000_0001;
instruction <= 32'b000000_00001_00000_00000_00000_000111;
#10
$display("srav: A >> B = 0x7fff_ffff >> 0x0000_0001 = 0x3fff_ffff, flags: 000.");
RegA <= 32'h7fff_ffff;
RegB <= 32'h0000_0001;
instruction <= 32'b000000_00001_00000_00000_00000_000111;

#10 $finish;
end
endmodule
