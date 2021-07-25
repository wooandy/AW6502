      .include "via.inc"
      .include "utils.inc"

      .export _blink_init
      .export _blink_led
      .export _strobe_led

BLINK_LED_ON  = $01
BLINK_LED_OFF = $00

      .code
; POSITIVE C COMPLIANT
; Initialize DDRB bit to output
_blink_init:
      pha
      lda VIA2_DDRB
      ora #%10000011
      sta VIA2_DDRB
;      lda VIA3_DDRB
;      ora #%11111111
;      sta VIA3_DDRB
;      lda VIA3_PORTB
;      ora #%11111111
;      sta VIA3_PORTB
;      lda #150
;      jsr _delay_ms
;      lda #%00000000
;      sta VIA3_PORTB
      pla
      rts

; POSITIVE C COMPLIANT - input in A
; no return value, no temp variables
_blink_led:
; store current value of accumulator
      pha
      cmp #(BLINK_LED_OFF)
      beq @disable_led
; if carry clear - disable LED
; enable LED otherwise
      lda VIA2_PORTB
      ora #%10000011
      bra @send_signal
@disable_led:
; send signal
      lda VIA2_PORTB
      and #%01111111
@send_signal:
      sta VIA2_PORTB
; restore accumulator value
      pla
      rts

; POSITIVE C COMPLIANT
; Short "on/off" blink
_strobe_led:
      pha
      lda #(BLINK_LED_ON)
      jsr _blink_led
      lda #150
      jsr _delay_ms
      lda #(BLINK_LED_OFF)
      jsr _blink_led
      lda #150
      jsr _delay_ms
      pla
      rts