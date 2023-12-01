package day1

import (
	"fmt"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// func run(filename string) int {
// 	fmt.Printf("open %s\n", filename)

// 	dat, err := os.ReadFile(filename)
// 	check(err)

// 	rows := strings.Split(string(dat), "\n")

// 	result := 0
// 	for _, value := range rows {
// 		first := 0
// 		second := 0

// 		for _, char := range value {
// 			// is_digit := char >= 48 && char <= 57
// 			is_digit := char >= '0' && char <= '9'

// 			if first == 0 && is_digit {
// 				first = int(char - '0')
// 			}

// 			if is_digit {
// 				second = int(char - '0')
// 			}
// 		}

// 		result += (first*10 + second)
// 	}

// 	return result
// }

var mapping map[string]int

func setup() {
	counts := [10]string{"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

	mapping = make(map[string]int)
	for idx, name := range counts {
		mapping[name] = idx
	}
}

/*
def convert(text: str):
    for pointer in range(len(text)):
        subtext = text[pointer:]
        for word, number in mapping.items():
            if subtext.startswith(word):
                text = text[:pointer] + subtext.replace(word, str(number))
                break

    return text
*/

func convert(value string) string {
	for pointer := range value {
		if pointer > len(value) {
			// size of value was updated in loop, stop now!
			break
		}

		subtext := value[pointer:]

		for word, number := range mapping {
			if strings.HasPrefix(subtext, word) {
				value = value[:pointer] + strings.Replace(subtext, word, fmt.Sprint(number), 1)
				break
				// value = value[:pointer] + strings.Replace(subtext, value, fmt.Sprint(number), 1)
			}
		}
	}

	return value
}

func run(filename string) int {
	setup()
	fmt.Printf("open %s\n", filename)

	dat, err := os.ReadFile(filename)
	check(err)

	rows := strings.Split(string(dat), "\n")

	result := 0
	for _, value := range rows {
		first := 0
		second := 0

		value = convert(value)

		for _, char := range value {
			// is_digit := char >= 48 && char <= 57
			is_digit := char >= '0' && char <= '9'

			if first == 0 && is_digit {
				first = int(char - '0')
			}

			if is_digit {
				second = int(char - '0')
			}

		}

		fmt.Printf("%s - %d - %d\n", value, first, second)
		result += (first*10 + second)
	}

	return result
}
