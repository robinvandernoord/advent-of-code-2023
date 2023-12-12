module day12

fn test_examples() {
	assert process_line('???.### 1,1,3') == 1
	assert process_line('.??..??...?##. 1,1,3') == 4
	assert process_line('?#?#?#?#?#?#?#? 1,3,1,6') == 1
	assert process_line('????.#...#... 4,1,1') == 1
	assert process_line('????.######..#####. 1,6,5') == 4
	assert process_line('?###???????? 3,2,1') == 10
}

fn test_dev() {
	assert run('dev.txt') == 21
}

fn test_prod() {
	assert run('test.txt') == 7191
}

fn test_examples2() {
	assert process_line2('.???.### 1,1,3') == 1
	assert process_line2('.??..??...?##. 1,1,3') == 16384
	assert process_line2('?#?#?#?#?#?#?#? 1,3,1,6') == 1
	assert process_line2('????.#...#... 4,1,1') == 16
	assert process_line2('????.######..#####. 1,6,5') == 2500
	assert process_line2('?###???????? 3,2,1') == 506250
}

fn test_dev2() {
	assert run2('dev.txt') == 525152
}

fn test_prod2() {
	assert run2('test.txt') == 6512849198636
}
