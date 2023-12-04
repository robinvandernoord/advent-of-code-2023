use std::fs;
use std::collections::HashMap;


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

fn find_matching(line: &str) -> u32 {
    let (_, _data) = split(line, ":");
    let (_winning, _having) = split(_data, "|");

    let winning = _winning.split(" ");
    let having = _having.split(" ");

    let mut matching = 0;

    for w in winning {
        if w == "" {
            continue;
        }

        for h in having.clone() {
            if h == "" {
                continue;
            }

            if to_int(h) == to_int(w) {
                matching += 1
            }
        }
    }

    return matching;
}

fn process_line(line: &str) -> u32 {
    let matching = find_matching(line);

    if matching == 0 {
        return 0;
    }

    return u32::pow(2, matching - 1);
}



fn memoize<F, T, U>(func: F) -> impl FnMut(T) -> U
where
    F: Fn(T) -> U,
    T: std::cmp::Eq + std::hash::Hash + Copy,
    U: Copy,
{
    let mut memo = HashMap::new();
    move |arg| {
        if let Some(&result) = memo.get(&arg) {
            return result;
        }
        let result = func(arg);
        memo.insert(arg, result);
        result
    }
}

fn process_line2(line: &str, lines: Vec<&str>, idx: u32) -> u32 {
    let matches = find_matching(line);

    let mut result = 1;

    for i in 1..=matches {
        let new_idx = idx + i;
        let nextline = lines[new_idx as usize];
        result += process_line2(nextline, lines.clone(), new_idx);
    }


    return result;
}

// fn process_line2(line: &str, lines: Vec<&str>, idx: u32) -> u32 {
//     let mut mem = memoize(|_idx| _process_line2(line, lines.clone(), _idx));
//
//     return mem(idx);
// }

fn run(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let mut result = 0;

    for line in contents.split("\n") {
        result += process_line(line);
    }

    return result;
}


fn run2(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let mut result = 0;

    let lines: Vec<&str> = contents.split("\n").collect();

    for (idx, line) in lines.iter().enumerate() {
        result += process_line2(line, lines.clone(), idx as u32);
    }

    return result;
}

fn main() {
    // let result = run("dev.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 13);

    let result = run2("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 30);

    let pt1_result = run2("test.txt");
    println!("part 2: {}", pt1_result);
}
