// scr1_pipe_ialu_seqc_default.svh
class scr1_pipe_ialu_seqc_default extends uvm_sequence #(scr1_pipe_ialu_seqi); // [UVM] class
	`uvm_object_utils(scr1_pipe_ialu_seqc_default) // [UVM] macro
	function new(string name = "scr1_pipe_ialu_seqc_default");
		super.new(name);
	endfunction
	
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h;
	
	task body();
		repeat(100) begin
			scr1_pipe_ialu_seqi_h = scr1_pipe_ialu_seqi::type_id::create("scr1_pipe_ialu_seqi_h");
			start_item(scr1_pipe_ialu_seqi_h); // [UVM] start transaction
			assert(scr1_pipe_ialu_seqi_h.randomize());
			finish_item(scr1_pipe_ialu_seqi_h); // [UVM] finish transaction
		end
	endtask
	
	
endclass
	