#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* Two integer image-processing kernels; unsigned overflow is defined. */
__attribute__((noinline))
void transform(uint32_t *restrict out, const uint32_t *restrict in, size_t n) {
    for (size_t i = 0; i < n; ++i)
        out[i] = (in[i] * 1664525u + 1013904223u) ^ (in[i] >> 7);
}
__attribute__((noinline))
uint64_t checksum(const uint32_t *a, size_t n) {
    uint64_t s = 0;
    for (size_t i = 0; i < n; ++i) s += a[i];
    return s;
}
int main(int argc, char **argv) {
    size_t n = 1048576;
    unsigned rounds = argc > 1 ? (unsigned)strtoul(argv[1], NULL, 10) : 2000;
    if (!rounds) return 2;
    uint32_t *a = malloc(n * sizeof(*a)), *b = malloc(n * sizeof(*b));
    if (!a || !b) { free(a); free(b); return 1; }
    for (size_t i = 0; i < n; ++i) a[i] = (uint32_t)i;
    for (unsigned r = 0; r < rounds; ++r) {
        transform(b, a, n);
        uint32_t *tmp = a; a = b; b = tmp;
    }
    printf("n=%zu rounds=%u checksum=%llu\n", n, rounds,
           (unsigned long long)checksum(a, n));
    free(a); free(b);
    return 0;
}
