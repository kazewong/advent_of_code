use std::collections::HashMap;
use std::{fs, result};
use std::env::args;
use memoize::memoize;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn update_stone(input: u64) -> Vec<u64> {
    let mut result = Vec::new();
    if input == 0{
        result.push(1);
    } else if (input.ilog10() + 1) % 2 == 0 {
        let n_digits = input.ilog10() + 1;
        let first_half = input / 10u64.pow(n_digits/2);
        let second_half = input % 10u64.pow(n_digits/2);
        result.push(first_half);
        result.push(second_half);
    } else {
        result.push(input*2024);
    }
    result
}

fn blink(input: Vec<u64>) -> Vec<u64> {
    let mut result = Vec::new();
    for i in 0..input.len(){
        let new_stone = update_stone(input[i]);
        for j in 0..new_stone.len(){
            result.push(new_stone[j]);
        }
    }
    result
}

fn part1(input: Vec<String>) -> u64 {
    let input: Vec<u64> = input[0].split(" ").map(|s| s.parse::<u64>().unwrap()).collect();
    let mut result = input.clone();
    for i in 0..25{
        result = blink(result);
    }
    result.len() as u64
}

fn spawn(input: u64) -> Vec<u64> {
    let mut result = Vec::new();
    if input == 0{
        result.push(1);
    } else if (input.ilog10() + 1) % 2 == 0 {
        let n_digits = input.ilog10() + 1;
        let first_half = input / 10u64.pow(n_digits/2);
        let second_half = input % 10u64.pow(n_digits/2);
        result.push(first_half);
        result.push(second_half);
    } else {
        result.push(input*2024);
    }
    result
}

fn part2(input: Vec<String>) -> u64{
    let input: Vec<u64> = input[0].split(" ").map(|s| s.parse::<u64>().unwrap()).collect();
    let mut unique_stone: HashMap<u64, u64> = HashMap::new();
    for i in 0..input.len(){
        if unique_stone.contains_key(&(input[i] as u64)){
            unique_stone.insert(input[i] as u64, unique_stone[&(input[i] as u64)] + 1);
        } else {
            unique_stone.insert(input[i] as u64, 1);
        }
    }
    for i in 0..75{
        for (key, value) in unique_stone.clone(){
            unique_stone.entry(key).and_modify(|e| *e -= value);
            let new_stone = spawn(key as u64);
            for j in 0..new_stone.len(){
                if unique_stone.contains_key(&(new_stone[j] as u64)){
                    unique_stone.entry(new_stone[j] as u64).and_modify(|e| *e += value);
                } else {
                    unique_stone.insert(new_stone[j] as u64, value);
                }
            }
        }
    }
    unique_stone.values().collect::<Vec<&u64>>().into_iter().sum::<u64>() as u64
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day11/data.txt".to_string());

    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}