module day4

import os
import math

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

fn find_matches(card string) int {
	_, parts := split(card, ': ')
	winning_, having_ := split(parts, ' | ')

	winning := winning_.split(' ').filter(it != '').map(it.int())
	having := having_.split(' ').filter(it != '').map(it.int())

	mut matching := 0

	for number in winning {
		if having.contains(number) {
			matching++
		}
	}

	return matching
}

fn process_card(card string) int {
	matching := find_matches(card)

	if matching == 0 {
		return 0
	}

	// 1 match    2^0 = 1
	// 2 matches  2^1 = 2
	// 3 matches  2^2 = 4
	// etc.
	return int(math.pow(2, matching - 1))
}

fn process_card2(cards []string, idx int, mut cache map[int]int) int {
	if idx >= cards.len {
		// illegal
		return 0
	}

	if idx in cache {
		return cache[idx]
	}

	card := cards[idx]
	matching := find_matches(card)

	mut result := 1 // you always start with on card

	for plus in 0 .. matching {
		card_idx := idx + plus + 1
		result += process_card2(cards, card_idx, mut &cache)
	}

	cache[idx] = result
	return result
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic('file ${filename} could not be read!') }

	mut points := 0

	for line in lines {
		points += process_card(line)
	}

	return points
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic('file ${filename} could not be read!') }
	mut points := 0

	mut cache := map[int]int{}
	for idx, _ in lines {
		points += process_card2(lines, idx, mut &cache)
	}

	return points
}
