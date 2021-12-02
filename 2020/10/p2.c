#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int cmpfunc(const void *a, const void *b) {
	return (*(int*)a - *(int*)b);
}

int main(void) {
	struct timeval start, end;
	// numbers = [0]
	int input[100];
	int max_index = 0;
	input[0] = 0;

	// input = File.open("input").lines.map(&:to_i)
	FILE *fp = fopen("input", "r");
	if (fp == NULL) {
		fprintf(stderr, "Failed to open input for reading.\n");
		return 1;
	}

	int value;
	int ints_read;
	while (fscanf(fp, "%d\n", &value) != EOF) {
		++max_index;
		input[max_index] = value;
	}

	// started = Time.now
	gettimeofday(&start, NULL);

	// numbers.concat(input.sort)
	qsort(input, max_index + 1, sizeof(int), cmpfunc);
	//   .push(input.max + 3)
	int max = input[max_index];
	input[++max_index] = max + 3;

	// paths = Hash.new(0)
	int paths_size = input[max_index] + 1;
	long int *paths = malloc(paths_size * sizeof(long int));
	// paths[0] = 1
	paths[0] = 1;
	for (int i = 1; i < paths_size; ++i) {
		paths[i] = 0;
	}

	// numbers.each_index do |index|
	for (int i = 0; i <= max_index; ++i) {
		// current_number = numbers[index]
		int current_number = input[i];
		// max_reach = current_number + 3
		int max_reach = current_number + 3;
		// entrance_paths = paths[current_number]
		long int entrance_paths = paths[current_number];
		// reachable_index = index + 1
		int reachable_index = i + 1;
		// reachable_number = numbers[reachable_index]
		int reachable_number;
		//   until !reachable_number || reachable_number > max_reach
		for (; reachable_index <= max_index && (reachable_number = input[reachable_index]) <= max_reach; ++reachable_index) {
			// paths[reachable_number] += entrance_paths
			paths[reachable_number] += entrance_paths;
		}
		//     reachable_index += 1
		//     reachable_number = numbers[reachable_index]
	}

	// ended = Time.now
	gettimeofday(&end, NULL);
	printf("%ld\n", paths[paths_size - 1]);
	printf("%ld\n", (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec));
	free(paths);
	// puts paths[numbers.max]
	// puts ended - started

	return 0;
}
