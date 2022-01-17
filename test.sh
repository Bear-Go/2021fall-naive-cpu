cd testcase

for test in add addi and andi auipc beq bge bgeu blt bltu bne jal jalr lb lbu lh lhu lui lw or ori sb sh simple sll slli slt slti sltiu sltu sra srai srl srli sub sw xor xori
  do
    ../output/emulator $test
  done