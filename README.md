# Single-Cycle RISC-V Processor

This repository contains the implementation of a **Single-Cycle RISC-V Processor** designed using **SystemVerilog**.  
The processor executes each instruction in a single clock cycle and follows the basic RV32I instruction set.

This project focuses on understanding processor microarchitecture, datapath design, control logic, and instruction-level execution.

---

## Features

- Supports core **RV32I** instructions  
- Complete single-cycle datapath  
- ALU operations (ADD, SUB, AND, OR, SLT, etc.)   
- Control Unit for instruction decoding  
- Immediate Generator  
- Program Counter logic  
- Instruction Memory  
- Testbench for verifying execution  

---

## Architecture Overview

Single-cycle RISC-V CPU includes:

- **Program Counter (PC)**  
- **Instruction Memory**  
- **Register File**  
- **ALU**
- **Control Unit**
- **ALU Control Unit**
- **Immediate Generator**  
- **Data Memory**  

---

## Block Diagram:
<p align="center">
<img width="482" height="253" alt="image" src="https://github.com/user-attachments/assets/79f346e7-093e-43ee-af75-bf6f8191938d" />
</p>

