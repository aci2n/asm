textfile: textfile.o textlib.o
	gcc textfile.o textlib.o -o textfile
textfile.o: textfile.asm
	nasm -g -f elf -F stabs textfile.asm -l textfile.lst
textlib.o: textlib.asm
	nasm -g -f elf -F stabs textlib.asm -l textlib.lst
