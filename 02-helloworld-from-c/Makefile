helloworld: helloworld.o main.c
	gcc -m32 -o $@ $^

helloworld.o: helloworld.asm
	nasm -f elf $^

clean:
	rm *.o helloworld

.PHONY: clean
