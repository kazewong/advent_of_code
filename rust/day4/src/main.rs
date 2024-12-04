use std::collections::HashMap;
use std::env::args;
use std::{fs, result, vec};

fn read_input(str: String) -> HashMap<(i32, i32), char> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    let mut map = HashMap::new();
    for (i, line) in result.lines().enumerate() {
        for (j, c) in line.chars().enumerate() {
            map.insert((i as i32, j as i32), c);
        }
    }
    map
}

fn check_XMAS(
    input_location: (i32, i32),
    direction: (i8, i8),
    hashmap: HashMap<(i32, i32), char>,
) -> bool {
    let mut result = false;
    if hashmap.get(&(
        input_location.0 + direction.0 as i32,
        input_location.1 + direction.1 as i32,
    )) == Some(&'M')
    {
        if hashmap.get(&(
            input_location.0 + 2 * direction.0 as i32,
            input_location.1 + 2 * direction.1 as i32,
        )) == Some(&'A')
        {
            if hashmap.get(&(
                input_location.0 + 3 * direction.0 as i32,
                input_location.1 + 3 * direction.1 as i32,
            )) == Some(&'S')
            {
                result = true;
            }
        }
    }
    result
}

fn part1(input: HashMap<(i32, i32), char>) -> i32 {
    let x_location: Vec<(i32, i32)> = input
        .iter()
        .filter(|(_k, v)| **v == 'X')
        .map(|(k, _v)| *k)
        .collect();
    let mut result = 0;
    for start_point in x_location {
        // LLM do your job LOL
        if check_XMAS(start_point, (1, 0), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (0, 1), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (1, 1), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (1, -1), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (-1, 1), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (-1, -1), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (-1, 0), input.clone()) {
            result += 1;
        }
        if check_XMAS(start_point, (0, -1), input.clone()) {
            result += 1;
        }
    }
    result
}

fn check_X_MAS(input_location: (i32, i32), hashmap: HashMap<(i32, i32), char>) -> bool {
    let mut result = false;
    for test_coord in [(1, 1), (1, -1), (-1, 1), (-1, -1)].iter() {
        if ((hashmap.get(&(
            input_location.0 + test_coord.0 as i32,
            input_location.1 + test_coord.1 as i32,
        )) == Some(&'M'))
            && (hashmap.get(&(
                input_location.0 - test_coord.0 as i32,
                input_location.1 - test_coord.1 as i32,
            )) == Some(&'S'))
            && (hashmap.get(&(
                input_location.0 + test_coord.0 as i32,
                input_location.1 - test_coord.1 as i32,
            )) == Some(&'S'))
            && (hashmap.get(&(
                input_location.0 - test_coord.0 as i32,
                input_location.1 + test_coord.1 as i32,
            )) == Some(&'M'))) ||
            ((hashmap.get(&(
                input_location.0 + test_coord.0 as i32,
                input_location.1 + test_coord.1 as i32,
            )) == Some(&'M'))
                && (hashmap.get(&(
                    input_location.0 - test_coord.0 as i32,
                    input_location.1 - test_coord.1 as i32,
                )) == Some(&'S'))
                && (hashmap.get(&(
                    input_location.0 + test_coord.0 as i32,
                    input_location.1 - test_coord.1 as i32,
                )) == Some(&'M'))
                && (hashmap.get(&(
                    input_location.0 - test_coord.0 as i32,
                    input_location.1 + test_coord.1 as i32,
                )) == Some(&'S'))) 
        {
            result = true;
        }
    }
    result
}

fn part2(input: HashMap<(i32, i32), char>) -> i32 {
    let a_location: Vec<(i32, i32)> = input
        .iter()
        .filter(|(_k, v)| **v == 'A')
        .map(|(k, _v)| *k)
        .collect();
    let mut result = 0;
    for start_point in a_location {
        if check_X_MAS(start_point, input.clone()) {
            result += 1;
        }
    }
    result
}

fn main() {
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day4/test.txt".to_string());
    // println!("Input: --------");
    // println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}
