// scr1_pipe_ialu_package.sv

package scr1_pipe_ialu_package;
	
	`include "scr1_arch_description.svh"
	import scr1_pkg::*;
	
	import uvm_pkg::*; // [UVM] package
	`include "uvm_macros.svh" // [UVM] macroses
	
	`include "scr1_pipe_ialu_seqi.svh"
	typedef uvm_sequencer #(scr1_pipe_ialu_seqi) scr1_pipe_ialu_seqr; // [UVM] sequencer
	
	`include "scr1_pipe_ialu_drvr.svh"
	
	typedef uvm_analysis_port #(scr1_pipe_ialu_seqi) scr1_pipe_ialu_aprt;
	`include "scr1_pipe_ialu_mont.svh"
	
	`include "scr1_pipe_ialu_scrb.svh"
	
	`include "scr1_pipe_ialu_agnt.svh"
	
	`include "scr1_pipe_ialu_seqc_default.svh"
	`include "scr1_pipe_ialu_test_default.svh"
endpackage