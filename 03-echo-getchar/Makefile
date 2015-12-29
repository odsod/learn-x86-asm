echo-getchar: echo-getchar.o main.c
	gcc -m32 -o $@ $^

echo-getchar.o: echo-getchar.asm
	nasm -f elf $^

clean:
	rm *.o echo-getchar

.PHONY: clean
