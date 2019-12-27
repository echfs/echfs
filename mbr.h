#include <stdint.h>
#include <stdio.h>

struct mbr_part {
	uint64_t first_sect;
	uint64_t sect_count;
};

struct mbr_part mbr_get_part(FILE *file, int partition);
