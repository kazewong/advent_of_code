use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn check_line(target: u64, components: Vec<u64>) -> bool {
    // println!("target: {:?}, components: {:?}", target, components);
    let mut previous_reachable: Vec<u64> = vec![components[0]];
    let mut current_reachable: Vec<u64> = vec![];
    for i in 1..components.len() {
        current_reachable.clear();
        for j in 0..previous_reachable.len() {
            let addition = previous_reachable[j] + components[i];
            let multiplication = previous_reachable[j] * components[i];
            // if !previous_reachable.contains(&addition) {
            current_reachable.push(addition);
            // }
            // if !previous_reachable.contains(&multiplication) {
            current_reachable.push(multiplication);
            // }
        }
        previous_reachable = current_reachable.clone();
    }
    if current_reachable.contains(&target) {
       return true;
    } else {
        return false;
    }
}

fn part1(input: Vec<String>) -> u64 {
    let mut result = 0;
    for line in input {
        let (target, components) = line.split_once(": ").unwrap();
        let target = target.parse::<u64>().unwrap();
        let components: Vec<u64> = components.split(" ").map(|s| s.parse::<u64>().unwrap()).collect();
        if check_line(target, components) {
            result += target;
        }
    }
    result
}

fn check_line_part2(target: u64, components: Vec<u64>) -> bool {
    let mut previous_reachable: Vec<u64> = vec![components[0]];
    let mut current_reachable: Vec<u64> = vec![];
    for i in 1..components.len() {
        current_reachable.clear();
        for j in 0..previous_reachable.len() {
            current_reachable.push(previous_reachable[j] + components[i]);
            current_reachable.push(previous_reachable[j] * components[i]);
            current_reachable.push(previous_reachable[j] * 10_u64.pow((components[i].ilog10() + 1).try_into().unwrap()) + components[i]);
        }
        previous_reachable = current_reachable.clone();
    }
    if current_reachable.contains(&target) {
       return true;
    } else {
        return false;
    }
}

fn part2(input: Vec<String>) -> u64{
    let mut result = 0;
    for line in input {
        let (target, components) = line.split_once(": ").unwrap();
        let target = target.parse::<u64>().unwrap();
        let components: Vec<u64> = components.split(" ").map(|s| s.parse::<u64>().unwrap()).collect();
        if check_line_part2(target, components) {
            result += target;
        }
    }
    result
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day7/data.txt".to_string());
    println!("Input: --------");
    // println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}