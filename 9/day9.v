module day9

import os

fn read_file(filename string) []string {
	return os.read_lines(filename) or { panic('file ${filename} could not be read!') }
}

fn get_history(nums []int) []int {
	mut history := []int{}
	mut previous := 0
	for idx, num in nums {
		if idx == 0 {
			previous = num
			continue
		}

		history << (num - previous)
		previous = num
	}

	return history
}

fn completed(nums []int) bool {
	return nums.filter(it != 0).len == 0
}

fn extrapolate_history(line string) [][]int {
	mut stack := [][]int{}

	mut cur_nums := line.split(' ').map(it.int())

	stack << cur_nums

	for !completed(cur_nums) {
		cur_nums = get_history(cur_nums)
		stack << cur_nums
	}
	return stack
}

fn predict_next(line string) int {
	stack := extrapolate_history(line)

	mut result := 0
	for level in stack.reverse() {
		result += level[level.len - 1]
	}

	return result
}

fn predict_prev(line string) int {
	stack := extrapolate_history(line)

	mut previous := 0
	for level in stack.reverse() {
		previous = level[0] - previous
	}

	return previous
}

fn run(filename string) int {
	rows := read_file(filename)

	mut result := 0
	for row in rows {
		result += predict_next(row)
	}

	println('result: ${result}')
	return result
}

fn run2(filename string) int {
	rows := read_file(filename)

	mut result := 0
	for row in rows {
		result += predict_prev(row)
	}

	println('result: ${result}')
	return result
}
