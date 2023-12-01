package day1

import (
	"fmt"
	"testing"
)

func TestDev(t *testing.T) {
	result := run("dev.txt")

	if result != 142 {
		t.Fatalf("Incorrect result! %d != 142", result)
	}
}

func TestDev2(t *testing.T) {
	result := run("dev2.txt")

	if result != 281 {
		t.Fatalf("Incorrect result! %d != 281", result)
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
