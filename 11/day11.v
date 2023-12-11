module day11

import os
import arrays
import math

fn expand_rows(mut rows []string) []int {
	mut empty_spaces := []int{}

	mut idx := 0
	for true {
		if idx >= rows.len {
			break
		}

		row := rows[idx]

		if row.count('.') == row.len {
			// expand!
			rows.insert(idx, '.'.repeat(row.len))
			empty_spaces << idx
			idx++
		}

		idx++
	}

	return empty_spaces
}

fn get_cols(rows []string) []string {
	mut columns := [][]string{len: rows.len, cap: rows.len, init: []string{cap: rows.len}}

	for row in rows {
		for idx, col in row.split('') {
			columns[idx] << col
		}
	}

	return columns.map(it.join('')).filter(it != '')
}

struct Universe {
	y   int
	x   int
	num int
}

fn find_universes(rows []string, cols []string) []Universe {
	mut universes := []Universe{}

	for y, _ in rows {
		for x, col in cols {
			if rune(col[y]) == `#` {
				universes << Universe{y, x, universes.len + 1}
			}
		}
	}

	return universes
}

fn make_pairs[T](rows []T) [][]T {
	mut pairs := [][]T{}

	for idx1 in 0 .. rows.len {
		for idx2 in idx1 .. rows.len {
			if idx1 == idx2 {
				continue
			}

			pairs << [rows[idx1], rows[idx2]]
		}
	}

	return pairs
}

fn distance_between_pair(pair []Universe) int {
	u1, u2 := pair[0], pair[1]

	distance_x := math.abs(u1.x - u2.x)
	distance_y := math.abs(u1.y - u2.y)

	return distance_x + distance_y
}

fn distance_between_pair2(pair []Universe, empty Empty) int {
	mut distance := distance_between_pair(pair)

	x_es := pair.map(it.x).sorted()

	for x in empty.empty_x {
		if x > x_es[0] && x < x_es[1] {
			distance += empty.empty_space - 2
		}
	}

	y_es := pair.map(it.y).sorted()

	for y in empty.empty_y {
		if y > y_es[0] && y < y_es[1] {
			distance += empty.empty_space - 2
		}
	}

	return distance
}

fn run(filename string) int {
	mut rows := os.read_lines(filename) or { panic(err) }

	expand_rows(mut rows)
	mut cols := get_cols(rows)
	expand_rows(mut cols)

	universes := find_universes(rows, cols)

	pairs := make_pairs(universes)

	distances := pairs.map(distance_between_pair)

	return arrays.sum(distances) or { 0 }
}

struct Empty {
	empty_space int
	empty_x     []int
	empty_y     []int
}

fn run2(filename string, empty_space int) int {
	mut rows := os.read_lines(filename) or { panic(err) }

	empty_y := expand_rows(mut rows)
	mut cols := get_cols(rows)
	empty_x := expand_rows(mut cols)

	empty := Empty{empty_space, empty_x, empty_y}

	universes := find_universes(rows, cols)

	pairs := make_pairs(universes)

	distances := pairs.map(distance_between_pair2(it, empty))

	return arrays.sum(distances) or { 0 }
}
