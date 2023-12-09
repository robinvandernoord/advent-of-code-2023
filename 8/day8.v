module day8

import os
import math

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

struct Mapping {
	l string
	r string
}

fn get_mapping(lines []string) map[string]Mapping {
	mut mapping := map[string]Mapping{}

	for line in lines {
		source, lr := split(line, ' = ')

		l, r := split(lr.trim('()'), ', ')

		mapping[source] = Mapping{l, r}
	}

	return mapping
}

fn solve(instructions string, mapping map[string]Mapping) int {
	mut start := 'AAA'
	end := 'ZZZ'

	mut instruction := instructions[0]
	mut rounds := 0
	for start != end {
		instruction = instructions[rounds % instructions.len]

		if instruction == `L` {
			start = mapping[start].l
		} else if instruction == `R` {
			start = mapping[start].r
		} else {
			panic('Invalid instruction: ${instruction}!')
		}

		rounds++
	}

	return rounds
}

fn solve2(_start string, instructions string, mapping map[string]Mapping) int {
	mut start := _start

	mut instruction := instructions[0]
	mut rounds := 0
	for !start.ends_with('Z') {
		instruction = instructions[rounds % instructions.len]

		if instruction == `L` {
			start = mapping[start].l
		} else if instruction == `R` {
			start = mapping[start].r
		} else {
			panic('Invalid instruction: ${instruction}!')
		}

		rounds++
	}

	return rounds
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic('File ${filename} could not be read!') }

	instructions := lines[0]
	mapping := get_mapping(lines#[2..])

	return solve(instructions, mapping)
}

fn find_smallest_divisible(numbers []i64) i64 {
	if numbers.len == 0 {
		return 0
	}

	mut result := numbers[0]
	for number in numbers#[1..] {
		result = math.lcm(result, number)
	}

	return result
}

fn run2(filename string) i64 {
	lines := os.read_lines(filename) or { panic('File ${filename} could not be read!') }

	instructions := lines[0]
	mapping := get_mapping(lines#[2..])

	starting_positions := mapping.keys().filter(it.ends_with('A'))

	mut results := []i64{cap: 5}
	for start in starting_positions {
		results << solve2(start, instructions, mapping)
	}

	return find_smallest_divisible(results)
}
