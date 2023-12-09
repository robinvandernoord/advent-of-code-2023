module day8

fn test_dev() {
	assert run('dev1.txt') == 2
	assert run('dev2.txt') == 6
}

fn test_prod() {
	assert run('test.txt') == 18113
}

fn test_dev2() {
	assert run2('dev3.txt') == 6
}

fn test_prod2() {
	assert run2('test.txt') == 12315788159977
}
