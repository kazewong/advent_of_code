use std::collections::HashMap;
use std::fs;
use std::env::args;
use itertools::Itertools;
use std::cmp;

fn read_input(str: String) -> Vec<String> {
    let result = fs::read_to_string(str).expect("Failed to read input.txt");
    result.lines().map(|s| s.to_string()).collect()
}

fn parse_map(input: Vec<String>) -> HashMap<(i32,i32), char> {
    let mut map = HashMap::new();
    for (x, line) in input.iter().enumerate() {
        for (y, c) in line.chars().enumerate() {
            map.insert((x as i32, y as i32), c);
        }
    }
    map
}

fn part1(input: Vec<String>) -> i32 {
    let original_map = parse_map(input);
    let (map_xmin, map_xmax, map_ymin, map_ymax) = (original_map.keys().map(|(x, _)| x).min().unwrap(), original_map.keys().map(|(x, _)| x).max().unwrap(), original_map.keys().map(|(_, y)| y).min().unwrap(), original_map.keys().map(|(_, y)| y).max().unwrap());
    let mut map = original_map.clone();
    let unique_entry = original_map.values().collect::<Vec<&char>>().into_iter().unique().filter(|&v| *v != '.').collect::<Vec<&char>>();
    for entry in unique_entry {
        let matched_entries = original_map.iter().filter(|(_, v)| *v == entry).collect::<Vec<(&(i32,i32), &char)>>();
        for i in 0..matched_entries.len(){
            for j in 0..i {
                let (dx, dy) = (matched_entries[j].0.0 - matched_entries[i].0.0, matched_entries[j].0.1 - matched_entries[i].0.1);
                let new_coord1 = (matched_entries[j].0.0 + dx, matched_entries[j].0.1 + dy);
                let new_coord2 = (matched_entries[i].0.0 - dx, matched_entries[i].0.1 - dy);
                if original_map.contains_key(&new_coord1){
                    map.entry(new_coord1).and_modify(|e| *e = '#');
                }
                if original_map.contains_key(&new_coord2){
                    map.entry(new_coord2).and_modify(|e| *e = '#');
                }
            }
        }
    }
    for i in 0..*map_xmax+1{
        for j in 0..*map_ymax+1{
            print!("{}", map.get(&(i,j)).unwrap());
        }
        println!();
    }
    map.values().filter(|&v| *v == '#').count() as i32
}

fn part2(input: Vec<String>) -> i32{
    let original_map = parse_map(input);
    let (map_xmin, map_xmax, map_ymin, map_ymax) = (original_map.keys().map(|(x, _)| x).min().unwrap(), original_map.keys().map(|(x, _)| x).max().unwrap(), original_map.keys().map(|(_, y)| y).min().unwrap(), original_map.keys().map(|(_, y)| y).max().unwrap());
    let mut map = original_map.clone();
    let unique_entry = original_map.values().collect::<Vec<&char>>().into_iter().unique().filter(|&v| *v != '.').collect::<Vec<&char>>();
    for entry in unique_entry {
        let matched_entries = original_map.iter().filter(|(_, v)| *v == entry).collect::<Vec<(&(i32,i32), &char)>>();
        for i in 0..matched_entries.len(){
            for j in 0..i {
                let (dx, dy) = (matched_entries[j].0.0 - matched_entries[i].0.0, matched_entries[j].0.1 - matched_entries[i].0.1);
                let mut new_coord1 = (matched_entries[j].0.0, matched_entries[j].0.1);
                let mut new_coord2 = (matched_entries[i].0.0, matched_entries[i].0.1);
                while original_map.contains_key(&new_coord1) {
                    map.entry(new_coord1).and_modify(|e| *e = '#');
                    new_coord1 = (new_coord1.0 + dx, new_coord1.1 + dy);
                }
                while original_map.contains_key(&new_coord2) {
                    map.entry(new_coord2).and_modify(|e| *e = '#');
                    new_coord2 = (new_coord2.0 - dx, new_coord2.1 - dy);
                }
            }
        }
    }
    for i in 0..*map_xmax+1{
        for j in 0..*map_ymax+1{
            print!("{}", map.get(&(i,j)).unwrap());
        }
        println!();
    }
    map.values().filter(|&v| *v == '#').count() as i32
}

fn main(){
    let input = read_input(args().nth(1).unwrap());
    println!("The answer to part 1 is: {}", part1(input.clone()));
    println!("The answer to part 2 is: {}", part2(input));
}