      .import _dpad_init
      .import _dpad_is_up
      .import _dpad_is_down
      .import _dpad_is_left
      .import _dpad_is_right
      
; LED_ON = %10000000
; LED_OFF = %00000000
BN_D = %01000000
BN_U = %00100000
BN_L = %00010000
BN_R = %00001000

DPAD_UP      = $00
DPAD_DOWN    = $01
DPAD_LEFT    = $02
DPAD_RIGHT   = $03