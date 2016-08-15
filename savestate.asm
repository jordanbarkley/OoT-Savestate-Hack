// savestate.asm

arch    n64.cpu
endian  msb

include "library\N64.inc"
include "library\macros.inc"    // my macros

origin  0x0
insert  "library\OoT_Dec.z64"   // copy decompressed ROM

origin 0x20
asciiz("OoT Savestate Hack")    // change ROM name 

// DMA Copy
origin  0x1A98
base    0x80000E98
lui     a0, $0340           // load ROM addr (0x03400000)
lui     a1, $8040           // load RAM dest (0x80400000)
jal     0x8000085C          // dmacopy (a0, a1, a2)
lui     a2, $0001           // load length ($10000)

insert "OoT_Random_Code.bin"

// Hook (on store controller)
origin  0xB0CB30
base    0x800A27F0
j       0x80400000
nop     

// Custom Function
origin  0x3400000
base    0x80400000
Setup:
swl     t7, 0x0000(s0)          // ~
swr     t7, 0x0003(s0)          // store controls (original)
mthi    t8                      // save t8
mtlo    t9                      // save t9
srl     t8, t7, $10             // t8 = upper 2 bytes of t7

// Reload Last Loading Zone with D-Pad Down
// D11C84B4 0400
// 801DA2B5 0014 <-- Reload
Reload:
andi    t9, t8, $0400           // check d-pad down
beq     t9, r0, Title           // if not pressed, skip
nop

ori     t9, r0, $0014           // ~
lui     t8, $801D               // ~
ori     t8, t8, $A2B5           // ~
sb      t9, 0x0000(t8)          // <-- Reload

beq     r0, r0, Return          // skip the rest of the tests
nop

// Title Screen with D-Pad Up
// D01C84B4 0008
// 8011B92F 0002 <-- Title
// D01C84B4 0008
// 801DA2B5 0014 <-- Reload
// D01C84B4 0008
// 801DA2B4 0000 <-- Deku Default
Title:
andi    t9, t8, $0800           // check d-pad up
beq     t9, r0, Hearts          // if not pressed, skip
nop

ori     t9, r0, $0002           // ~
lui     t8, $8011               // ~
ori     t8, t8, $B92F           // ~
sb      t9, 0x0000(t8)          // <-- Title

ori     t9, r0, $0014           // ~
lui     t8, $801D               // ~
ori     t8, t8, $A2B5           // ~
sb      t9, 0x0000(t8)          // <-- Reload

ori     t9, r0, $0000           // ~
lui     t8, $801D               // ~
ori     t8, t8, $A2B4           // ~
sb      t9, 0x0000(t8)          // <-- Deku Default

beq     r0, r0, Return          // skip the rest of the tests
nop

 
// D-Pad Left to set at 3 Hearts
// D01C84B4 0002
// 8111A600 0030 <-- Hearts(?)
Hearts:
andi    t9, t8, $0200           // check d-pad left
beq     t9, r0, Void            // if not pressed, skip
nop

ori     t9, r0, $0030           // ~
lui     t8, $8011               // ~
ori     t8, t8, $A600           // ~
sb      t9, 0x0000(t8)          // <-- Hearts(?)

beq     r0, r0, Return          // skip the rest of the tests
nop

 
// Void D-Pad Down (D-Pad Down Already Used...)
// D11C84B4 0400
// 801DA2B5 0014 <-- Reload
// D11C84B4 0400
// 8011B937 0001 <-- Void(?)
Void:
andi    t9, t8, $0400           // check d-pad left
beq     t9, r0, Return          // if not pressed, skip
nop

ori     t9, r0, $0014           // ~
lui     t8, $801D               // ~
ori     t8, t8, $A2B5           // ~
sb      t9, 0x0000(t8)          // <-- Reload

ori     t9, r0, $0001           // ~
lui     t8, $8011               // ~
ori     t8, t8, $B937           // ~
sb      t9, 0x0000(t8)          // <-- Void(?)

Return:
mfhi    t8                      // restore t8
mflo    t9                      // restore t9
j   0x800A27F8
nop




