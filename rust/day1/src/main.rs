use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn split_string(input: Vec<String>) -> [Vec<i64>; 2] {
    let mut first_column: Vec<i64> = Vec::new();
    let mut second_column: Vec<i64> = Vec::new();
    for line in input {
        let split = line.split_whitespace().collect::<Vec<&str>>();
        first_column.push(split[0].parse::<i64>().unwrap());
        second_column.push(split[1].parse::<i64>().unwrap());
    }

    [first_column, second_column]
}

fn part1(input: [Vec<i64>; 2]) -> i64 {
    let mut first_column = input[0].clone();
    let mut second_column = input[1].clone();
    first_column.sort();
    second_column.sort();
    let mut result = 0;
    for i in 0..first_column.len() {
        result += (first_column[i] - second_column[i]).abs();
    }
    result
}

fn part2(input: [Vec<i64>; 2]) -> usize{
    let mut result = 0;
    for i in 0..input[0].len() {
        let count = input[1].clone().into_iter().filter(|&x| x == input[0][i]).count();
        result += input[0][i] as usize * count;
    }
    result
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    println!("Input: --------");
    println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(split_string(input.clone())));
    println!("The answer to part 2 is: {}", part2(split_string(input)));
}