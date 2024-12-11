use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn blink(input: Vec<u64>) -> Vec<u64> {
    let mut result = Vec::new();
    for i in 0..input.len(){
        if input[i] == 0{
            result.push(1);
        } else if (input[i].ilog10() + 1) % 2 == 0 {
            let n_digits = input[i].ilog10() + 1;
            let first_half = input[i] / 10u64.pow(n_digits/2);
            let second_half = input[i] % 10u64.pow(n_digits/2);
            result.push(first_half);
            result.push(second_half);
        } else {
            result.push(input[i]*2024);
        }
    }
    result
}

fn part1(input: Vec<String>) -> u64 {
    let input: Vec<u64> = input[0].split(" ").map(|s| s.parse::<u64>().unwrap()).collect();
    let mut result = input.clone();
    for i in 0..25{
        println!("{:?}", i);
        result = blink(result);
    }
    println!("{:?}", result);
    result.len() as u64
}

fn part2(input: Vec<String>) -> u64{
    0
}

fn main(){
    // let input = read_input(args().nth(1).unwrap());
    let input = read_input("../asset/day11/data.txt".to_string());

    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}