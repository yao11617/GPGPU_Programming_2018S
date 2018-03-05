#include <cstdio>
#include <cstdlib>
#include "../utils/SyncedMemory.h"

#define CHECK {\
	auto e = cudaDeviceSynchronize();\
	if (e != cudaSuccess) {\
		printf("At " __FILE__ ":%d, %s\n", __LINE__, cudaGetErrorString(e));\
		abort();\
	}\
}

const int W = 40;
const int H = 12;

__global__ void Draw(char *frame) 
{
	// TODO: draw more complex things here
	// Do not just submit the original file provided by the TA!
	const int y = blockIdx.y * blockDim.y + threadIdx.y;
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (y < H and x < W) 
    {
		char c;
		if (x == W-1) 
        {
			c = y == H-1 ? '\0' : '\n';
		}
        else if (y == 0 or y == H-1 or x == 0 or x == W-2) 
        {
			c = ':';
		}
        else if(
            y == 3 && x == 6 ||
            y == 3 && x == 7 ||
            y == 3 && x == 8 ||
            y == 3 && x == 9 ||
            y == 3 && x == 10 ||
            y == 3 && x == 28 ||
            y == 3 && x == 29 ||
            y == 3 && x == 30 ||
            y == 3 && x == 31 ||
            y == 3 && x == 32 ||
            y == 4 && x == 4 ||
            y == 4 && x == 5 ||
            y == 4 && x == 11 ||
            y == 4 && x == 12 ||
            y == 4 && x == 26 ||
            y == 4 && x == 27 ||
            y == 4 && x == 33 ||
            y == 4 && x == 34 ||
            y == 5 && x == 3 ||
            y == 5 && x == 4 ||
            y == 5 && x == 12 ||
            y == 5 && x == 13 ||
            y == 5 && x == 25 ||
            y == 5 && x == 26 ||
            y == 5 && x == 34 ||
            y == 5 && x == 35 ||
            y == 6 && x == 3 ||
            y == 6 && x == 4 ||
            y == 6 && x == 12 ||
            y == 6 && x == 13 ||
            y == 6 && x == 25 ||
            y == 6 && x == 26 ||
            y == 6 && x == 34 ||
            y == 6 && x == 35 ||
            y == 7 && x == 3 ||
            y == 7 && x == 4 ||
            y == 7 && x == 12 ||
            y == 7 && x == 13 ||
            y == 7 && x == 25 ||
            y == 7 && x == 26 ||
            y == 7 && x == 34 ||
            y == 7 && x == 35 ||
            y == 8 && x == 4 ||
            y == 8 && x == 5 ||
            y == 8 && x == 11 ||
            y == 8 && x == 12 ||
            y == 8 && x == 26 ||
            y == 8 && x == 27 ||
            y == 8 && x == 33 ||
            y == 8 && x == 34 ||
            y == 9 && x == 6 ||
            y == 9 && x == 7 ||
            y == 9 && x == 8 ||
            y == 9 && x == 9 ||
            y == 9 && x == 10 ||
            y == 9 && x == 28 ||
            y == 9 && x == 29 ||
            y == 9 && x == 30 ||
            y == 9 && x == 31 ||
            y == 9 && x == 32)
        {
            c = 'O';
        }
        else if(
            y == 3 && x == 19 ||
            y == 4 && x == 18 ||
            y == 4 && x == 19 ||
            y == 4 && x == 20 ||
            y == 5 && x == 17 ||
            y == 5 && x == 18 ||
            y == 5 && x == 20 ||
            y == 5 && x == 21 ||
            y == 6 && x == 16 ||
            y == 6 && x == 17 ||
            y == 6 && x == 21 ||
            y == 6 && x == 22 ||
            y == 7 && x == 15 ||
            y == 7 && x == 16 ||
            y == 7 && x == 17 ||
            y == 7 && x == 18 ||
            y == 7 && x == 19 ||
            y == 7 && x == 20 ||
            y == 7 && x == 21 ||
            y == 7 && x == 22 ||
            y == 7 && x == 23 ||
            y == 8 && x == 14 ||
            y == 8 && x == 15 ||
            y == 8 && x == 23 ||
            y == 8 && x == 24 ||
            y == 9 && x == 13 ||
            y == 9 && x == 14 ||
            y == 9 && x == 24 ||
            y == 9 && x == 25)
        {
            c = 'A';
        }
        else
        {
			c = ' ';
		}
		frame[y*W+x] = c;
	}
}

int main(int argc, char **argv)
{
	MemoryBuffer<char> frame(W*H);
	auto frame_smem = frame.CreateSync(W*H);
	CHECK;

	Draw<<<dim3((W-1)/16+1,(H-1)/12+1), dim3(16,12)>>>(frame_smem.get_gpu_wo());
	CHECK;

	puts(frame_smem.get_cpu_ro());
	CHECK;
	return 0;
}
