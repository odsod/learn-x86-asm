mul-and-div: mul-and-div.o
	gcc -m32 -o $@ $^

mul-and-div.o: mul-and-div.asm
	nasm -f elf $^

clean:
	rm *.o mul-and-div

.PHONY: clean
