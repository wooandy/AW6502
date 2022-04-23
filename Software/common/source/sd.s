      .include "via.inc"
      .include "lcd.inc"
      .include "tty.inc"
      .include "libfat32.s"
      .include "zeropage.inc"
      .include "utils.inc"
      .include "keyboard.inc"
      .include "sysram_map.inc"
      .include "sys_const.inc"
      .include "acia.inc"
;      .import TXTPTR
;      .import INPUTBUFFER
      
      .export _sd_init
      .export _sd_read
      
SD_PORTB = $8200
SD_PORTA = $8201
SD_DDRB = $8202
SD_DDRA = $8203


SD_CS   = %00010000
SD_SCK  = %00001000
SD_MOSI = %00000100
SD_MISO = %00000010      

PORTA_OUTPUTPINS = SD_CS | SD_SCK | SD_MOSI

fat32_workspace = $200      ; two pages (was $200)

buffer = $400   ; was $400



subdirname:
  .asciiz "SUBFOLDR   "
filename:
  .asciiz "DEEPFILETXT"

        .zeropage
memory_pointer:   .res 2
  
      
      .code 
      
_sd_init:
  write_lcd #SD_initializing
  jsr sd_init
  jsr _lcd_newline
;  write_lcd #FAT32_initializing
;  jsr _lcd_newline
 ; lda #02
 ; jsr _delay_sec
 ; jsr _lcd_clear
  jsr fat32_init
 ; bcc initsuccess
  RTS
  
    ; Error during FAT32 initialization
  lda #'Z'
  jsr _lcd_print_char
  lda fat32_errorstage
  jsr print_hex
  jmp forever_loop

_sd_read:  
initsuccess:
  ; Open root directory
  jsr fat32_openroot

  ; Find subdirectory by name
  ldx #<subdirname
  ldy #>subdirname
  jsr fat32_finddirent
  bcc foundsubdir

  ; Subdirectory not found
  lda #'X'
  jsr _lcd_print_char
  jmp forever_loop
  
foundsubdir:
  ; Open subdirectory
  jsr fat32_opendirent

  ; Find file by name
  ldx #<filename
  ldy #>filename
  jsr fat32_finddirent
  bcc foundfile

  ; File not found
  lda #'Y'
  jsr _lcd_print_char
  jmp forever_loop  
  
foundfile:
 
  ; Open file
  jsr fat32_opendirent

  ; Read file contents into buffer
  lda #<buffer
  sta fat32_address
  lda #>buffer
  sta fat32_address+1

  jsr fat32_file_read
  
    ; Dump data to LCD

;  jsr lcd_cleardisplay

 ; ldy #0
 ; lda buffer, y
 ; sta memory_pointer
 ; iny
 ; lda buffer, y
 ; sta memory_pointer+1
 ; iny
  ldy #0
  phx 
  ldx keyboard_rptr
@printloop:
  lda buffer,y
  sta keyboard_buffer,y
  jsr tty_write_byte
  iny
  inx
  stx keyboard_rptr
  
;  cpy #16
;  bne @not16
;  jsr lcd_setpos_startline1
;@not16:

;  cpy #66

;  bne @not64
;  jsr _tty_send_newline
;  lda #01
;  jsr _delay_sec
;@not64:  
;  cpy #190
  bne  @printloop
;  jsr _tty_send_newline
;  lda #01
;  jsr _delay_sec
  plx
  rts
  
;@loop:
;  jmp @loop
  
sd_init:
;  lda #%11111111          ; Set all pins on port B to output
;  sta SD_DDRA
  lda #PORTA_OUTPUTPINS   ; Set various pins on port B to output
  sta SD_DDRB
  
  ; Let the SD card boot up, by pumping the clock with SD CS disabled

  ; We need to apply around 80 clock pulses with CS and MOSI high.
  ; Normally MOSI doesn't matter when CS is high, but the card is
  ; not yet is SPI mode, and in this non-SPI state it does care.
;  pha 
  lda #(SD_CS | SD_MOSI)
  ldx #160               ; toggle the clock 160 times, so 80 low-high transitions
@preinitloop:
  eor #SD_SCK
  sta SD_PORTB
  dex
  bne @preinitloop
  
  
cmd0: ; GO_IDLE_STATE - resets card to idle state, and SPI mode
  lda #<sd_cmd0_bytes
  sta zp_sd_address
  lda #>sd_cmd0_bytes
  sta zp_sd_address+1

  jsr sd_sendcommand

  ; Expect status response $01 (not initialized)
  cmp #$01
  bne initfailed

cmd8: ; SEND_IF_COND - tell the card how we want it to operate (3.3V, etc)
  lda #<sd_cmd8_bytes
  sta zp_sd_address
  lda #>sd_cmd8_bytes
  sta zp_sd_address+1

  jsr sd_sendcommand

  ; Expect status response $01 (not initialized)
  cmp #$01
  bne initfailed

  ; Read 32-bit return value, but ignore it
  jsr sd_readbyte
  jsr sd_readbyte
  jsr sd_readbyte
  jsr sd_readbyte 


cmd55: ; APP_CMD - required prefix for ACMD commands
  lda #<sd_cmd55_bytes
  sta zp_sd_address
  lda #>sd_cmd55_bytes
  sta zp_sd_address+1

  jsr sd_sendcommand

  ; Expect status response $01 (not initialized)
  cmp #$01
  bne initfailed

cmd41: ; APP_SEND_OP_COND - send operating conditions, initialize card
  lda #<sd_cmd41_bytes
  sta zp_sd_address
  lda #>sd_cmd41_bytes
  sta zp_sd_address+1

  jsr sd_sendcommand

  ; Status response $00 means initialised
  cmp #$00
  beq initialized

  ; Otherwise expect status response $01 (not initialized)
  cmp #$01
  bne initfailed

  ; Not initialized yet, so wait a while then try again.
  ; This retry is important, to give the card time to initialize.
    
  jsr delay

  jmp cmd55

initialized:
;  lda #'Y'
;  jsr _lcd_print_char
;  write_lcd #SD_initialized
;  jsr _lcd_newline
;  lda #02
;  jsr _delay_sec
;  jsr _lcd_clear
 ; jmp forever_loop
  rts
    
initfailed:
;  lda #'X'
;  jsr _lcd_print_char
  write_lcd #SD_not_initialized
  jsr _lcd_newline
;  lda #01
;  jsr _delay_sec
;  jsr _lcd_clear
@loop:
  jmp @loop

  ; loop forever
forever_loop:
  jmp forever_loop
  
      
sd_readbyte:
  ; Enable the card and tick the clock 8 times with MOSI high, 
  ; capturing bits from MISO and returning them

  ldx #$fe    ; Preloaded with seven ones and a zero, so we stop after eight bits

read_loop:

  lda #SD_MOSI                ; enable card (CS low), set MOSI (resting state), SCK low
  sta SD_PORTB

  lda #(SD_MOSI | SD_SCK)       ; toggle the clock high
  sta SD_PORTB

  lda SD_PORTB                  ; read next bit
  and #SD_MISO

  clc                         ; default to clearing the bottom bit
  beq @bitnotset              ; unless MISO was set
  sec                         ; in which case get ready to set the bottom bit
@bitnotset:

  txa                         ; transfer partial result from X
  rol                         ; rotate carry bit into read result, and loop bit into carry
  tax                         ; save partial result back to X
  
  bcs read_loop                   ; loop if we need to read more bits

  rts
   
sd_writebyte:
  ; Tick the clock 8 times with descending bits on MOSI
  ; SD communication is mostly half-duplex so we ignore anything it sends back here
;  jsr print_hex
  ldx #8                      ; send 8 bits

write_loop:
  asl                         ; shift next bit into carry
  tay                         ; save remaining bits for later

  lda #0
  bcc sendbit                ; if carry clear, don't set MOSI for this bit
  ora #SD_MOSI

sendbit:
  sta SD_PORTB                   ; set MOSI (or not) first with SCK low
  eor #SD_SCK
  sta SD_PORTB                   ; raise SCK keeping MOSI the same, to send the bit

  tya                         ; restore remaining bits to send

  dex
  bne write_loop                   ; loop if there are more bits to send

  rts

sd_waitresult:
  ; Wait for the SD card to return something other than $ff
  jsr sd_readbyte 
  cmp #$ff
  beq sd_waitresult
  rts 
    
sd_sendcommand:
  ; Debug print which command is being executed
;  jsr lcd_cleardisplay

;  lda #'c'
;  jsr _lcd_print_char
  ldx #0
  lda (zp_sd_address,x)
;  jsr print_hex

  lda #SD_MOSI           ; pull CS low to begin command
  sta SD_PORTB

  ldy #0
  lda (zp_sd_address),y    ; command byte
  jsr sd_writebyte
  ldy #1
  lda (zp_sd_address),y    ; data 1
  jsr sd_writebyte
  ldy #2
  lda (zp_sd_address),y    ; data 2
  jsr sd_writebyte
  ldy #3
  lda (zp_sd_address),y    ; data 3
  jsr sd_writebyte
  ldy #4
  lda (zp_sd_address),y    ; data 4
  jsr sd_writebyte
  ldy #5
  lda (zp_sd_address),y    ; crc
  jsr sd_writebyte

  jsr sd_waitresult
  pha

  ; Debug print the result code
 ; jsr print_hex

  ; End command
  lda #(SD_CS | SD_MOSI)   ; set CS high again
  sta SD_PORTB

  pla   ; restore result code
  rts

sd_readsector:
  ; Read a sector from the SD card.  A sector is 512 bytes.
  ;
  ; Parameters:
  ;    zp_sd_currentsector   32-bit sector number
  ;    zp_sd_address     address of buffer to receive data
  
  lda #SD_MOSI
  sta SD_PORTB

  ; Command 17, arg is sector number, crc not checked
  lda #$51                    ; CMD17 - READ_SINGLE_BLOCK
  jsr sd_writebyte
  lda zp_sd_currentsector+3   ; sector 24:31
  jsr sd_writebyte
  lda zp_sd_currentsector+2   ; sector 16:23
  jsr sd_writebyte
  lda zp_sd_currentsector+1   ; sector 8:15
  jsr sd_writebyte
  lda zp_sd_currentsector     ; sector 0:7
  jsr sd_writebyte
  lda #$01                    ; crc (not checked)
  jsr sd_writebyte

  jsr sd_waitresult
  cmp #$00
  bne @fail

  ; wait for data
  jsr sd_waitresult
  cmp #$fe
  bne @fail

  ; Need to read 512 bytes - two pages of 256 bytes each
  jsr readpage
  inc zp_sd_address+1
  jsr readpage
  dec zp_sd_address+1

  ; End command
  lda #(SD_CS | SD_MOSI)
  sta SD_PORTB

  rts

@fail:
  lda #'s'
  jsr _lcd_print_char
  lda #':'
  jsr _lcd_print_char
  lda #'f'
  jsr _lcd_print_char
failloop:
  jmp failloop


readpage:
  ; Read 256 bytes to the address at zp_sd_address
  ldy #0
readloop:
  jsr sd_readbyte
  sta (zp_sd_address),y
  iny
  bne readloop
  rts
  
print_hex:
  pha
  ror
  ror
  ror
  ror
  jsr print_nybble
  pla
  pha
  jsr print_nybble
  pla
  rts
print_nybble:
  and #15
  cmp #10
  bmi @skipletter
  adc #6
@skipletter:
  adc #48
  jsr _lcd_print_char
  rts

delay:
  ldx #0
  ldy #0
delay_loop:
  dey
  bne delay_loop
  dex
  bne delay_loop
  rts

longdelay:
  jsr mediumdelay
  jsr mediumdelay
  jsr mediumdelay
mediumdelay:
  jsr delay
  jsr delay
  jsr delay
  jmp delay    
  
     .segment "RODATA"
     
sd_cmd0_bytes:
  .byte $40, $00, $00, $00, $00, $95
sd_cmd8_bytes:
  .byte $48, $00, $00, $01, $aa, $87
sd_cmd55_bytes:
  .byte $77, $00, $00, $00, $00, $01
sd_cmd41_bytes:
  .byte $69, $40, $00, $00, $00, $01
  
       
   
SD_initializing:
    .asciiz "Initializing SD..."      
SD_initialized:
    .asciiz "SD initialized"    
SD_not_initialized:
    .asciiz "SD not initialized"       
;FAT32_initializing:
;    .asciiz "Initializing FAT32..."   
        