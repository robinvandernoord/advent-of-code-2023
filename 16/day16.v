module day16

import os
import time
import arrays

struct Point {
mut:
	y int
	x int
}

fn pretty(grid [][]rune, position Point) {
	for y, line in grid {
		for x, col in line {
			if y == position.y && x == position.x {
				print('#')
			} else {
				print(col)
			}
		}
		println('')
	}
	println('')
	time.sleep(500_000_000)
}

enum Direction {
	up
	right
	down
	left
}

fn move_forward(mut position Point, direction Direction) {
	match direction {
		.up {
			position.y--
		}
		.right {
			position.x++
		}
		.down {
			position.y++
		}
		.left {
			position.x--
		}
	}
}

fn hash(point Point, direction Direction) string {
	return '${point.y}-${point.x}-${direction}'
}

fn walk(runes [][]rune, initial_position Point, initial_direction Direction, mut points_visited []string) {
	mut position := initial_position
	mut direction := initial_direction

	for true {
		if position.y < 0 || position.y >= runes.len {
			// out of grid, stop!
			return
		}
		row := runes[position.y]
		if position.x < 0 || position.x >= row.len {
			// out of grid, stop!
			return
		}

		// pretty(runes, position)

		tile := row[position.x]

		unique_key := hash(position, direction)

		if unique_key in points_visited {
			// no need to retry
			return
		}

		points_visited << unique_key

		// if point + direction already seen, break!

		match tile {
			`.` {
				// do nothing but move
				move_forward(mut position, direction)
			}
			`|` {
				if direction in [.right, .left] {
					walk(runes, position, .up, mut points_visited)
					walk(runes, position, .down, mut points_visited)

					return
				} else {
					move_forward(mut position, direction)
				}
			}
			`-` {
				if direction in [.up, .down] {
					walk(runes, position, .left, mut points_visited)
					walk(runes, position, .right, mut points_visited)

					return
				} else {
					move_forward(mut position, direction)
				}
			}
			`\\` {
				direction = match direction {
					.up {
						.left
					}
					.right {
						.down
					}
					.down {
						.right
					}
					.left {
						.up
					}
				}
				move_forward(mut position, direction)
			}
			`/` {
				direction = match direction {
					.up {
						.right
					}
					.right {
						.up
					}
					.down {
						.left
					}
					.left {
						.down
					}
				}
				move_forward(mut position, direction)
			}
			else {
				panic('Invalid tile ${tile}')
			}
		}
	}
}

fn process_points_visited(points_visited []string) []Point {
	mut result := []Point{}
	for point_str in points_visited {
		parts := point_str.split('-')
		y, x := parts[0], parts[1]

		point := Point{y.int(), x.int()}

		if point !in result {
			result << point
		}
	}

	return result
}

fn get_score(runes [][]rune, position Point, direction Direction) int {
	mut points_visited := []string{}

	walk(runes, position, direction, mut points_visited)

	unique_points_visited := process_points_visited(points_visited)

	return unique_points_visited.len
}

fn run(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }
	runes := lines.map(it.runes())

	return get_score(runes, Point{0, 0}, Direction.right)
}

fn search_top(runes [][]rune) int {
	mut max_score := 0

	for x in 0 .. runes[0].len {
		score := get_score(runes, Point{0, x}, .down)
		if score > max_score {
			max_score = score
		}
	}

	return max_score
}

fn search_bottom(runes [][]rune) int {
	mut max_score := 0

	for x in 0 .. runes[0].len {
		score := get_score(runes, Point{runes.len - 1, x}, .up)
		if score > max_score {
			max_score = score
		}
	}

	return max_score
}

fn search_left(runes [][]rune) int {
	mut max_score := 0

	for y in 0 .. runes.len {
		score := get_score(runes, Point{y, 0}, .right)
		if score > max_score {
			max_score = score
		}
	}

	return max_score
}

fn search_right(runes [][]rune) int {
	mut max_score := 0

	for y in 0 .. runes.len {
		score := get_score(runes, Point{y, runes[0].len - 1}, .left)
		if score > max_score {
			max_score = score
		}
	}

	return max_score
}

fn run2(filename string) int {
	lines := os.read_lines(filename) or { panic(err) }
	runes := lines.map(it.runes())

	mut threads := []thread int{}

	threads << spawn search_top(runes)
	threads << spawn search_bottom(runes)
	threads << spawn search_left(runes)
	threads << spawn search_right(runes)

	results := threads.wait()

	println(results)

	return arrays.max(results) or { 0 }
}

// fn main() {
// 	println(run2('test.txt'))
// }
