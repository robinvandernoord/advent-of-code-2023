use std::fs;

#[derive(Debug)]
struct Race {
    max_time: u64,
    record_distance: u64,
}

fn to_int(txt: &str) -> u64 {
    match txt.parse::<u64>() {
        Ok(n) => n,
        Err(_) => 0,
    }
}

fn get_races(rows: Vec<&str>) -> Vec<Race> {
    let mut time_row: Vec<&str> = rows[0].split(" ").collect();
    time_row.retain(|x| *x != "");
    time_row.remove(0);
    let mut distance_row: Vec<&str> = rows[1].split(" ").collect();
    distance_row.retain(|x| *x != "");
    distance_row.remove(0);

    let mut races: Vec<Race> = vec![];
    let mut i = 0;
    loop {
        if i >= time_row.len() || i >= distance_row.len() {
            break;
        }

        let time = to_int(time_row[i]);
        let distance = to_int(distance_row[i]);

        races.push(Race {
            max_time: time,
            record_distance: distance,
        });

        i += 1;
    }

    return races;
}

fn get_race2(rows: Vec<&str>) -> Vec<Race> {
    let mut time_row: Vec<&str> = rows[0].split(" ").collect();
    time_row.remove(0);
    time_row.retain(|x| *x != "");

    let mut distance_row: Vec<&str> = rows[1].split(" ").collect();
    distance_row.remove(0);
    distance_row.retain(|x| *x != "");

    let mut races: Vec<Race> = vec![];

    races.push(
        Race {
            max_time: to_int(&time_row.join("")),
            record_distance: to_int(&distance_row.join("")),
        }
    );

    return races;
}

fn calc_distance(duration_ms: u64, max_time: u64) -> u64 {
    let time_to_move = max_time - duration_ms;
    // speed = duration_ms
    return time_to_move * duration_ms; // = distance
}

fn beat_race(race: Race) -> u64 {
    let mut beats = 0;

    for duration in 0..=race.max_time {
        let distance = calc_distance(duration, race.max_time);

        if distance > race.record_distance {
            beats += 1;
        }
    }

    return beats;
}

fn run(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows: Vec<&str> = contents.split("\n").collect();

    let races = get_races(rows);

    let mut result = 1;

    for race in races {
        result *= beat_race(race)
    }

    return result;
}

fn run2(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows: Vec<&str> = contents.split("\n").collect();

    let races = get_race2(rows);

    let mut result = 1;

    for race in races {
        result *= beat_race(race)
    }

    return result;
}

fn main() {
    // let result = run("dev.txt");
    // println!("result: {r}", r = result);
    // assert!(result == 288);
    //
    // let pt1_result = run("test.txt");
    // println!("part 1: {}", pt1_result);

    let result = run2("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 71503);

    let pt2_result = run2("test.txt");
    println!("part 2: {}", pt2_result);
}
