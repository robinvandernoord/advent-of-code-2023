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

// func threaded(threadno int, ch_recv chan rune, ch_send chan bool, location string, mapping map[string]Tuple) {
// 	fmt.Printf("new thread! %d\n", threadno)

// 	for instruction := range ch_recv {
// 		if instruction == 'X' {
// 			break
// 		} else if instruction == 'L' {
// 			location = mapping[location].L
// 		} else if instruction == 'R' {
// 			location = mapping[location].R
// 		}

// 		done := location[len(location)-1] == 'Z'
// 		if done {
// 			fmt.Printf("%d - %s\n", threadno, location)
// 		}

// 		ch_send <- done
// 	}
// 	fmt.Printf("%d byebye\n", threadno)
// }

// type Thread struct {
// 	threadno int
// 	ch_send  chan rune
// 	ch_recv  chan bool
// }

// func solve2(instructions string, mapping map[string]Tuple) int {

// 	starting_positions := make([]string, 0, 5)
// 	for position := range mapping {
// 		if position[len(position)-1] == 'A' {
// 			starting_positions = append(starting_positions, position)
// 		}
// 	}

// 	threads := make([]Thread, 0, 5)

// 	for x := 0; x < len(starting_positions); x++ {
// 		fmt.Printf("thread: %d\n", x)
// 		ch_send := make(chan rune) // Creating an unbuffered channel
// 		ch_recv := make(chan bool) // Creating an unbuffered channel

// 		go threaded(x, ch_send, ch_recv, starting_positions[x], mapping)
// 		threads = append(threads, Thread{x, ch_send, ch_recv})
// 	}

// 	rounds := 0

// 	for true {
// 		instruction := instructions[rounds%len(instructions)]
// 		rounds += 1
// 		all := true

// 		for _, thread := range threads {
// 			thread.ch_send <- rune(instruction)
// 		}

// 		for _, thread := range threads {
// 			thread_result := <-thread.ch_recv
// 			if thread_result == false {
// 				all = false
// 			}
// 		}

// 		if all {
// 			break
// 		}
// 	}

// 	// clean up:
// 	for _, thread := range threads {
// 		thread.ch_send <- 'X'
// 	}

// 	return rounds
// }

func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func lcm(a, b int) int {
	return a * b / gcd(a, b)
}

func findSmallestDivisible(numbers []int) int {
	if len(numbers) == 0 {
		return 0
	}
	result := numbers[0]
	for i := 1; i < len(numbers); i++ {
		result = lcm(result, numbers[i])
	}
	return result
}

func solve2(instructions string, mapping map[string]Tuple) int {
	starting_positions := make([]string, 0, 5)
	for position := range mapping {
		if position[len(position)-1] == 'A' {
			starting_positions = append(starting_positions, position)
		}
	}

	options := make([]int, 0, 5)
	for _, start := range starting_positions {
		rounds := 0

		first_match := 0

		for x := 0; x < 10_000_000_000; x++ {
			instruction := instructions[rounds%len(instructions)]
			rounds += 1

			if instruction == 'L' {
				start = mapping[start].L
			} else if instruction == 'R' {
				start = mapping[start].R
			} else {
				panic("Invalid instruction!")
			}

			if start[len(start)-1] == 'Z' {

				if first_match == 0 {
					first_match = rounds
				} else if rounds%first_match == 0 {
					// it looped!
					break
				}

				options = append(options, rounds)
			}
		}
	}

	return findSmallestDivisible(options)
}

func run(filename string) int {
	contents := readFile(filename)

	instructions, rows := split(contents, "\n\n")

	mapping := getMapping(rows)

	return solve(instructions, mapping)
}

func run2(filename string) int {
	contents := readFile(filename)

	instructions, rows := split(contents, "\n\n")

	mapping := getMapping(rows)

	return solve2(instructions, mapping)
}
