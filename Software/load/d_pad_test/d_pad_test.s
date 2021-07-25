        .setcpu "65C02"
        .include "blink.inc"
        .include "utils.inc"
        .include "dpad.inc"
        .include "lcd.inc"

        .segment "VECTORS"

        .word   $0000
        .word   init
        .word   $0000
        

        .code

init:

        jsr _blink_init 
        jsr _lcd_init

        write_lcd #hello
        lda #$03
        jsr _delay_sec

        jsr _lcd_clear  
        jsr _dpad_init  
        ldx #10
    
  
main_loop:
        ldx #3
        jsr _dpad_is_up
        beq print_up
        jsr _dpad_is_down
        beq print_down
        jsr _dpad_is_left
        beq print_left
        jsr _dpad_is_right
        beq print_right
        jmp main_loop

print_up:
        jsr blink
        write_lcd #message_up
        lda #$01
        jsr _delay_sec
        jsr _lcd_clear  
        jmp main_loop
print_down:
        jsr blink
        write_lcd #message_down
        lda #$01
        jsr _delay_sec
        jsr _lcd_clear  
        jmp main_loop 
print_left:
        jsr blink
        write_lcd #message_left
        lda #$01
        jsr _delay_sec
        jsr _lcd_clear  
        jmp main_loop 
print_right:
        jsr blink
        write_lcd #message_right
        lda #$01
        jsr _delay_sec
        jsr _lcd_clear  
        jmp quit


blink:  
        lda #(BLINK_LED_ON)
        jsr _blink_led
        lda #250
        jsr _delay_ms
        lda #(BLINK_LED_OFF)
        jsr _blink_led
        lda #150
        jsr _delay_ms
        dex
        bne blink
        rts
quit:
        rts
        
        .segment "RODATA"
hello:
      .asciiz "Hello"
message: .byte "D-Pad Test", $00          
message_up: .byte "Up", $00  
message_down: .byte "Down", $00     
message_left: .byte "Left", $00     
message_right: .byte "Right", $00      