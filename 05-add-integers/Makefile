add-integers: add-integers.o
	gcc -m32 -o $@ $^

add-integers.o: add-integers.asm
	nasm -f elf $^

clean:
	rm *.o add-integers

.PHONY: clean
