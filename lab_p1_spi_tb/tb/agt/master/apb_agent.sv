//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class apb_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(apb_agent #(REQ,RSP))
   
   typedef apb_driver #(REQ,RSP) apb_driver_t;
   typedef uvm_sequencer #(REQ,RSP) apb_sequencer_t;
   
   string   my_name;
   
   apb_sequencer_t  sequencer;
   apb_driver_t      driver ;
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = apb_sequencer_t::type_id::create("apb_sequencer",this);
      driver = apb_driver_t::type_id::create("apb_driver",this);
   endfunction
   
   function void connect;
      //
      // Connect the sequencer to the driver
      //
      driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction
   
   task run;
   endtask
   
endclass
