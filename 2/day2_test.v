module day2

fn test_dev() {
	assert run('dev.txt') == 8
}

fn test_prod() {
	assert run('test.txt') == 2679
}

fn test_dev2() {
	assert run2('dev.txt') == 2286
}

fn test_prod2() {
	assert run2('test.txt') == 77607
}
