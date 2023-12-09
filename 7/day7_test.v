module day7

fn test_hand_types() {
	assert get_hand_type('AAAAA') == HandType.five
	assert get_hand_type('AA8AA') == HandType.four
	assert get_hand_type('23332') == HandType.full
	assert get_hand_type('TTT98') == HandType.three
	assert get_hand_type('23432') == HandType.two
	assert get_hand_type('A23A4') == HandType.one
	assert get_hand_type('23456') == HandType.high
}

fn test_dev() {
	assert run('dev.txt') == 6440
}

fn test_prod() {
	assert run('test.txt') == 249748283
}

fn test_dev2() {
	assert run2('dev.txt') == 5905
}

fn test_prod2() {
	assert run2('test.txt') == 248029057
}
