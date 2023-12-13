module day13

fn test_dev() {
	assert run('dev.txt') == 405
}

fn test_prod() {
	assert run('test.txt') == 43614
}

fn test_dev2() {
	assert run2('dev.txt') == 400
}

fn test_prod2() {
	result := run2('test.txt')

	assert result == 36771
}
