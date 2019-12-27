#include "mbr.h"

struct mbr_entry {
	uint8_t status;
	uint8_t chs_first_sect[3];
	uint8_t type;
	uint8_t chs_last_sect[3];
	uint32_t first_sect;
	uint32_t sect_count;
}__attribute__((packed));

/* 0 return is error condition */
struct mbr_part mbr_get_part(FILE *file, int partition) {
	struct mbr_part ret = {0};
	fseek(file, 0x1BE, SEEK_SET);
	struct mbr_entry entries[4];
	fread(entries, sizeof(struct mbr_entry), 4, file);
	
	if (!entries[partition].type) return ret;
	ret.first_sect = entries[partition].first_sect;
	ret.sect_count = entries[partition].sect_count;

	return ret;
}
