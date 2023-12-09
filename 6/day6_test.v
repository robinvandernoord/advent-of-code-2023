module main

fn test_dev() {
	assert run('dev.txt') == 288
}

fn test_prod() {
	assert run('test.txt') == 1083852
}

fn test_dev2() {
	assert run2('dev.txt') == 71503
}

fn test_prod2() {
	assert run2('test.txt') == 23501589
}
