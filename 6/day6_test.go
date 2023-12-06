package day6

import (
	"testing"
)

func TestDev(t *testing.T) {
	result := run("dev.txt")

	if result != 288 {
		t.Fatalf("Incorrect result! %d != 288", result)
	}
}

func TestProd(t *testing.T) {
	result := run("test.txt")

	if result != 1083852 {
		t.Fatalf("Incorrect result! %d != 1083852", result)
	}
}

func TestDev2(t *testing.T) {
	result := run2("dev.txt")

	if result != 71503 {
		t.Fatalf("Incorrect result! %d != 71503", result)
	}
}

func TestProd2(t *testing.T) {
	result := run2("test.txt")

	if result != 23501589 {
		t.Fatalf("Incorrect result! %d != 23501589", result)
	}
}
