// scr1_pipe_ialu_seqi.svh

class scr1_pipe_ialu_seqi extends uvm_sequence_item; // [UVM] class
	`uvm_object_utils(scr1_pipe_ialu_seqi); // [UVM] macro
	
	function new(string name = "scr1_pipe_ialu_seqi");
		super.new(name);
	endfunction
	
	// Main adder
	rand bit [`SCR1_XLEN-1:0]		main_op1;
	rand bit [`SCR1_XLEN-1:0]		main_op2;
	rand type_scr1_ialu_cmd_sel_e	cmd;
	//rand type_scr1_ialu_cmd_sel_e	cmd [];
	bit [`SCR1_XLEN-1:0]			main_res;
	bit 							cmp_res;
	
	// Address adder
	rand bit [`SCR1_XLEN-1:0]		addr_op1;
	rand bit [`SCR1_XLEN-1:0]		addr_op2;
	bit [`SCR1_XLEN-1:0]			addr_res;
	
/*  constraint c_main_op {
		main_op1 inside {[0:4095]};
		main_op2 inside {[0:4095]};
	}  */
	
/* 	constraint c_cmd {
		cmd inside {
			SCR1_IALU_CMD_NONE  = '0,   // IALU disable
			SCR1_IALU_CMD_AND,          // op1 & op2
			SCR1_IALU_CMD_OR,           // op1 | op2
			SCR1_IALU_CMD_XOR,          // op1 ^ op2
			SCR1_IALU_CMD_ADD,          // op1 + op2
			SCR1_IALU_CMD_SUB,          // op1 - op2
			SCR1_IALU_CMD_SUB_LT,       // op1 < op2
			SCR1_IALU_CMD_SUB_LTU,      // op1 u< op2
			SCR1_IALU_CMD_SUB_EQ,       // op1 = op2
			SCR1_IALU_CMD_SUB_NE,       // op1 != op2
			SCR1_IALU_CMD_SUB_GE,       // op1 >= op2
			SCR1_IALU_CMD_SUB_GEU,      // op1 u>= op2
			SCR1_IALU_CMD_SLL,          // op1 << op2
			SCR1_IALU_CMD_SRL,          // op1 >> op2
			SCR1_IALU_CMD_SRA           // op1 >>> op2
		`ifdef SCR1_RVM_EXT
			,
			SCR1_IALU_CMD_MUL,          // low(unsig(op1) * unsig(op2))
			SCR1_IALU_CMD_MULHU,        // high(unsig(op1) * unsig(op2))
			SCR1_IALU_CMD_MULHSU,       // high(op1 * unsig(op2))
			SCR1_IALU_CMD_MULH,         // high(op1 * op2)
			SCR1_IALU_CMD_DIV,          // op1 / op2
			SCR1_IALU_CMD_DIVU,         // op1 u/ op2
			SCR1_IALU_CMD_REM,          // op1 % op2
			SCR1_IALU_CMD_REMU          // op1 u% op2
		`endif  // SCR1_RVM_EXT
		};
	} */

/*	constraint c_addr_op {
		unique {addr_op1, addr_op2};
	} */	
	
	extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	extern function string convert2string();
	
endclass	

function bit scr1_pipe_ialu_seqi::do_compare(uvm_object rhs, uvm_comparer comparer);
	scr1_pipe_ialu_seqi RHS;
	bit same;
	
	same = super.do_compare(rhs, comparer); // [UVM] call parent
	
	$cast(RHS,rhs);
	same = (main_op1 == RHS.main_op1 && main_op2 == RHS.main_op2 &&
			main_res == RHS.main_res && cmp_res  == RHS.cmp_res  &&
			addr_op1 == RHS.addr_op1 && addr_op2 == RHS.addr_op2 &&
			addr_res == RHS.addr_res)&& same;
	return same;
endfunction

function string scr1_pipe_ialu_seqi::convert2string();
	string s;
	s = $sformatf("main_op1 = %h, main_op2 = %h, cmd = %s, main_res = %h, cmp_res = %h, addr_op1 = %h, addr_op2 = %h, addr_res = %h", 
					main_op1, main_op2, cmd, main_res, cmp_res, addr_op1, addr_op2, addr_res);
	return s;
endfunction