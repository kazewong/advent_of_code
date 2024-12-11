use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn blink(input: Vec<i32>) -> Vec<i32> {
    let mut result = Vec::new();
    for i in 0..input.len(){
        if input[i] == 0{
            result.push(1);
        } else if input[i].checked_ilog10() +1 / 2 == 0 {
            
        } else {
            result.push(input[i]*2024);
        }
    }
    result
}

fn part1(input: Vec<String>) -> i32 {
    0
}

fn part2(input: Vec<String>) -> i32{
    0
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    println!("Input: --------");
    println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}