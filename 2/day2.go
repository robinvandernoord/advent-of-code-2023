package day2

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

func getEmptyBag() map[string]int {
	contents := make(map[string]int)

	contents["red"] = 0
	contents["green"] = 0
	contents["blue"] = 0

	return contents
}

// func getBag() map[string]int {
// 	contents := make(map[string]int)

// 	contents["red"] = 12
// 	contents["green"] = 13
// 	contents["blue"] = 14

// 	return contents
// }

// func isValidMove(move string) bool {
// 	bag := getBag()

// 	for _, cubes := range strings.Split(move, ",") {
// 		splitted_cubes := strings.Split(cubes, " ")
// 		_count, color := splitted_cubes[1], splitted_cubes[2]
// 		count, err := strconv.Atoi(_count)
// 		check(err)

// 		bag[color] -= count

// 		if bag[color] < 0 {
// 			// invalid!
// 			return false
// 		}
// 	}

// 	return true
// }

// func isValidRow(row string) int {
// 	// if  valid: return ID
// 	// else, return 0
// 	if row == "" {
// 		// empty is invalid
// 		return 0
// 	}

// 	raw_id, game := split(row, ":")
// 	_, _id := split(raw_id, " ")
// 	id, err := strconv.Atoi(_id)
// 	check(err)

// 	moves := strings.Split(game, ";")

// 	row_valid := true
// 	for _, move := range moves {
// 		move_valid := isValidMove(move)
// 		if !move_valid {
// 			row_valid = false
// 			break
// 		}
// 	}

// 	if row_valid {
// 		return id
// 	} else {
// 		return 0
// 	}
// }

// func run(filename string) int {
// 	dat, err := os.ReadFile(filename)
// 	check(err)

// 	rows := strings.Split(string(dat), "\n")

// 	result := 0

// 	for _, row := range rows {
// 		result += isValidRow(row)
// 	}

// 	return result
// }
// }

func parseRow(row string) int {
	// if  valid: return ID
	// else, return 0
	if row == "" {
		// empty is invalid
		return 0
	}

	_, game := split(row, ":")

	moves := strings.Split(game, ";")

	bag := getEmptyBag()
	for _, move := range moves {
		stones := strings.Split(move, ",")
		for _, stone := range stones {
			splitted := strings.Split(stone, " ")
			_count, color := splitted[1], splitted[2]
			count, err := strconv.Atoi(_count)
			check(err)

			if count > bag[color] {
				bag[color] = count
			}
		}
	}

	result := 1
	for _, count := range bag {
		result *= count
	}

	return result
}

func run2(filename string) int {
	dat, err := os.ReadFile(filename)
	check(err)

	rows := strings.Split(string(dat), "\n")

	result := 0

	for _, row := range rows {
		result += parseRow(row)
	}

	return result
}
