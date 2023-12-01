use std::fs;
use std::collections::HashMap;

fn is_digit(char: char) -> bool {
    return char > '0' && char <= '9';
}

// fn process_line(line: &str) -> u32 {
//     let mut first = 0;
//     let mut last = 0;
//
//     for char in line.chars() {
//         if is_digit(char) {
//             last = char.to_digit(10).unwrap();
//
//             if first == 0 {
//                 first = char.to_digit(10).unwrap();
//             }
//         }
//     }
//
//     return first * 10 + last;
// }

fn get_numbers() -> HashMap<&'static str, usize> {
    let nums = vec!["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

    let mut result = HashMap::new();

    for (idx, &num) in nums.iter().enumerate() {
        result.insert(num, idx);
    }

    return result;
}

fn convert(line: &str) -> String {
    let nums = get_numbers();
    let mut modified_line = line.to_string();

    let mut i: usize = 0;
    for _ in 0..modified_line.chars().count() {
        if i > line.chars().count() {
            break;
        }

        let sliced = line.split_at(i).1;

        for num in nums.keys() {
            if sliced.starts_with(num) {
                let num_as_str = nums[num].to_string();

                // six -> 6ix
                let replacement = num_as_str + &num[1..];
                modified_line = modified_line.replacen(num, &replacement, 1);

                i += 1;
                // modified_line = modified_line.replacen(num, &num_as_str, 1);
                // i += num.chars().count() - 1;
                break;
            }
        }

        i += 1;
    }

    return modified_line;
}

fn process_line(line: &str) -> u32 {
    let mut first = 0;
    let mut last = 0;

    let updated = convert(line);

    for char in updated.chars() {
        if is_digit(char) {
            last = char.to_digit(10).unwrap();

            if first == 0 {
                first = char.to_digit(10).unwrap();
            }
        }
    }
    let result = first * 10 + last;
    return result;
}


fn run(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let mut result = 0;
    for line in contents.split("\n") {
        println!("{}", line);
        let _result = process_line(&line);
        result += _result;
        println!("{}", _result);
    }

    return result;
}

fn main() {
    let result = run("dev2.txt");
    println!("result: {r}", r = result);
    assert!(result == 281);

    let pt2_result = run("test.txt");
    println!("part 2: {}", pt2_result);
}
