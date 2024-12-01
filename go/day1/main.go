package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
	"math"
)

func readFile(filename string) [2][]int {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	var fileLines [2][]int
	for scanner.Scan() {
		fields := strings.Fields(scanner.Text())
		var pairs []int
		for _, field := range fields {
			num, err := strconv.Atoi(field)
			if err != nil {
				panic(err)
			}
			pairs = append(pairs, num)
		}
		fileLines[0] = append(fileLines[0], pairs[0])
		fileLines[1] = append(fileLines[1], pairs[1])
	}
	file.Close()
	return fileLines
}

func part1(fileLines [2][]int) int {
	fmt.Println(fileLines)
	first_column := fileLines[:][0]
	second_column := fileLines[:][1]
	slices.Sort(first_column)
	slices.Sort(second_column)
	var result int = 0
	for i, num1 := range first_column {
		result += int(math.Abs(float64(num1 - second_column[i])))
	}
	return result
}

func part2(fileLines [2][]int) int {
	var result int = 0
	freq := make(map[int]int)
	for _, num := range fileLines[1] {
		freq[num]++
	}
	for _, num := range fileLines[0] {
		if freq[num] > 0 {
			result += num*freq[num]
		}
	}
	return result
}

func main() {

	var filename string = os.Args[1]

	// Read file
	fileLines := readFile(filename)

	// Print the content of the file
	fmt.Println("The content of the file is:")
	for _, line := range fileLines {
		fmt.Println(line)
	}

	// Print answer for part 1
	fmt.Println("The answer for part 1 is: ", part1(fileLines))

	// Print answer for part 2
	fmt.Println("The answer for part 2 is: ", part2(fileLines))
	
}