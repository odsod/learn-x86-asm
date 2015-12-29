helloworld: helloworld.o main.c
	gcc -m32 -o $@ $^

helloworld.o: helloworld.asm
	nasm -f elf helloworld.asm

clean:
	rm *.o helloworld

.PHONY: clean
