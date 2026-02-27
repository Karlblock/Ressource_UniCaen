
pub fn run() {
    // print to console
    println!("Hello, world");

    println!("{} id from {}", "Brad", "Mass");

    //positional Arguments
    println!("{0} is from {1} and {2} ", "Brad","Mass", "code");

    //Named Arguments
    println!("{name} Likes to play {activity}", name = "Jhon", activity = "baseball");

    // Placeholder traits
    println!("Binary: {:b} Hex: {:x} Octal: {:o}", 10, 10, 10);

    //placeholder for debug trait
    println!("{:?}", (12, true, "hello"));

    //Basic match
    println!("10 + 10 = {}", 10 + 10);
}

