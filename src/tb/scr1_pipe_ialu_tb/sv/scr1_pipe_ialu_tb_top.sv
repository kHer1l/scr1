// scr1_pipe_ialu_tb_top.sv
`timescale 1ns/1ns

`include "scr1_arch_description.svh"
//`include "scr1_riscv_isa_decoding.svh"

module scr1_pipe_ialu_tb_top;
	parameter PERIOD = 10;
	bit clk = 0;
	always #(PERIOD/2) clk = ~clk;
	bit rst_n = 1;
	
scr1_pipe_ialu_if scr1_pipe_ialu_if_h(clk,rst_n);

scr1_pipe_ialu #() dut (
`ifdef SCR1_RVM_EXT
    // Common
    .clk					(scr1_pipe_ialu_if_h.clk			),	// IALU clock
    .rst_n					(scr1_pipe_ialu_if_h.rst_n			),	// IALU reset
    .exu2ialu_rvm_cmd_vd_i	(scr1_pipe_ialu_if_h.rvm_cmd_vd_i	),	// MUL/DIV command valid
    .ialu2exu_rvm_res_rdy_o	(scr1_pipe_ialu_if_h.rvm_res_rdy_o	),	// MUL/DIV result ready
`endif // SCR1_RVM_EXT
    // Main adder
    .exu2ialu_main_op1_i	(scr1_pipe_ialu_if_h.main_op1_i		),	// main ALU 1st operand
    .exu2ialu_main_op2_i	(scr1_pipe_ialu_if_h.main_op2_i		),	// main ALU 2nd operand
    .exu2ialu_cmd_i			({scr1_pipe_ialu_if_h.cmd_i}		),	// IALU command
    .ialu2exu_main_res_o	(scr1_pipe_ialu_if_h.main_res_o		),	// main ALU result
    .ialu2exu_cmp_res_o		(scr1_pipe_ialu_if_h.cmp_res_o		),	// IALU comparison result
    // Address adder
    .exu2ialu_addr_op1_i	(scr1_pipe_ialu_if_h.addr_op1_i		),	// Address adder 1st operand
    .exu2ialu_addr_op2_i	(scr1_pipe_ialu_if_h.addr_op2_i		),	// Address adder 2nd operand
    .ialu2exu_addr_res_o	(scr1_pipe_ialu_if_h.addr_res_o		)	// Address adder result
);

import uvm_pkg::*; // [UVM] package
`include "uvm_macros.svh" // [UVM] macroses
import scr1_pipe_ialu_package::*; // connect our package

initial begin
	uvm_config_db #(virtual scr1_pipe_ialu_if)::set( // pass interface
		null, "*", "scr1_pipe_ialu_if_h", scr1_pipe_ialu_if_h); // to UVM database
	run_test("scr1_pipe_ialu_test_default"); // run test routine
end

endmodule