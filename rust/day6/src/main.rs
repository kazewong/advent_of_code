use std::collections::HashMap;
use std::fs;
use std::env::args;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn parse_map(input: Vec<String>) -> HashMap<(i32, i32), char>{
    let mut result: HashMap<(i32, i32), char> = HashMap::new();
    for (i, line) in input.iter().enumerate() {
        for (j, c) in line.chars().enumerate() {
                result.insert((i as i32, j as i32), c);
        }
    }
    result
}

fn fill_map(input: Vec<String>) -> HashMap<(i32, i32), char>{
    let mut map = parse_map(input);
    let (max_x, max_y) = (map.keys().map(|&(x, _)| x).max().unwrap(), map.keys().map(|&(_, y)| y).max().unwrap());
    let (min_x, min_y) = (map.keys().map(|&(x, _)| x).min().unwrap(), map.keys().map(|&(_, y)| y).min().unwrap());
    let mut cursor = *map.iter().filter(|&(_, &v)| v == '^').next().unwrap().0;
    let mut heading = (-1, 0);
    while (cursor.0 <= max_x) && (cursor.0 >= min_x) && (cursor.1 <= max_y) && (cursor.1 >= min_y) {
        map.entry(cursor).and_modify(|c| *c = 'X');
        let next_location = &(cursor.0 + heading.0, cursor.1 + heading.1);
        if map.contains_key(next_location) {
            if *map.get(next_location).unwrap() == '#' {
                heading = match heading {
                    (-1, 0) => (0, 1),
                    (0, 1) => (1, 0),
                    (1, 0) => (0, -1),
                    (0, -1) => (-1, 0),
                    _ => panic!("Invalid heading"),
                };
                let next_location = &(cursor.0 + heading.0, cursor.1 + heading.1);
                cursor = *next_location;
            } else {
                cursor = *next_location;
            }
        }
        if next_location.0 > max_x || next_location.0 < min_x || next_location.1 > max_y || next_location.1 < min_y {
            break;
        }
    }
    map
}

fn part1(input: Vec<String>) -> i32 {
    let map = fill_map(input);
    map.into_iter().filter(|&(_, v)| v == 'X').count() as i32
}

fn print_map(map: &HashMap<(i32, i32), char>){
    let (max_x, max_y) = (map.keys().map(|&(x, _)| x).max().unwrap(), map.keys().map(|&(_, y)| y).max().unwrap());
    let (min_x, min_y) = (map.keys().map(|&(x, _)| x).min().unwrap(), map.keys().map(|&(_, y)| y).min().unwrap());
    for i in min_x..=max_x {
        for j in min_y..=max_y {
            print!("{}", map.get(&(i, j)).unwrap());
        }
        println!();
    }
}

fn test_if_escape(map: &HashMap<(i32, i32), char>, obstacle_location: (i32, i32)) -> bool {
    let mut map = map.clone();
    let (max_x, max_y) = (map.keys().map(|&(x, _)| x).max().unwrap(), map.keys().map(|&(_, y)| y).max().unwrap());
    let (min_x, min_y) = (map.keys().map(|&(x, _)| x).min().unwrap(), map.keys().map(|&(_, y)| y).min().unwrap());
    let mut cursor = *map.iter().filter(|&(_, &v)| v == '^').next().unwrap().0;
    let mut heading = (-1, 0);
    let mut heading_map: HashMap<(i32, i32), Vec<(i32, i32)>> = HashMap::new();
    let mut escaped = false;
    map.entry(obstacle_location).and_modify(|c| *c = '#');
    loop{ //(cursor.0 <= max_x) && (cursor.0 >= min_x) && (cursor.1 <= max_y) && (cursor.1 >= min_y) {
        let mut next_location: (i32, i32) = (cursor.0 + heading.0, cursor.1 + heading.1);
        if map.contains_key(&next_location) {
            if *map.get(&next_location).unwrap() == '#' {
                heading = match heading {
                    (-1, 0) => (0, 1),
                    (0, 1) => (1, 0),
                    (1, 0) => (0, -1),
                    (0, -1) => (-1, 0),
                    _ => panic!("Invalid heading"),
                };
                next_location = (cursor.0 + heading.0, cursor.1 + heading.1);
            } 
            cursor = next_location;
        }
        if heading_map.contains_key(&cursor) {
            if heading_map.get(&cursor).unwrap().contains(&heading) {
                break;
            } else {
                heading_map.entry(cursor).and_modify(|c| c.push(heading));
            }
        } else {
            heading_map.insert(cursor, vec![heading]);
        }
        
        if cursor.0 + heading.0 > max_x || cursor.0 + heading.0 < min_x || cursor.1 + heading.1 > max_y || cursor.1 + heading.1 < min_y {
            escaped = true;
            break;
        }
    }
    escaped
}

fn part2(input: Vec<String>) -> i32{
    let map = parse_map(input.clone());
    let filled_map = fill_map(input);
    print_map(&filled_map);
    let mut result = 0;
    for (k, _) in filled_map.iter().filter(|&(_, v)| v == &'X') {
        if !test_if_escape(&map, *k) {
            result += 1;
        }
    }
    result
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    // let input = read_input("../asset/day6/test.txt".to_string());
    println!("Input: --------");
    // println!("{:?}", input);
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}