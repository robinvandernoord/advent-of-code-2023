module day13

import os
import arrays

fn valid_split(below []string, above []string) bool {
	for idx, row_a in above {
		if idx >= below.len {
			break
		}

		row_b := below[idx]

		if row_a != row_b {
			return false
		}
	}

	return true
}

fn find(rows []string) int {
	mut previous := ''
	mut history := []string{}

	for idx, row in rows {
		if previous == row {
			if valid_split(rows[idx..], history.reverse()) {
				return idx
				// else keep looking
			}
		}

		previous = row
		history << row
	}

	return 0
}

fn find_horizontal(block string) int {
	rows := block.split('\n')

	return find(rows)
}

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

fn find_vertical(block string) int {
	rows := block.split('\n')

	cols := rotate_90deg(rows)

	return find(cols)
}

fn process_block(block string) int {
	h := find_horizontal(block) * 100
	v := find_vertical(block)

	// why not both? idk
	return if h > 0 { h } else { v }
	// return find_horizontal(block) * 100 + find_vertical(block)
}

struct Smudge {
	y      int
	x      int
	found  bool
	result int = -1 // easier than changing the return type lol
}

fn check_rest(history []string, future []string, smudges int, y int) ?Smudge {
	mut problems := smudges

	mut smudge := Smudge{
		y: 0
		x: 0
		found: false
	}

	for idx, first in history {
		if idx >= future.len {
			// done looping
			break
		}

		second := future[idx]

		if !almost_equal(first, second) {
			return none // problem
		}
		if first != second {
			problems++

			if problems > 1 {
				return none // problem
			} else {
				x := find_difference_idx(first, second) or { -1 }
				smudge = Smudge{
					y: y - 2 - idx
					x: x
					found: true
				}
			}
		}
	}

	if smudges == 1 || smudge.found {
		return smudge
	} else {
		return none
	}
}

fn almost_equal(one string, two string) bool {
	if one == two {
		return true
	}
	if one.len != two.len {
		return false
	}

	mut issues := 0

	for idx, char1 in one {
		char2 := two[idx]

		if char1 != char2 {
			issues++
			if issues > 1 {
				return false
			}
		}
	}

	return true
}

fn find_difference_idx(one string, two string) ?int {
	if one == two {
		return none
	}
	if one.len != two.len {
		return none
	}

	for idx, char1 in one {
		char2 := two[idx]

		if char1 != char2 {
			return idx
		}
	}

	return none
}

fn find_smudge(lines []string) ?Smudge {
	mut previous := ''
	mut history := []string{}

	for idx, line in lines {
		if almost_equal(previous, line) {
			// possibly center found!
			has_smudge := if previous == line { 0 } else { 1 }
			if smudge := check_rest(history.reverse()[1..], lines[idx + 1..], has_smudge,
				idx)
			{
				println('result: ~${idx}')

				if has_smudge == 1 && smudge.found {
					panic('This shouldnt happen')
				} else if has_smudge == 1 {
					x := find_difference_idx(previous, line) or { -1 }
					return Smudge{
						y: idx
						x: x
						found: true
						result: idx
					}
				} else {
					return Smudge{
						...smudge
						result: idx
					}
				}
			}
			// else continue?
		}

		history << line
		previous = line
	}

	return none
}

fn find_smudge_horizontal(block string) ?Smudge {
	rows := block.split('\n')
	return find_smudge(rows)
}

fn find_smudge_vertical(block string) ?Smudge {
	rows := block.split('\n')
	cols := rotate_90deg(rows)

	smudge := find_smudge(cols) or { return none }

	// flip y and x:
	return Smudge{
		y: smudge.x
		x: smudge.y
		found: smudge.found
		result: smudge.result
	}
}

fn modify_block(block string, smudge Smudge) string {
	mut new_block := ''

	for y, line in block.split('\n') {
		for x, character in line.split('') {
			if y == smudge.y && x == smudge.x {
				new_block += if character == '.' { '#' } else { '.' }
			} else {
				new_block += character
			}
		}
		new_block += '\n'
	}

	return new_block.trim_right('\n')
}

fn process_block2(block string) int {
	if smudge_h := find_smudge_horizontal(block) {
		// println('---')
		// println(block)
		// println(smudge_h)
		// assert smudge_h.y == find_horizontal(modify_block(block, smudge_h))
		// return smudge_h.y * 100
		assert smudge_h.result > -1
		return smudge_h.result * 100
		// return find_horizontal(modify_block(block, smudge_h)) * 100
	} else if smudge_v := find_smudge_vertical(block) {
		// assert smudge_v.x == find_vertical(modify_block(block, smudge_v))
		// return smudge_v.x
		// return find_vertical(modify_block(block, smudge_v))
		assert smudge_v.result > -1
		return smudge_v.result
	} else {
		panic('No smudge found??')
	}
}

fn run(filename string) int {
	contents := os.read_file(filename) or { panic(err) }

	results := contents.split('\n\n').map(process_block)

	return arrays.sum(results) or { 0 }
}

fn run2(filename string) int {
	contents := os.read_file(filename) or { panic(err) }

	results := contents.split('\n\n').map(process_block2)

	return arrays.sum(results) or { 0 }
}
