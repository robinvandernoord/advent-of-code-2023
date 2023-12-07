package day7

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func to_int(char string) int {
	value, err := strconv.Atoi(char)
	check(err)
	return value
}

func split(input string, on string) (string, string) {
	_sliced := strings.Split(input, on)
	return _sliced[0], _sliced[1]
}

func readFile(filename string) string {
	dat, err := os.ReadFile(filename)
	check(err)
	return string(dat)
}

func calculateHandType(cards string) uint {
	hand := map[rune]uint{}

	for _, card := range cards {
		hand[card]++
	}

	pairs := 0
	hasThree := false
	for _, count := range hand {
		switch count {
		case 5:
			return 6
		case 4:
			return 5
		case 3:
			hasThree = true
		case 2:
			pairs++
		}
	}

	if hasThree && pairs == 1 {
		// full house
		return 4
	} else if hasThree {
		return 3 // of a kind
	} else if pairs == 2 {
		return 2 // pairs
	} else if pairs == 1 {
		return 1 // pair
	} else {
		return 0 // high card
	}
}

func findBestCard(hand map[rune]uint) rune {
	best_card := 'J'
	var best_count uint = 0

	for card, count := range hand {
		if count < best_count || card == 'J' {
			continue
		} else if count > best_count {
			best_count = count
			best_card = card
		} else {
			if indexOf2(card) < indexOf2(best_card) {
				best_card = card
			}
		}
	}

	return best_card
}

func calculateHandType2(cards string) uint {
	hand := map[rune]uint{}

	for _, card := range cards {
		hand[card]++
	}

	if hand['J'] > 0 && hand['J'] < 5 {
		best := findBestCard(hand)

		if best == 'J' {
			fmt.Printf("hand: %v", hand)
			panic("BEST = J")
		}

		hand[best] += hand['J']
		hand['J'] = 0
	}

	pairs := 0
	hasThree := false
	for _, count := range hand {
		switch count {
		case 5:
			return 6
		case 4:
			return 5
		case 3:
			hasThree = true
		case 2:
			pairs++
		}
	}

	if hasThree && pairs == 1 {
		// full house
		return 4
	} else if hasThree {
		return 3 // of a kind
	} else if pairs == 2 {
		return 2 // pairs
	} else if pairs == 1 {
		return 1 // pair
	} else {
		return 0 // high card
	}
}

type Hand struct {
	cards     string
	bet       int
	hand_type int
}

var ORDENING = []rune{'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'}
var ORDENING2 = []rune{'A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'}

func indexOf(element rune) int {
	for k, v := range ORDENING {
		if element == v {
			return k
		}
	}
	return -1 //not found.
}

func indexOf2(element rune) int {
	for k, v := range ORDENING2 {
		if element == v {
			return k
		}
	}
	return -1 //not found.
}

func run(filename string) int {
	contents := readFile(filename)

	hands := make([]Hand, 0, 10)

	for _, hand := range strings.Split(contents, "\n") {
		if hand == "" {
			continue
		}

		cards, _bet := split(hand, " ")
		bet := to_int(_bet)

		hands = append(hands, Hand{
			cards, bet, int(calculateHandType(cards)),
		})
	}

	sort.SliceStable(hands, func(i, j int) bool {
		hand1 := hands[i]
		hand2 := hands[j]

		if hand1.hand_type > hand2.hand_type {
			return false
		} else if hand1.hand_type < hand2.hand_type {
			return true
		}

		for idx, card1 := range hand1.cards {
			card2 := rune(hand2.cards[idx])

			if card1 == card2 {
				continue
			}

			return indexOf(card1) > indexOf(card2)
		}

		return false
	})

	result := 0
	for _rank, hand := range hands {
		rank := _rank + 1

		result += rank * hand.bet
	}

	return result
}

func run2(filename string) int {
	contents := readFile(filename)

	hands := make([]Hand, 0, 10)

	for _, hand := range strings.Split(contents, "\n") {
		if hand == "" {
			continue
		}

		cards, _bet := split(hand, " ")
		bet := to_int(_bet)

		hands = append(hands, Hand{
			cards, bet, int(calculateHandType2(cards)),
		})
	}

	sort.SliceStable(hands, func(i, j int) bool {
		hand1 := hands[i]
		hand2 := hands[j]

		if hand1.hand_type > hand2.hand_type {
			return false
		} else if hand1.hand_type < hand2.hand_type {
			return true
		}

		for idx, card1 := range hand1.cards {
			card2 := rune(hand2.cards[idx])

			if card1 == card2 {
				continue
			}

			return indexOf2(card1) > indexOf2(card2)
		}

		return false
	})

	result := 0
	for _rank, hand := range hands {
		rank := _rank + 1

		result += rank * hand.bet
	}

	return result
}
