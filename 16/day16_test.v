module day16

fn test_dev() {
	assert run('dev.txt') == 46
}

fn test_prod() {
	assert run('test.txt') == 7884
}

fn test_dev2() {
	assert run2('dev.txt') == 51
}

fn test_prod2() {
	assert run2('test.txt') == 8185
}
