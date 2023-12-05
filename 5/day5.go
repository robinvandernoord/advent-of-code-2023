package day5

import (
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

type Mapping struct {
	from int
	to   int
	dest int
}

func newMapping(from int, rng int, dest int) Mapping {
	mapping := Mapping{}

	mapping.from = from
	mapping.to = from + rng
	mapping.dest = dest

	return mapping
}

func createMap(rows string) []Mapping {
	mapping := make([]Mapping, 0)

	lines := strings.Split(rows, "\n")[1:]

	for _, line := range lines {
		if line == "" {
			continue
		}

		parts := strings.Split(line, " ")
		_dest, _src, _rng := parts[0], parts[1], parts[2]
		dest := to_int(_dest)
		src := to_int(_src)
		rng := to_int(_rng)

		mapping = append(mapping, newMapping(src, rng, dest))

	}

	return mapping
}

func extractSeeds(row string) []int {
	seeds := make([]int, 0, 5)

	_seeds := strings.Split(row, ": ")[1]
	_nums := strings.Split(_seeds, " ")

	for _, num := range _nums {
		seeds = append(seeds, to_int(num))
	}

	return seeds
}

func chunkBy[T any](items []T, chunkSize int) (chunks [][]T) {
	for chunkSize < len(items) {
		items, chunks = items[chunkSize:], append(chunks, items[0:chunkSize:chunkSize])
	}
	return append(chunks, items)
}

func extractSeeds2(row string) []int {
	seeds := make([]int, 0, 5)

	_seeds := strings.Split(row, ": ")[1]
	_nums := strings.Split(_seeds, " ")

	chunked := chunkBy(_nums, 2)

	for _, chunk := range chunked {
		_start, _rng := chunk[0], chunk[1]
		start := to_int(_start)
		rng := to_int(_rng)
		end := start + rng

		for x := start; x < end; x++ {
			seeds = append(seeds, x)
		}

	}

	return seeds
}

func run(filename string) int {
	contents := readFile(filename)

	splitted := strings.Split(contents, "\n\n")

	_seeds, _maps := splitted[0], splitted[1:]
	seeds := extractSeeds2(_seeds)

	maps := [][]Mapping{}

	for _, entry := range _maps {
		maps = append(maps, createMap(entry))
	}

	lowest := math.MaxInt64

	for _, seed := range seeds {
		for _, mappings := range maps {

			for _, mapping := range mappings {

				if seed >= mapping.from && seed < mapping.to {
					delta := seed - mapping.from
					seed = mapping.dest + delta
					break // prevent double mapping
				}

			}

		}

		if seed < lowest {
			lowest = seed
		}

	}

	return lowest
}
