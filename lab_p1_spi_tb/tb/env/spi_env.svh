//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(spi_env #(REQ,RSP))
   
   string my_name;
   
   typedef apb_agent  #(REQ,RSP) apb_agent_t;
   apb_agent_t apb_agent_0;
   typedef spi_agent  #(REQ,RSP) spi_agent_t;
   spi_agent_t spi_agent_0;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
      apb_agent_0 = apb_agent_t::type_id::create("apb_agent_0",this);
      spi_agent_0 = spi_agent_t::type_id::create("spi_agent_0",this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
   endfunction
   
   task run_phase(uvm_phase phase);
      `uvm_info(my_name,"Running env ...",UVM_MEDIUM);
   endtask
   
   function void extract_phase(uvm_phase phase);
      `uvm_info(my_name,"Extract phase is called",UVM_NONE);
   endfunction
   
   function void check_phase(uvm_phase phase);
      `uvm_info(my_name,"Check phase is called",UVM_NONE);
   endfunction
   
endclass
