      .include "via.inc"
      .include "utils.inc"
      
      .export _dpad_init
      .export _dpad_is_up
      .export _dpad_is_down
      .export _dpad_is_left
      .export _dpad_is_right

BN_D = %01000000
BN_U = %00100000
BN_L = %00010000
BN_R = %00001000
DPAD_UP      = $00
DPAD_DOWN    = $01
DPAD_LEFT    = $02
DPAD_RIGHT   = $03
            
      .code
      
_dpad_init:
      pha
      lda #%10000011 ; Set pin 7 as out for LED, others are input for buttons
 ;     lda VIA2_DDRB
 ;     and #%10000000
      sta VIA2_DDRB
  ;    lda #%11111111
  ;    sta VIA2_PORTB
      pla
      rts
      
_dpad_is_up:
      lda VIA2_PORTB
      and #BN_U 
      RTS
      
_dpad_is_down:
      lda VIA2_PORTB
      and #BN_D
      RTS
      
_dpad_is_left:
      lda VIA2_PORTB
      and #BN_L
      RTS
      
_dpad_is_right:
      lda VIA2_PORTB
      and #BN_R
      rts
            