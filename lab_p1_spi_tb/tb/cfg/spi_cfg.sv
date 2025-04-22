//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_cfg extends uvm_object;

  `uvm_object_utils(spi_cfg)
  
  string  my_name;
  integer  num_dwords;
	bit     tx_done;
	integer clk_cnt_ss; // used to count number of SPI clock cycles during transmission
  rand bit     inject_error;
	rand bit [7:0] num_chars;
	bit [127:0]    mask;
	bit [31:0]     mask_arr[4];
	rand integer mode;
	rand bit bit_ass; // control reg bits
	rand bit bit_ie; // control reg bits
	rand bit bit_lsb; // control reg bits
	rand bit bit_txneg; // control reg bits
	rand bit bit_rxneg; // control reg bits
	rand bit bit_gobsy; // control reg bits
	rand integer  max_loop; // control reg bits
	event sample_e;
    
	// Capture coverage of control bits
	covergroup cfg_cov_grp @sample_e;
		ass_cov: coverpoint bit_ass {
			bins ass[] = {0,1};
		}
		ie_cov: coverpoint bit_ie {
			bins ie[] = {0,1};
		}
		lsb_cov: coverpoint bit_lsb {
			bins lsb[] = {0,1};
		}
		txneg_cov: coverpoint bit_txneg {
			bins txneg[] = {0,1};
		}
		rxneg_cov: coverpoint bit_rxneg {
			bins rxneg[] = {0,1};
		}
		num_chars_cov: coverpoint num_chars {
			bins num_chars_lo = {1};
			bins num_chars_mid = {[2:127]};
			bins num_chars_hi = {128};
		}
		maxloop_cov: coverpoint max_loop {
			bins maxloop[5] = {[2:6]};
		}
	endgroup
  
  function new(string name = "");
    super.new(name);
    my_name = name;
		cfg_cov_grp = new;
  endfunction

	// virtual function to support the print() function
  function void do_print(uvm_printer printer);
    printer.print_field("inject_error",inject_error,$bits(inject_error));
    printer.print_field("max_loop",max_loop,$bits(max_loop));
    printer.print_field("bit_ass",bit_ass,$bits(bit_ass));
    printer.print_field("bit_ie",bit_ie,$bits(bit_ie));
    printer.print_field("bit_lsb",bit_lsb,$bits(bit_lsb));
    printer.print_field("bit_txneg",bit_txneg,$bits(bit_txneg));
    printer.print_field("bit_rxneg",bit_rxneg,$bits(bit_rxneg));
    printer.print_field("num_chars",num_chars,$bits(num_chars));
  endfunction

	function void start_tx;
		tx_done = 0;
		clk_cnt_ss = 0;
	endfunction
  
	function void stop_tx;
		tx_done = 1;
	endfunction
  
	// Set the proper masking for the Rx regs based on the number of
	// bits in num_chars
  function void set_mask;
		mask = 0;
		for (int ii=0; ii<num_chars; ii++) begin
			mask[ii] = 1;
		end
		mask_arr[0] = mask[31:0];
		mask_arr[1] = mask[63:32];
		mask_arr[2] = mask[95:64];
		mask_arr[3] = mask[127:96];
		if (num_dwords % 32 == 0) begin
			num_dwords = num_chars / 32;
		end else begin
			num_dwords = (num_chars / 32) + 1;
		end
	endfunction

  constraint default_config_c {
    inject_error == 0;
		num_chars inside {[52:128]};
		max_loop inside {[2:6]};
		//max_loop == 1;
		(mode == 0) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
		(mode == 1) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 1;
				bit_rxneg == 0;
				bit_gobsy == 1;
		}
		(mode == 2) -> {
				bit_ass   == 1;
				bit_ie    == 1;
				bit_lsb   == 0;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
		(mode == 3) -> {
				bit_ass   == 0;
				bit_ie    == 1;
				bit_lsb   == 1;
				bit_txneg == 0;
				bit_rxneg == 1;
				bit_gobsy == 1;
		}
  }
  
endclass
