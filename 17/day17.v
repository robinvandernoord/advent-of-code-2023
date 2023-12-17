module main

import os
import arrays
import time

struct Point {
	y int
	x int
}

enum Direction {
	up
	right
	down
	left
}

struct Suggestion {
	Point
	direction Direction
	weight    int
}

fn in_grid(grid [][]int, point Point) ?int {
	if point.y < 0 || point.y >= grid.len || point.x < 0 || point.x >= grid[0].len {
		return none
	}

	return grid[point.y][point.x]
}

fn get_options(grid [][]int, position Point, direction Direction, straight int) []Suggestion {
	mut options := []Suggestion{}
	max_straight := 3

	if straight > max_straight {
		panic('uh oh!')
	}

	match direction {
		.up {
			point_up := Point{position.y - 1, position.x}
			if straight < max_straight {
				// can suggest up
				if weight := in_grid(grid, point_up) {
					options << Suggestion{point_up, .up, weight}
				}
			}

			point_left := Point{position.y, position.x - 1}
			if weight := in_grid(grid, point_left) {
				options << Suggestion{point_left, .left, weight}
			}

			point_right := Point{position.y, position.x + 1}
			if weight := in_grid(grid, point_right) {
				options << Suggestion{point_right, .right, weight}
			}
		}
		.down {
			point_down := Point{position.y + 1, position.x}
			if straight < max_straight {
				// can suggest down
				if weight := in_grid(grid, point_down) {
					options << Suggestion{point_down, .down, weight}
				}
			}
			point_right := Point{position.y, position.x + 1}
			if weight := in_grid(grid, point_right) {
				options << Suggestion{point_right, .right, weight}
			}

			point_left := Point{position.y, position.x - 1}
			if weight := in_grid(grid, point_left) {
				options << Suggestion{point_left, .left, weight}
			}
		}
		.left {
			if straight < max_straight {
				// can suggest left
				point_left := Point{position.y, position.x - 1}
				if weight := in_grid(grid, point_left) {
					options << Suggestion{point_left, .left, weight}
				}
			}
			point_up := Point{position.y - 1, position.x}
			if weight := in_grid(grid, point_up) {
				options << Suggestion{point_up, .up, weight}
			}

			point_down := Point{position.y + 1, position.x}
			if weight := in_grid(grid, point_down) {
				options << Suggestion{point_down, .down, weight}
			}
		}
		.right {
			if straight < max_straight {
				// can suggest right
				point_right := Point{position.y, position.x + 1}
				if weight := in_grid(grid, point_right) {
					options << Suggestion{point_right, .right, weight}
				}
			}
			point_up := Point{position.y - 1, position.x}
			if weight := in_grid(grid, point_up) {
				options << Suggestion{point_up, .up, weight}
			}

			point_down := Point{position.y + 1, position.x}
			if weight := in_grid(grid, point_down) {
				options << Suggestion{point_down, .down, weight}
			}
		}
	}

	options.sort(a.weight < b.weight)

	return options
}

fn walk(grid [][]int, position Point, direction Direction, straight int, current_score int, shared scores []int, target Point, seen []Point) {
	options := get_options(grid, position, direction, straight)

	lock scores {
		best_score := arrays.min(scores) or { max_int }

		if position == target {
			scores << current_score
			println('hurray! ${current_score}')
			println('min: ${best_score}')
			return
		}

		if current_score >= best_score {
			// already too high!
			return
		}
	}

	if position in seen {
		// prevent loop
		return
	}

	mut newseen := seen.clone()
	newseen << position

	for option in options {
		new_straight := if option.direction == direction {
			straight + 1
		} else {
			1
		}
		walk(grid, option.Point, option.direction, new_straight, current_score + option.weight, shared
			scores, target, newseen)
	}
}

fn get_target(grid [][]int) Point {
	row := grid[grid.len - 1]
	return Point{grid.len - 1, row.len - 1}
}

fn run_async(grid [][]int, output_ch chan int, shared scores []int) {
	mut position := Point{0, 0}
	mut direction := Direction.right

	target := get_target(grid)

	// todo: start thread
	// set timeout
	// if it takes too long, stop and use current high score

	walk(grid, position, direction, 1, 0, shared scores, target, []Point{})

	rlock scores {
		output_ch <- arrays.min(scores) or { 0 }
	}
}

fn run_with_timeout(filename string, timeout_sec int) int {
	contents := os.read_lines(filename) or { panic(err) }
	grid := contents.map(it.split('').map(it.int()))

	shared scores := []int{}

	ch := chan int{}

	go run_async(grid, ch, shared scores)

	select {
		result := <-ch {
			return result
		}
		timeout_sec * 1000 * time.millisecond { // 50.000 sec ~ 13 hours
			rlock scores {
				return arrays.min(scores) or { 0 }
			}
		}
	}

	return 0
}

fn run(filename string) int {
	return run_with_timeout(filename, 50)
}

fn main() {
	// println("dev:")
	// println("!!! final dev result: ${run_with_timeout('dev.txt', 5)}}") // 5 sec
	println("test:")
	println("!!! final test result: ${run_with_timeout('test.txt', 50_000)}}") // ~ 13 hours
}
