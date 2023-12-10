module day3

fn test_dev() {
	assert run('dev.txt') == 4361
}

fn test_prod() {
	assert run('test.txt') == 546563
}

fn test_dev2() {
	assert run2('dev.txt') == 467835
}

fn test_prod2() {
	assert run2('test.txt') == 91031374
}
