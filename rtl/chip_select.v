//

module chip_select
(
    input  [1:0] pcb,

    input [23:0] cpu_a,
    input        cpu_as_n,

    input [15:0] z80_addr,
    input        MREQ_n,
    input        IORQ_n,

    // M68K selects
    output       prog_rom_cs,
    output       ram_cs,
    output       scroll_ofs_x_cs,
    output       scroll_ofs_y_cs,
    output       frame_done_cs,
    output       int_en_cs,
    output       crtc_cs,
    output       tile_ofs_cs,
    output       tile_attr_cs,
    output       tile_num_cs,
    output       scroll_cs,
    output       shared_ram_cs,
    output       vblank_cs,
    output       tile_palette_cs,
    output       bcu_flip_cs,
    output       sprite_palette_cs,
    output       sprite_ofs_cs,
    output       sprite_cs,
    output       sprite_size_cs,
    output       sprite_ram_cs,
    output       fcu_flip_cs,
    output       reset_z80_cs,

    // Z180 selects
    output       credits_cs,
    output       p1_cs,
    output       p2_cs,
    output       dswa_cs,
    output       dswb_cs,
    output       system_cs,
    output       tjump_cs,
    output       sound0_cs,
    output       sound1_cs,

    // other params
    output reg [15:0] scroll_y_offset
);

localparam pcb_vimana   = 0;
localparam pcb_samesame = 1;

function m68k_cs;
        input [23:0] base_address;
        input  [7:0] width;
begin
    m68k_cs = ( cpu_a >> width == base_address >> width ) & !cpu_as_n;
end
endfunction

function z80_cs;
        input [7:0] address_lo;
begin
    z80_cs = ( IORQ_n == 0 && z80_addr[7:0] == address_lo );
end
endfunction

always @(*) begin

//    if (pcb == pcb_zero_wing || pcb == pcb_hellfire) begin
//        scroll_y_offset = 16;
//    end else begin
        scroll_y_offset = 0;
//    end


    // Setup lines depending on pcb
    case (pcb)
        pcb_vimana: begin
            prog_rom_cs       = m68k_cs( 'h000000, 18 );

            scroll_ofs_x_cs   = m68k_cs( 'h080000,  1 );
            scroll_ofs_y_cs   = m68k_cs( 'h080002,  1 );
            fcu_flip_cs       = m68k_cs( 'h080006,  1 );

            vblank_cs         = m68k_cs( 'h400000,  1 );
            int_en_cs         = m68k_cs( 'h400002,  1 );
            crtc_cs           = m68k_cs( 'h400008,  3 );

            tile_palette_cs   = m68k_cs( 'h404000, 11 );
            sprite_palette_cs = m68k_cs( 'h406000, 11 );

            shared_ram_cs     = m68k_cs( 'h440000, 11 );

            bcu_flip_cs       = m68k_cs( 'h4c0000,  1 );
            tile_ofs_cs       = m68k_cs( 'h4c0002,  1 );
            tile_attr_cs      = m68k_cs( 'h4c0004,  1 );
            tile_num_cs       = m68k_cs( 'h4c0006,  1 );
            scroll_cs         = m68k_cs( 'h4c0010,  4 );

            frame_done_cs     = m68k_cs( 'h0c0000,  1 );
            sprite_ofs_cs     = m68k_cs( 'h0c0002,  1 );
            sprite_cs         = m68k_cs( 'h0c0004,  1 );
            sprite_size_cs    = m68k_cs( 'h0c0006,  1 );

            reset_z80_cs      = 0;

            ram_cs            = m68k_cs( 'h480000, 14 );

            credits_cs    = m68k_cs( 'h440004,  1 );
            dswa_cs       = m68k_cs( 'h440006,  1 );
            system_cs     = m68k_cs( 'h440008,  1 );
            p1_cs         = m68k_cs( 'h44000a,  1 );
            p2_cs         = m68k_cs( 'h44000c,  1 );
            dswb_cs       = m68k_cs( 'h44000e,  1 );
            tjump_cs      = m68k_cs( 'h440010,  1 );

            sound0_cs     = z80_cs( 8'h87 );
            sound1_cs     = z80_cs( 8'h8f );
        end

/*
	map(0x480000, 0x487fff).ram();
	map(0x440004, 0x440005).lr16(NAME([]() -> u16 {  return 1; })); 	number of credits

	map(0x440006, 0x440007).portr("DSWA");
	map(0x440008, 0x440009).portr("SYSTEM"); 	needs special handling
	map(0x44000a, 0x44000b).portr("P1");
	map(0x44000c, 0x44000d).portr("P2");
	map(0x44000e, 0x44000f).portr("DSWB");
	map(0x440010, 0x440011).portr("TJUMP");

void toaplan1_state::vimana_hd647180_io_map(address_map &map)
{
	map.global_mask(0xff);
	map(0x32, 0x32).nopw(); // DMA WAIT/Control register
	map(0x33, 0x33).nopw(); // IL (int vector low) register
	map(0x36, 0x36).nopw(); // refresh control register for RFSH pin
	// 53: disable reg for port A
	map(0x60, 0x60).nopr(); // read/write port A
	// 61: read/write port B
	// 62: read/write port C
	// 63: read/write port D
	// 64: read/write port E
	// 65: read/write port F
	map(0x66, 0x66).nopr(); // read port G
	// 70: ddr for port A
	map(0x71, 0x71).nopw(); // ddr for port B
	map(0x72, 0x72).nopw(); // ddr for port C
	map(0x73, 0x73).nopw(); // ddr for port D
	map(0x74, 0x74).nopw(); // ddr for port E
	map(0x75, 0x75).nopw(); // ddr for port F
	map(0x80, 0x80).portr("P1");
	map(0x81, 0x81).portr("P2");
	map(0x82, 0x82).portr("DSWA");
	map(0x83, 0x83).portr("SYSTEM");
	map(0x84, 0x84).w(FUNC(toaplan1_state::coin_w));  // Coin counter/lockout // needs verify
	map(0x87, 0x87).rw("ymsnd", FUNC(ym3812_device::status_r), FUNC(ym3812_device::address_w));
	map(0x8f, 0x8f).w("ymsnd", FUNC(ym3812_device::data_w));
}

u8 toaplan1_state::vimana_dswb_invert_r()
{
	return m_dswb_io->read() ^ 0xff;
}

u8 toaplan1_state::vimana_tjump_invert_r()
{
	return (m_tjump_io->read() ^ 0xff) | 0xc0; // high 2 bits of port G always read as 1
}

u8 toaplan1_samesame_state::cmdavailable_r()
{
	return m_soundlatch->pending_r() ? 1 : 0;
}

void toaplan1_samesame_state::hd647180_io_map(address_map &map)
{
	map.unmap_value_high();
	map.global_mask(0xff);

	map(0x63, 0x63).nopr(); // read port D
	map(0xa0, 0xa0).r(m_soundlatch, FUNC(generic_latch_8_device::read));
	map(0xb0, 0xb0).w(m_soundlatch, FUNC(generic_latch_8_device::acknowledge_w));

	map(0x80, 0x81).rw("ymsnd", FUNC(ym3812_device::read), FUNC(ym3812_device::write));
}*/

        default:;
    endcase
end

endmodule
