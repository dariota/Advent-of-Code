#include <stdio.h>
#include <stdlib.h>

#define TURNS 30000000+1//2020+1
#define NAN 0

int main(int argc, char *argv[]) {
	int turn;
	int *spokenMostRecent = calloc(TURNS, sizeof(int));
	int *spokenSecondRecent = calloc(TURNS, sizeof(int));
	int lastSpoken;

	for(turn = 1; turn < argc; turn++) {
		lastSpoken = atoi(argv[turn]);
		spokenMostRecent[lastSpoken] = turn;
	}

	for(; turn < TURNS; turn++){
		int lastTurn = turn-1;
		int turnSpokenBeforeLast = spokenSecondRecent[lastSpoken];

		// Spoken once
		if (turnSpokenBeforeLast == NAN) {
			spokenSecondRecent[lastSpoken] = lastTurn;
			lastSpoken = 0;
		// Spoken twice
		} else {
			lastSpoken = lastTurn - turnSpokenBeforeLast;
		}

		spokenSecondRecent[lastSpoken] = spokenMostRecent[lastSpoken];

		// Update lists
		spokenMostRecent[lastSpoken] = turn;
	}
	printf("%d\n", lastSpoken);

	return 0;
}
