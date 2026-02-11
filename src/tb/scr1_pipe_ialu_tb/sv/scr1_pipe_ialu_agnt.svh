// scr1_pipe_ialu_agnt.svh
class scr1_pipe_ialu_agnt extends uvm_agent; // [UVM] class
	`uvm_component_utils(scr1_pipe_ialu_agnt) // [UVM] macro
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	extern function void build_phase(uvm_phase phase); // [UVM] build_phase
	extern function void connect_phase(uvm_phase phase); // [UVM] connect phase
	
	virtual scr1_pipe_ialu_if scr1_pipe_ialu_if_h; // our interface
	
	scr1_pipe_ialu_seqr scr1_pipe_ialu_seqr_h;
	scr1_pipe_ialu_drvr scr1_pipe_ialu_drvr_h;
	scr1_pipe_ialu_mont scr1_pipe_ialu_mont_h;
	scr1_pipe_ialu_scrb scr1_pipe_ialu_scrb_h;
	
endclass

function void scr1_pipe_ialu_agnt::build_phase(uvm_phase phase);
	scr1_pipe_ialu_seqr_h = uvm_sequencer #(scr1_pipe_ialu_seqi)::type_id::create("scr1_pipe_ialu_seqr_h", this);
	scr1_pipe_ialu_drvr_h = scr1_pipe_ialu_drvr::type_id::create("scr1_pipe_ialu_drvr_h", this);
	scr1_pipe_ialu_mont_h = scr1_pipe_ialu_mont::type_id::create("scr1_pipe_ialu_mont_h", this);
	scr1_pipe_ialu_scrb_h = scr1_pipe_ialu_scrb::type_id::create("scr1_pipe_ialu_scrb_h", this);
	
	scr1_pipe_ialu_drvr_h.scr1_pipe_ialu_if_h = this.scr1_pipe_ialu_if_h;
	scr1_pipe_ialu_mont_h.scr1_pipe_ialu_if_h = this.scr1_pipe_ialu_if_h;
endfunction

function void scr1_pipe_ialu_agnt::connect_phase(uvm_phase phase);
	scr1_pipe_ialu_drvr_h.seq_item_port.connect(scr1_pipe_ialu_seqr_h.seq_item_export);
	scr1_pipe_ialu_mont_h.scr1_pipe_ialu_aprt_i.connect(scr1_pipe_ialu_scrb_h.scr1_pipe_ialu_aprt_i);
	scr1_pipe_ialu_mont_h.scr1_pipe_ialu_aprt_o.connect(scr1_pipe_ialu_scrb_h.scr1_pipe_ialu_aprt_o);
endfunction