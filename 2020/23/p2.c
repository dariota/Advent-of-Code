#include<stdio.h>
#include<stdlib.h>

void print_list(int* list, int current_val, int length) {
	printf("%d", current_val);
	int ind = current_val;
	for (int i = 1; i < length; i++) {
		ind = list[ind];
		printf("%d", ind);
	}
	printf("\n");
}

int target_from(int current_value, int max) {
	int dec = current_value - 1;
	return dec ? dec : max;
}

void main() {
	int size = 1000000;
	int* nodes = malloc(sizeof(int) * (size + 1));
	nodes[1] = 9;
	nodes[2] = 5;
	nodes[3] = 7;
	nodes[4] = 3;
	nodes[5] = 8;
	nodes[6] = 4;
	nodes[7] = 1;
	nodes[8] = 10;
	nodes[9] = 2;
	for (int i = 10; i <= size; i++) {
		nodes[i] = i + 1;
	}
	nodes[size] = 6;

	int current_val = 6;
	for (int i = 0; i < 10000000; i++) {
		int moving_val = nodes[current_val];
		int moving_values[3];
		moving_values[0] = moving_val;
		int new_next = moving_val;
		for (int j = 1; j < 3; j++) {
			new_next = nodes[new_next];
			moving_values[j] = new_next;
		}

		int target_value = target_from(current_val, size);
		while (moving_values[0] == target_value || moving_values[1] == target_value || moving_values[2] == target_value) {
			target_value = target_from(target_value, size);
		}

		int old_val = current_val;
		current_val = nodes[old_val] = nodes[new_next];
		nodes[new_next] = nodes[target_value];
		nodes[target_value] = moving_val;
	}

	int after_one = nodes[1];
	int after_that = nodes[after_one];

	printf("After one comes %d and %d == %lld\n", after_one, after_that, ((long long int) after_one) * after_that);
}
