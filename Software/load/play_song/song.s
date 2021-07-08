
    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes


    .include "sound.inc"
;    .include "via.inc"

    
    .segment "VECTORS"
    
    .word $0000
    .word init
    .word $0000

; Some notes
C5_BYTE_1       = $07
C5_BYTE_2       = $07
D5_BYTE_1       = $0a
D5_BYTE_2       = $06
E5_BYTE_1       = $0E
E5_BYTE_2       = $05
G5_BYTE_1       = $0F
G5_BYTE_2       = $04

__VIA1_START__ = $9000
__VIA2_START__ = $8800

VIA_REGISTER_PORTB = $00
VIA_REGISTER_PORTA = $01
VIA_REGISTER_DDRB  = $02
VIA_REGISTER_DDRA  = $03
VIA_REGISTER_T1CL  = $04
VIA_REGISTER_T1CH  = $05
VIA_REGISTER_T1LL  = $06
VIA_REGISTER_T1LH  = $07
VIA_REGISTER_T2CL  = $08
VIA_REGISTER_T2CH  = $09
VIA_REGISTER_SR    = $0a
VIA_REGISTER_ACR   = $0b
VIA_REGISTER_PCR   = $0c
VIA_REGISTER_IFR   = $0d
VIA_REGISTER_IER   = $0e
VIA_REGISTER_PANH  = $0f

VIA1_PORTB = __VIA1_START__ + VIA_REGISTER_PORTB
VIA1_PORTA = __VIA1_START__ + VIA_REGISTER_PORTA
VIA1_DDRB  = __VIA1_START__ + VIA_REGISTER_DDRB
VIA1_DDRA  = __VIA1_START__ + VIA_REGISTER_DDRA

VIA2_PORTB = __VIA2_START__ + VIA_REGISTER_PORTB
VIA2_PORTA = __VIA2_START__ + VIA_REGISTER_PORTA
VIA2_DDRB  = __VIA2_START__ + VIA_REGISTER_DDRB
VIA2_DDRA  = __VIA2_START__ + VIA_REGISTER_DDRA

    .code
init:
play_a_song:
    ; Play Mary Had a Little Lamb located
    LDX #$00                ; Index into our song array
play_song:
    INX
    LDA song,X              ; Load the first byte of the note
    INX
    LDY song,X              ; Load the second byte of the note
    JSR play_song_note
    CPX song                ; Have we played all the notes?
    BEQ song_done
    JMP play_song
song_done:
    RTS

; Register A first byte of note
; Register Y second byte of note
play_song_note:
    ORA #(FIRST|CHANNEL_1|TONE)
    JSR sn_send
    TYA
    ORA #(SECOND|CHANNEL_1|TONE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    JSR song_sleep
    JSR silence_all
    RTS
  

play_note_noise:
    ORA #(FIRST|CHANNEL_NOISE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_NOISE|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_NOISE|VOLUME|VOLUME_MAX)
    JSR sn_send
    RTS

silence_all:
    PHA
    LDA #(FIRST|CHANNEL_1|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_2|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_3|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_NOISE|VOLUME|VOLUME_OFF)
    JSR sn_send
    PLA
    RTS

; A - databus value to strobe SN with
; Note: currently destructive of other pins on the VIA
sn_send:
    PHX
    PHY 
    STA VIA2_PORTA              ; Put our data on the data bus
    LDY VIA2_PORTB 
    LDA VIA2_PORTB 
    ORA #SN_WE 
  ;  TAX 
  ;  LDX #SN_WE                  ; Strobe WE
    STA VIA2_PORTB
  ;  ORA #SN_WE_CLEAR
    LDA #SN_WE_CLEAR
    STA VIA2_PORTB
    JSR wait_ready              ; Wait for chip to be ready from last instruction
    TYA 
    ORA #SN_WE 
  ;  LDX #SN_WE
    STA VIA2_PORTB
    PLY 
    PLX
    RTS

; Wait for the SN76489 to signal it's ready for more commands
wait_ready:
    PHA
ready_loop:
    LDA VIA2_PORTB
    AND #SN_READY
    BNE ready_loop
ready_done:
    PLA
    RTS

song_sleep:
    PHX
    PHY 
    LDX #$00
    LDY #$00
song_sleep_inner_loop:
    CPX #$FF
    BEQ song_sleep_outer_loop
    INX
    JMP song_sleep_inner_loop
song_sleep_outer_loop:
    LDX #$00
    CPY #$FF
    BEQ song_sleep_done
    INY
    JMP song_sleep_inner_loop
song_sleep_done:
    PLY
    PLX 
    RTS
    
sleep:
    PHX
    PHY 
    LDX #$00
    LDY #$00
sleep_inner_loop:
    CPX #$FF
    BEQ sleep_outer_loop
    INX
    JMP sleep_inner_loop
sleep_outer_loop:
    LDX #$00
    CPY #$0F
    BEQ sleep_done
    INY
    JMP sleep_inner_loop
sleep_done:
    PLY
    PLX 
    RTS


    
    .segment "RODATA"    
    ; Song: first verse of Mary had a Little Lamb
song:
    .byte $34                 ; 26 notes in this array
    .byte E5_BYTE_1,E5_BYTE_2 ; M
    .byte D5_BYTE_1,D5_BYTE_2 ; ry
    .byte C5_BYTE_1,C5_BYTE_2 ; had
    .byte D5_BYTE_1,D5_BYTE_2 ; a
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte E5_BYTE_1,E5_BYTE_2 ; tle
    .byte E5_BYTE_1,E5_BYTE_2 ; lamb
    .byte D5_BYTE_1,D5_BYTE_2 ; lit-
    .byte D5_BYTE_1,D5_BYTE_2 ; tle
    .byte D5_BYTE_1,D5_BYTE_2 ; lamb
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte G5_BYTE_1,G5_BYTE_2 ; tle
    .byte G5_BYTE_1,G5_BYTE_2 ; lab
    .byte E5_BYTE_1,E5_BYTE_2 ; Ma
    .byte D5_BYTE_1,D5_BYTE_2 ; ry
    .byte C5_BYTE_1,C5_BYTE_2 ; had
    .byte D5_BYTE_1,D5_BYTE_2 ; a
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte E5_BYTE_1,E5_BYTE_2 ; tle
    .byte E5_BYTE_1,E5_BYTE_2 ; lamb
    .byte E5_BYTE_1,E5_BYTE_2 ; its
    .byte D5_BYTE_1,D5_BYTE_2 ; fleece
    .byte D5_BYTE_1,D5_BYTE_2 ; was
    .byte E5_BYTE_1,E5_BYTE_2 ; white
    .byte D5_BYTE_1,D5_BYTE_2 ; as
    .byte C5_BYTE_1,C5_BYTE_2 ; snow

; .endif