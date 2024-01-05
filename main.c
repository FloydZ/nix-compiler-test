#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

const uint64_t NUMBERS  = 500000u;
const uint32_t THREADS  = 1u;
const uint32_t ITERS  	= 10000u;

static inline uint64_t get_cycles(void) {
#if defined __GNUC__ && !defined __clang__
	uint32_t hi, lo;
	__asm__ __volatile__ ("rdtsc" : "=d" (hi), "=a" (lo) : : );
	return ((uint64_t)hi << 32) | (uint64_t)lo;
#else
	return __rdtsc();
#endif
}

int main() {
	float a[NUMBERS], b[NUMBERS], c[NUMBERS], d[NUMBERS];

	// Some initializations
	for (uint64_t i=0; i<NUMBERS; i++) {
	  a[i] = i * 1.5;
	  b[i] = i + 22.35;
	  c[i] = d[i] = 0.0;
	}

	uint64_t start 	= 0;
	uint64_t end 	= NUMBERS;
	uint64_t ec  	= 0;

	for (uint64_t iters = 0; iters < ITERS; iters++) {
		uint64_t cyc = get_cycles();

		for (uint64_t i=start; i<end; i++) {
			c[i] = a[i] + b[i];
		}

		for (uint64_t i=start; i<end; i++) {
			d[i] = a[i] * b[i];
		}

		for (uint64_t i=start; i<end; i++) {
			a[i] = c[i] / d[i] + a[i]*b[i];
		}

		for (uint64_t i=start; i<end; i++) {
			b[i] = a[i] / c[i] - b[i]*d[i];
		}

		float sum = 0.0;
		for (uint64_t i=start; i<end; i++) {
			sum += a[i] / c[i] - b[i]*d[i];
		}

		ec += get_cycles() - cyc;
	}

	ec /= ITERS;
	printf("%" PRIu64 "\n", ec);
	return 0;
}
