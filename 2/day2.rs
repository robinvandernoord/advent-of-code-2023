use std::fs;
use std::collections::HashMap;


type Bag = HashMap<&'static str, u32>;

fn get_bag() -> Bag {
    let mut result = HashMap::new();

    result.insert("red", 12);
    result.insert("green", 13);
    result.insert("blue", 14);
    return result;
}

fn get_empty_bag() -> Bag {
    let mut result = HashMap::new();

    result.insert("red", 0);
    result.insert("green", 0);
    result.insert("blue", 0);
    return result;
}

fn split<'a>(original_string: &'a str, delimiter: &'a str) -> (&'a str, &'a str) {
    let mut parts = original_string.split(delimiter);
    let first_half = parts.next().unwrap_or("");
    let second_half = parts.next().unwrap_or("");

    return (first_half, second_half);
}

fn to_int(txt: &str) -> u32 {
    match txt.parse::<u32>() {
        Ok(n) => n,
        Err(_) => 0,
    }
}

fn valid_round(round: &str, bag: &Bag) -> bool {
    for pair in round.split(",") {
        if pair == "" {
            continue;
        }

        let (_num, color) = split(pair.trim(), " ");
        let num = to_int(_num);

        if bag[color] < num {
            return false;
        }
    }
    return true;
}

fn validate_row(row: &str, bag: &Bag) -> u32 {
    let (_prefix, game) = split(row, ":");

    let (_, _id) = split(_prefix, " ");
    let id = to_int(_id);

    let rounds = game.split(";");

    for round in rounds {
        if !valid_round(round, bag) {
            return 0;
        }
    }

    return id;
}

fn run(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let bag = get_bag();

    let rows: Vec<&str> = contents.split("\n").collect();
    let mut result = 0;

    for row in rows {
        result += validate_row(row, &bag);
    }

    return result;
}

fn calculate_bag(row: &str) -> u32 {
    let mut bag = get_empty_bag();

    let (_, game) = split(row, ": ");

    for set in game.split(";") {
        for pair in set.split(",") {
            if pair == "" {
                continue;
            }

            let (_num, color) = split(pair.trim(), " ");
            let num = to_int(_num);

            if num > bag[color] {
                bag.insert(color, num);
            }
        }
    }

    let mut result = 1;
    for (_, count) in bag {
        result *= count;
    }


    return result;
}

fn run2(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows: Vec<&str> = contents.split("\n").collect();
    let mut result = 0;

    for row in rows {
        result += calculate_bag(row);
    }

    return result;
}

fn main() {
    let result = run("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 8);

    let pt1_result = run("test.txt");
    println!("part 1: {}", pt1_result);
    assert!(pt1_result == 2679);

    println!("All checks passed for pt1!");

    let result = run2("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 2286);

    let pt1_result = run2("test.txt");
    println!("part 2: {}", pt1_result);
    assert!(pt1_result == 77607);

    println!("All checks passed for pt2!");
}
