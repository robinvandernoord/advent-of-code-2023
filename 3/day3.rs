use std::fs;


#[derive(Debug)]
struct Position {
    line: i32,
    start: i32,
    end: i32,
    num: u32,
}

fn len<T>(something: &Vec<T>) -> i32 {
    return something.len() as i32;
}

impl Position {
    // Define the get_score function for the Position struct
    fn is_valid(&self, rows: Vec<&str>) -> bool {
        for _y in 0..=2 {
            let y = self.line + (_y - 1);

            if y < 0 || y >= len(&rows) {
                continue;
            }

            let row = rows[y as usize].chars().collect();

            for x in self.start - 1..=self.end + 1 {
                if x < 0 || x >= len(&row) {
                    continue;
                }

                let value = row[x as usize];

                if is_digit(value) || value == '.' {
                    continue;
                }

                // else: it's a symbol so this Position is valid!
                return true;
            }
        }


        return false;
    }

    fn get_score(&self, rows: Vec<&str>) -> u32 {
        if self.is_valid(rows) {
            return self.num;
        }

        return 0; // because * 1
    }
}

fn is_digit(char: char) -> bool {
    return char >= '0' && char <= '9';
}

fn find_numbers(line: &str, lineno: u32, collect: &mut Vec<Position>) {
    let mut current_number = 0;

    let mut start_idx = -1;
    let mut end_idx = -1;

    for (idx, char) in line.chars().enumerate() {
        end_idx = idx as i32;
        if is_digit(char) {
            if current_number == 0 {
                start_idx = idx as i32;
            }

            current_number = current_number * 10 + char.to_digit(10).unwrap()
        } else {
            if current_number != 0 {
                collect.push(Position { line: lineno as i32, start: start_idx, end: end_idx - 1, num: current_number });
            }

            current_number = 0;
        }
    }

    if current_number != 0 {
        collect.push(Position { line: lineno as i32, start: start_idx, end: end_idx, num: current_number });
    }
}

fn run(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows: Vec<&str> = contents.split("\n").collect();

    let mut numbers: Vec<Position> = vec![];

    for (idx, line) in rows.iter().enumerate() {
        find_numbers(line, idx as u32, &mut numbers)
    }

    let mut result = 0;

    for pos in &numbers {
        let _result = pos.get_score(rows.clone());
        result += _result;
    }

    return result;
}

fn process_symbols(rows: Vec<&str>, numbers: Vec<Position>) -> u32 {
    // find all symbols
    // find all overlapping numbers
    // calculate
    // ...
    // profit!
    let mut result = 0;

    for (_lineno, row) in rows.iter().enumerate() {
        for (_charno, char) in row.chars().enumerate() {
            if is_digit(char) || char == '.' {
                // not a symbol
                continue;
            }
            let mut nums_found: Vec<&Position> = vec![];


            let lineno = _lineno as i32;
            let charno = _charno as i32;

            for position in &numbers {
                let matches_line = (position.line - 1..=position.line + 1).contains(&lineno);
                let matches_col = (position.start - 1..=position.start + 1).contains(&charno) || (position.end - 1..=position.end + 1).contains(&charno);


                if (matches_line && matches_col) {
                    nums_found.push(position);
                }
            }

            if nums_found.len() == 2 {
                // right amount of numbers!
                result += nums_found[0].num * nums_found[1].num;
            }
        }
    }

    return result;
}

fn run2(filename: &str) -> u32 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows: Vec<&str> = contents.split("\n").collect();

    let mut numbers: Vec<Position> = vec![];

    for (idx, line) in rows.iter().enumerate() {
        find_numbers(line, idx as u32, &mut numbers)
    }

    return process_symbols(rows, numbers);
}


fn main() {
    // let result = run("dev.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 4361);
    //
    // let pt1_result = run("test.txt");
    // println!("part 1: {}", pt1_result);
    // assert!(pt1_result == 546563);
    //
    // println!("All checks passed for pt1!")

    let result = run2("dev.txt");
    println!("result: {}", result);
    assert!(result == 467835);

    println!("All checks passed for pt2!");

    let pt2_result = run2("test.txt");
    println!("part 2: {}", pt2_result);
}
