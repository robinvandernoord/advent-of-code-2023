module day18

fn test_shoestring() {
	points := [
		Point{10, 4},
		Point{7, 9},
		Point{2, 11},
		Point{2, 2},
	]
	assert shoestring(points) == 45.5
}

fn test_dev() {
	assert run('dev.txt') == 62
}

// fn test_prod() {
// 	result := run('test.txt')
// 	assert result > 48278 // 48278 is too low
// 	assert result < 58960 // 58960 is too high
// }
