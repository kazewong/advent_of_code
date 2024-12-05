use std::collections::HashMap;
use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn parse_input(input: Vec<String>) -> Vec<Vec<i32>> {
    let mut result = Vec::new();
    for line in input {
        let mut temp = Vec::new();
        for num in line.split(",") {
            temp.push(num.parse::<i32>().unwrap());
        }
        result.push(temp);
    }
    result
}

fn parse_guide(input: Vec<String>) -> HashMap<i32, Vec<i32>>{
    let mut result: HashMap<i32, Vec<i32>> = HashMap::new();
    for line in input {
        let temp_input: Vec<i32> = line.split("|").map(|s| s.parse::<i32>().unwrap()).collect();
        if result.contains_key(&temp_input[0]) {
            result.get_mut(&temp_input[0]).unwrap().push(temp_input[1]);
        } else {
            result.insert(temp_input[0], vec![temp_input[1]]);
        }
    }
    result
}

fn check_line(input: Vec<i32>, guide: HashMap<i32, Vec<i32>>) -> bool{
    let mut result = true;
    for i in 0..input.len() {
        let current = input[i];
        let iter_len = i as i32 -1;
        for j in 0..iter_len{
            if guide.contains_key(&current){
                if guide.get(&current).unwrap().contains(&input[j as usize]) {
                    result = false;
                    break;
                }    
            }
        }
    }
    result
}

fn part1(input: Vec<String>, guide: Vec<String>) -> i32 {
    let input = parse_input(input);
    let guide = parse_guide(guide);
    let mut result = 0;
    for line in input {
        if check_line(line.clone(), guide.clone()) {
            result += line[line.len()/2];
        }
    }
    result
}

fn part2(input: Vec<String>, guide: Vec<String>) -> i32{
    0
}

fn main(){
    // let tag = args().nth(1).unwrap();
    let tag = "../asset/day5/test".to_owned();
    let guide = read_input(tag.clone() + "_guide.txt");
    let input = read_input(tag + "_input.txt");
    println!("Input: --------");
    println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone(), guide.clone()));
    println!("The answer to part 2 is: {}", part2(input, guide));
}