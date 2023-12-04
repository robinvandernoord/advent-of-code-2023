package day4

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readFile(filename string) string {
	dat, err := os.ReadFile(filename)
	check(err)
	return string(dat)
}

func to_int(char string) int {
	value, err := strconv.Atoi(char)
	check(err)
	return value
}

func findMatching(row string) int {
	_data := strings.Split(row, ":")[1]
	data := strings.Split(_data, "|")
	_winning, _having := data[0], data[1]
	winning := strings.Split(_winning, " ")
	having := strings.Split(_having, " ")

	matching := 0

	for _, _x := range winning {
		_x = strings.TrimSpace(_x)
		if _x == "" {
			continue
		}

		for _, _y := range having {
			_y = strings.TrimSpace(_y)
			if _y == "" {
				continue
			}

			x := to_int(_x)
			y := to_int(_y)

			if x == y {
				matching++
			}

		}
	}

	return matching
}

func processRow(row string) int {
	// 0 matching -> 0 points
	// 1 matching -> 1 points
	// 2 matching -> 2 points
	// 3 matching -> 4 points
	// 4 matching -> 8 points
	// f(n)=2^(n-1)
	// this formula does NOT work for n = 0
	// but we can just manually check that case

	matching := findMatching(row)

	if matching != 0 {
		fmt.Printf("matching: %d\n", matching)
		// f(n)=2^(n-1)
		n := float64(matching - 1)
		points := math.Pow(2, n)
		return int(points)
	} else {
		return 0
	}
}

type memoized struct {
	f     func(int) int
	cache map[int]int
}

func (m *memoized) memoize(n int) int {
	if val, ok := m.cache[n]; ok {
		return val
	}
	result := m.f(n)
	m.cache[n] = result
	return result
}

func memoize(f func(int) int) *memoized {
	return &memoized{f: f, cache: make(map[int]int)}
}

func _processRow2(row string, rows []string, idx int) int {
	// result: 1 + sum(process(winning))
	matching := findMatching(row)

	result := 1

	for i := 1; i <= matching; i++ {
		new_idx := idx + i

		if new_idx >= len(rows) {
			// out of bounds, skip!
			continue
		}

		result += processRow2(rows[new_idx], rows, new_idx)
	}

	return result
}

func processRow2(row string, rows []string, idx int) int {
	process := func(_idx int) int {
		return _processRow2(row, rows, _idx)
	}

	mem := memoize(process)

	return mem.memoize(idx)
}

func run2(filename string) int {
	result := 0

	contents := readFile(filename)
	rows := strings.Split(contents, "\n")

	for idx, row := range rows {
		result += processRow2(row, rows, idx)
	}

	return result
}
