#include <array>
#include <cstdlib>
#include <iostream>
#include <chrono>
#include <immintrin.h>
#include "fstd/num.hpp"
#include "fstd/optimization/hints.hpp"

extern "C" u64 jt(u64 opcode, u64 a, u64 b);
extern "C" u64 asm_test(u64 opcode, u64 a, u64 b);
extern "C" u64 asm_test2(u64 opcode, u64 a, u64 b);


extern "C" u64 naive(u64 opcode, u64 a, u64 b) {
	switch (opcode) {
		case 0: return a + 1;
		case 1: return a - 1;
		case 2: return a + b;
		case 3: return a - b;
		default: unreachable();
	}
}

extern "C" using TestFn = u64 (*)(u64, u64, u64);

constexpr usize data_size = 8192 * 1024;

std::array<u8, data_size> opcodes;

void run(TestFn function, const char *name) {
	std::srand(0);
	for (usize i = 0; i < data_size; ++i) {
		opcodes[i] = std::rand() % 4;
	}

	u64 a = 0, b = 0;
	const auto start = std::chrono::high_resolution_clock::now();
	for (usize i = 0; i < data_size; ++i) {
		const u64 result = function(opcodes[i], a, b);
		a = b;
		b = result;
	}
	const auto end = std::chrono::high_resolution_clock::now();
	std::cout << name << ":\n\t";
	std::cout << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() << "us\n\t";
	std::cout << b << '\n';
}
int main() {
	run(naive, "naive");
	run(jt, "jt");
	run(asm_test, "asm_test");
	run(asm_test2, "asm_test2");
}