module day15

import os

fn hash(input string) int {
	mut result := 0

	for letter in input {
		result += letter
		result *= 17
		result %= 256
	}

	return result
}

fn run(filename string) int {
	contents := os.read_file(filename) or { panic(err) }

	mut result := 0

	for instruction in contents.replace('\n', '').split(',') {
		result += hash(instruction)
	}

	return result
}

fn split(input string, sep string) (string, string) {
	splitted := input.split(sep)
	return splitted[0], splitted[1]
}

fn fill_boxes(instructions []string) map[int][]int {
	mut boxes := map[int][]string{}
	mut boxes_with_focal := map[int][]int{}

	for instruction in instructions {
		if instruction.contains('-') {
			// remove
			box_id, _ := split(instruction, '-')
			box_hash := hash(box_id)

			box_idx := boxes[box_hash].index(box_id)

			if box_idx > -1 {
				boxes[box_hash].delete(box_idx)
				boxes_with_focal[box_hash].delete(box_idx)
			}
		} else if instruction.contains('=') {
			// add focal length
			box_id, focal_length := split(instruction, '=')
			box_hash := hash(box_id)

			box_idx := boxes[box_hash].index(box_id)

			if box_idx == -1 {
				// add lens
				boxes[box_hash] << box_id
				boxes_with_focal[box_hash] << focal_length.int()
			} else {
				// replace lens
				boxes_with_focal[box_hash][box_idx] = focal_length.int()
			}
		} else {
			panic('Invalid instruction! ${instruction}')
		}
	}

	return boxes_with_focal
}

fn run2(filename string) int {
	contents := os.read_file(filename) or { panic(err) }

	boxes := fill_boxes(contents.replace('\n', '').split(','))

	mut result := 0

	for box_no, lenses in boxes {
		for lens_idx, lens in lenses {
			result += (box_no + 1) * (lens_idx + 1) * lens
		}
	}

	return result
}
