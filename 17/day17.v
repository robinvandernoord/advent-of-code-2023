module main

import os
import arrays

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

fn make_cache_key(position Point, direction Direction, straight int) string {
	return '${position.y}:${position.x}-${direction}-${straight}'
}

fn walk(grid [][]int, position Point, direction Direction, straight int, current_score int, target Point, seen []Point, mut cache map[string]int) ?int {
	cache_key := make_cache_key(position, direction, straight)

	cached_distance := cache[cache_key]

	if cached_distance > 0 {
		return cached_distance + current_score
	} else if cached_distance == -1 {
		return none
	}

	if current_score >= 1010 {
		// kinda hacky but too high according to AoC
		return none
	}

	if position == target {
		return current_score
	}


	if position in seen {
		// prevent loop
		return none
	}

	mut newseen := seen.clone()
	newseen << position

	options := get_options(grid, position, direction, straight)
	mut option_results := []int{}
	for option in options {
		new_straight := if option.direction == direction {
			straight + 1
		} else {
			1
		}
		if option_result := walk(grid, option.Point, option.direction, new_straight,
			current_score + option.weight, target, newseen, mut cache)
		{
			option_results << option_result
		}
	}

	if option_results.len > 0 {
		result := arrays.min(option_results) or { panic(err) }

		distance := result - current_score
		existing_distance := cache[cache_key]

		if existing_distance == 0 || existing_distance > distance {
			cache[cache_key] = distance
		}

		return result
	} else {
		cache[cache_key] = -1 // invalid
		return none
	}
}

fn get_target(grid [][]int) Point {
	row := grid[grid.len - 1]
	return Point{grid.len - 1, row.len - 1}
}

fn prepare_cache(grid [][]int, target Point, mut global_cache map[string]int) {
	mut n := -1
	total := grid.len * grid[0].len

	for y_ in 0 .. grid.len {
		y := grid.len - y_ - 1

		for x_ in 0 .. grid[y].len {
			n++

			if n % (y + 1) != 0 {
				// only do some items
				continue
			}

			println('${n} / ${total}')

			x := grid[y].len - x_ - 1
			mut cache := global_cache.clone()

			position := Point{y, x}
			straight := 1

			for direction in [Direction.up, .right, .down, .left] {
				result := walk(grid, position, direction, straight, 0, target,
					[]Point{}, mut cache) or { -1 }

				if result == -1 {
					continue
				}

				global_cache[make_cache_key(position, direction, straight)] = result
			}
		}
	}
}

fn run(filename string) int {
	contents := os.read_lines(filename) or { panic(err) }
	grid := contents.map(it.split('').map(it.int()))


	mut cache := map[string]int{}
	target := get_target(grid)

	prepare_cache(grid, target, mut cache)

	return walk(grid, Point{0, 0}, .right, 1, 0, target, []Point{}, mut cache) or { -1 }
}

fn main() {
	println('done: ${run('test.txt')}')
}
