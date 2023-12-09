module main

fn test_mapping() {
	mymap := Mapping{10, 20, 30, 40, 10}

	assert mymap.source_to_dest(10) or { -1 } == 30
	assert mymap.source_to_dest(15) or { -1 } == 35
	assert mymap.source_to_dest(20) or { -1 } == -1

	assert mymap.dest_to_source(30) or { -1 } == 10
	assert mymap.dest_to_source(35) or { -1 } == 15
	assert mymap.dest_to_source(20) or { -1 } == -1
}

fn test_dev() {
	assert run('dev.txt') == 35
}

fn test_prod() {
	assert run('test.txt') == 178159714
}

fn test_de2v() {
	assert run2('dev.txt') == 46
}

fn test_prod2() {
	assert run2('test.txt') == 100_165_128
}
