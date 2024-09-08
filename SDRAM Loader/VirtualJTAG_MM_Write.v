module VirtualJTAG_MM_Write(
  input        ipClk,
  input        ipReset,

  output reg   opBusy,

  output [23:0]opAvalon_Address,
  output [ 3:0]opAvalon_ByteEnable,
  input        ipAvalon_WaitRequest,

  output [31:0]opAvalon_WriteData,
  output reg   opAvalon_Write,

  output       opAvalon_Read,
  input  [31:0]ipAvalon_ReadData,
  input        ipAvalon_ReadDataValid
);

assign opAvalon_ByteEnable = 4'b1111;
assign opAvalon_Read       = 1'b0;
//------------------------------------------------------------------------------

reg  TDO;
wire TCK;
wire TDI;

wire [7:0]Instruction;
wire      Capture;
wire      Shift;
wire      Update;

sld_virtual_jtag #(
  .sld_auto_instance_index("NO"),
  .sld_instance_index     (0),
  .sld_ir_width           (8)

)virtual_jtag_0(
  .tck              (TCK),
  .tdi              (TDI),
  .tdo              (TDO),

  .ir_in            (Instruction),
  .virtual_state_cdr(Capture),
  .virtual_state_sdr(Shift  ),
  .virtual_state_udr(Update )
);
//------------------------------------------------------------------------------

reg [12:0]WrAddress;

altsyncram #(
  // General parameters
  .intended_device_family("MAX 10"),
  .lpm_type              ("altsyncram"),
  .operation_mode        ("DUAL_PORT"),
  .power_up_uninitialized("FALSE"),
  .ram_block_type        ("M9K"),

  // Port A parameters
  .clock_enable_input_a  ("BYPASS"),
  .numwords_a            (8192),
  .widthad_a             (13),
  .width_a               (1),
  .width_byteena_a       (1),

  // Port B parameters
  .address_aclr_b        ("NONE"),
  .address_reg_b         ("CLOCK1"),
  .clock_enable_input_b  ("BYPASS"),
  .clock_enable_output_b ("BYPASS"),
  .numwords_b            (256),
  .outdata_aclr_b        ("NONE"),
  .outdata_reg_b         ("UNREGISTERED"),
  .widthad_b             (8),
  .width_b               (32)

)altsyncram_component(
  // Write port
  .clock0        (TCK),
  .address_a     (WrAddress),
  .data_a        (TDI),
  .wren_a        (Shift),

  // Read port
  .clock1        (ipClk),
  .address_b     (opAvalon_Address[7:0]),
  .q_b           (opAvalon_WriteData),

  // Unused features
  .aclr0         (1'b0),
  .aclr1         (1'b0),
  .addressstall_a(1'b0),
  .addressstall_b(1'b0),
  .byteena_a     (1'b1),
  .byteena_b     (1'b1),
  .clocken0      (1'b1),
  .clocken1      (1'b1),
  .clocken2      (1'b1),
  .clocken3      (1'b1),
  .data_b        ({16{1'b1}}),
  .eccstatus     (),
  .q_a           (),
  .rden_a        (1'b1),
  .rden_b        (1'b1),
  .wren_b        (1'b0)
);
//------------------------------------------------------------------------------

reg JTAG_Reset;
reg JTAG_Busy;

always @(posedge TCK) begin
  JTAG_Reset <= ipReset;

  if(JTAG_Reset) begin
    TDO       <= 0;
    WrAddress <= 0;
    JTAG_Busy <= 0;

  end else begin
    case(1'b1)
      Capture: begin
        WrAddress <= 0;
        JTAG_Busy <= 1'b1;
      end

      Shift: begin
        WrAddress <= WrAddress + 1'b1;
      end

      Update: begin
        JTAG_Busy <= 1'b0;
      end

      default:;
    endcase
  end
end
//------------------------------------------------------------------------------

reg       Local_Reset;
reg [ 1:0]TCK_Sync;
reg [12:0]WrAddress_Sync;
reg       Capture_Sync;

always @(posedge ipClk) begin
  Local_Reset  <=  ipReset;
  TCK_Sync     <= {TCK_Sync[0], TCK};
  Capture_Sync <=  Capture;
  //----------------------------------------------------------------------------

  if(Local_Reset || Capture_Sync) begin
    opAvalon_Address <= 0;
    opAvalon_Write   <= 0;
    WrAddress_Sync   <= 0;
  //----------------------------------------------------------------------------

  end else begin
    if(TCK_Sync == 2'b10) WrAddress_Sync <= WrAddress;

    if(~opAvalon_Write) begin // Idle
      if(WrAddress_Sync[12:5] != opAvalon_Address[7:0]) begin
        opBusy         <= 1'b1;
        opAvalon_Write <= 1'b1;

      end else begin
        opBusy <= JTAG_Busy;
      end

    end else begin // Writing
      if(~ipAvalon_WaitRequest) begin
        opAvalon_Address <= opAvalon_Address + 1'b1;
        opAvalon_Write   <= 0;
      end
    end
  end
end
//------------------------------------------------------------------------------

endmodule
//------------------------------------------------------------------------------

