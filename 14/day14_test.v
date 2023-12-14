module day14

fn test_dev() {
	assert run('dev.txt') == 136
}

fn test_prod() {
	assert run('test.txt') == 105461
}

fn test_dev2() {
	assert run2('dev.txt') == 64
}

fn test_prod2() {
	assert run2('test.txt') == 102829
}
