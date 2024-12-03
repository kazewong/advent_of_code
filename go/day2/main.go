package main

import (
	"bufio"
	"fmt"
	"os"
	// "slices"
	"strconv"
	"strings"
	// "math"
)

func readFile(filename string) [][]int {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	var fileLines [][]int
	for scanner.Scan() {
		fields := strings.Fields(scanner.Text())
		var line []int
		for _, field := range fields {
			num, _ := strconv.Atoi(field)
			line = append(line, num)
		}
		fileLines = append(fileLines, line)
	}
	file.Close()
	return fileLines
}

func check_safe_values(values []int) bool {
	var diff []int
	for i := 0; i < len(values) -1; i++ {
		diff = append(diff, values[i+1] - values[i])
	}
	var test_positives bool = true
	for _, d := range diff {
		if (d >= 1) && (d <= 3) {
			test_positives = true
		} else {
			test_positives = false
			break
		}
	}
	var test_negatives bool = true
	for _, d := range diff {
		if (d >= -3) && (d <= -1) {
			test_negatives = true
		} else {
			test_negatives = false
			break
		}
	}
	return test_positives || test_negatives
}

func part1(fileLines [][]int) int {
	var safe_values int = 0
	for _, line := range fileLines {
		if check_safe_values(line) {
			safe_values++
		}
	}
	return safe_values
}

func part2(fileLines [][]int) int {
	var safe_values int = 0
	for _, line := range fileLines {
		if check_safe_values(line) {
			safe_values++
		} else {
			fmt.Println("line: ", line)
			for i := 0; i < len(line); i++ {
				// it seems I have to make copy like this otherwise it would break. 
				temp := make([]int, len(line))
				copy(temp, line)
				temp = append(temp[:i], temp[i+1:]...)
				if check_safe_values(temp) {
					// fmt.Println("i:", i, "temp: ", temp)
					safe_values++
					break
				}
			}
		}
	}
	return safe_values
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