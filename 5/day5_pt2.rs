use std::fs;
use std::thread;
use std::sync::{Arc, Mutex};

fn to_int(txt: &str) -> u64 {
    match txt.parse::<u64>() {
        Ok(n) => n,
        Err(_) => 0,
    }
}

fn split<'a>(original_string: &'a str, delimiter: &'a str) -> (&'a str, &'a str) {
    let mut parts = original_string.split(delimiter);
    let first_half = parts.next().unwrap_or("");
    let second_half = parts.next().unwrap_or("");

    return (first_half, second_half);
}

fn extract_seeds(line: &str) -> Vec<u64> {
    let mut result = vec![];

    let (_, nums) = split(line, ":");

    for num in nums.split(" ") {
        if num == "" {
            continue;
        }

        result.push(to_int(num));
    }

    return result;
}

#[derive(Debug)]
struct Mapping {
    start: u64,
    end: u64,
    dest: u64,
    range: u64,
}

fn create_mapping(section: &str) -> Vec<Mapping> {
    let mut result = vec![];

    let lines: Vec<&str> = section.split("\n").collect();

    for line in &lines[1..] {
        if *line == "" {
            continue;
        }

        let parts: Vec<&str> = line.split(" ").collect();

        let dest = to_int(parts[0]);
        let src = to_int(parts[1]);
        let range = to_int(parts[2]);

        result.push(
            Mapping {
                start: src,
                end: src + range,
                dest,
                range,
            }
        )
    }


    return result;
}

#[derive(Debug)]
struct Range {
    from: u64,
    to: u64,
    length: u64,
}

fn extract_seed_ranges(section: &str) -> Vec<Range> {
    let seeds = extract_seeds(section);
    let mut seed_ranges = vec![];

    let chunks: Vec<&[u64]> = seeds.chunks(2).collect();
    for chunk in chunks {
        let from = chunk[0];
        let length = chunk[1];
        let to = from + length;

        seed_ranges.push(Range {
            from,
            to,
            length,
        });
    }
    return seed_ranges;
}


fn pretty_print_int(i: u64) {
    let mut s = String::new();
    let i_str = i.to_string();
    let a = i_str.chars().rev().enumerate();
    for (idx, val) in a {
        if idx != 0 && idx % 3 == 0 {
            s.insert(0, '_');
        }
        s.insert(0, val);
    }
    println!("{}", s);
}

fn loop_range(from: u64, to: u64, mappings: &Vec<Vec<Mapping>>, seed_ranges: &Vec<Range>) -> u64 {
    let mut i: u64 = from;
    loop {
        let mut j = i;

        for mapping in mappings {
            for map in mapping {
                if j >= map.dest && j < map.dest + map.range {
                    j = map.start + (j - map.dest);
                    break;
                }
            }
        }

        for range in seed_ranges {
            if j >= range.from && j < range.to {
                println!("{}, true", i);

                panic!("FOUND A RESULT: {}", i);
                return i;
            }
        }

        // println!("{}, false", i);

        i += 1;

        if i % 1_000_000 == 0 {
            pretty_print_int(i);
            // println!("{}", i)
        }

        if i > to {
            return 0;
        }
    }
}

fn run(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let sections: Vec<&str> = contents.split("\n\n").collect();

    let seed_ranges = extract_seed_ranges(sections[0]);

    let mut mappings: Vec<Vec<Mapping>> = vec![];

    for section in &sections[1..] {
        mappings.push(
            create_mapping(section)
        )
    }

    mappings.reverse();

    // let mappings_arc = Arc::new(mappings);
    // let seed_ranges_arc = Arc::new(seed_ranges);
    //
    // let mappings_clone = Arc::clone(&mappings_arc);
    // let seed_ranges_clone = Arc::clone(&seed_ranges_arc);
    //
    // let handle1 = thread::spawn(move || loop_range(10_000_000_000, 15_000_000_000, &mappings_clone, &seed_ranges_clone));
    // let handle2 = thread::spawn(move || loop_range(15_000_000_000, 20_000_000_000, &mappings_arc, &seed_ranges_arc));
    //
    // handle1.join().expect("Thread 1 panicked");
    // handle2.join().expect("Thread 2 panicked");

    // Vector of ranges to process
    let ranges_to_process = vec![
        (0, 10_000_000_000),
        (10_000_000_000, 20_000_000_000),
        (20_000_000_000, 30_000_000_000),
        (30_000_000_000, 40_000_000_000),
        (40_000_000_000, 50_000_000_000),
        (50_000_000_000, 60_000_000_000),
        (60_000_000_000, 70_000_000_000),
    ];

    // Wrap mappings and seed_ranges in Arc and Mutex to share across threads
    let mappings_arc = Arc::new(mappings);
    let seed_ranges_arc = Arc::new(seed_ranges);

    // Create a vector to store the thread handles
    let mut handles = vec![];

    for range in ranges_to_process {
        let mappings_clone = Arc::clone(&mappings_arc);
        let seed_ranges_clone = Arc::clone(&seed_ranges_arc);

        // Spawn a thread for each range
        let handle = thread::spawn(move || {
            loop_range(range.0, range.1, &mappings_clone, &seed_ranges_clone);
        });

        handles.push(handle);
    }

    // Wait for all threads to finish
    for handle in handles {
        handle.join().expect("Thread panicked");
    }

    return u64::MAX;
}

fn main() {
    // let result = run("dev.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 46);

    let pt2_result = run("test.txt");
    println!("part 2: {}", pt2_result);
}
