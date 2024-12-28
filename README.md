# interpreter-testing

I've had this idea for implementing a bytecode interpreter for a while:

Sequential opcodes (0-N), each opcode's block in the interpreter is the same size, padded with nops to fill it.
Instead of a normal jump table, multiply the opcode by the block size to get a jmp offset.

I made a 'bytecode' with a few instructions just to have something to apply the idea too.
It doesn't seem to be that useful in this situation, being only marginally faster than the naive C++ version.

But the other assembly functions I wrote did end up being significantly faster, around 5x on my machine using MSVC or Clang.
I assume the reason is due to the lack of branches, but the question is why doesn't either compiler make a branchless function out of the C++?
