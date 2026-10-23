#ifndef EDGE_OTA_PLATFORM_H
#define EDGE_OTA_PLATFORM_H
#include <stdint.h>
void platform_puts(const char *s);
_Noreturn void platform_exit(uint32_t code);
_Noreturn void fault(void);
_Noreturn void handoff(uint32_t entry_or_vector, uint32_t stack);
#endif
