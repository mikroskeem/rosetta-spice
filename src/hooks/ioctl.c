#include "nolibc.h"

// Sets up AOT caching
__attribute__((section(".text.entry")))
int64_t my_ioctl(int fd, unsigned long req, void *value) {
	if (req == _IOC(_IOC_READ, 0x61, 0x23, 0x80)) {
		strncpy(value, "\x01rosettad", 0x80);

		// Abstract socket flag
		*(unsigned char*)(value + 108) = 1;

		return 1;
	}

	if (req == _IOC(_IOC_READ, 0x61, 0x25, 0x45)) {
		strncpy(value, "Our hard work\nby these words guarded\nplease don't steal\n\u00A9 Apple Inc", 0x45);
		return 1;
	}

	return sys_ioctl(fd, req, value);
}
