echo-scanf: echo-scanf.o main.c
	gcc -m32 -o $@ $^

echo-scanf.o: echo-scanf.asm
	nasm -f elf $^

clean:
	rm *.o echo-scanf

.PHONY: clean
