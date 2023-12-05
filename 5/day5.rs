use std::fs;

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
            }
        )
    }


    return result;
}

fn run(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let sections: Vec<&str> = contents.split("\n\n").collect();

    let seeds = extract_seeds(sections[0]);

    let mut mappings: Vec<Vec<Mapping>> = vec![];

    for section in &sections[1..] {
        mappings.push(
            create_mapping(section)
        )
    }

    let mut result = u64::MAX;

    for mut seed in seeds {

        for mapping in &mappings {
            for entry in mapping {
                if seed >= entry.start && seed < entry.end {
                    let delta = seed - entry.start;
                    seed = entry.dest + delta;
                    break // prevent mapping twice
                }
            }
        }

        if seed < result {
            result = seed;
        }
    }

    return result;
}

fn main() {
    let result = run("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 35);

    let pt1_result = run("test.txt");
    println!("part 1: {}", pt1_result);
    assert!(pt1_result == 178159714);

    println!("All checks passed for pt1!");
}
