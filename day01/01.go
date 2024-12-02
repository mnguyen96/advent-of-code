package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

func main() {
	filePath := os.Args[1]
	counter := 0
	readFile, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
	}
	var left []int
	var right []int
	var temp int
	scanner := bufio.NewScanner(readFile)

	for scanner.Scan() {
		line := scanner.Text()
		temp, err = strconv.Atoi(line[0:5])
		if err != nil {
			fmt.Println("ERROR READING left")
		}
		left = append(left, temp)
		temp, err = strconv.Atoi(line[8:13])
		if err != nil {
			fmt.Println("ERROR READING right")
		}
		right = append(right, temp)
	}
	sort.Ints(left)
	sort.Ints(right)

	for i := range left {
		counter += abs(left[i] - right[i])
	}
	fmt.Println("Total distance", counter)

	rightMap := make(map[string]int)

	for _, v := range right {
		rightMap[strconv.Itoa(v)] += 1
	}

	var similarity int
	for _, v := range left {
		similarity += v * rightMap[strconv.Itoa(v)]
	}
	fmt.Println(similarity)
}

func abs(a int) int {
	if a >= 0 {
		return a
	}
	return -a
}
