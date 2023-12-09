module day9

fn test_dev() {
	assert run('dev.txt') == 114
}

fn test_prod() {
	result := run('test.txt')
	assert result == 2038472161
}

fn test_dev2() {
	assert run2('dev.txt') == 2
}

fn test_prod2() {
	assert run2('test.txt') == 1091
}
