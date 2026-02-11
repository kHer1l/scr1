// scr1_pipe_ialu_test_default.svh
class scr1_pipe_ialu_test_default extends uvm_test; // [UVM] class
	`uvm_component_utils(scr1_pipe_ialu_test_default) // [UVM] macro
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual scr1_pipe_ialu_if scr1_pipe_ialu_if_h;
	
	scr1_pipe_ialu_agnt scr1_pipe_ialu_agnt_h;
	scr1_pipe_ialu_seqc_default scr1_pipe_ialu_seqc_default_h;
	
	function void build_phase(uvm_phase phase); // [UVM] build phase
		// get bfm from database
		if (!uvm_config_db #(virtual scr1_pipe_ialu_if)::get( // [UVM] try to get interface
			this, "", "scr1_pipe_ialu_if_h", scr1_pipe_ialu_if_h) // froom uvm database
		) `uvm_fatal("BFM","Failed to get bfm"); // otherwise throw error
	
		scr1_pipe_ialu_agnt_h = scr1_pipe_ialu_agnt::type_id::create("scr1_pipe_ialu_agnt_h", this);
		scr1_pipe_ialu_agnt_h.scr1_pipe_ialu_if_h = this.scr1_pipe_ialu_if_h;
	
		scr1_pipe_ialu_seqc_default_h = scr1_pipe_ialu_seqc_default::type_id::create("scr1_pipe_ialu_seqc_default_h", this);		
	endfunction
	
	task run_phase(uvm_phase phase); // [UVM] run phase
		phase.raise_objection(this); // [UVM] start sequence
		scr1_pipe_ialu_seqc_default_h.start(scr1_pipe_ialu_agnt_h.scr1_pipe_ialu_seqr_h);
		phase.drop_objection(this); // [UVM] finish sequence
	endtask
	
endclass	