package day3

import (
	"fmt"
	"testing"
)

func TestDev(t *testing.T) {
	result := run("dev.txt")

	if result != 4361 {
		t.Fatalf("Incorrect result! %d != 4361", result)
	}
}

func TestProd(t *testing.T) {
	result := run("test.txt")

	if result == 0 {
		t.Fatalf("Incorrect result! %d = 0", result)
	} else {
		fmt.Printf("%d\n", result)
	}
}
