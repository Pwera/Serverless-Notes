package main

import (
	"fmt"
	"hello"
)

func Hello(args map[string]interface{}) map[string]interface{} {
	fmt.Println("Entering Hello")
	return hello.Hello(args)
}
