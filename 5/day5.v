module main

import os
import arrays

struct Mapping {
	source_start i64
	source_end   i64
	dest_start   i64
	dest_end     i64
	range        i64
}

fn (self Mapping) source_to_dest(value i64) ?i64 {
	if value < self.source_start || value >= self.source_end {
		return none
	}

	return value - self.source_start + self.dest_start
}

fn (self Mapping) dest_to_source(value i64) ?i64 {
	if value < self.dest_start || value >= self.dest_end {
		return none
	}

	return value - self.dest_start + self.source_start
}

fn build_mapping(block string) []Mapping {
	mut mapping := []Mapping{}

	lines := block.split('\n')#[1..].filter(it != '')

	for line in lines {
		values := line.split(' ').map(it.i64())
		dest, source, range := values[0], values[1], values[2]

		mapping << Mapping{source, source + range, dest, dest + range, range}
	}

	return mapping
}

fn get_seeds_and_mappings(input string) ([]i64, [][]Mapping) {
	parts := input.split('\n\n')

	seeds := parts[0].split(': ')[1].split(' ').map(it.i64())
	mapping_blocks := parts#[1..]

	mappings := mapping_blocks.map(build_mapping(it))

	return seeds, mappings
}

struct SeedRange {
	start i64
	stop  i64
	range i64
}

fn (self SeedRange) contains(value i64) bool {
	return value >= self.start && value < self.stop
}

fn get_seeds_and_mappings2(input string) ([]SeedRange, [][]Mapping) {
	seeds, mappings := get_seeds_and_mappings(input)
	mut seed_ranges := []SeedRange{}

	for chunk in arrays.chunk(seeds, 2) {
		start, range := chunk[0], chunk[1]

		seed_ranges << SeedRange{start, start + range, range}
	}

	return seed_ranges, mappings
}

fn process_seed(_seed i64, mapping_blocks [][]Mapping) i64 {
	mut seed := _seed
	for mappings in mapping_blocks {
		for mapping in mappings {
			seed = mapping.source_to_dest(seed) or { continue }
			break // if source_to_dest could be matched, don't update seed again this block!
		}
	}

	return seed
}

fn process_seed_rev(_seed i64, mapping_blocks [][]Mapping) i64 {
	mut seed := _seed
	for mappings in mapping_blocks.reverse() {
		for mapping in mappings {
			seed = mapping.dest_to_source(seed) or { continue }
			break // if source_to_dest could be matched, don't update seed again this block!
		}
	}

	return seed
}

fn run(filename string) i64 {
	content := os.read_file(filename) or { panic('File ${filename} could not be read!') }

	seeds, mapping_blocks := get_seeds_and_mappings(content)

	mut lowest := i64(max_i64)

	for seed_ in seeds {
		seed := process_seed(seed_, mapping_blocks)

		if seed < lowest {
			lowest = seed
		}
	}

	return lowest
}

fn process_range(result chan i64, start i64, stop i64, seed_ranges []SeedRange, mapping_blocks [][]Mapping) bool {
	for i in start .. stop {
		seed := process_seed_rev(i, mapping_blocks)

		for range in seed_ranges {
			if range.contains(seed) {
				result <- i
				return true
			}
		}

		if i % 1_000 == 0 {
			println(i)
		}
	}

	return false
}

fn run2(filename string) i64 {
	content := os.read_file(filename) or { panic('File ${filename} could not be read!') }

	seed_ranges, mapping_blocks := get_seeds_and_mappings2(content)

	result := chan i64{}

	spawn process_range(result, 0, 50_000_000, seed_ranges, mapping_blocks)
	spawn process_range(result, 50_000_000, 100_000_000, seed_ranges, mapping_blocks)
	spawn process_range(result, 100_000_000, 150_000_000, seed_ranges, mapping_blocks)

	return <-result
}
