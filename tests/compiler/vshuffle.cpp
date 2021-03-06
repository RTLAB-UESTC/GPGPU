#include "output.h"

typedef int veci16 __attribute__((__vector_size__(16 * sizeof(int))));

Output output;

const veci16 kSourceVec = { 0xa, 0xb, 0xc, 0xd, 0xe, 0xf, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19 };
const veci16 kIndexVec = { 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };

int main()
{
	output << __builtin_vp_blendi(0xaaaa, __builtin_vp_shufflei(kSourceVec, kIndexVec), 
		kSourceVec);

	// CHECK: 0x00000019
	// CHECK: 0x0000000b
	// CHECK: 0x00000017
	// CHECK: 0x0000000d
	// CHECK: 0x00000015
	// CHECK: 0x0000000f
	// CHECK: 0x00000013
	// CHECK: 0x00000011
	// CHECK: 0x00000011
	// CHECK: 0x00000013
	// CHECK: 0x0000000f
	// CHECK: 0x00000015
	// CHECK: 0x0000000d
	// CHECK: 0x00000017
	// CHECK: 0x0000000b
	// CHECK: 0x00000019
}
