package day5

import (
	"fmt"
	"testing"
)

// func TestDev(t *testing.T) {
// 	result := run("dev.txt")

// 	if result != 35 {
// 		t.Fatalf("Incorrect result! %d != 35", result)
// 	}
// }

func TestDev2(t *testing.T) {
	result := run("dev.txt")

	if result != 46 {
		t.Fatalf("Incorrect result! %d != 46", result)
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
	result := run("test.txt")

	if result == 0 {
		t.Fatalf("Incorrect result! %d = 0", result)
	} else {
		fmt.Printf("%d\n", result)
	}
}
