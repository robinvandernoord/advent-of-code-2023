module day11

fn test_dev() {
	assert run('dev.txt') == 374
}

fn test_prod() {
	assert run('test.txt') == 9312968
}

fn test_dev2() {
	assert run2('dev.txt', 2) == 374
	assert run2('dev.txt', 10) == 1030
	assert run2('dev.txt', 100) == 8410
}

fn test_dev_small() {
	assert run2('dev2.txt', 1) == 4
	assert run2('dev2.txt', 2) == 6
	assert run2('dev2.txt', 10) == 22
	assert run2('dev2.txt', 100) == 202
	assert run2('dev2.txt', 1000) == 2002
	assert run2('dev2.txt', 10000) == 20002
}

fn test_prod2() {
	assert run2('test.txt', 1_000_000) == 597714117556
}
