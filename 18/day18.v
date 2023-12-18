module day18

import os
import math

struct Point {
	y int
	x int
}

struct Line {
mut:
	start int
	end   int
}

fn count_lines(line []Point) int {
	if line.len == 0 {
		return 0
	}

	mut lines := 0

	mut prev_x := -1

	for item in line {
		if prev_x != item.x - 1 {
			lines++
		}

		prev_x = item.x
	}
	return lines
}

fn pretty_points(points []Point, fill bool) {
	mut min_x := int(max_int)
	mut min_y := int(max_int)
	mut max_x := 0
	mut max_y := 0

	mut points_per_y := map[int][]Point{}

	for point in points {
		if point.x < min_x {
			min_x = point.x
		}
		if point.x > max_x {
			max_x = point.x
		}
		if point.y < min_y {
			min_y = point.y
		}
		if point.y > max_y {
			max_y = point.y
		}

		points_per_y[point.y] << point
	}

	for y in min_y .. max_y + 1 {
		line_points := points_per_y[y]

		for x in min_x .. max_x + 1 {
			point := Point{y, x}

			if point in line_points {
				print('#')
			} else if fill && count_lines(line_points.filter(it.x < x)) % 2 == 1
				&& count_lines(line_points.filter(it.x > x)) % 2 == 1 {
				print('#')
			} else {
				print('.')
			}
		}
		println('')
	}
}

fn calc_area_from_points(points []Point) int {
	// find min x, min y, max x, max y
	// for every point in that range
	// check if it is in points or trapped by it
	// if so, add 1m to area
	mut points_per_y := map[int][]Point{}

	mut min_x := int(max_int)
	mut min_y := int(max_int)
	mut max_x := 0
	mut max_y := 0

	for point in points {
		if point.x < min_x {
			min_x = point.x
		}
		if point.x > max_x {
			max_x = point.x
		}
		if point.y < min_y {
			min_y = point.y
		}
		if point.y > max_y {
			max_y = point.y
		}

		points_per_y[point.y] << point
	}

	mut area := 0

	for y in min_y .. max_y + 1 {
		mut line_count := 0
		line_points := points_per_y[y]

		mut previous := Point{-1, -1}
		for x in min_x .. max_x + 1 {
			point := Point{y, x}

			if point in line_points {
				area++
				if previous !in line_points {
					// else: that line was already counted
					line_count++
				}
			} else if line_count % 2 == 1 {
				// currently entrapped
				area++
			}

			previous = point
		}
	}

	return area
}

fn shoestring(points []Point) f32 {
	mut previous := points[points.len - 1]

	mut right_side := 0
	mut left_side := 0

	for point in points {
		right_side += previous.y * point.x
		left_side += previous.x * point.y

		previous = point
	}

	return f32(math.abs(left_side - right_side)) * 0.5
}

fn run(filename string) int {
	rows := os.read_lines(filename) or { panic(err) }

	mut points := []Point{}

	mut line_idx := 0
	mut col_idx := 0

	for row in rows {
		parts := row.split(' ')
		instruction := parts[0]
		length := parts[1].int()

		match instruction {
			'D' {
				line_idx += length
				points << Point{line_idx, col_idx}
			}
			'U' {
				line_idx -= length
				points << Point{line_idx, col_idx}
			}
			'L' {
				col_idx -= length
				points << Point{line_idx, col_idx}
			}
			'R' {
				col_idx += length
				points << Point{line_idx, col_idx}
			}
			else {
				panic('Unknown instruction ${instruction}')
			}
		}
	}

	pretty_points(points, false)
	// pretty_points(points, true)
	// return calc_area_from_points(points)
	result := shoestring(points)
	println(result)
	return int(result)
}

fn main() {
	println(run('dev.txt'))
}
