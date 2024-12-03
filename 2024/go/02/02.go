package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	readFile, err := os.Open("../../inputs/02.txt")
	if err != nil {
		fmt.Println(err)
	}
	scanner := bufio.NewScanner(readFile)

	var list [][]int
	for scanner.Scan() {
		line := scanner.Text()
		numText := strings.Split(line, " ")

		var numbers []int
		for _, part := range numText {
			num, err := strconv.Atoi(part)
			if err != nil {
				fmt.Println("Error converting to int:", err)
				continue
			}
			numbers = append(numbers, num)
		}
		list = append(list, numbers)
	}
	var safeCount int
	for _, report := range list {
		if isValid(report) {
			safeCount++
		}
	}
	fmt.Println(safeCount)

	safeCount = 0
	for _, report := range list {
		for i := 0; i < len(report); i++ {
			// make slice without current level
			slice := make([]int, 0, len(report)-1)
			slice = append(slice, report[:i]...)
			slice = append(slice, report[i+1:]...)
			if isValid(slice) {
				safeCount++
				break
			}
		}
	}
	fmt.Println(safeCount)
}

func isValid(report []int) bool {
	var lastSign int
	for i := 1; i < len(report); i++ {
		level := report[i]
		currDiff := level - report[i-1]
		if currDiff == 0 || abs(currDiff) < 1 || abs(currDiff) > 3 || lastSign > 0 && currDiff < 0 || lastSign < 0 && currDiff > 0 {
			return false
		}
		if currDiff < 0 {
			lastSign = -1
		} else if currDiff > 0 {
			lastSign = 1
		}
	}
	return true
}

func abs(a int) int {
	if a >= 0 {
		return a
	}
	return -a
}
