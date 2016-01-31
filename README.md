# Learn x86 ASM

Reading [PC Assembly Language][pcasm-book] by [Paul Carter][paulcarter].

[pcasm-book]: http://drpaulcarter.com/pcasm/pcasm-book-pdf.zip
[paulcarter]: http://drpaulcarter.com/

Watching [Introductory Intel x86][intel-x86-course] by
[OpenSecurityTraining.info][open-security-training-site].

[intel-x86-course]: http://www.opensecuritytraining.info/IntroX86.html
[open-security-training-site]: http://www.opensecuritytraining.info/

Reading [Programming Intel i386 Assembly with NASM][nasm-slides] by
[Yorick Hardy][yorickhardy].

[nasm-slides]: http://issc.uj.ac.za/assembler/NASM.pdf
[yorickhardy]: https://sites.google.com/site/yorickhardy/

Looking wantonly at [Zen of Assembly Language][zen-of-asm-book] by
[Michael Abrash][abrash].

[zen-of-asm-book]: https://github.com/jagregory/abrash-zen-of-asm
[abrash]: https://en.wikipedia.org/wiki/Michael_Abrash

## Platform

The stuff here runs (on a good day) in 32-bit mode on Ubuntu 14.04 x64
with gcc-multilib installed.

## Intro

* 14 instructions account for ~90% of x86 ASM [[source]][blackhat-bilar]
* Knowing 20-30 instructions is enough

[blackhat-bilar]: http://www.blackhat.com/presentations/bh-usa-06/BH-US-06-Bilar.pdf

## Refreshers

### Data types

| Bytes | Bits | C       | ASM     |
|-------|------|---------|---------|
| `1`   | `8`  | `char`  | `byte`  |
| `2`   | `16` | `short` | `word`  |
| `4`   | `32` | `int`   | `dword` |
| `8`   | `64` | `long`  | `qword` |

### Radices

| Decimal | Binary | Hex | Decimal | Binary | Hex |
|:-------:|--------|-----|:-------:|--------|-----|
| **0**   | `0000` | `0` | **8**   | `1000` | `8` |
| **1**   | `0001` | `1` | **9**   | `1001` | `9` |
| **2**   | `0010` | `2` | **10**  | `1010` | `a` |
| **3**   | `0011` | `3` | **11**  | `1011` | `b` |
| **4**   | `0100` | `4` | **12**  | `1100` | `c` |
| **5**   | `0101` | `5` | **13**  | `1101` | `d` |
| **6**   | `0110` | `6` | **14**  | `1110` | `e` |
| **7**   | `0111` | `7` | **15**  | `1111` | `f` |

Learn in chunks of 4. Recognize the first two bits.

| Bits   | Value     | Hex      |
|--------|-----------|----------|
| `00xx` | `0 + xx`  | `0 + xx` |
| `01xx` | `4 + xx`  | `4 + xx` |
| `10xx` | `8 + xx`  | `8 + xx` |
| `11xx` | `12 + xx` | `c + xx` |

### Negative numbers

**1's complement**: Flip all bits

**2's complement**: 1's complement + 1

Negative numbers are 2's complement of the positive number.

| Dec. | Hex  | Binary     | 1's comp.  | 2's comp.  | Neg.  | Neg. hex |
|------|------|------------|------------|------------|-------|----------|
| `1`  | `01` | `00000001` | `11111110` | `11111111` | `-1`  | `ff`     |
| `4`  | `04` | `00000100` | `11111011` | `11111100` | `-4`  | `fc`     |
| `26` | `1a` | `00011010` | `11100101` | `11100110` | `-26` | `e6`     |

#### Sign extension

Extending a signed number means extending the sign bit to all the new high
order bits.

~~~
2c -> 002c
81 -> ff81
~~~

#### Arithmetic

2's complement arithmetic works exactly the same as unsigned arithmetic,
so `ADD` and `SUB` works on both signed and unsigned numbers.

~~~
  002c      44
+ ffff  +  (-1)
------  -------
  002b      43
~~~

Multiplication and division require specific instructions for signed
numbers: `MUL` vs `IMUL` and `DIV` vs `IDIV`.

#### 8-bit number line

~~~
                            Positive
          |------------------------------------------|
Unsigned: 0                127    128              255
Binary:   00000000    01111111    10000000    11111111
Hex:      00                7f    80                ff
Signed:   0                127    -128              -1
          |------------------|    |------------------|
                Positive                Negative
~~~

#### 32-bit number line

~~~
                                      Positive
          |--------------------------------------------------------------|
Unsigned: 0                2,147,483,647    2,147,483,648    4,294,967,295
Hex:      00000000              7fffffff    80000000              ffffffff
Signed:   0                2,147,483,647    -2,147,483,648              -1
          |----------------------------|    |----------------------------|
                     Positive                          Negative
~~~

## Architecture

### CISC vs. RISC

| Instruction set | Instructions | Registers | Architectures             |
|-----------------|--------------|-----------|---------------------------|
| **CISC**        | Many         | Few       | x86                       |
| **RISC**        | Few          | Many      | ARM, SPARC, MIPS, PowerPC |

### Endianness

Determines byte order of multi-byte values. Does not affect bit order.

~~~
      BIG ENDIAN                               LITTLE ENDIAN

 register                 high memory      register
 +----+----+----+----+   +----+   +----+   +----+----+----+----+
 | de | ad | be | ef |   | 00 | 5 | 00 |   | de | ad | be | ef |
 +----+----+----+----+   +----+   +----+   +----+----+----+----+
    |    |    |    |     | 00 | 4 | 00 |     |    |    |    |
    |    |    |    |     +----+   +----+     |    |    |    |
    |    |    |    +-----| ef | 3 | de |-----+    |    |    |
    |    |    |          +----+   +----+          |    |    |
    |    |    +----------| be | 2 | ad |----------+    |    |
    |    |               +----+   +----+               |    |
    |    +---------------| ad | 1 | be |---------------+    |
    |                    +----+   +----+                    |
    +--------------------| de | 0 | ef |--------------------+
                         +----+   +----+
                          low memory
~~~

#### Little-endian

Least significant byte stored at low address.

x86 memory layout is little-endian. Registers are big-endian.

Makes sense when looking at memory from top to bottom, e.g. when looking
at the stack.

#### Big-endian

Most significant byte stored at low address.

Most architectures except for x86 are entirely big-endian.

Network traffic is big-endian.

Makes sense when looking at memory from left to right.

### Registers

#### General registers

| Register | Nickname      | Usage                           |
|----------|---------------|---------------------------------|
| `EAX`    | Accumulator   | Return values, arithmetic       |
| `EBX`    | Base (Memory) | Memory access base pointer      |
| `ECX`    | Counter       | Loop counter                    |
| `EDX`    | Data          | I/O pointer, arithmetic         |
| `ESI`    | Source        | Source pointer for copying      |
| `EDI`    | Destination   | Destination pointer for copying |
| `EBP`    | Base (Stack)  | Stack frame base pointer        |
| `EIP`    | Instruction   | Offset of next instuction       |

The low order bits of `EAX`, `EBX`, `ECX` and `EDX` can be addressed as such:

~~~
31                 EAX                  0
|---------------------------------------|
                    15       AX         0
                    |-------------------|
                    15  AH   8 7   AL   0
                    |--------| |--------|
~~~

The low order bits of `ESI`, `EDI`, `EBP` and `EIP` can be addressed as such:

~~~
31                ESI                 0
|-------------------------------------|
                   15       SI        0
                   |------------------|
~~~

#### EFLAGS

| Bit     | Label  | Description
|---------|--------|----------------------------------------|
| `0`     | `CF`   | Carry                                  |
| `2`     | `PF`   | Parity                                 |
| `4`     | `AF`   | Auxiliary carry                        |
| `6`     | `ZF`   | Zero flag. `1` iff last result is `0`. |
| `7`     | `SF`   | Sign flag. Sign bit of last result.    |
| `8`     | `TF`   | Trap                                   |
| `9`     | `IF`   | Interrupt enable                       |
| `10`    | `DF`   | Direction                              |
| `11`    | `OF`   | Overflow                               |
| `12-13` | `IOPL` | Privilege level                        |
| `14`    | `NT`   | Nested task                            |
| `16`    | `RF`   | Resume                                 |
| `17`    | `VM`   | Virtual 8086 mode                      |
| `18`    | `AC`   | Alignment check (486+)                 |
| `19`    | `VIF`  | Virutal interrupt                      |
| `20`    | `VIP`  | Virtual interrupt pending              |
| `21`    | `ID`   | ID                                     |

## Calling conventions

### Register calling conventions

Caller preserves `EAX`, `EDX` and `ECX`, if needed.

Callee preserves and restores `EBP`, `EBX`, `ESI`, and `EDI`, if modified.

### Parameter calling conventions

Determines how parameters are pushed to the stack before a call, and how
they are cleaned up afterwards.

Compiler-dependent.

Two primary conventions:

* **cdecl**
* **stdcall**

Common properties of these conventions:

* Parameters are pushed from right to left
* 32-bit values returned in `EAX`
* 64-bit values returned in `EDX:EAX`
* Callee saves old stack frame pointer and sets up new stack frame

#### cdecl

Caller cleans up stack. Used by most C compilers.

#### stdcall

Callee cleans up stack. Mostly used by the Win32 API.

#### fastcall

* 1st parameter goes in `ECX`
* 2nd parameter goes in `EDX`
* Remaining parameters go on the stack, pushed from right to left

## The Stack

LIFO data structure. `ESP` points to the top byte of the stack.

Grows downward in memory.

Memory beyond the top of the stack is considered undefined.

`EBP` points to the base of the current stack frame.

Directly above `EBP` is usually the current return address. Above that are
the function parameters.

### argv

For C programs, the initial stack will contain the `argv` pointers.

`argv[0]` is at the low address.

~~~
$ ./program hello world

        high memory
        +------+
        | 6400 | d.
        +------+
        | 726c | rl
        +------+
     +--| 776f | wo
     |  +------+
     |  | 6f00 | o.
     |  +------+
     |  | 6c6c | ll
     |  +------+
  +--^--| 6865 | he
  |  |  +------+
  |  |    ...
  |  |  +---------+
  |  +--| argv[2] |
  |     +---------+
  +-----| argv[1] |
        +---------+
        | argv[0] |
        +---------+
        | argc    |
        +---------+
        low memory
~~~

### Stack frames

Linked list of function-local variables for every function in the call
hierarchy.

The value in `EBP` is the address of the parent function's `EBP` value.

The function's arguments are at `EBP + x`.

The function's local variables are at `EBP - x`.

## Addressing forms

Angle brackets `[<value>]` is used for memory addressing and
dereferencing.

The angle brackets can contain the following arithmetic:

`[base + index * scale + displacement]`

* `base`: Starting point in memory of the array
* `index`: Current array element
* `scale`: Size of the array elements (allowed values are `[1, 2, 4, 8]`)
* `displacement`: Offset into current element (useful for small structs?)

## Instructions

### NOP

Does nothing, alias for `XCHG EAX, EAX`.

Common usage is to pad code for word boundary alignment.

Also good for stack smashing.

### PUSH

Push a value to the stack. Argument can be inline value or a register.

Decrements `ESP` by the amount of bytes pushed.

Cannot push a value in memory directly to the stack. Must first load into
register.

Can specify value size when pushing inline values:

* `PUSH WORD`
* `PUSH DWORD`
* `PUSH QWORD`

Pushing a `DWORD` is default in x86 32-bit mode.

### POP

Pop a value from the stack into a register.

Increments `ESP` by the amount of bytes pushed.

### CALL

Call a function.

* Pushes `EIP` to the stack
* Loads a new address into `EIP`

Address can either be absolute or relative to the `CALL` instruction.

### RET

Return from a function.

* Pops the stack into `EIP`

Optional argument for cleaning up parameters on the stack. Used by stdcall
functions.

`RET 0x4` will increment the stack pointer by `4` bytes, e.g. cleaning up
a 32-bit argument.

### MOV

Move data.

* Register to register
* Register to memory
* Memory to register
* Inline value to memory
* Inline value to register

Can not move memory to memory.

Intel syntax uses `MOV <dst>, <src>`.

AT&T syntax uses `MOV <src>, <dst>`.

### LEA

Load a register with the result of a memory offset computation.

Useful both for loading memory addresses into registers, and performing
general arithmetic on multiple register values simultaneously.

### ADD / SUB

Perform addition and subtraction.

Works the same for signed and unsigned numbers.

Modifies the `OF`, `SF`, `ZF`, `AF`, `PF` and `CF` flags.

### MOVZX

Move an 8 or 16 bit value to a larger register and set the high order
bytes to zero.

### MOVSX

Move an 8 or 16 bit value to a larger register and set the high order
bytes to the sign bit.

### MUL / IMUL

Signed and unsigned multiplication.

### CDQ

Sign extend a dword in EAX to EDX:EAX.

> CDQ must be called after setting EAX if EDX is not manually initialized
> (as in 64/32 division) before (I)DIV.

### DIV / IDIV

Signed and unsigned division. Remember to sign extend EDX with CQD.

### ADC

Add with carry.

If the carry flag is 0, there is no difference from `add`.

~~~
operand1 = operand1 + carry_flag + operand2
~~~

~~~nasm
add eax, ecx ; add lower 32 bits
adc edx, ebx ; add upper 32 bits
~~~

### SBB

Subtract with carry (borrow).

If the carry flag is 0, there is no difference from `sub`.

~~~
operand1 = operand1 - carry flag - operand2
~~~

~~~nasm
sub eax, ecx ; subtract lower 32 bits
sbb edx, ebx ; subtract upper 32 bits
~~~

### ENTER

Create a stack frame.

~~~
enter frame_size, nesting_level
~~~

Nesting level is used for nested functions in higher level languages.

### Sections or segments

Relates to the different segments of an object file.

| Section | Purpose                                     |
|---------|---------------------------------------------|
| `text`  | Program code                                |
| `data`  | Globally accessible data                    |
| `bss`   | Reserved memory for uninitialized variables |

`bss` is originally an acronym for *Block Started by Symbol*.
