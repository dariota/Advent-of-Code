#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define ITERATIONS 30000001
#define MAX_ARR 30000000

int main(void) {
	struct timeval start, end;
	gettimeofday(&start, NULL);
	int* rolling = calloc(MAX_ARR, sizeof(int));
	int current_turn = 1;

	FILE *fp = fopen("input", "r");
	if (fp == NULL) {
		fprintf(stderr, "Failed to open input for reading.\n");
		return 1;
	}

	int value;
	int ints_read;
	while (fscanf(fp, "%d,", &value) != EOF) {
		//printf("Turn %d: %d\n", current_turn, value);
		//printf("rolling[%d] = %d\n", value, current_turn);
		rolling[value] = current_turn++;
	}
	int last_spoken = value;

	for (int i = current_turn; i < ITERATIONS; i++) {
		int previous_spoken_turn = rolling[last_spoken];
		int next;
		if (previous_spoken_turn != 0) {
			next = i - previous_spoken_turn - 1;
		} else {
			next = 0;
		}
		//printf("Turn %d: %d\n", i, next);
		//printf("rolling[%d] = %d\n", last_spoken, i - 1);
		rolling[last_spoken] = i - 1;
		last_spoken = next;
	}

	gettimeofday(&end, NULL);
	printf("%d\n", last_spoken);
	free(rolling);
	printf("%ld\n", (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec));

	return 0;
}
