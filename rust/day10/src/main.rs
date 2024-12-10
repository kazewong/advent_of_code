use std::collections::{hash_map, HashMap};
use std::{fs, path};
use std::env::args;

use itertools::Itertools;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn parse_map(input: Vec<String>) -> HashMap<(i32,i32), i32> {
    let mut map = HashMap::new();
    for (y, line) in input.iter().enumerate(){
        for (x, c) in line.chars().enumerate(){
            map.insert((x as i32, y as i32), c.to_digit(10).unwrap() as i32);
        }
    }
    map
}

fn trace_path(map: &HashMap<(i32,i32), i32>, start: (i32,i32)) -> i32 {
    let mut result: Vec<(i32,i32)> = Vec::new();

    let mut stack = Vec::new();

    stack.push(start);

    while let Some((x,y)) = stack.pop(){
        for (dx, dy) in vec![(0,1), (0,-1), (1,0), (-1,0)]{
            let new_x = x + dx;
            let new_y = y + dy;
            if map.contains_key(&(new_x, new_y)){
                if *map.get(&(new_x, new_y)).unwrap() - 1 == *map.get(&(x,y)).unwrap(){
                    stack.push((new_x, new_y));
                }
            }
        }
        let value = map.get(&(x,y)).unwrap();
        if *value == 9{
            result.push((x,y));
        }
    }
    result.iter().unique().count() as i32
}


fn part1(input: Vec<String>) -> i32 {
    let mut result = 0;
    let map = parse_map(input);
    let start = map.iter().filter(|(_, &v)| v == 0).collect::<Vec<(&(i32,i32), &i32)>>();
    for (k,_) in start{
        result += trace_path(&map, *k);
    }
    result
}

fn part2(input: Vec<String>) -> i32{
    0
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day10/test.txt".to_string());
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}