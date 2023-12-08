use std::fs;
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::thread;
use std::sync::mpsc;

// fn to_int(txt: &str) -> u32 {
//     match txt.parse::<u32>() {
//         Ok(n) => n,
//         Err(_) => 0,
//     }
// }

fn split<'a>(original_string: &'a str, delimiter: &'a str) -> (&'a str, &'a str) {
    let mut parts = original_string.split(delimiter);
    let first_half = parts.next().unwrap_or("");
    let second_half = parts.next().unwrap_or("");

    return (first_half, second_half);
}

type MazeMap<'a> = HashMap<&'a str, (&'a str, &'a str)>;

fn make_mapping(contents: &str) -> MazeMap {
    let mut map = HashMap::new();

    let rows = contents.split("\n");

    for row in rows {
        if row == "" {
            continue;
        }

        let (mut from, mut to) = split(row, "=");
        from = from.trim();
        to = to.trim_matches(|c: char| c.is_whitespace() || c == '(' || c == ')');

        let (left, right) = split(to, ", ");

        map.insert(from, (left, right));
    }

    return map;
}

fn solve(instruction: &str, mapping: &MazeMap) -> u32 {
    let mut location = "AAA";
    let target = "ZZZ";

    let mut current_instruction: char;
    let instruction_bytes: Vec<char> = instruction.chars().collect();

    let mut idx = 0;
    while location != target {
        current_instruction = instruction_bytes[idx % instruction.len()];

        idx += 1;

        if current_instruction == 'L' {
            location = mapping[location].0
        } else if current_instruction == 'R' {
            location = mapping[location].1
        } else {
            continue;
        }
    }

    return idx as u32;
}

fn run(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let (instruction, mapping_str) = split(&contents, "\n\n");

    let mapping = make_mapping(mapping_str);

    return solve(instruction, &mapping);
}

fn all_done(positions: Vec<&str>) -> bool {
    for position in positions {
        if !position.ends_with("Z") {
            return false;
        }
    }

    return true;
}

fn solve2(instruction: &str, mapping: &MazeMap) -> u32 {
    let mut starting_positions = vec![];
    for position in mapping.keys() {
        if position.ends_with("A") {
            starting_positions.push(*position)
        }
    }

    let mut current_instruction: char;
    let instruction_bytes: Vec<char> = instruction.chars().collect();

    let mut rounds = 0;

    while !all_done(starting_positions.clone()) {
        println!("{:?}", starting_positions);

        current_instruction = instruction_bytes[rounds % instruction.len()];
        rounds += 1;

        for i in 0..starting_positions.len() { // works better than .iter_mut.enumerate
            let mut location = starting_positions[i];

            if current_instruction == 'L' {
                starting_positions[i] = &mapping[location].0
            } else if (current_instruction == 'R') {
                starting_positions[i] = &mapping[location].1
            } else {
                continue;
            }
        }
    }

    return rounds as u32;
}


fn thread_task(id: usize, sender: mpsc::Sender<usize>, receiver: Arc<Mutex<mpsc::Receiver<char>>>) {
    let local_receiver = Arc::clone(&receiver);

    loop {
        let instruction = match local_receiver.lock().unwrap().recv() {
            Ok(instruction) => instruction,
            Err(_) => break,
        };

        println!("Thread {} received instruction: {}", id, instruction);

        sender.send(id).unwrap();

        if instruction == 'X' {
            break;
        }
    }
}

// start 6 threads
// send L or R
// receive 6x True or False whether it ends with Z
// if all True -> stop counter and return


fn run2(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let (instruction, mapping_str) = split(&contents, "\n\n");

    let mapping = make_mapping(mapping_str);

    return solve2(instruction, &mapping);
}


fn main() {
    // let result = run("dev1.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 2);
    //
    // let result = run("dev2.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 6);
    //
    // println!("All checks passed for pt1!");
    //
    // let pt1_result = run("test.txt");
    // println!("part 1: {}", pt1_result);

    let result = run2("dev3.txt");
    println!("result: {r}", r = result);
    assert!(result == 6);

    println!("All checks passed for pt2!");

    // let pt2_result = run2("test.txt");
    // println!("part 2: {}", pt2_result);
}