module day7

import os

enum HandType {
	five
	four
	full
	three
	two
	one
	high
}

struct Hand {
	cards     string
	bet       int
	hand_type HandType
}

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

fn process_counter(counter map[rune]int) HandType {
	mut sorted_values := counter.values()
	sorted_values.sort()

	return match sorted_values {
		[5] {
			HandType.five
		}
		[1, 4] {
			HandType.four
		}
		[2, 3] {
			HandType.full
		}
		[1, 1, 3] {
			HandType.three
		}
		[1, 2, 2] {
			HandType.two
		}
		[1, 1, 1, 2] {
			HandType.one
		}
		else {
			HandType.high
		}
	}
}

fn get_hand_type(cards string) HandType {
	mut counter := map[rune]int{}

	for card in cards.runes() {
		counter[card]++
	}

	return process_counter(counter)
}

fn find_best_card(counter map[rune]int) rune {
	mut result := `J`
	mut best_count := 0

	for card, count in counter {
		if count < best_count || result == card || card == `J` {
			continue
		} else if count > best_count {
			best_count = count
			result = card
		}
		// else count == best count
		if get_card_value2(result) > get_card_value2(card) {
			result = card
		}
	}

	return result
}

fn get_hand_type2(cards string) HandType {
	mut counter := map[rune]int{}

	for card in cards.runes() {
		counter[card]++
	}

	if `J` in counter && counter[`J`] != 5 {
		most_common := find_best_card(counter)

		counter[most_common] += counter[`J`]
		counter.delete(`J`)
	}

	return process_counter(counter)
}

fn get_hand(line string) Hand {
	cards, bet := split(line, ' ')

	return Hand{cards, bet.int(), get_hand_type(cards)}
}

fn get_hand2(line string) Hand {
	cards, bet := split(line, ' ')

	return Hand{cards, bet.int(), get_hand_type2(cards)}
}

fn get_card_value(card rune) int {
	ordening := [`A`, `K`, `Q`, `J`, `T`, `9`, `8`, `7`, `6`, `5`, `4`, `3`, `2`]

	return ordening.index(card)
}

fn sort_hands(a &Hand, b &Hand) int {
	h1 := int(a.hand_type)
	h2 := int(b.hand_type)

	if h1 > h2 {
		return -1
	} else if h1 < h2 {
		return 1
	}

	for idx, carda in a.cards {
		cardb := b.cards[idx]
		if carda == cardb {
			continue
		}

		return get_card_value(cardb) - get_card_value(carda)
	}

	// else:
	return 0
}

fn get_card_value2(card rune) int {
	ordening := [`A`, `K`, `Q`, `T`, `9`, `8`, `7`, `6`, `5`, `4`, `3`, `2`, `J`]

	return ordening.index(card)
}

fn sort_hands2(a &Hand, b &Hand) int {
	h1 := int(a.hand_type)
	h2 := int(b.hand_type)

	if h1 > h2 {
		return -1
	} else if h1 < h2 {
		return 1
	}

	for idx, carda in a.cards {
		cardb := b.cards[idx]
		if carda == cardb {
			continue
		}

		return get_card_value2(cardb) - get_card_value2(carda)
	}

	// else:
	return 0
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic('Could not read ${filename}!') }

	mut hands := lines.map(get_hand)

	hands.sort_with_compare(sort_hands)

	mut result := 0
	for rank, hand in hands {
		result += (rank + 1) * hand.bet
	}

	return result
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic('Could not read ${filename}!') }

	mut hands := lines.map(get_hand2)

	hands.sort_with_compare(sort_hands2)

	mut result := 0
	for rank, hand in hands {
		result += (rank + 1) * hand.bet
	}

	return result
}
