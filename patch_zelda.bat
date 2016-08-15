assembler\bass.exe -o OoT_Savestate_Hack.z64 savestate.asm
echo OFF
assembler\chksum64.exe OoT_Savestate_Hack.z64
assembler\rn64crc.exe -u
pause