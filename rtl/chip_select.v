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

    scroll_y_offset = 0;

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

            dswb_cs       = z80_cs( 8'h60 ); // port a inverted
            tjump_cs      = z80_cs( 8'h66 ); // port g ( x ^ 0xFF) | 0xC0
            p1_cs         = z80_cs( 8'h80 );
            p2_cs         = z80_cs( 8'h81 );
            dswa_cs       = z80_cs( 8'h82 );
            system_cs     = z80_cs( 8'h83 );
            
            sound0_cs     = z80_cs( 8'h87 );
            sound1_cs     = z80_cs( 8'h8f );
        end

        default:;
    endcase
end

endmodule
