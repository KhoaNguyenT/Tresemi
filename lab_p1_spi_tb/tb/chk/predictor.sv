
//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
// Predictor responsible for generating a reference packet
//============================================================================================================================
`uvm_analysis_imp_decl(_apb_ap_imp)
`uvm_analysis_imp_decl(_spi_ap_imp)

class predictor extends uvm_component;
	`uvm_component_utils(predictor)

	typedef sb_tlm REQ;
        string  my_name;
	uvm_analysis_imp_apb_ap_imp #(REQ,predictor) apb_ap_imp; // APB writes to Tx regs
	uvm_analysis_port #(REQ) ref_apb_ap;
	uvm_analysis_imp_spi_ap_imp #(REQ,predictor) spi_ap_imp; // APB reads of Rx regs
	uvm_analysis_port #(REQ) act_spi_ap;
	integer ref_pkt_cnt;
	integer act_pkt_cnt;
	spi_cfg spi_cfg_h;
	bit [31:0] mosi;
	bit [31:0] miso;
  
        function new(string name, uvm_component parent);
                super.new(name,parent);
                my_name = name;
		ref_apb_ap = new("ref_apb_ap",this);
		act_spi_ap = new("act_spi_ap",this);
		reset();
        endfunction

	function void reset;
		`uvm_info(my_name,"Predictor resetting",UVM_NONE)
		ref_pkt_cnt = 0;
		act_pkt_cnt = 0;
		miso = 0;
	endfunction

	function void build_phase(uvm_phase phase);
		apb_ap_imp = new("apb_ap_imp",this);
		spi_ap_imp = new("spi_ap_imp",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if( !uvm_config_db #(spi_cfg)::get(this,"","SPI_CFG",spi_cfg_h) ) begin
			`uvm_error(my_name, "Could not retrieve virtual spi_cfg_h")
		end
	endfunction

	// ==================================================================================================
	// After performing an APB write to a Tx register, the driver sends the packet here
	// The assumption is the sequence must perform writes to all four Tx registers before starting a
	// new transmission.
	// ==================================================================================================
	function void write_apb_ap_imp(REQ req_pkt);
		REQ ref_pkt;
                integer i;
                //bit [31:0] temp [3:0];

		`uvm_info(my_name,$psprintf("Write to address %0d wdata=%0x",req_pkt.addr,req_pkt.wdata),UVM_NONE)
                mosi = req_pkt.wdata;

                if (ref_pkt_cnt < spi_cfg_h.num_dwords)
                begin
                  ref_pkt = REQ::type_id::create($psprintf("ref_pkt_%d", ref_pkt_cnt) );
                  `uvm_info(my_name, $psprintf("assigning miso = %0x", miso), UVM_NONE)
                  ref_pkt.mosi = mosi;
                  ref_apb_ap.write(ref_pkt);
                  ref_pkt_cnt++;
                end 
                else ref_pkt_cnt = 0;
      
	endfunction

	// ==================================================================================================
	// Read num_dwords of Rx regs to generate an actual packet to send to the SB
	// ==================================================================================================
	function void write_spi_ap_imp(REQ req_pkt);
		REQ act_pkt;

		`uvm_info(my_name,$psprintf("Read at address %0d rdata=%0x",req_pkt.addr,req_pkt.rdata),UVM_NONE)
		miso = req_pkt.rdata;
    
    if (act_pkt_cnt < spi_cfg_h.num_dwords)
    begin
      act_pkt = REQ::type_id::create($psprintf("sct_pkt_%d", act_pkt_cnt) );
      `uvm_info(my_name, $psprintf("assigning mosi = %0x", mosi), UVM_NONE)
      act_pkt.miso = miso;
      act_spi_ap.write(act_pkt);
      act_pkt_cnt++;
    end 
    else act_pkt_cnt = 0;
	endfunction

	virtual task run_phase(uvm_phase phase);
	endtask

endclass

