package day5

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

type Mapping struct {
	from int
	to   int
	dest int
	rng  int
}

func newMapping(from int, rng int, dest int) Mapping {
	return Mapping{from, from + rng, dest, rng}
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

type SeedRange struct {
	from int
	to   int
	rng  int
}

func extractSeeds2(row string) []SeedRange {
	seeds := make([]SeedRange, 0, 5)

	_seeds := strings.Split(row, ": ")[1]
	_nums := strings.Split(_seeds, " ")

	chunked := chunkBy(_nums, 2)

	for _, chunk := range chunked {
		_start, _rng := chunk[0], chunk[1]
		start := to_int(_start)
		rng := to_int(_rng)
		end := start + rng

		seeds = append(seeds, SeedRange{start, end, rng})

	}

	return seeds
}

func run(filename string) int {
	contents := readFile(filename)

	splitted := strings.Split(contents, "\n\n")

	_seeds, _maps := splitted[0], splitted[1:]
	seeds := extractSeeds(_seeds)

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

func isInSeedRange(start int, seeds []SeedRange, maps [][]Mapping) bool {
	for _, mappings := range maps {
		for _, mapping := range mappings {
			if start >= mapping.dest && start < mapping.dest+mapping.rng {
				start = mapping.from + start - mapping.dest
				break
			}

		}
	}

	for _, sr := range seeds {
		if start >= sr.from && start < sr.to {
			return true
		}
	}

	return false
}

func processRange(from int, to int, seeds []SeedRange, maps [][]Mapping, out chan int) {
	for i := from; i < to; i++ {
		if isInSeedRange(i, seeds, maps) {
			out <- i
			return
		}
	}
}

func reverse[T any](maps []T) {
	for i, j := 0, len(maps)-1; i < j; i, j = i+1, j-1 {
		maps[i], maps[j] = maps[j], maps[i]
	}
}

func run2(filename string) int {
	contents := readFile(filename)

	splitted := strings.Split(contents, "\n\n")

	_seeds, _maps := splitted[0], splitted[1:]
	seeds := extractSeeds2(_seeds)

	maps := [][]Mapping{}

	for _, entry := range _maps {
		maps = append(maps, createMap(entry))
	}

	reverse(maps)

	ch := make(chan int) // Creating an unbuffered channel

	for i := 0; i < 8; i++ {
		// start 8 threads with different ranges
		start := 10_000_000_000 * i
		end := 10_000_000_000 * (i + 1)
		fmt.Printf("thread %d: range %d - %d\n", i, start, end)
		go processRange(start, end, seeds, maps, ch)
	}

	return <-ch // Receiving the value from the channel
}
