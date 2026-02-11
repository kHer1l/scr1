// scr1_pipe_ialu_if.sv
`include "scr1_arch_description.svh"
import scr1_pkg::*;

interface scr1_pipe_ialu_if (
	input bit						clk,			// IALU clock
	input bit 						rst_n			// IALU reset	
	);
`ifdef SCR1_RVM_EXT	
	// Common	
	logic                           rvm_cmd_vd_i;	// MUL/DIV command valid
	logic                           rvm_res_rdy_o;	// MUL/DIV result ready
`endif // SCR1_RVM_EXT
	
	// Main adder
    logic [`SCR1_XLEN-1:0]          main_op1_i;		// main ALU 1st operand
    logic [`SCR1_XLEN-1:0]          main_op2_i;		// main ALU 2nd operand
    type_scr1_ialu_cmd_sel_e        cmd_i;			// IALU command
    logic [`SCR1_XLEN-1:0]          main_res_o;		// main ALU result
    logic                           cmp_res_o;		// IALU comparison result

    // Address adder
    logic [`SCR1_XLEN-1:0]          addr_op1_i;		// Address adder 1st operand
    logic [`SCR1_XLEN-1:0]          addr_op2_i;		// Address adder 2nd operand
    logic [`SCR1_XLEN-1:0]          addr_res_o;		// Address adder result

endinterface

