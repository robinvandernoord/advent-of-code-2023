module day3

import os
import arrays

fn isdigit(character rune) bool {
	return character >= `0` && character <= `9`
}

struct Number {
	y int // line
	x int // start char
	z int // end char

	value int
	// ---
mut:
	symbols []Number
}

fn (mut self Number) attach_symbols(lines []string) {
	for y in self.y - 1 .. self.y + 1 + 1 { // + 2 for inclusive
		if y < 0 || y >= lines.len {
			continue
		}

		line := lines[y].runes()

		for x in self.x - 1 .. self.z + 1 + 1 {
			if x < 0 || x >= line.len {
				continue
			}

			symbol := line[x]

			if isdigit(symbol) || symbol == `.` {
				continue
			}

			self.symbols << new_number(y, x, x, int(symbol))
		}
	}
}

fn (self Number) to_key() string {
	return '${self.x}-${self.y}-${self.z}'
}

fn new_number(x int, y int, z int, value int) &Number {
	num := Number{x, y, z, value, []Number{}}
	return &num
}

fn store_number(x int, y int, z int, value int, mut into []Number) {
	if value == 0 {
		return
	}

	into << new_number(x, y, z, value)
}

fn find_numbers(lines []string) []Number {
	mut numbers := []Number{}

	for lineno, line in lines {
		mut current_number := 0
		mut start_char := 0
		mut end_char := 0

		for charno, character in line.runes() {
			if isdigit(character) {
				end_char = charno
				if current_number == 0 {
					start_char = charno
				}

				current_number = current_number * 10 + character.str().int()
			} else {
				store_number(lineno, start_char, end_char, current_number, mut numbers)
				current_number = 0
			}
		}

		store_number(lineno, start_char, end_char, current_number, mut numbers)
	}

	return numbers
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }

	mut numbers := find_numbers(lines)

	for mut number in numbers {
		number.attach_symbols(lines)
	}

	return arrays.sum(numbers.filter(it.symbols.len > 0).map(it.value)) or { 0 }
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }

	mut numbers := find_numbers(lines)

	mut grouped_by_symbol := map[string][]Number{}

	for mut number in numbers {
		number.attach_symbols(lines)

		for symbol in number.symbols {
			grouped_by_symbol[symbol.to_key()] << number
		}
	}

	mut result := 0
	for _, values in grouped_by_symbol {
		if values.len < 2 {
			continue
		}

		mut product := 1

		for value in values {
			product *= value.value
		}

		result += product
	}

	return result
}
