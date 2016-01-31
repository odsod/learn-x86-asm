countdown: countdown.o
	gcc -m32 -o $@ $^

countdown.o: countdown.asm
	nasm -f elf $^

clean:
	rm *.o countdown

.PHONY: clean
