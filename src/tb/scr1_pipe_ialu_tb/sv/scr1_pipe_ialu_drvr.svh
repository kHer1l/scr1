// scr1_pipe_ialu_drvr.svh
class scr1_pipe_ialu_drvr extends uvm_driver #(scr1_pipe_ialu_seqi); // [UVM] class
	`uvm_component_utils(scr1_pipe_ialu_drvr) // [UVM] macro
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual scr1_pipe_ialu_if scr1_pipe_ialu_if_h; // our interface
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h; // handler for transactions

	task run_phase(uvm_phase phase); // [UVM] run phase
		forever begin
			seq_item_port.get_next_item(scr1_pipe_ialu_seqi_h); // [UVM] request transactions
			
		`ifdef SCR1_RVM_EXT
			wait(scr1_pipe_ialu_if_h.rvm_res_rdy_o);
		`endif // SCR1_RVM_EXT
			
			// Main adder
			@(posedge scr1_pipe_ialu_if_h.clk)
				scr1_pipe_ialu_if_h.cmd_i <= scr1_pipe_ialu_seqi_h.cmd;
			if (scr1_pipe_ialu_seqi_h.cmd != SCR1_IALU_CMD_NONE) begin
				scr1_pipe_ialu_if_h.main_op1_i <= scr1_pipe_ialu_seqi_h.main_op1;
				scr1_pipe_ialu_if_h.main_op2_i <= scr1_pipe_ialu_seqi_h.main_op2;
			end else begin
				scr1_pipe_ialu_if_h.main_op1_i <= '0;
				scr1_pipe_ialu_if_h.main_op2_i <= '0;
			end
		`ifdef SCR1_RVM_EXT
			case (scr1_pipe_ialu_seqi_h.cmd)
				SCR1_IALU_CMD_MUL, SCR1_IALU_CMD_MULHU, SCR1_IALU_CMD_MULHSU,
				SCR1_IALU_CMD_MULH, SCR1_IALU_CMD_DIV, SCR1_IALU_CMD_DIVU,    
				SCR1_IALU_CMD_REM, SCR1_IALU_CMD_REMU : scr1_pipe_ialu_if_h.rvm_cmd_vd_i = 1'b1;
				default: scr1_pipe_ialu_if_h.rvm_cmd_vd_i = 1'b0;
			endcase
		`endif // SCR1_RVM_EXT
				
			// Address adder
			scr1_pipe_ialu_if_h.addr_op1_i <= scr1_pipe_ialu_seqi_h.addr_op1;
			scr1_pipe_ialu_if_h.addr_op2_i <= scr1_pipe_ialu_seqi_h.addr_op2;
			
			seq_item_port.item_done(); // [UVM] finish transactions
		end
	endtask
	
endclass