# RISC-V_Processor


A single cycle RISC-V processor for EC413, Computer Organization.



The goal of this project was to build an effective single-cycle RISC-V CPU system. A single cycle CPU will carry out a single instruction per clock cycle and will execute any given operation in the same amount of time as the next. With every clock cycle, the CPU will fetch an instruction, finding its location and then decode the instruction found at that address. Based on the values in parts of the instruction, the decode module can tell many other modules how to proceed with the instruction. Data such as opcode, immediate value, and required registers are all able to be decoded by the decode module. The ALU performs an arithmetic operation on operands within the instruction or the PC and outputs the result of the operation. The CPU is able to write back data to determine locations, such as specific registers. The CPU finally continues the cycle by determining the next location where PC should point and an instruction can be received from.


The CPU checks at every positive edge of the clock with the fetch module to determine the Program Counter register's information, whether it be a branch target address, jump target address, or PC+4. This information is determined by the decode module, which deciphers the instructions by using combinational logic and conditional operands to separate the R-Type, I-Type, Load, Store, and branch type instructions. Only one target is sent to the fetch module. Fetch inputs the Program Counter and the instruction data into the decode module.
The decode module also receives inputs from the ALU module, which performs the arithmetic operations first determined by the decode module. The decode module then outputs the next and target PC to fetch, read1, read2, write, and write enable to the Register file (which reads and writes to registers), branch_op, imm32, opA, opB, and ALU_Control to ALU, the memory write enable to RAM, and wb_sel to write back. Hence, the decode module is the center of the operation - receiving and sending information on every positive edge of the clock cycle.
The RAM module supports the load and store instructions as well as fetching the instructions. It contains a read and address port for instructions, as well as the data port to read and write to the data addresses. The RAM module writes data to memory on every positive edge of the clock and only reads when asked combinationally with conditional operands.
