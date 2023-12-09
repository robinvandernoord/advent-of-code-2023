module main

import os

struct Race {
	time     u64
	distance u64
}

fn extract_races(filename string) []Race {
	lines := os.read_lines(filename) or { panic('File ${filename} could not be read!') }
	mut races := []Race{}

	times := lines[0].split(':')[1].split(' ').filter(it != '').map(it.u64())
	distances := lines[1].split(':')[1].split(' ').filter(it != '').map(it.u64())

	for idx, time in times {
		distance := distances[idx]
		races << Race{time, distance}
	}

	return races
}

fn extract_race2(filename string) []Race {
	lines := os.read_lines(filename) or { panic('File ${filename} could not be read!') }
	mut races := []Race{}

	time := lines[0].split(':')[1].split(' ').filter(it != '').join('').u64()
	distance := lines[1].split(':')[1].split(' ').filter(it != '').join('').u64()

	races << Race{time, distance}

	return races
}

fn beat_race(race &Race) int {
	mut beats := 0

	for hold in 0 .. race.time + 1 {
		// + 1 to make it an inclusive range
		distance := hold * (race.time - hold)
		if distance > race.distance {
			beats++
		}
	}

	return beats
}

fn run(filename string) int {
	races := extract_races(filename)

	mut result := 1
	for race in &races {
		result *= beat_race(race)
	}

	return result
}

fn run2(filename string) int {
	races := extract_race2(filename)

	mut result := 1
	for race in &races {
		result *= beat_race(race)
	}

	return result
}
