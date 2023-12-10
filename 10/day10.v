module day10

import os
import arrays

struct Point {
	y int
	x int
}

fn (self &Cell) reachable(point Point) bool {
	options := self.legal_xy()

	for option in options {
		if option == point {
			return true
		}
	}

	return false
}

fn get_delta_map() map[rune][]Point {
	return {
		`S`: [
			Point{-1, -1},
			Point{-1, 0},
			Point{-1, 1},
			Point{0, -1},
			Point{0, 1},
			Point{1, -1},
			Point{1, 0},
			Point{1, 1},
		]
		`|`: [
			Point{-1, 0},
			Point{1, 0},
		]
		`-`: [
			Point{0, -1},
			Point{0, 1},
		]
		`L`: [
			Point{-1, 0},
			Point{0, 1},
		]
		`J`: [
			Point{-1, 0},
			Point{0, -1},
		]
		`7`: [
			Point{1, 0},
			Point{0, -1},
		]
		`F`: [
			Point{0, 1},
			Point{1, 0},
		]
	}
}

fn (self &Cell) legal_xy() []Point {
	// deltas := match self.symbol {
	// 	`S` {
	// 		[
	// 			Point{-1, -1},
	// 			Point{-1, 0},
	// 			Point{-1, 1},
	// 			Point{0, -1},
	// 			Point{0, 1},
	// 			Point{1, -1},
	// 			Point{1, 0},
	// 			Point{1, 1},
	// 		]
	// 	}
	// 	`|` {
	// 		[
	// 			Point{-1, 0},
	// 			Point{1, 0},
	// 		]
	// 	}
	// 	`-` {
	// 		[
	// 			Point{0, -1},
	// 			Point{0, 1},
	// 		]
	// 	}
	// 	`L` {
	// 		[
	// 			Point{-1, 0},
	// 			Point{0, 1},
	// 		]
	// 	}
	// 	`J` {
	// 		[
	// 			Point{-1, 0},
	// 			Point{0, -1},
	// 		]
	// 	}
	// 	`7` {
	// 		[
	// 			Point{1, 0},
	// 			Point{0, -1},
	// 		]
	// 	}
	// 	`F` {
	// 		[
	// 			Point{1, 0},
	// 			Point{0, 1},
	// 		]
	// 	}
	// 	else {
	// 		[]Point{cap: 0}
	// 	}
	// }
	//
	mapping := get_delta_map()
	if self.symbol !in mapping {
		return []
	}
	deltas := mapping[self.symbol]

	// apply delta's on own x and y:
	return deltas.map(Point{self.y + it.y, self.x + it.x})
}

struct Cell {
	y int
	x int
mut:
	symbol rune
}

fn (self &Cell) point() Point {
	return Point{self.y, self.x}
}

fn (self &Cell) legal_moves(grid map[string]Cell) []Cell {
	mut moves := []Cell{}

	for point in self.legal_xy() {
		x := point.x
		y := point.y
		key := '${y}-${x}'
		if key !in grid {
			// not a valid move
			continue
		}

		other := grid[key]

		if other.reachable(self.point()) {
			moves << other
		}
	}

	return moves
}

fn make_grid(lines []string) (map[string]Cell, Cell) {
	mut grid := map[string]Cell{}
	mut starting_idx := ''

	for y, line in lines {
		for x, symbol in line {
			key := '${y}-${x}'

			if symbol == `S` {
				starting_idx = key
			}

			grid[key] = Cell{y, x, rune(symbol)}
		}
	}

	return grid, grid[starting_idx]
}

fn determine_type_of_s(mut s Cell, grid map[string]Cell) {
	deltas := s.legal_moves(grid).map(Point{it.y - s.y, it.x - s.x})

	mapping := get_delta_map()

	for new_symbol, option in mapping {
		if option == deltas {
			s.symbol = new_symbol
			return
		}
	}
}

fn get_loop(grid map[string]Cell, starting_point Cell) []Cell {
	mut location := starting_point
	mut seen := []Cell{}

	for true {
		seen << location
		moves := location.legal_moves(grid)

		options := moves.filter(!seen.contains(it))

		if options.len == 0 {
			if moves.contains(starting_point) {
				// done!
				break
			}

			panic('No options! :(')
		}

		location = options[0]
	}

	return seen
}

fn setup(filename string) (map[string]Cell, Cell, []Cell) {
	lines := os.read_lines(filename) or { panic('File ${filename} could not be read!') }

	grid, starting_point := make_grid(lines)

	mut loop := get_loop(grid, starting_point)

	determine_type_of_s(mut loop[0], grid)

	return grid, starting_point, loop
}

fn run(filename string) int {
	_, _, loop := setup(filename)
	return loop.len / 2
}

fn count_intersections_x(from int, to int, source Point, loop []Cell, loop_points []Point) int {
	mut intersections := 0

	mut symbol_counter := map[rune]int{}

	for new_x in from .. to {
		new_point := Point{source.y, new_x}

		loop_idx := loop_points.index(new_point)
		if loop_idx != -1 { // loop_points.contains(new_point)
			symbol := loop[loop_idx].symbol

			symbol_counter[symbol]++
		}
	}

	if symbol_counter.len > 0 {
		if (symbol_counter[`L`] + symbol_counter[`|`] + symbol_counter[`J`]) % 2 == 1
			&& (symbol_counter[`F`] + symbol_counter[`|`] + symbol_counter[`7`]) % 2 == 1 {
			return 1
		}
	}

	return intersections
}

fn count_intersections_right(source Point, loop []Cell, loop_points []Point, max_x int) int {
	return count_intersections_x(source.x, max_x + 1, source, loop, loop_points)
}

fn count_intersections_left(source Point, loop []Cell, loop_points []Point) int {
	return count_intersections_x(0, source.x, source, loop, loop_points)
}

// fn count_intersections_y(source Point, loop []Point, max_y int) int {
// 	mut intersections := 0
//
// 	for new_y in source.y .. max_y + 1 {
// 		new_point := Point{new_y, source.x}
// 		if loop.contains(new_point) {
// 			intersections++
// 		}
// 	}
//
// 	return intersections
// }

fn count_enclosed_cells(partial_grid []Cell, loop []Cell, max_x int, max_y int) int {
	mut num_enclosed := 0

	loop_as_points := loop.map(it.point())

	for cell in partial_grid {
		point := cell.point()
		if loop_as_points.contains(point) {
			continue
		}

		intersections_left := count_intersections_left(point, loop, loop_as_points)
		intersections_right := count_intersections_right(point, loop, loop_as_points,
			max_x)

		// intersections_y := count_intersections_y(cell.point(), loop_as_points, max_y)
		// if intersections_x % 2 == 1 && intersections_y % 2 == 1 {
		if intersections_left % 2 == 1 && intersections_right % 2 == 1 {
			// odd -> enclosed
			println(cell)
			num_enclosed++
		}
	}

	return num_enclosed
}

fn run2(filename string) int {
	processes := 10

	grid, _, loop := setup(filename)

	// for every point in grid with x and y between loop min/max
	// increment x
	// count intersections
	// if number of intersections is odd, the point is enclosed

	points := grid.values()

	max_x := arrays.max(points.map(it.x)) or { 0 }
	max_y := arrays.max(points.map(it.y)) or { 0 }

	// to spread over 5 processes, chunk by length / 5
	mut threads := []thread int{}

	for chunk in arrays.chunk(points, points.len / processes) {
		threads << spawn count_enclosed_cells(chunk, loop, max_x, max_y)
	}

	results := threads.wait()
	return arrays.sum(results) or { 0 }
}
