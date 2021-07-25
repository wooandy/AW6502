        .include "lcd.inc"
        .include "utils.inc"

        .segment "VECTORS"

        .word   $0000
        .word   init
        .word   $0000

        .code

        
init:
        jsr _lcd_init
        write_lcd #message
        lda #$03
        jsr _delay_sec
        jsr _lcd_clear
        rts

message: .asciiz "Hello, world!"
