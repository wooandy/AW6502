      .import _sd_init
      .import _sd_read

SD_PORTB = $8200
SD_PORTA = $8201
SD_DDRB = $8202
SD_DDRA = $8203

SD_CS   = %00010000
SD_SCK  = %00001000
SD_MOSI = %00000100
SD_MISO = %00000010

