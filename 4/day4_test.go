package day4

import (
	"testing"
)

// func TestDev(t *testing.T) {
// 	result := run("dev.txt")

// 	if result != 13 {
// 		t.Fatalf("Incorrect result! %d != 13", result)
// 	}
// }

func TestDev2(t *testing.T) {
	result := run2("dev.txt")

	if result != 30 {
		t.Fatalf("Incorrect result! %d != 30", result)
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

// func TestProd2(t *testing.T) {
// 	result := run2("test.txt")

// 	if result == 0 {
// 		t.Fatalf("Incorrect result! %d = 0", result)
// 	} else {
// 		fmt.Printf("%d\n", result)
// 	}
// }
