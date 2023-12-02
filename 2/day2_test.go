package day2

import (
	"fmt"
	"testing"
)

// func TestDev(t *testing.T) {
// 	result := run("dev.txt")

// 	if result != 8 {
// 		t.Fatalf("Incorrect result! %d != 8", result)
// 	}
// }

func TestDe2(t *testing.T) {
	result := run2("dev.txt")

	if result != 2286 {
		t.Fatalf("Incorrect result! %d != 2286", result)
	}
}

// func TestProd(t *testing.T) {
// 	result := run("test.txt")

// 	if result == 0 {
// 		t.Fatalf("Incorrect result! %d = 0", result)
// 	} else {
// 		fmt.Printf("%d\n", result)
// 	}
// }

func TestProd2(t *testing.T) {
	result := run2("test.txt")

	if result == 0 {
		t.Fatalf("Incorrect result! %d = 0", result)
	} else {
		fmt.Printf("%d\n", result)
	}
}
