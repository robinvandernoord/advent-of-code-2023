module day4

fn test_dev() {
	assert run('dev.txt') == 13
}

fn test_prod() {
	assert run('test.txt') == 18519
}

fn test_dev2() {
	assert run2('dev.txt') == 30
}

fn test_prod2() {
	assert run2('test.txt') == 11787590
}
