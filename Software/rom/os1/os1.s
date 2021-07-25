      .setcpu "65C02"
      .include "utils.inc"
      .include "lcd.inc"
      .include "core.inc"
      .include "acia.inc"
      .include "keyboard.inc"
      .include "syscalls.inc"
      .include "via.inc"
      .include "zeropage.inc"

      .import _run_shell
      .export os1_version

      .segment "VECTORS"

      .word   $0000
      .word   init
      .word   _interrupt_handler

      .code
BN_D  = %01000000
BN_U  = %00100000
BN_L  = %00010000
BN_R  = %00001000
ENTER = $0d


init:
      ; clean up stack and zeropage
      ldx #$00
@clean_stack_loop:
      stz $0100,x
      stz $00,x
      inx
      bne @clean_stack_loop
      ; Set up stack
      ldx #$ff
      txs
      ; Run setup routine
      jsr _system_init
      ; Display hello message
      write_lcd #os1_version
      ; Display keyboard status
      ldx #$00
      ldy #$01
      jsr lcd_set_position
      lda #1
      jsr _delay_sec
      jsr _keyboard_is_connected
      cmp #(KEYBOARD_NOT_CONNECTED)
      beq @no_keyboard
      write_lcd #keyboard_connected
      bra @wait_for_1s
@no_keyboard:
      write_lcd #keyboard_disconnected
@wait_for_1s:
      lda #01
      jsr _delay_sec
      jsr _lcd_newline
      write_lcd #instruction
@wait_for_acia_input:
      jsr _acia_is_data_available
      cmp #(ACIA_NO_DATA_AVAILABLE)
      beq @no_acia
      jsr _acia_read_byte
;      tax 
      cmp #(ENTER)
      bne @no_acia
; Serial connected      
      lda #$01
      sta acia_conn
;      txa 
      bra @run_shell
@no_acia:      
      lda #$00
      sta acia_conn
@check_keyboard:
      jsr _keyboard_is_data_available
      cmp #(KEYBOARD_NO_DATA_AVAILABLE)
      beq @check_dpad
;      write_lcd #msg_no_acia
;      lda #$00
;      sta acia_conn
      jsr _keyboard_read_char
      bra @run_shell
@check_dpad:
      lda VIA2_PORTB
      and #BN_U
      beq @dpad_pressed
      lda VIA2_PORTB
      and #BN_D
      beq @dpad_pressed
      lda VIA2_PORTB
      and #BN_L
      beq @dpad_pressed
      lda VIA2_PORTB
      and #BN_R
      beq @dpad_pressed
      bra @wait_for_acia_input 
@dpad_pressed:
 ;     write_lcd #msg_no_acia
      lda #$00
      sta acia_conn
 ;     lda #02
 ;     jsr _delay_sec          
@run_shell:
      jsr _lcd_clear
      write_lcd #shell_connected
      lda #02
      jsr _delay_sec
      jsr _lcd_clear
;      jsr _lcd_newline
      jsr _run_shell
      ; Disable interrupt processing during init
      sei 
      jmp init
 
      .segment "RODATA"

os1_version:
      .asciiz "Eunice OS 1.0"
keyboard_disconnected:
      .asciiz "No keyboard"
keyboard_connected:
      .asciiz "Keyboard connected"
instruction:
      .asciiz "Press any key to continue"
shell_connected:
      .asciiz "Eunice <---> Mac"
msg_no_acia:
    .asciiz "No serial"
msg_has_acia:
    .asciiz "Serial connected"          
