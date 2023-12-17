module day17

// fn test_dev() {
// 	assert run('dev.txt') == 102
// }

fn test_prod() {
	result := run('test.txt')
	assert result > 0
	assert result == -1
	// 1010: too high
}
