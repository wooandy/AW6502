        .include "clock.inc"
        .include "string.inc"
        .include "utils.inc"
        .include "zeropage.inc"
        .include "tty.inc"
        .include "lcd.inc"
        .include "modem.inc"
        .include "blink.inc"
        .include "core.inc"
        .include "menu.inc"
        .include "parse.inc"
        .include "macros.inc"
        .include "sound.inc"
        .include "dpad.inc"
        .include "sd.inc"
;        .include "../../load/22_msbasic/msbasic.s"

        .export _run_shell
        .import os1_version
        .import _run_monitor
        .import __ROM_START__
        .import __ROM_LAST__
        .import __ROM_SIZE__
        .import __USERRAM_START__
        .import __USERRAM_LAST__
        .import __USERRAM_SIZE__
        .import __SYS_RAM_START__
        .import __SYS_RAM_LAST__
        .import __SYS_RAM_SIZE__
        .import __CODE_SIZE__
        .import __DATA_SIZE__
        .import __RODATA_SIZE__
        .import __RODATA_PA_SIZE__
        .import __SYSCALLS_SIZE__
        .import __VECTORS_SIZE__
        .import __VIA1_START__
        .import __VIA2_START__
        .import __VIA3_START__             
        .import __ACIA_START__   
        .import beep
        .import _start_msbasic

        .code
_run_shell:
        lda acia_conn
        cmp #$00
        beq @disable_serial
      
        write_lcd #msg_has_acia
        lda #02
        jsr _delay_sec   
        lda #(TTY_CONFIG_INPUT_SERIAL | TTY_CONFIG_INPUT_KEYBOARD | TTY_CONFIG_OUTPUT_SERIAL | TTY_CONFIG_OUTPUT_LCD)  
        jsr _tty_init
        jmp @start_hello
@disable_serial:
         write_lcd #msg_no_acia  
         lda #02
         jsr _delay_sec 
         lda #(TTY_CONFIG_INPUT_KEYBOARD | TTY_CONFIG_OUTPUT_LCD)      
         jsr _tty_init 
        ; Display banner
;        writeln_tty #msgemptyline
;        writeln_tty #bannerh1
;        writeln_tty #bannerh2
;        writeln_tty #banner1
;        writeln_tty #banner2
;        writeln_tty #banner3
;        writeln_tty #banner4
;        writeln_tty #banner5
;        writeln_tty #bannerh2
;        writeln_tty #bannerh1
;        writeln_tty #msgemptyline

        ; Display hello messages
;        write_tty #os1_version
;        writeln_tty #msghello1
;        writeln_tty #msgemptyline
@start_hello:
         jsr _tty_send_newline
        writeln_tty #msghello2
        jsr _tty_send_newline
;        lda #03
;        jsr _delay_sec
;        writeln_tty #msghello3

        ; Display welcome message on lcd
;        write_lcd #welcome_lcd

        register_system_break #system_break_handler

main_loop:
        run_menu #menu, #os1prompt

        rts

_process_load:
        writeln_tty #msgload

@receive_file:
        jsr _modem_receive
        cmp #(MODEM_RECEIVE_FAILED)
        beq @receive_file
        rts

_process_run:
        writeln_tty #msgrun
        jsr $1000
        jsr _deregister_user_irq
        jsr _deregister_user_break
        rts

_process_sd:
        jsr _sd_read
        rts
        
_process_msbasic:
        jsr _start_msbasic
        rts        
        
_process_blink:
        sta tokens_pointer
        stx tokens_pointer+1

        strgettoken tokens_pointer, 1
        copy_ptr ptr1, param_pointer

        parse_onoff param_pointer
        bcc @error
        cmp #$00
        beq @turn_off
        lda #(BLINK_LED_ON)
        jsr _blink_led
        rts
@turn_off:
        lda #(BLINK_LED_OFF)
        jsr _blink_led
        rts
@error:
        writeln_tty #blinkerror
        rts

_process_beep:
        jsr beep
        rts 

_process_monitor:
        writeln_tty #msgmonitor
        jsr _run_monitor
        rts

_process_info:
        writeln_tty #msginfo
        write_tty #clock_msg1
        ldx #$00
        lda #(clock_mhz)
        jsr _tty_write_dec
        writeln_tty #clock_msg2
        jsr _tty_send_newline

        write_tty #rom_msg
        write_tty #mem_msg1
        write_tty_address #__ROM_START__
        write_tty #mem_msg2
        write_tty_dec #(__CODE_SIZE__+__DATA_SIZE__+__RODATA_SIZE__+__RODATA_PA_SIZE__+__SYSCALLS_SIZE__+__VECTORS_SIZE__)
        write_tty #out_of_msg
        write_tty_dec #(__ROM_SIZE__)
        writeln_tty #bytes_msg

        write_tty #system_ram_msg
        write_tty #mem_msg1
        write_tty_address #__SYS_RAM_START__
        write_tty #mem_msg2
        write_tty_dec #(__SYS_RAM_LAST__-__SYS_RAM_START__)
        write_tty #out_of_msg
        write_tty_dec #__SYS_RAM_SIZE__
        writeln_tty #bytes_msg

        write_tty #user_ram_msg
        write_tty #mem_msg1
        write_tty_address #__USERRAM_START__
        write_tty #mem_msg2
        write_tty_dec #(__USERRAM_LAST__-__USERRAM_START__)
        write_tty #out_of_msg
        write_tty_dec #__USERRAM_SIZE__
        writeln_tty #bytes_msg

        jsr _tty_send_newline

        write_tty #rom_code_msg
        write_tty_dec #(__CODE_SIZE__)
        writeln_tty #bytes_msg

        write_tty #rom_data_msg
        write_tty_dec #(__DATA_SIZE__+__RODATA_SIZE__+__RODATA_PA_SIZE__)
        writeln_tty #bytes_msg

        write_tty #syscalls_msg
        write_tty_dec #(__SYSCALLS_SIZE__)
        writeln_tty #bytes_msg

        jsr _tty_send_newline

        write_tty #via1_addr_msg
        write_tty_address #__VIA1_START__
        jsr _tty_send_newline
        write_tty #via2_addr_msg
        write_tty_address #__VIA2_START__
        jsr _tty_send_newline
        write_tty #via3_addr_msg
        write_tty_address #__VIA3_START__
        jsr _tty_send_newline        
        write_tty #acia_addr_msg
        write_tty_address #__ACIA_START__
        jsr _tty_send_newline
        rts

system_break_handler:
        writeln_tty #msgemptyline
        writeln_tty #msgemptyline
        writeln_tty #msgemptyline
        writeln_tty #msgsystembreak
        jsr _strobe_led
        jmp main_loop

        .segment "BSS"
tokens_pointer:
        .res 2
param_pointer:
        .res 2

        .segment "RODATA"
bannerh1:
        .asciiz "+------------------------------------------+"
bannerh2:
        .asciiz "|                                          |"
banner1:
        .asciiz "|  #####  #   #  #   #  ###   ###   #####  |"
banner2:
        .asciiz "|  #      #   #  ##  #   #   #   #  #      |"
banner3:
        .asciiz "|  ###    #   #  # # #   #   #      ###    |"
banner4:
        .asciiz "|  #      #   #  #  ##   #   #   #  #      |"
banner5:
        .asciiz "|  #####   ###   #   #  ###   ###   #####  |"
msghello1: 
        .asciiz " (Alpha)"
msghello2: 
        .asciiz "Welcome to Eunice OS"
msghello3:
        .asciiz "Enter HELP to get list of possible commands"
msgload:
        .asciiz "Initiating load operation..."
msgrun:
        .asciiz "Running program..."
msgmonitor:
        .asciiz "Running monitor application..."
msginfo:
        .asciiz "Eunice OS System Information"
clock_msg1:
        .asciiz "System clock running at "
clock_msg2:
        .asciiz "MHz"
rom_msg:
        .asciiz "ROM"
system_ram_msg:
        .asciiz "System RAM"
user_ram_msg:
        .asciiz "User RAM"
mem_msg1:
        .asciiz " at address: 0x"
mem_msg2:
        .asciiz ", used: "
out_of_msg:
        .asciiz " out of "
bytes_msg:
        .asciiz " bytes."
rom_code_msg:
        .asciiz "ROM code uses "
rom_data_msg:
        .asciiz "ROM data uses "
syscalls_msg:
        .asciiz "SYSCALLS table uses "
via1_addr_msg:
        .asciiz "VIA1 address: 0x"
via2_addr_msg:
        .asciiz "VIA2 address: 0x"
via3_addr_msg:
        .asciiz "VIA3 address: 0x"        
acia_addr_msg:
        .asciiz "ACIA address: 0x"
os1prompt:
        .asciiz "]"
msgemptyline:
        .byte $00
blinkerror:
        .asciiz "Incorrect parameters passed"
msgsystembreak:
        .asciiz "System break initiated, returning to shell..."
menu:
        menuitem load_cmd,    1, load_desc,    _process_load
        menuitem run_cmd,     1, run_desc,     _process_run
        menuitem monitor_cmd, 1, monitor_desc, _process_monitor
        menuitem blink_cmd,   2, blink_desc,   _process_blink
        menuitem beep_cmd,    1, beep_desc,    _process_beep
        menuitem info_cmd,    1, info_desc,    _process_info
        menuitem sd_cmd,      1, sd_desc,      _process_sd
        menuitem msbasic_cmd, 1, msbasic_desc, _process_msbasic
        endmenu 

load_cmd:
        .asciiz "LOAD"
load_desc:
        .asciiz "LOAD - load application using XMODEM/CRC protocol"
run_cmd:
        .asciiz "RUN"
run_desc:
        .asciiz "RUN - execute loaded application"
monitor_cmd:
        .asciiz "MONITOR"
monitor_desc:
        .asciiz "MONITOR - run embedded monitor application"
blink_cmd:
        .asciiz "BLINK"
blink_desc:
        .asciiz "BLINK on/off - toggle onboard blink LED"
beep_cmd:
        .asciiz "BEEP"        
beep_desc:
        .asciiz "BEEP - Play a beep sound"        
info_cmd:
        .asciiz "INFO"
info_desc:
        .asciiz "INFO - display system information"
sd_cmd:
        .asciiz "SD"
sd_desc:
        .asciiz "SD - Read a TXT file"     
msbasic_cmd:
        .asciiz "BASIC"        
msbasic_desc:
        .asciiz "BASIC - Run Microsoft BASIC"                     
msg_no_acia:
    .asciiz "No ACIA"
msg_has_acia:
    .asciiz "ACIA connected" 