uppercaser: uppercaser.o
	ld -o uppercaser uppercaser.o
uppercaser.o: uppercaser.asm
	nasm -g -f elf -F stabs uppercaser.asm -l uppercaser.lst
