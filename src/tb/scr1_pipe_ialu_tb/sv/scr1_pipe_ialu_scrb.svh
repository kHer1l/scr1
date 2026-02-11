// scr1_pipe_ialu_scrb.svh
`uvm_analysis_imp_decl(_i) // [UVM] macro
`uvm_analysis_imp_decl(_o) // [UVM] macro

class scr1_pipe_ialu_scrb extends uvm_scoreboard; // [UVM] class
	`uvm_component_utils(scr1_pipe_ialu_scrb); // [UVM] macro
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	uvm_analysis_imp_i #(scr1_pipe_ialu_seqi, scr1_pipe_ialu_scrb) scr1_pipe_ialu_aprt_i;
	uvm_analysis_imp_o #(scr1_pipe_ialu_seqi, scr1_pipe_ialu_scrb) scr1_pipe_ialu_aprt_o;
		
	function void build_phase(uvm_phase phase); // [UVM] build phase
		scr1_pipe_ialu_aprt_i = new("scr1_pipe_ialu_aprt_i",this);
		scr1_pipe_ialu_aprt_o = new("scr1_pipe_ialu_aprt_o",this);
	endfunction
	
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_queue_i[$];
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_queue_o[$];
	
	virtual function void write_i(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
		scr1_pipe_ialu_seqi_queue_i.push_back(scr1_pipe_ialu_seqi_h);
	endfunction
	virtual function void write_o(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
		scr1_pipe_ialu_seqi_queue_o.push_back(scr1_pipe_ialu_seqi_h);
		processing();
	endfunction
	
	extern function void processing();
	
	extern virtual function bit [`SCR1_XLEN-1:0] get_main_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	extern virtual function bit get_cmp_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	extern virtual function bit [`SCR1_XLEN-1:0] get_addr_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	
endclass

function void scr1_pipe_ialu_scrb::processing();
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_i;
	scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_o;
	string data_str;
	
	scr1_pipe_ialu_seqi_i = scr1_pipe_ialu_seqi_queue_i.pop_front();
	scr1_pipe_ialu_seqi_i.main_res = get_main_res(scr1_pipe_ialu_seqi_i);
	scr1_pipe_ialu_seqi_i.cmp_res = get_cmp_res(scr1_pipe_ialu_seqi_i);
	scr1_pipe_ialu_seqi_i.addr_res = get_addr_res(scr1_pipe_ialu_seqi_i);
	
	scr1_pipe_ialu_seqi_o = scr1_pipe_ialu_seqi_queue_o.pop_front();
	scr1_pipe_ialu_seqi_o.main_op1 = scr1_pipe_ialu_seqi_i.main_op1;
	scr1_pipe_ialu_seqi_o.main_op2 = scr1_pipe_ialu_seqi_i.main_op2;
	scr1_pipe_ialu_seqi_o.cmd 	   = scr1_pipe_ialu_seqi_i.cmd;
	scr1_pipe_ialu_seqi_o.addr_op1 = scr1_pipe_ialu_seqi_i.addr_op1;
	scr1_pipe_ialu_seqi_o.addr_op2 = scr1_pipe_ialu_seqi_i.addr_op2;
	
	data_str = {
		"\n", "actual:    ", scr1_pipe_ialu_seqi_o.convert2string(),
		"\n", "predicted: ", scr1_pipe_ialu_seqi_i.convert2string()
	};
	
	if (!scr1_pipe_ialu_seqi_i.compare(scr1_pipe_ialu_seqi_o)) begin
		`uvm_error("FAIL", data_str)
	end else
		`uvm_info("PASS", data_str, UVM_NONE) // UVM_HIGH, UVM_NONE
endfunction

function bit [`SCR1_XLEN-1:0] scr1_pipe_ialu_scrb::get_main_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	bit [`SCR1_XLEN-1:0] res;
	bit signed [`SCR1_XLEN-1:0] op1 = scr1_pipe_ialu_seqi_h.main_op1;
	bit signed [`SCR1_XLEN-1:0] op2 = scr1_pipe_ialu_seqi_h.main_op2;
	case (scr1_pipe_ialu_seqi_h.cmd)
		SCR1_IALU_CMD_AND		: res = op1 & op2;
		SCR1_IALU_CMD_OR		: res = op1 | op2;
		SCR1_IALU_CMD_XOR		: res = op1 ^ op2;
		SCR1_IALU_CMD_ADD		: res = op1 + op2;
		SCR1_IALU_CMD_SUB		: res = op1 - op2;
		SCR1_IALU_CMD_SUB_LT	: res = op1 < op2;
		SCR1_IALU_CMD_SUB_LTU	: res = $unsigned(op1) < $unsigned(op2);
		SCR1_IALU_CMD_SUB_EQ	: res = op1 == op2;
		SCR1_IALU_CMD_SUB_NE	: res = {{`SCR1_XLEN-1{1'b1}}, op1 != op2};
		SCR1_IALU_CMD_SUB_GE	: res = {{`SCR1_XLEN-1{1'b1}}, op1 >= op2};
		SCR1_IALU_CMD_SUB_GEU	: res = {{`SCR1_XLEN-1{1'b1}}, $unsigned(op1) >= $unsigned(op2)};
		SCR1_IALU_CMD_SLL		: res = op1 << op2[$clog2(`SCR1_XLEN)-1:0];
		SCR1_IALU_CMD_SRL		: res = op1 >> op2[$clog2(`SCR1_XLEN)-1:0];
		SCR1_IALU_CMD_SRA		: res = op1 >>> op2[$clog2(`SCR1_XLEN)-1:0];
	`ifdef SCR1_RVM_EXT
		SCR1_IALU_CMD_MUL		: res = $unsigned(op1)*$unsigned(op2);
		SCR1_IALU_CMD_MULHU		: begin bit [`SCR1_XLEN*2-1:0] mul_res = $unsigned(op1)*$unsigned(op2); res = mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]; end
		SCR1_IALU_CMD_MULHSU	: begin bit [`SCR1_XLEN*2-1:0] mul_res = op1*$signed({1'b0,op2}); res = mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]; end
		SCR1_IALU_CMD_MULH		: begin bit [`SCR1_XLEN*2-1:0] mul_res = op1*op2; res = mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]; end
		SCR1_IALU_CMD_DIV		: res = op1 / op2;
		SCR1_IALU_CMD_DIVU		: res = $unsigned(op1) / $unsigned(op2);
		SCR1_IALU_CMD_REM		: res = op1 % op2;
		SCR1_IALU_CMD_REMU      : res = $unsigned(op1) % $unsigned(op2);
	`endif  // SCR1_RVM_EXT
		default	: res = '0;
	endcase
	return res;
endfunction

function bit scr1_pipe_ialu_scrb::get_cmp_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	bit res;
	bit signed [`SCR1_XLEN-1:0] op1 = scr1_pipe_ialu_seqi_h.main_op1;
	bit signed [`SCR1_XLEN-1:0] op2 = scr1_pipe_ialu_seqi_h.main_op2;
	case (scr1_pipe_ialu_seqi_h.cmd)
		SCR1_IALU_CMD_SUB_LT : res = op1 < op2;
		SCR1_IALU_CMD_SUB_LTU: res = $unsigned(op1) < $unsigned(op2);
		SCR1_IALU_CMD_SUB_EQ : res = op1 == op2;
		SCR1_IALU_CMD_SUB_NE : res = op1 != op2;
		SCR1_IALU_CMD_SUB_GE : res = op1 >= op2;
		SCR1_IALU_CMD_SUB_GEU: res = $unsigned(op1) >= $unsigned(op2);
		default: res = 1'b0;
	endcase
	return res;
endfunction

function bit [`SCR1_XLEN-1:0] scr1_pipe_ialu_scrb::get_addr_res(scr1_pipe_ialu_seqi scr1_pipe_ialu_seqi_h);
	return scr1_pipe_ialu_seqi_h.addr_op1 + scr1_pipe_ialu_seqi_h.addr_op2;
endfunction