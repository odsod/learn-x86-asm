print-argv: print-argv.o
	gcc -m32 -o $@ $^

print-argv.o: print-argv.asm
	nasm -f elf $^

clean:
	rm *.o print-argv

.PHONY: clean
