module day10

fn test_dev() {
	assert run('dev0.txt') == 4
	assert run('dev1.txt') == 4
	assert run('dev2.txt') == 8
	assert run('dev3.txt') == 8
}

// fn test_prod() {
// 	assert run('test.txt') == 6725
// }

fn dev_count_intersections(input string) int {
	y := 0

	mut loop_points := []Point{}
	mut loop := []Cell{}

	for x, symbol in input.runes()#[1..] {
		if symbol == `.` {
			continue
		}

		loop << Cell{y, x, symbol}
		loop_points << Point{y, x + 1}
	}

	return count_intersections_right(Point{0, 0}, loop, loop_points, input.len)
}

fn test_intersections() {
	assert dev_count_intersections('XL--J') == 0
	assert dev_count_intersections('XL---J') == 0

	assert dev_count_intersections('XL--7') == 1
	assert dev_count_intersections('XL---7') == 1

	assert dev_count_intersections('XL--JF--7') == 0
	assert dev_count_intersections('XL--JF---7') == 0
}

fn test_dev2() {
	assert run2('dev4.txt') == 4
	assert run2('dev5.txt') == 8
	assert run2('dev6.txt') == 10
}

fn test_prod2() {
	assert run2('test.txt') == 383
}
