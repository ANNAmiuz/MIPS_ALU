test:compile; vvp compiled;
testresult:compile; vvp compiled > result.txt;
compile: ALU.v ALU_test.v; iverilog -o compiled ALU.v ALU_test.v;
