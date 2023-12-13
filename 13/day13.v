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

fn check_rest(history []string, future []string, smudges int) ?bool {
	mut problems := smudges

	mut found := false

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
				found = true
			}
		}
	}

	if smudges == 1 || found {
		return found
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

fn find_smudge(lines []string) ?int {
	mut previous := ''
	mut history := []string{}

	for idx, line in lines {
		if almost_equal(previous, line) {
			// possibly center found!
			has_smudge := if previous == line { 0 } else { 1 }
			if found := check_rest(history.reverse()[1..], lines[idx + 1..], has_smudge) {
				if has_smudge == 1 && found {
					panic('This shouldnt happen')
				} else {
					return idx
				}
			}
			// else continue?
		}

		history << line
		previous = line
	}

	return none
}

fn find_smudge_horizontal(block string) ?int {
	rows := block.split('\n')
	return find_smudge(rows)
}

fn find_smudge_vertical(block string) ?int {
	rows := block.split('\n')
	cols := rotate_90deg(rows)

	return find_smudge(cols)
}

fn process_block2(block string) int {
	if smudge_h := find_smudge_horizontal(block) {
		return smudge_h * 100
	} else if smudge_v := find_smudge_vertical(block) {
		return smudge_v
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
