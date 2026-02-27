
//  Tester des conditions 

pub fn run() {
    
    let age: u8 = 18;
    let age_min = 21;
    let check_id: bool = true;
    let know_person_of_age = true;

    if age >= age_min && check_id || know_person_of_age {
        println!("Bartender: What would you like to drink");
    }else if age < age_min && check_id {
        println!("Bartender: Sorry, you have to leave");
    } else {
        println!("Bartender: I'll need to see your ID");
    }

    // shorthand if 
    let if_of_age = if age >= 21 {true} else {false};
    println!("Is of Age: {}", if_of_age)
}