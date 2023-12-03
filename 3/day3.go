package day3

import (
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Location struct {
	line   int
	start  int
	stop   int
	number int
}

func newLocation(lineno int, start_idx int, end_idx int, number int) Location {
	loc := Location{}

	loc.line = lineno
	loc.start = start_idx
	loc.stop = end_idx
	loc.number = number

	return loc
}

func getRune(line int, char int, data []string) rune {
	if line < 0 || line >= len(data) {
		return '.'
	}

	row := data[line]

	if char < 0 || char >= len(row) {
		return '.'
	}

	return rune(row[char])
}

func (self Location) pointsToCheck(data string) []rune {
	rows := strings.Split(data, "\n")

	runes := make([]rune, 0, 10)
	for c := self.start - 1; c <= self.stop+1; c++ {

		for l := self.line - 1; l <= self.line+1; l++ {
			// line before, current line, next line
			rune := getRune(l, c, rows)
			runes = append(runes, rune)
		}

	}
	return runes
}

func is_digit(char rune) bool {
	return char >= '0' && char <= '9'
}

func to_int(char string) int {
	value, err := strconv.Atoi(char)
	check(err)
	return value
}

func idenitfy_numbers(input string) []Location {
	rows := strings.Split(input, "\n")

	// 1. identify numbers with indexes
	// -> 467 at 0:0-3, 114 at ...
	// 2. identify characters around numbers
	// 467: ...*. etc

	// number: line, start, stop

	numbers := make([]Location, 0, 10)

	for lineno, row := range rows {
		open_number := false
		current_number := 0
		start_idx := -1
		end_idx := -1

		for charno, char := range row {
			end_idx = charno
			if is_digit(char) {
				current_number = current_number*10 + to_int(string(char))

				if !open_number {
					open_number = true
					start_idx = charno
				}

			} else if open_number {
				// numbers[current_number] = newLocation(lineno, start_idx, end_idx, current_number)
				numbers = append(numbers, newLocation(lineno, start_idx, end_idx-1, current_number))

				current_number = 0
				open_number = false
				start_idx = -1
			}
		}
		// number touching right edge:
		if open_number {
			numbers = append(numbers, newLocation(lineno, start_idx, end_idx, current_number))
		}
	}

	return numbers
}

// func getSymbols() []rune {
// 	runes := make([]rune, 5, 5)

// 	runes[0] = '*'
// 	runes[1] = '#'
// 	runes[3] = '+'
// 	runes[4] = '$'

// 	return runes
// }

func charsToStrings(data []rune) []string {
	strings := make([]string, len(data))

	for idx, char := range data {
		strings[idx] = string(char)
	}

	return strings
}

func checkLocation(loc Location, rows string) int {
	chars := loc.pointsToCheck(rows)

	for _, char := range chars {

		if !is_digit(char) && char != '.' {
			return loc.number
		}
	}

	return 0
}

func run(filename string) int {
	_dat, err := os.ReadFile(filename)
	check(err)

	dat := string(_dat)

	numbers := idenitfy_numbers(dat)

	result := 0
	for _, location := range numbers {
		result += checkLocation(location, dat)
	}

	return result
}
