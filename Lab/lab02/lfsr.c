#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t lsb = *reg & 1U;
    uint16_t b2 = (*reg & (1U << 2)) >> 2;
    uint16_t b3 = (*reg & (1U << 3)) >> 3;
    uint16_t b5 = (*reg & (1U << 5)) >> 5;
    uint16_t msb = lsb ^ b2 ^ b3 ^ b5;
    
    *reg = *reg >> 1;
    *reg = *reg | (msb << 15);
}

