package day8

import (
	"testing"
)

func TestDev1(t *testing.T) {
	result := run("dev1.txt")

	if result != 2 {
		t.Fatalf("Incorrect result! %d != 2", result)
	}

}

func TestDev2(t *testing.T) {
	result := run("dev2.txt")

	if result != 6 {
		t.Fatalf("Incorrect result! %d != 6", result)
	}
}

func TestProd(t *testing.T) {
	result := run("test.txt")

	if result != 18113 {
		t.Fatalf("Incorrect result! %d != 18113", result)
	}
}

// func TestDev3(t *testing.T) {
// 	result := run2("dev.txt")

// 	if result != 5905 {
// 		t.Fatalf("Incorrect result! %d != 5905", result)
// 	}
// }

// func TestProd2(t *testing.T) {
// 	result := run2("test.txt")

// 	fmt.Printf("part 2: %d", result)
// 	// 248238926: too high
// }
