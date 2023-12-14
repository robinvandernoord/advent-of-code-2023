module day14

import os
import arrays

fn rotate_90deg(rows []string) []string {
	// rows -> cols
	mut cols := []string{len: rows[0].len, init: ''}

	for x in 0 .. rows[0].len {
		for row in rows {
			cols[x] += row[x..x + 1]
		}
	}
	return cols
}

fn get_score(cols []string) int {
	mut total := 0
	for idx in 0 .. cols.len {
		points := cols.len - idx
		if cols[idx] == 'O' {
			total += points
		}
	}

	return total
}

fn get_score2(grid []string) int {
	return arrays.sum(grid.map(get_score(it.split('')))) or { 0 }
}

fn shift_rocks(column []string) []string {
	mut items := column.clone()

	mut roll_to := 0
	for idx, item in items {
		if item == '#' {
			roll_to = idx + 1
		} else if item == '.' {
			// do nothing?
		} else if item == 'O' {
			if roll_to != idx {
				items[idx], items[roll_to] = items[roll_to], items[idx]
			}
			roll_to++
		} else {
			panic('Invalid item ${item}')
		}
	}

	return items
}

fn process_col(column string) int {
	items := shift_rocks(column.split(''))

	return get_score(items)
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }
	cols := rotate_90deg(lines)

	return arrays.sum(cols.map(process_col)) or { 0 }
}

fn run_cycle(lines []string) []string {
	mut new := []string{}
	for column in lines {
		new << shift_rocks(column.split('')).join('')
	}
	return new
}

fn pretty(lines []string) {
	println('')
	println('--- start ---')
	for line in rotate_90deg(lines) {
		println(line)
	}
	println('--- end ---')
}

struct Cached {
	score int
	index int
}

fn run_cycles(mut lines []string, times int, mut cache map[string]Cached) int {
	lines = rotate_90deg(lines)
	for idx in 1 .. times {
		// if idx % 10 == 0 {
		// 	print('${idx} / ${times}\r')
		// 	os.flush()
		// }

		// pretty(rotate_90deg(lines))
		lines = run_cycle(lines) // north
		// pretty(lines)
		lines = run_cycle(rotate_90deg(lines)) // west
		// pretty(rotate_90deg(lines))
		lines = run_cycle(rotate_90deg(lines).map(it.reverse())) // south
		// pretty(lines.map(it.reverse()))
		lines = run_cycle(rotate_90deg(lines).map(it.reverse())) // east
		// pretty(rotate_90deg(lines.map(it.reverse())).map(it.reverse()))
		lines = rotate_90deg(lines.map(it.reverse())).map(it.reverse()) // back to north

		cache_key := lines.join('')

		if cache_key in cache {
			// early exit
			return cache[cache_key].index
		}

		cache[lines.join('')] = Cached{get_score2(lines), idx}
	}

	panic('Why are you here??')
	return -1
}

fn process_cache(cache map[string]Cached, after int) map[int]int {
	mut idx_to_score := map[int]int{}

	mut idx := 0
	for _, item in cache {
		if item.index < after {
			continue
		}

		idx_to_score[idx] = item.score
		idx++
	}

	return idx_to_score
}

fn run2(filename string) int {
	iterations := 1_000_000_000

	mut lines := os.read_lines(filename) or { panic(err) }

	mut cache := map[string]Cached{}

	stop_idx := run_cycles(mut lines, iterations, mut cache)
	idx_to_score := process_cache(cache, stop_idx)

	return idx_to_score[(iterations - stop_idx) % idx_to_score.len]
}
