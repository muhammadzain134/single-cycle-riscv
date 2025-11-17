`timescale 1ns / 1ps

module top(
input logic clk,
input logic rst
    );
logic [31:0] pc, pc_4, pc_target, pc_next, pc_jal;
logic [31:0] instr;
logic [1:0] ALUOp;
logic RegWrite, ALUSrc, MemtoReg, MemWrite, MemRead;
logic [4:0] rs1, rs2, rd;
logic [31:0] data1, data2, write_data;
logic [31:0] imm_out;

logic [3:0] alu_ctrl;
logic [31:0] alu_in2, alu_in1, alu_result;
logic carry_out, Zero, Overflow, Negative;

logic [6:0] opcode, funct7;
logic [2:0] funct3;

logic [31:0] ram_rword, dataR, wordW;
logic [3:0] mask;
logic not_align,  jump, jalr;
logic [31:0] jump_addr;

logic branch, uimm ,lui;


branch_unit BU (.funct3(funct3),.opcode(opcode),.Zero(Zero),.Negative(Negative),.Overflow(Overflow),.carry_out(carry_out),
    .PCSrc(branch));

assign pc_4 = pc + 4;
assign pc_target = pc + imm_out;
assign pc_jal = (jump || branch ) ? pc_target : pc_4;
assign pc_next = (jalr) ? (alu_result & ~32'd1) : pc_jal;


program_counter PC (.clk(clk), .rst(rst),.pc_next(pc_next), .pc(pc));
    
inst_mem IM (.addr(pc),.instr_out(instr));
    
// partation 
assign opcode = instr[6:0];
assign rd = instr[11:7];
assign funct3 = instr[14:12];
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign funct7 = instr[31:25];
    
main_control CTRL (.opcode(opcode),.ALUOp(ALUOp),.RegWrite(RegWrite),.ALUSrc(ALUSrc),.MemRead(MemRead),.MemWrite(MemWrite),.MemtoReg(MemtoReg),.jump(jump), .jalr(jalr),. uimm(uimm),.lui(lui));
    
reg_file RF (.clk(clk),.rs1(rs1), .rs2(rs2), .rsW(rd), .dataW(write_data),.RegWEn(RegWrite), .data1(data1),.data2(data2));
    
imm_gen IMM (.instr(instr),.opcode(opcode),.imm_out(imm_out));
    
ALU_control ALUCTRL (.funct7(funct7), .finct3(funct3),.ALUOp(ALUOp),.control_sig(alu_ctrl));
    
// Selecting ALU second input
assign alu_in2 = (ALUSrc) ? imm_out : data2;
assign alu_in1 = (uimm) ? pc : data1;   
alu_logic ALU (.a(alu_in1),.b(alu_in2),.alu_op(alu_ctrl),.result(alu_result),.carry_out(carry_out),.Zero(Zero),.Negative(Negative),.Overflow(Overflow));

load_store_format LS (.mem_read (MemRead),.mem_write(MemWrite),.funct3(funct3),.addr(alu_result),.rword(ram_rword),.rs2(data2),      
                .dataR(dataR), .wordW(wordW),.be(mask),.not_align(not_align));
                
data_mem DM (.clk(clk),.rst(rst),.addr(alu_result),.we(MemWrite),.be(mask),.dataWM(wordW),.dataR (ram_rword));
    
assign write_data = jump ? pc_4 :
                    MemtoReg ? dataR  :
                    lui ? imm_out  :
                    alu_result;
    
endmodule
