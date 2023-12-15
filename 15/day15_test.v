module day15

fn test_hash() {
	assert hash('HASH') == 52
}

fn test_dev() {
	assert run('dev.txt') == 1320
}

fn test_prod() {
	assert run('test.txt') == 517551
}

fn test_dev2() {
	assert run2('dev.txt') == 145
}

fn test_prod2() {
	assert run2('test.txt') == 286097
}
