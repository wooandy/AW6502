#include <stdint.h>
#include <avr/pgmspace.h>
#include "opcodes.h"

const char ADC_OP[] PROGMEM = "adc";
const char AND_OP[] PROGMEM = "and";
const char ASL_OP[] PROGMEM = "asl";
const char BCC_OP[] PROGMEM = "bcc";
const char BCS_OP[] PROGMEM = "bcs";
const char BEQ_OP[] PROGMEM = "beq";
const char BIT_OP[] PROGMEM = "bit";
const char BMI_OP[] PROGMEM = "bmi";
const char BNE_OP[] PROGMEM = "bne";
const char BPL_OP[] PROGMEM = "bpl";
const char BRA_OP[] PROGMEM = "bra";
const char BRK_OP[] PROGMEM = "brk";
const char BVC_OP[] PROGMEM = "bvc";
const char BVS_OP[] PROGMEM = "bvs";
const char CLC_OP[] PROGMEM = "clc";
const char CLD_OP[] PROGMEM = "cld";
const char CLI_OP[] PROGMEM = "cli";
const char CLV_OP[] PROGMEM = "clv";
const char CMP_OP[] PROGMEM = "cmp";
const char CPX_OP[] PROGMEM = "cpx";
const char CPY_OP[] PROGMEM = "cpy";
const char DEC_OP[] PROGMEM = "dec";
const char DEX_OP[] PROGMEM = "dex";
const char DEY_OP[] PROGMEM = "dey";
const char EOR_OP[] PROGMEM = "eor";
const char INC_OP[] PROGMEM = "inc";
const char INX_OP[] PROGMEM = "inx";
const char INY_OP[] PROGMEM = "iny";
const char JMP_OP[] PROGMEM = "jmp";
const char JSR_OP[] PROGMEM = "jsr";
const char LDA_OP[] PROGMEM = "lda";
const char LDX_OP[] PROGMEM = "ldx";
const char LDY_OP[] PROGMEM = "ldy";
const char LSR_OP[] PROGMEM = "lsr";
const char NOP_OP[] PROGMEM = "nop";
const char ORA_OP[] PROGMEM = "ora";
const char PHA_OP[] PROGMEM = "pha";
const char PHP_OP[] PROGMEM = "php";
const char PHX_OP[] PROGMEM = "phx";
const char PHY_OP[] PROGMEM = "phy";
const char PLA_OP[] PROGMEM = "pla";
const char PLP_OP[] PROGMEM = "plp";
const char PLX_OP[] PROGMEM = "plx";
const char PLY_OP[] PROGMEM = "ply";
const char ROL_OP[] PROGMEM = "rol";
const char ROR_OP[] PROGMEM = "ror";
const char RTI_OP[] PROGMEM = "rti";
const char RTS_OP[] PROGMEM = "rts";
const char SBC_OP[] PROGMEM = "sbc";
const char SEC_OP[] PROGMEM = "sec";
const char SED_OP[] PROGMEM = "sed";
const char SEI_OP[] PROGMEM = "sei";
const char STA_OP[] PROGMEM = "sta";
const char STP_OP[] PROGMEM = "stp";
const char STX_OP[] PROGMEM = "stx";
const char STY_OP[] PROGMEM = "sty";
const char STZ_OP[] PROGMEM = "stz";
const char TAX_OP[] PROGMEM = "tax";
const char TAY_OP[] PROGMEM = "tay";
const char TRB_OP[] PROGMEM = "trb";
const char TSB_OP[] PROGMEM = "tsb";
const char TSX_OP[] PROGMEM = "tsx";
const char TXA_OP[] PROGMEM = "txa";
const char TXS_OP[] PROGMEM = "txs";
const char TYA_OP[] PROGMEM = "tya";
const char WAI_OP[] PROGMEM = "wai";
const char RMB0_OP[] PROGMEM = "rmb0";
const char RMB1_OP[] PROGMEM = "rmb1";
const char RMB2_OP[] PROGMEM = "rmb2";
const char RMB3_OP[] PROGMEM = "rmb3";
const char RMB4_OP[] PROGMEM = "rmb4";
const char RMB5_OP[] PROGMEM = "rmb5";
const char RMB6_OP[] PROGMEM = "rmb6";
const char RMB7_OP[] PROGMEM = "rmb7";
const char SMB0_OP[] PROGMEM = "smb0";
const char SMB1_OP[] PROGMEM = "smb1";
const char SMB2_OP[] PROGMEM = "smb2";
const char SMB3_OP[] PROGMEM = "smb3";
const char SMB4_OP[] PROGMEM = "smb4";
const char SMB5_OP[] PROGMEM = "smb5";
const char SMB6_OP[] PROGMEM = "smb6";
const char SMB7_OP[] PROGMEM = "smb7";
const char BBR0_OP[] PROGMEM = "bbr0";
const char BBR1_OP[] PROGMEM = "bbr1";
const char BBR2_OP[] PROGMEM = "bbr2";
const char BBR3_OP[] PROGMEM = "bbr3";
const char BBR4_OP[] PROGMEM = "bbr4";
const char BBR5_OP[] PROGMEM = "bbr5";
const char BBR6_OP[] PROGMEM = "bbr6";
const char BBR7_OP[] PROGMEM = "bbr7";
const char BBS0_OP[] PROGMEM = "bbs0";
const char BBS1_OP[] PROGMEM = "bbs1";
const char BBS2_OP[] PROGMEM = "bbs2";
const char BBS3_OP[] PROGMEM = "bbs3";
const char BBS4_OP[] PROGMEM = "bbs4";
const char BBS5_OP[] PROGMEM = "bbs5";
const char BBS6_OP[] PROGMEM = "bbs6";
const char BBS7_OP[] PROGMEM = "bbs7";

PGM_P const opcodes[] PROGMEM = {
  BRK_OP, ORA_OP, NOP_OP, NOP_OP, TSB_OP, ORA_OP, ASL_OP, RMB0_OP, PHP_OP, ORA_OP, ASL_OP, NOP_OP, TSB_OP, ORA_OP, ASL_OP, BBR0_OP,
  BPL_OP, ORA_OP, ORA_OP, NOP_OP, TRB_OP, ORA_OP, ASL_OP, RMB1_OP, CLC_OP, ORA_OP, INC_OP, NOP_OP, TRB_OP, ORA_OP, ASL_OP, BBR1_OP,
  JSR_OP, AND_OP, NOP_OP, NOP_OP, BIT_OP, AND_OP, ROL_OP, RMB2_OP, PLP_OP, AND_OP, ROL_OP, NOP_OP, BIT_OP, AND_OP, ROL_OP, BBR2_OP,
  BMI_OP, AND_OP, AND_OP, NOP_OP, BIT_OP, AND_OP, ROL_OP, RMB3_OP, SEC_OP, AND_OP, DEC_OP, NOP_OP, BIT_OP, AND_OP, ROL_OP, BBR3_OP,
  RTI_OP, EOR_OP, NOP_OP, NOP_OP, NOP_OP, EOR_OP, LSR_OP, RMB4_OP, PHA_OP, EOR_OP, LSR_OP, NOP_OP, JMP_OP, EOR_OP, LSR_OP, BBR4_OP,
  BVC_OP, EOR_OP, EOR_OP, NOP_OP, NOP_OP, EOR_OP, LSR_OP, RMB5_OP, CLI_OP, EOR_OP, PHY_OP, NOP_OP, NOP_OP, EOR_OP, LSR_OP, BBR5_OP,
  RTS_OP, ADC_OP, NOP_OP, NOP_OP, STZ_OP, ADC_OP, ROR_OP, RMB6_OP, PLA_OP, ADC_OP, ROR_OP, NOP_OP, JMP_OP, ADC_OP, ROR_OP, BBR6_OP,
  BVS_OP, ADC_OP, ADC_OP, NOP_OP, STZ_OP, ADC_OP, ROR_OP, RMB7_OP, SEI_OP, ADC_OP, PLY_OP, NOP_OP, JMP_OP, ADC_OP, ROR_OP, BBR7_OP,
  BRA_OP, STA_OP, NOP_OP, NOP_OP, STY_OP, STA_OP, STX_OP, SMB0_OP, DEY_OP, BIT_OP, TXA_OP, NOP_OP, STY_OP, STA_OP, STX_OP, BBS0_OP,
  BCC_OP, STA_OP, STA_OP, NOP_OP, STY_OP, STA_OP, STX_OP, SMB1_OP, TYA_OP, STA_OP, TXS_OP, NOP_OP, STZ_OP, STA_OP, STZ_OP, BBS1_OP,
  LDY_OP, LDA_OP, LDX_OP, NOP_OP, LDY_OP, LDA_OP, LDX_OP, SMB2_OP, TAY_OP, LDA_OP, TAX_OP, NOP_OP, LDY_OP, LDA_OP, LDX_OP, BBS2_OP,
  BCS_OP, LDA_OP, LDA_OP, NOP_OP, LDY_OP, LDA_OP, LDX_OP, SMB3_OP, CLV_OP, LDA_OP, TSX_OP, NOP_OP, LDY_OP, LDA_OP, LDX_OP, BBS3_OP,
  CPY_OP, CMP_OP, NOP_OP, NOP_OP, CPY_OP, CMP_OP, DEC_OP, SMB4_OP, INY_OP, CMP_OP, DEX_OP, WAI_OP, CPY_OP, CMP_OP, DEC_OP, BBS4_OP,
  BNE_OP, CMP_OP, CMP_OP, NOP_OP, NOP_OP, CMP_OP, DEC_OP, SMB5_OP, CLD_OP, CMP_OP, PHX_OP, STP_OP, NOP_OP, CMP_OP, DEC_OP, BBS5_OP,
  CPX_OP, SBC_OP, NOP_OP, NOP_OP, CPX_OP, SBC_OP, INC_OP, SMB6_OP, INX_OP, SBC_OP, NOP_OP, NOP_OP, CPX_OP, SBC_OP, INC_OP, BBS6_OP,
  BEQ_OP, SBC_OP, SBC_OP, NOP_OP, NOP_OP, SBC_OP, INC_OP, SMB7_OP, SED_OP, SBC_OP, PLX_OP, NOP_OP, NOP_OP, SBC_OP, INC_OP, BBS7_OP
};

const uint8_t addressModes[] PROGMEM = {
  IMPLIED, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, ACCUMULATOR, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, ACCUMULATOR, IMPLIED, ABSOLUTE, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  ABSOLUTE, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, ACCUMULATOR, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, ACCUMULATOR, IMPLIED, ABSOLUTE_X, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  IMPLIED, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, ACCUMULATOR, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  IMPLIED, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, ACCUMULATOR, IMPLIED, INDIRECT, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, X_INDIRECT, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, INDIRECT_X, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  RELATIVE, ZEROPAGE_I, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_Y, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  IMMEDIATE, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_Y, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, ABSOLUTE_X, ABSOLUTE_X, ABSOLUTE_Y, ZEROPAGE_R,
  IMMEDIATE, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R,
  IMMEDIATE, X_INDIRECT, IMMEDIATE, IMPLIED, ZEROPAGE, ZEROPAGE, ZEROPAGE, ZEROPAGE, IMPLIED, IMMEDIATE, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE, ABSOLUTE, ZEROPAGE_R,
  RELATIVE, INDIRECT_Y, ZEROPAGE_I, IMPLIED, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE_X, ZEROPAGE, IMPLIED, ABSOLUTE_Y, IMPLIED, IMPLIED, ABSOLUTE, ABSOLUTE_X, ABSOLUTE_X, ZEROPAGE_R
};

// how many bytes per instruction (aggregated by addressModes)
const unsigned char modeBytes[] = {
  0, 2, 2, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2
};

void getOpcodeText(char* buffer, const uint8_t opcode) {
  strcpy_P(buffer, (PGM_P)pgm_read_word(&(opcodes[opcode])));
}

uint8_t getAddressMode(const uint8_t opcode) {
  return pgm_read_byte(&addressModes[opcode]);
}

uint8_t getOpcodeBytes(const uint8_t opcode) {
  return modeBytes[getAddressMode(opcode)];
}

