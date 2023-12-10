module day2

import os
import arrays

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

const bag = {
	'red':   12
	'green': 13
	'blue':  14
}

fn valid_set(set_raw string) bool {
	dice := set_raw.split(', ')

	for die in dice {
		count_, color := split(die, ' ')
		count := count_.int()

		if count > day2.bag[color] {
			return false
		}
	}

	return true
}

fn valid_game(sets_raw string) bool {
	sets := sets_raw.split('; ')
	for set in sets {
		if !valid_set(set) {
			return false
		}
	}

	return true
}

fn find_smallest_bag(sets_raw string) map[string]int {
	mut bag := map[string]int{}

	sets := sets_raw.split('; ')
	for set in sets {
		dice := set.split(', ')

		for die in dice {
			count_, color := split(die, ' ')
			count := count_.int()

			if count > bag[color] {
				bag[color] = count
			}
		}
	}

	return bag
}

fn process_game(game string) ?int {
	header, sets := split(game, ': ')

	_, id := split(header, ' ')

	if valid_game(sets) {
		return id.int()
	}

	return none
}

fn process_game2(game string) int {
	_, sets := split(game, ': ')

	bag := find_smallest_bag(sets)

	mut result := 1

	for _, count in bag {
		result *= count
	}

	return result
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }

	mut result := 0

	for line in lines {
		result += process_game(line) or { 0 }
	}

	return result
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }

	// mut result := 0
	// for line in lines {
	// 	result += process_game2(line)
	// }
	//
	// return result
	return arrays.sum(lines.map(process_game2)) or { 0 }
}
