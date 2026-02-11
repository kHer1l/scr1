// scr1_pipe_ialu_mont.svh
class scr1_pipe_ialu_mont extends uvm_monitor; // [UVM] class
	`uvm_component_utils(scr1_pipe_ialu_mont) // [UVM] macro
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual scr1_pipe_ialu_if scr1_pipe_ialu_if_h; // out interface
	
	scr1_pipe_ialu_aprt scr1_pipe_ialu_aprt_i; // analysis port, input
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_i; // transaction, input
	scr1_pipe_ialu_aprt scr1_pipe_ialu_aprt_o; // analysis port, output
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_o; // transaction, output
	
	function void build_phase(uvm_phase phase); // [UVM] build phase
		// build analysis ports
		scr1_pipe_ialu_aprt_i = new("scr1_pipe_ialu_aprt_i",this);
		scr1_pipe_ialu_aprt_o = new("scr1_pipe_ialu_aprt_o",this);
	endfunction
	
	task run_phase(uvm_phase phase); // [UVM] run phase
		forever @(posedge scr1_pipe_ialu_if_h.clk) begin
		`ifdef SCR1_RVM_EXT 
			if (scr1_pipe_ialu_if_h.rvm_res_rdy_o) 
		`endif // SCR1_RVM_EXT
			begin
				scr1_pipe_ialu_seqi_i = scr1_pipe_ialu_seqi::type_id::create("scr1_pipe_ialu_seqi_i");
				scr1_pipe_ialu_seqi_i.main_op1 = scr1_pipe_ialu_if_h.main_op1_i;
				scr1_pipe_ialu_seqi_i.main_op2 = scr1_pipe_ialu_if_h.main_op2_i;
				scr1_pipe_ialu_seqi_i.cmd	   = scr1_pipe_ialu_if_h.cmd_i;
				scr1_pipe_ialu_seqi_i.addr_op1 = scr1_pipe_ialu_if_h.addr_op1_i;
				scr1_pipe_ialu_seqi_i.addr_op2 = scr1_pipe_ialu_if_h.addr_op2_i;
				scr1_pipe_ialu_aprt_i.write(scr1_pipe_ialu_seqi_i); // [UVM] write to aprt
			end
			
		`ifdef SCR1_RVM_EXT 
			if (scr1_pipe_ialu_if_h.rvm_res_rdy_o) 
		`endif // SCR1_RVM_EXT
			begin
				scr1_pipe_ialu_seqi_o = scr1_pipe_ialu_seqi::type_id::create("scr1_pipe_ialu_seqi_o");
				scr1_pipe_ialu_seqi_o.main_res = scr1_pipe_ialu_if_h.main_res_o;
				scr1_pipe_ialu_seqi_o.cmp_res  = scr1_pipe_ialu_if_h.cmp_res_o;
				scr1_pipe_ialu_seqi_o.addr_res = scr1_pipe_ialu_if_h.addr_res_o;
				scr1_pipe_ialu_aprt_o.write(scr1_pipe_ialu_seqi_o); // [UVM] write to aprt
			end
		end
	endtask
	
endclass