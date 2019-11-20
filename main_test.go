package main

import (
	"testing"
)

func TestHello(t *testing.T) {
	if hello() != "Lambda!" {
		t.Fail()
	}
}
