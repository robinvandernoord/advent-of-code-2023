module day1

import os
import arrays

fn isdigit(character string) bool {
	return character >= '0' && character <= '9'
}

fn process_line(line string) int {
	mut first := ''
	mut last := ''

	for c in line.split('') {
		if !isdigit(c) {
			continue
		}

		last = c
		if first == '' {
			first = c
		}
	}
	return first.int() * 10 + last.int()
}

fn get_numbers() map[string]string {
	// one -> 1 etc.
	numbers := ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

	mut mapping := map[string]string{}
	for idx, number in numbers {
		mapping[number] = idx.str()
	}

	return mapping
}

fn preprocess_line(line string, numbers map[string]string) string {
	// array of 1 character strings -> works better than an array of bytes,
	//  and you can replace by index in an array (not in a string)
	mut line_copy := line.split('')

	for idx in 0 .. line.len {
		for number, replacement in numbers {
			if line[idx..].starts_with(number) {
				line_copy[idx] = replacement // replace the first letter with a number, so eight -> 8ight
			}
		}
	}

	return line_copy.join('')
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }
	return arrays.sum(lines.map(process_line)) or { 0 }
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }

	numbers := get_numbers()

	return arrays.sum(lines.map(preprocess_line(it, numbers)).map(process_line)) or { 0 }
}
