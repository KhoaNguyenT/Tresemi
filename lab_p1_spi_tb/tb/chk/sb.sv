//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************

//============================================================================================================================
// Scoreboard responsible for data checking
//============================================================================================================================
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

	`uvm_component_param_utils(sb #(REQ))
  
	uvm_tlm_analysis_fifo #(REQ) ref_ap_fifo; // reference data for outbound APB -> SPI
	uvm_tlm_analysis_fifo #(REQ) act_ap_fifo; // actual data for outbound APB -> SPI
	uvm_tlm_analysis_fifo #(REQ) ref_inb_ap_fifo; // reference data for inbound APB <- SPI
	uvm_tlm_analysis_fifo #(REQ) act_inb_ap_fifo; // actual data for inbound APB <- SPI
   string  my_name;
	spi_cfg spi_cfg_h;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
  endfunction
		
	function void build_phase(uvm_phase phase);
		ref_ap_fifo = new("ref_ap_fifo",this);
		act_ap_fifo = new("act_ap_fifo",this);
		ref_inb_ap_fifo = new("ref_inb_ap_fifo",this);
		act_inb_ap_fifo = new("act_inb_ap_fifo",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
			`uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
		end
	endfunction

  task monitor_outbound;
		REQ ref_pkt;
		REQ act_pkt;
		bit [31:0] ref_mosi;
		bit [31:0] act_miso;

		forever begin
			act_ap_fifo.get(act_pkt);
			`uvm_info(my_name,$psprintf("Received act_pkt miso = %0x",act_pkt.miso),UVM_NONE)
			if (ref_ap_fifo.is_empty()) begin
				`uvm_fatal(my_name,"ref_ap_fifo is empty")
			end else begin
				ref_ap_fifo.get(ref_pkt);
				ref_mosi = ref_pkt.mosi; // & spi_cfg_h.mask;
				act_miso = act_pkt.miso; // & spi_cfg_h.mask;
				if (ref_mosi == act_miso) begin
					`uvm_info(my_name,$psprintf("Matched mosi = %0x",ref_mosi),UVM_NONE)
				end else begin
					`uvm_error(my_name,$psprintf("Mismatched ref mosi = %0x, act miso = %0x",ref_mosi,act_miso))
				end
			end
		end
	endtask

  task monitor_inbound;
		REQ ref_pkt;
		REQ act_pkt;
		bit [31:0] ref_miso;
		bit [31:0] act_miso;

		forever begin
			act_inb_ap_fifo.get(act_pkt);
			`uvm_info(my_name,$psprintf("Received act_pkt miso = %0x",act_pkt.miso),UVM_NONE)
			if (ref_inb_ap_fifo.is_empty()) begin
				`uvm_fatal(my_name,"ref_ap_fifo is empty")
			end else begin
				ref_inb_ap_fifo.get(ref_pkt);
				ref_miso = ref_pkt.miso; // & spi_cfg_h.mask;
				act_miso = act_pkt.miso; // & spi_cfg_h.mask;
				if (ref_miso == act_miso) begin
					`uvm_info(my_name,$psprintf("Matched miso = %0x",ref_miso),UVM_NONE)
				end else begin
					`uvm_error(my_name,$psprintf("Mismatched ref miso = %0x, act miso = %0x",ref_miso,act_miso))
				end
			end
		end
	endtask

  task run_phase(uvm_phase phase);
		fork
			monitor_outbound();
			monitor_inbound();
		join
	endtask

endclass
