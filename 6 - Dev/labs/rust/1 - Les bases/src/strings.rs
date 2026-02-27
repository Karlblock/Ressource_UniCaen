
// Primiive str = Immutable fixed-lenght string somewhere in memory
// String = Growable, heap-allocated data structure - use when you need to modify or own string data 

pub fn run() {

    let mut hello = String::from("Hello ");

    // Get lenght
    println!("Length: {}", hello.len());

    // Push char
    hello.push('W');

    // Push string
    hello.push_str("orld!");

    // Capacity in bytes
    println!("Capacity: {}", hello.capacity());

    // Check if empty
    println!(" Is Empty: {}", hello.is_empty());

    //Contains
    println!("Contains 'World' {}",hello.contains("World"));

    //Replace 
    println!("Replace: {}", hello.replace("World", "There"));

    // Loop through string by whitespace :
    for word in hello.split_whitespace() {
        println!("{}", word);
    }

    // create String with capacity

    let mut s = String::with_capacity(10);
    s.push('a');
    s.push('b');

    // Assertion testing

    assert_eq!(2, s.len());
    assert_eq!(10, s.capacity());

    println!("{}", s);

println!("{}", hello);
}