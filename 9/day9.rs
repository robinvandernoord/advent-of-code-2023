use std::fs;

fn to_int(txt: &str) -> i64 {
    match txt.parse::<i64>() {
        Ok(n) => n,
        Err(_) => 0,
    }
}

fn find_sequence(line: &str) -> Vec<Vec<i64>> {
    let numbers_original: Vec<i64> = line.split(" ").map(to_int).collect();

    let mut numbers = numbers_original.clone();
    let mut all_deltas = vec![];

    all_deltas.push(numbers.clone());

    loop {
        let mut previous = None;
        let mut deltas = vec![];
        for number in &numbers {
            if let Some(prev) = previous {
                deltas.push(number - prev);
            }

            previous = Some(number);
        }

        all_deltas.push(deltas.clone());
        if deltas.iter().all(|x| *x == 0) {
            break;
        }

        numbers = deltas.clone();
    }

    return all_deltas;
}

fn process_line(line: &str) -> i64 {
    let all_deltas = find_sequence(line);

    // sum every last element:
    return all_deltas.iter().map(|arr| arr[arr.len() - 1]).reduce(|acc, e| acc + e).unwrap();
}

fn process_line2(line: &str) -> i64 {
    let all_deltas = find_sequence(line);

    let mut first_deltas: Vec<i64> = all_deltas.iter().map(|arr| arr[0]).collect();

    first_deltas.reverse();

    let mut previous = 0;
    for number in first_deltas {
        previous = number - previous;
    }

    return previous;
}

fn run(filename: &str) -> i64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    return contents.split("\n").map(process_line).reduce(|acc, e| acc + e).unwrap();
}

fn run2(filename: &str) -> i64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    return contents.split("\n").map(process_line2).reduce(|acc, e| acc + e).unwrap();
}

fn main() {
    assert!(run("dev.txt") == 114);
    assert!(run("test.txt") == 2038472161);

    println!("All checks passed for part 1!");

    assert!(run2("dev.txt") == 2);
    assert!(run2("test.txt") == 1091);

    println!("All checks passed for part 2!");
}