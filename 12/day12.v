module day12

import os
import arrays

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

fn generate_combinations_(seq string, n int) []string {
	if n == 0 {
		return [seq]
	}
	mut combinations := []string{}
	combinations << generate_combinations_(seq + '#', n - 1)
	combinations << generate_combinations_(seq + '.', n - 1)
	return combinations
}

fn generate_combinations(n int) []string {
	return generate_combinations_('', n)
}

fn is_valid(line string, groups []int) bool {
	return groups == line.split('.').filter(it != '').map(it.count('#'))
}

fn bruteforce(layout string, groups []int) int {
	mut result := 0

	for combination in generate_combinations(layout.count('?')) {
		mut new_line := layout
		for character in combination.split('') {
			new_line = new_line.replace_once('?', character)
		}
		if is_valid(new_line, groups) {
			result++
		}
	}

	return result
}

fn process_line(line string) i64 {
	// replace ? with every combination of . and #
	// if valid? result++
	layout, check := split(line, ' ')

	groups := check.split(',').map(it.int())

	// return bruteforce(layout, groups)
	return solve_recursive(layout, groups)
}

fn solve_recursive_cached(layout []string, groups []int, hash_count int, result string, mut cache map[string]i64) i64 {
	cache_key := '${layout}-${groups}-${hash_count}'
	if cache_key in cache {
		return cache[cache_key]
	}

	answer := solve_recursive_(layout, groups, hash_count, result, mut cache)

	cache[cache_key] = answer

	return answer
}

fn solve_recursive_(layout []string, groups []int, hash_count int, result string, mut cache map[string]int) i64 {
	// als layout niet begint met ? -> volgende karakter
	// als layout wel begint met ? -> vul # in en ga verder
	//     als none resultaat, set . en ga verder
	if layout.len == 0 {
		if groups.len == 1 && groups[0] == hash_count {
			// println('result 1: ${result}')
			return 1
		} else if groups.len > 0 {
			// invalid sequence
			return 0
		} else {
			// println('result 2: ${result}')
			return 1
		}
	}

	if groups.len == 0 {
		remaining := layout.filter(it == '#')

		// println('result 3: ${result}')
		return if remaining.len > 0 { 0 } else { 1 }
	}

	to_try := groups[0]

	if hash_count > to_try {
		return 0 // invalid
	}

	sliced_groups := if to_try == hash_count { groups[1..] } else { groups }

	if layout[0] == '.' {
		if hash_count > 0 && hash_count < to_try {
			return 0
		}

		return solve_recursive_cached(layout[1..], sliced_groups, 0, result + '.', mut
			cache)
	} else if layout[0] == '#' {
		if hash_count >= to_try {
			// goofed up
			return 0
		}

		return solve_recursive_cached(layout[1..], sliced_groups, hash_count + 1, result + '#', mut
			cache)
	} else { // ?
		if hash_count > 0 && hash_count < to_try {
			// must try #
			return solve_recursive_cached(layout[1..], sliced_groups, hash_count + 1,
				result + '#', mut cache)
		} else if hash_count >= to_try {
			// . required
			return solve_recursive_cached(layout[1..], sliced_groups, 0, result + '.', mut
				cache)
		} else {
			// try both
			return solve_recursive_cached(layout[1..], sliced_groups, hash_count + 1, result +
				'#', mut cache) + solve_recursive_cached(layout[1..], sliced_groups, 0, result +
				'.', mut cache)
		}
	}
}

fn solve_recursive(layout string, groups []int) i64 {
	mut cache := map[string]i64{}
	return solve_recursive_cached(layout.split(''), groups, 0, '', mut cache)
}

fn process_line2(line string) i64 {
	layout, check := split(line, ' ')

	full_layout := [layout].repeat(5).join('?')
	groups := check.split(',').map(it.int()).repeat(5)

	return solve_recursive(full_layout, groups)
}

fn process_lines(lines []string) i64 {
	return arrays.sum(lines.map(process_line)) or { 0 }
}

fn process_lines2(lines []string) i64 {
	return arrays.sum(lines.map(process_line2)) or { 0 }
}

fn run(filename string) i64 {
	lines := os.read_lines(filename) or { panic(err) }

	processes := 4

	mut threads := []thread i64{}

	for chunk in arrays.chunk(lines, lines.len / processes) {
		threads << spawn process_lines(chunk)
	}

	results := threads.wait()
	return arrays.sum(results) or { 0 }
}

fn run2(filename string) i64 {
	lines := os.read_lines(filename) or { panic(err) }

	processes := 4

	mut threads := []thread i64{}

	for chunk in arrays.chunk(lines, lines.len / processes) {
		threads << spawn process_lines2(chunk)
	}

	results := threads.wait()
	return arrays.sum(results) or { 0 }
}
