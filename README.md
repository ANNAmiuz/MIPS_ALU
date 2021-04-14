# MIPS simple ALU

### Introduction

​		This report shows the method to run the codes, the  big picture thoughts and idea of ALU, data flow chart, high level implementations, some details and tricks and the test methods to verify the function of codes.

### 0. How to run it

​		The summited program, if unzipped, will be in this structure. All the codes are in the *src* file.

```
+-- report.pdf
+-- src
|  +-- ALU.v
|  +-- ALU_test.v
|  +-- Makefile
```

```
cd ./src
make testresult
# to see the test results:
cat result.txt
```

### 1. Implementation

#### 1.0 Big Picture

​		ALU (arithmetic-logic unit) is a part of CPU (computer processor), which can perform arithmetic and logical operation according to the input data, like the operands and control words (which are distinguished by opcode and function-code in MIPS instruction) of specific length. 

​		With 32-bit operands, the ALU will get the results using these basic operations implemented which can be implemented in hardware easily:

> AND (for and, andi......)
>
> OR    (for or, ori......)
>
> 32-bit ADDER (for add, addi, addiu, sub, subu, subiu......)

​		Here is the graph showing how ALU perform various kinds of operations. For example, when the opcode is 000000 and the function-code is 100100, the *Operation* code for the multiplexer of every 1-bit ALU is 0. 

<img src="C:\Users\yingy\AppData\Roaming\Typora\typora-user-images\image-20210411200238876.png" alt="image-20210411200238876" style="zoom: 25%;" />

​		In CPU, the control words of ALU, like ALUop and ALUctr come from the parts outsides ALU. The operands of ALU are also got and modified outsides ALU. ALU takes the two operands and some control signals as inputs. 

​		However, in this simplified version of ALU, the program takes the 32-bit instruction, 32-bit values of register A and register B as inputs. Therefore, the ALU in this program needs to distinguish and modify the 2 operands. Then it should be able to decide which operation to perform. Finally, it gets the 32-bit result and sets the 3 flags.

 <img src="C:\Users\yingy\Desktop\general.svg" alt="general" style="zoom: 50%;" />

#### 1.1 Data Flow Chart

<img src="C:\Users\yingy\Desktop\mermaid-diagram-20210411205149.svg" alt="mermaid-diagram-20210411205149" style="zoom:50%;" />

#### 1.2 High Level Implementation

​	The input of the ALU program are the 32-bit instruction, 32-bit values in registers A & B. The outputs are the 32-bit result of ALU and 3-bit flags. The meanings of the 3 bits of flags and the 5-bit addresses of registers A & B are as follow:

> zero flag: flags[2]negative flag: flags[1]
>
> overflow flag: flags[0]
>
> address of register A is 00000, address of register B is 00001.

​	The implement this ALU, the program first need to phrase the 32-bit input instruction. The 6-bit opcode, addresses of RS & RT, shift amount, function code and immediate number should be got. After that, the program will decide which function to perform according to the opcode and function-code. Then the program will perform the instruction and get the values of 32-bit result and 3-bit flags.

#### 1.3 Implementation Details & Tricks

​		The first part of codes is the instruction phrasing and the connection of output wires (result, flags) with their corresponding registers, since ***register*** type can be assigned in the ***always*** blocks but ***wire*** cannot be assigned in blocks. The flags are assigned in this way:

```verilog
assign flags[2] = zero; //zero flag
assign flags[1] = negative; //negative flag
assign flags[0] = overflow; //overflow flag
```

​		The second part of codes is an ***always*** block, where the ***case*** sentences are used to determine which operation should be performed.

```verilog
always @(*) begin
        zero = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
    	alu_res = 32'b0;
        case (opcode)
            //for R-type instruction, still need function-code to determine the operation
            6'b000000:begin
                case (funct)
               		...
            end 
            //addi: overflow
            6'b001000:
                ...
        endcase
    end
```

 		Many ***tricks*** are used in the ***always*** block above.

##### (0).  Avoid Latch

​		In combination logics, incomplete assignment in conditional assignment. In this program, we first assign all the values as 0 at the beginning of the block to always make a complete assignment, for which we can avoid latches without putting a ***default*** condition.

##### (1). Sign-extension and Zero-extension

​		For the 16-bit immediate, we can perform zero/sign extension with these replication and concatenation:

```verilog
signed_imme = {{16{imme[15]}}, imme};
unsigned_imme = {{16{1'b0}}, imme};
```

### 2. Test

​		The outputs of the src codes are the test results. The current instruction type, the 32-bit instruction codes, the operands, the sources of operands, the 32-bit results and the 3-bit flags will be included. For each required instruction, the program provide at least one test.

​		The test results will be like:

```verilog
Instruction                        RegA      RegB      result     zero negative overflow
00000000000000000000000000000000:  00000000  00000000  00000000    0       0       0    
-----------------------------------------------------------------------------------------
add: A + B = 1 + 1 = 2, flags: 000.
00000000000000010000000000100000:  00000001  00000001  00000002    0       0       0    
```

At first we initialize all the values as 0. After the instructions are inputted, the values change. For the example above, the current instruction is for ***add*** (addition). The first operand comes from register A, and the second operand comes from register B.  The expected result is 2, which is consistent with the displayed result. The 3 flags should be all 0, and the displayed results are correct.

