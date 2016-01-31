jumping: jumping.o
	gcc -m32 -o $@ $^

jumping.o: jumping.asm
	nasm -f elf $^

clean:
	rm *.o jumping

.PHONY: clean
