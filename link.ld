ENTRY(_start)

PHDRS {
  rxw PT_LOAD FLAGS(0x7); /* R=4 | W=2 | X=1 → 4+2+1 = 7 */
}

SECTIONS
{
  . = 0x400000;

  .text : {
    *(.text)
    *(.data)
    *(.rodata)
    *(.bss)
  } :rxw

  /DISCARD/ : { *(.note.GNU-stack) }
}
