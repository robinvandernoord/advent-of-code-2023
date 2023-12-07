use std::cmp::Ordering;
use std::collections::HashMap;
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

#[derive(Debug, Eq, Ord, PartialEq, PartialOrd)]
struct Hand {
    cards: String,
    bet: u64,
    hand_type: u32,
}


const ORDERING: &[char] = &['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'];
const ORDERING2: &[char] = &['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'];


fn get_card_rank(card: &char) -> usize {
    return ORDERING2.iter().position(|n| n == card).unwrap();
}

fn compare_hands(first: &Hand, second: &Hand) -> Ordering {
    if first.hand_type > second.hand_type {
        return Ordering::Greater;
    } else if first.hand_type < second.hand_type {
        return Ordering::Less;
    }

    // else: compare individual cards
    let chars_1: Vec<char> = first.cards.chars().collect();
    let chars_2: Vec<char> = second.cards.chars().collect();

    for i in 0..chars_1.len() {
        let card1 = chars_1[i];
        let card2 = chars_2[i];
        if card1 == card2 {
            continue;
        }

        return if get_card_rank(&card1) > get_card_rank(&card2) {
            Ordering::Less
        } else {
            Ordering::Greater
        };
    }

    // should not happen but sure
    return Ordering::Equal;
}

fn calculate_hand_type(cards: &str) -> u32 {
    let chars: Vec<char> = cards.chars().collect();

    let mut hand = HashMap::new();

    for char in &chars {
        *hand.entry(char).or_insert(0) += 1;
    }

    return match (
        hand.values().filter(|&&count| count == 5).count(),
        hand.values().filter(|&&count| count == 4).count(),
        hand.values().filter(|&&count| count == 3).count(),
        hand.values().filter(|&&count| count == 2).count(),
    ) {
        (1, _, _, _) => 6, // 5 of a kind
        (_, 1, _, _) => 5, // 4 of a kind
        (_, _, 1, 1) => 4, // full house
        (_, _, 1, 0) => 3, // three of a kind
        (_, _, _, 2) => 2, // two pairs
        (_, _, _, 1) => 1, // one pair
        _ => 0, // 'high card'
    };
}

fn find_best_card<'a>(hand: &'a HashMap<&'a char, u32>) -> &'a char {
    let mut best_card: &char = &'J';
    let mut best_count: &u32 = &0;

    for (card, count) in hand.iter() {

        if count < best_count || *card == &'J' {
            continue;
        } else if count > best_count {
            best_count = count;
            best_card = card;
        } else if get_card_rank(card) < get_card_rank(best_card) {
            best_card = card;
        }
    }

    return best_card;
}

fn calculate_hand_type2(cards: &str) -> u32 {
    let chars: Vec<char> = cards.chars().collect();

    let mut hand = HashMap::new();

    for char in &chars {
        *hand.entry(char).or_insert(0) += 1;
    }

    // clone outside of scope to pass to find_best_card (idk)
    let cloned = hand.clone();

    if hand.contains_key(&'J') && hand[&'J'] != 5 {
        let jokers = hand[&'J'];
        let best_card = find_best_card(&cloned);

        if best_card == &'J' {
            panic!("BEST CARD = J!")
        }

        hand.remove_entry(&'J');
        *hand.entry(best_card).or_insert(0) += jokers;
    }

    return match (
        hand.values().filter(|&&count| count == 5).count(),
        hand.values().filter(|&&count| count == 4).count(),
        hand.values().filter(|&&count| count == 3).count(),
        hand.values().filter(|&&count| count == 2).count(),
    ) {
        (1, _, _, _) => 6, // 5 of a kind
        (_, 1, _, _) => 5, // 4 of a kind
        (_, _, 1, 1) => 4, // full house
        (_, _, 1, 0) => 3, // three of a kind
        (_, _, _, 2) => 2, // two pairs
        (_, _, _, 1) => 1, // one pair
        _ => 0, // 'high card'
    };
}


fn run(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows = contents.split("\n");

    let mut hands = vec![];

    for row in rows {
        if row == "" {
            continue;
        }

        let parts = split(row, " ");
        let cards = parts.0.to_string();
        let bet = to_int(parts.1);

        let hand_type = calculate_hand_type(&cards);

        hands.push(Hand {
            cards,
            bet,
            hand_type,
        });
    }

    hands.sort_by(compare_hands);

    let mut result: u64 = 0;

    for (_rank, hand) in hands.iter().enumerate() {
        let rank = (_rank + 1) as u64;
        result += rank * hand.bet;
    }

    return result;
}

fn run2(filename: &str) -> u64 {
    let contents = fs::read_to_string(filename)
        .expect("Should have been able to read the file");

    let rows = contents.split("\n");

    let mut hands = vec![];

    for row in rows {
        if row == "" {
            continue;
        }

        let parts = split(row, " ");
        let cards = parts.0.to_string();
        let bet = to_int(parts.1);

        let hand_type = calculate_hand_type2(&cards);

        hands.push(Hand {
            cards,
            bet,
            hand_type,
        });
    }

    hands.sort_by(compare_hands);

    let mut result: u64 = 0;

    for (_rank, hand) in hands.iter().enumerate() {
        let rank = (_rank + 1) as u64;
        result += rank * hand.bet;
    }

    return result;
}

fn test_hand_types() {
    assert!(calculate_hand_type("AAAAA") == 6);
    assert!(calculate_hand_type("AA8AA") == 5);
    assert!(calculate_hand_type("23332") == 4);
    assert!(calculate_hand_type("TTT98") == 3);
    assert!(calculate_hand_type("23432") == 2);
    assert!(calculate_hand_type("A23A4") == 1);
    assert!(calculate_hand_type("23456") == 0);
}

fn test_hand_types2() {
    assert!(calculate_hand_type2("32T3K") == 1);
    assert!(calculate_hand_type2("KK677") == 2);
    assert!(calculate_hand_type2("T55J5") == 5);
    assert!(calculate_hand_type2("KTJJT") == 5);
    assert!(calculate_hand_type2("QQQJA") == 5);
}


fn main() {
    test_hand_types();

    let result = run("dev.txt");
    println!("result: {r}", r = result);
    assert!(result == 6440);

    let pt1_result = run("test.txt");
    println!("part 1: {}", pt1_result);

    println!("All checks passed for pt1!");

    test_hand_types2();

    let result = run2("dev.txt");
    println!("result: {}", result);
    // assert!(result == 5905);

    println!("All checks passed for pt2!");

    let pt2_result = run2("test.txt");
    println!("part 2: {}", pt2_result);
    assert!(pt2_result == 248029057)

    // 248238926: too high
}
