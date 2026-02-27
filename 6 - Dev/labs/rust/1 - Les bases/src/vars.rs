// Variables hold primitive data or references to data
// Variables are immutable by default
// rust is a block-scoped language

pub fn run() {
    let name = "Karl";

    let mut age = 37;
    println!("My name is {} and I am {}", name, age);
    age = 38;
    println!("My name is {} and I am {}", name, age);

    //Define constant
    const ID: i32 = 001;
    println!("ID: {}", ID);

    // Asign multpple vars
    let (my_name, my_age) = ("Karl", 37);
    println!("{} is {}", my_name, my_age);
}