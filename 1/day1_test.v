module day1

fn test_dev() {
	assert run('dev.txt') == 142
}

fn test_prod() {
	assert run('test.txt') == 55447
}

fn test_dev2() {
	assert run2('dev2.txt') == 281
}

fn test_prod2() {
	assert run2('test.txt') == 54706
}
