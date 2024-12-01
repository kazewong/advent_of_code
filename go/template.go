package main

import (
	"fmt"
	"bufio"
	"os"
)

func readFile(filename string) []string {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	var fileLines []string
	for scanner.Scan() {
		fileLines = append(fileLines, scanner.Text())
	}
	file.Close()
	return fileLines
}

func part1(fileLines []string) int {
	return 0	
}

func part2(fileLines []string) int {
	return 0
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