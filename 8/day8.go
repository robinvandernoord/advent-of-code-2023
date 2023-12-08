package day8

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

func to_int(char string) int {
	value, err := strconv.Atoi(char)
	check(err)
	return value
}

func split(input string, on string) (string, string) {
	_sliced := strings.Split(input, on)
	return _sliced[0], _sliced[1]
}

func readFile(filename string) string {
	dat, err := os.ReadFile(filename)
	check(err)
	return string(dat)
}

type Tuple struct {
	L string
	R string
}

func getMapping(rows string) map[string]Tuple {
	mapping := map[string]Tuple{}

	for _, map_str := range strings.Split(rows, "\n") {
		if map_str == "" {
			continue
		}

		from, _to := split(map_str, " = ")
		_to = strings.Trim(_to, "(")
		_to = strings.Trim(_to, ")")
		l, r := split(_to, ", ")

		mapping[from] = Tuple{l, r}
	}

	return mapping
}

func solve(instructions string, mapping map[string]Tuple) int {
	start := "AAA"
	end := "ZZZ"

	rounds := 0
	for start != end {
		instruction := instructions[rounds%len(instructions)]
		rounds += 1

		if instruction == 'L' {
			start = mapping[start].L
		} else if instruction == 'R' {
			start = mapping[start].R
		} else {
			panic("Invalid instruction!")
		}
	}

	return rounds
}

func run(filename string) int {
	contents := readFile(filename)

	instructions, rows := split(contents, "\n\n")

	mapping := getMapping(rows)

	return solve(instructions, mapping)
}
