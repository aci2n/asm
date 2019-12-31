hexdump: hexdump.o
	ld -o hexdump hexdump.o
hexdump.o: hexdump.asm
	nasm -g -f elf -F stabs hexdump.asm -l hexdump.lst
