package day7

import (
	"fmt"
	"testing"
)

func TestHandTypes(t *testing.T) {
	tests := []struct {
		input     string
		expected  uint
		testLabel string
	}{
		{"AAAAA", 6, "Five of a Kind"},
		{"AA8AA", 5, "Four of a Kind"},
		{"23332", 4, "Full House"},
		{"TTT98", 3, "Three of a Kind"},
		{"23432", 2, "Two Pairs"},
		{"A23A4", 1, "One Pair"},
		{"23456", 0, "High Card"},
	}

	for _, test := range tests {
		result := calculateHandType(test.input)
		if result != test.expected {
			t.Errorf("Failed test '%s': expected %d but got %d", test.testLabel, test.expected, result)
		}
	}
}

func TestDev(t *testing.T) {
	result := run("dev.txt")

	if result != 6440 {
		t.Fatalf("Incorrect result! %d != 6440", result)
	}
}

func TestProd(t *testing.T) {
	result := run("test.txt")

	if result != 249748283 {
		t.Fatalf("Incorrect result! %d != 249748283", result)
	}
}

func TestDev2(t *testing.T) {
	result := run2("dev.txt")

	if result != 5905 {
		t.Fatalf("Incorrect result! %d != 5905", result)
	}
}

func TestProd2(t *testing.T) {
	result := run2("test.txt")

	fmt.Printf("part 2: %d", result)
	// 248238926: too high
}
