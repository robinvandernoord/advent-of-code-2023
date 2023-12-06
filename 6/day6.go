package day6

import (
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func split(input string, on string) (string, string) {
	_sliced := strings.Split(input, on)
	return _sliced[0], _sliced[1]
}

func to_int(char string) int {
	value, err := strconv.Atoi(char)
	check(err)
	return value
}

func readFile(filename string) string {
	dat, err := os.ReadFile(filename)
	check(err)
	return string(dat)
}

type Race struct {
	time int
	dist int
}

func getRaces(contents string) []Race {
	races := []Race{}

	time_row, distance_row := split(contents, "\n")

	time_row = strings.Split(time_row, ":")[1]
	distance_row = strings.Split(distance_row, ":")[1]

	times := []int{}
	distances := []int{}

	for _, _time := range strings.Split(time_row, " ") {
		if _time == "" {
			continue
		}

		times = append(times, to_int(_time))
	}

	for _, _dist := range strings.Split(distance_row, " ") {
		if _dist == "" {
			continue
		}

		distances = append(distances, to_int(_dist))
	}

	for i, time := range times {
		dist := distances[i]

		races = append(races, Race{time, dist})
	}

	return races
}

func getRace2(contents string) []Race {
	races := make([]Race, 0, 1)

	time_row, distance_row := split(contents, "\n")

	time_row = strings.Split(time_row, ":")[1]
	distance_row = strings.Split(distance_row, ":")[1]

	_time := ""

	for _, part := range strings.Split(time_row, " ") {
		if part == "" {
			continue
		}

		_time += part
	}

	time := to_int(_time)

	_dist := ""

	for _, part := range strings.Split(distance_row, " ") {
		if part == "" {
			continue
		}

		_dist += part
	}

	dist := to_int(_dist)

	races = append(races, Race{time, dist})

	return races
}

func winRace(race Race) int {
	wins := 0

	for hold := 0; hold <= race.time; hold++ {
		distance := hold * (race.time - hold)
		if distance > race.dist {
			wins++
		}
	}

	return wins
}

func run(filename string) int {
	contents := readFile(filename)

	result := 1

	races := getRaces(contents)

	for _, race := range races {
		result *= winRace(race)
	}

	return result
}

func run2(filename string) int {
	contents := readFile(filename)

	result := 1

	races := getRace2(contents)

	for _, race := range races {
		result *= winRace(race)
	}

	return result
}
