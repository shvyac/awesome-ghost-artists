#pragma once
#include <stdint.h>

typedef struct Calculator Calculator;

Calculator *calc_new(void);
void calc_free(Calculator *ptr);
void calc_press(Calculator *ptr, uint32_t key);
char *calc_display(const Calculator *ptr);
void calc_string_free(char *s);
