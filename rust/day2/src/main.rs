use std::env::args;
use std::{fs, vec};

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn check_safe_values(value: Vec<i32>) -> bool {
    let mut diff: Vec<i32> = vec![];
    for i in 0..value.len() - 1 {
        diff.push(value[i + 1] - value[i]);
    }
    diff.clone().into_iter().all(|x| 3>=x && x>=1) || diff.into_iter().all(|x| x>=-3 && x<=-1)
}

fn check_safe_part1(input: String) -> bool {
    let split = input.split_whitespace().collect::<Vec<&str>>();
    let value = split
        .into_iter()
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    check_safe_values(value)
}

fn part1(input: Vec<String>) -> i32 {
    let mut result = 0;
    for line in input {
        if check_safe_part1(line.clone()) {
            result += 1;
        }
    }
    result
}

fn check_safe_part2(input: String) -> bool {
    let split = input.split_whitespace().collect::<Vec<&str>>();
    let value = split
        .into_iter()
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    if !check_safe_values(value.clone()) {
        let mut is_safe = false;
        for i in 0..value.len() {
            let mut temp = value.clone();
            temp.remove(i);
            if check_safe_values(temp) {
                is_safe = true;
            }
        }
        return is_safe;
    } else {
        return true;
    }
}

fn part2(input: Vec<String>) -> i32 {
    let mut result = 0;
    for line in input {
        if check_safe_part2(line) {
            result += 1;
        }
    }
    result
}

fn main() {
    // let input = read_input(args().nth(1).unwrap());
    let input = read_input("../asset/day2/data.txt".to_string());
    // let input = read_input("../asset/day2/test.txt".to_string());
    println!("Input: --------");
    println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}
