use std::collections::HashMap;
use std::fs;
use std::env::args;
use itertools::{Itertools, Position};

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn make_buffers(input: String) -> HashMap<u64, i64> {
    let mut buffer : HashMap<u64, i64> = HashMap::new();
    let mut position: u64 = 0;
    let mut id = 0;
    let mut is_space = false;
    for char in input.chars() {
        let num = char.to_digit(10).unwrap() as u64;
        if is_space{
            position += num;
        }
        else{
            for _ in 0..num {
                buffer.insert(position, id);
                position += 1;
            }
            id += 1;
        }
        is_space = !is_space;
    }
    buffer
}

fn sort_buffers(buffer: &HashMap<u64, i64>) -> HashMap<u64, i64> {
    let mut sorted_buffer = HashMap::new();
    let length = buffer.len();
    let keys :Vec<&u64> = buffer.keys().sorted().rev().collect();
    let mut moved_counter = 0;
    for i in 0..length{
        if buffer.contains_key(&(i as u64)){
            sorted_buffer.insert(i as u64, *buffer.get(&(i as u64)).unwrap());
        }
        else{
            sorted_buffer.insert(i as u64, *buffer.get(&(keys[moved_counter])).unwrap());
            moved_counter += 1;
        }
    }
    sorted_buffer
}

fn part1(input: Vec<String>) -> i64 {
    let buffer = make_buffers(input[0].clone());

    let mut sum = 0;
    let sorted_buffer = sort_buffers(&buffer);

    for (key, value) in sorted_buffer.iter(){
        sum += *key as i64 * value;
    }
    sum
}

fn find_space(buffer: &HashMap<u64, i64>, length: u64) -> i64{
    let keys :Vec<&u64> = buffer.keys().sorted().collect();
    let mut position = -1;
    for i in 0..buffer.len() -1{
        if *keys[i+1] - *keys[i] > length{
            position = *keys[i] as i64;
            break;
        }
    }
    position
}

fn find_first_entry(buffer: &HashMap<u64, i64>, value: i64) -> u64{
    let keys = buffer.iter().sorted().collect::<Vec<(&u64, &i64)>>();
    let mut position = 0;
    for i in 0..keys.len(){
        if *keys[i].1 == value{
            position = *keys[i].0;
            break;
        }
    }
    position
}

fn sort_buffers_part2(buffer: &HashMap<u64, i64>) -> HashMap<u64, i64> {
    let mut sorted_buffer = buffer.clone();
    let values = buffer.values().unique().sorted().rev().collect::<Vec<&i64>>();
    // println!("{:?}", values);
    let length = values.len();
    for i in 0..length{
        let entry_size = sorted_buffer.clone().into_iter().filter(|(_, value)| value == values[i]).count() as u64;
        let first_entry_index = find_first_entry(&sorted_buffer, *values[i]);
        let position = find_space(&sorted_buffer, entry_size);
        // println!("Position: {},, Entry Size: {}, First Entry Index: {}", position,entry_size, first_entry_index);
        // for i in sorted_buffer.clone().keys().sorted(){
        //     print!("{}", sorted_buffer.get(i).unwrap());
        // }
        if position != -1 && position < first_entry_index as i64{
            for j in 0..entry_size{
                sorted_buffer.remove(&(first_entry_index + j));
                sorted_buffer.insert(position as u64 + j+1, *values[i]);
            }
        }
    }
    sorted_buffer
}

fn part2(input: Vec<String>) -> i64{
    let buffer = make_buffers(input[0].clone());
    let sorted_buffer = sort_buffers_part2(&buffer);
    let mut sum = 0;
    for (key, value) in sorted_buffer.iter(){
        sum += *key as i64 * value;
    }
    sum
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day9/test.txt".to_string());
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}