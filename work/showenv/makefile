showenv: showenv.o showlib.o
	ld -o showenv showenv.o showlib.o
showenv.o: showenv.asm
	nasm -g -f elf -F stabs showenv.asm -l showenv.lst
showlib.o: showlib.asm
	nasm -g -f elf -F stabs showlib.asm -l showlib.lst
