helloworld: helloworld.o
	ld -melf_i386 -o $@ $^

helloworld.o: helloworld.asm
	nasm -f elf helloworld.asm

clean:
	rm *.o helloworld

.PHONY: clean
