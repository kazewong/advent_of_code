use std::env::args;
use std::{fs, result, vec};

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn scan_line(line: &str) -> i32 {
    let strings = line.split("mul(").collect::<Vec<&str>>();
    let mut result = 0;
    let mut buffer1 = Vec::<char>::new();
    let mut buffer2 = Vec::<char>::new();
    let mut buffer_switch = false;
    for string in strings{
        for char in string.chars(){
            if char.is_ascii_digit(){
                if buffer_switch{
                    buffer2.push(char);
                } else{
                    buffer1.push(char);
                }
            }
            else if char == ','{
                buffer_switch = true;
            }
            else if char == ')' && buffer1.len() > 0 && buffer2.len() > 0{
                result += buffer1.iter().collect::<String>().parse::<i32>().unwrap() * buffer2.iter().collect::<String>().parse::<i32>().unwrap();
                buffer1.clear();
                buffer2.clear();
                buffer_switch = false;
                break;
            }
            else {
                buffer1.clear();
                buffer2.clear();
                buffer_switch = false;
                break;
                
            }
        }
    }
    result
}

fn part1(input: Vec<String>) -> i32 {
    let mut result = 0;
    for line in input {
        result += scan_line(&line);
    }
    result
}

fn scan_line_part2(line: &str) -> i32 {
    let mut result = 0;
    let strings = line.split("do()").collect::<Vec<&str>>();
    for string in strings{
        let valid = string.split("don't()").collect::<Vec<&str>>();
        result += scan_line(valid[0]);
    }
    result
}

fn part2(input: Vec<String>) -> i32 {
    let mut result = 0;
    for line in input {
        result += scan_line_part2(&line);
    }
    result
}

fn main() {
    // let input = read_input(args().nth(1).unwrap());
    let input = read_input("../asset/day3/data.txt".to_string());
    // println!("Input: --------");
    println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}
