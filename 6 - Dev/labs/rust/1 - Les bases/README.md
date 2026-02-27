## Bon à savoir :

Compilateur Cargo : 

Installation de Cargo : [CargoInstall](https://doc.rust-lang.org/cargo/getting-started/installation.html)


``curl https://sh.rustup.rs -sSf | sh
``


### Types : 

Les variables contiennent des données primitives ou des références à des données Les variables sont immuables par défaut rust est un langage à portée de bloc

```rust
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
```

### Variable :

Primitive Types ->

    Intergers: u8, i8, u16, i16, u32, i32, u64, i64, u128, i128, (number of bits they take in memory)
    floasts: f32, f64
    Boolean (bool)
    Tuples
    Arrays 

Rust est un langage typé statistiquement, ce qui signifie qu'il doit connaître les types de toutes les variables au moment de la compilation, cependant, le compilateur peut généralement déduire quel type nous voulons utiliser en fonction de la valeur et de la façon dont nous l'utilisons.


*   mains.rs

```rust
mod print;
mod vars;

fn main() {
    print::run(); 
}

````

*   print.rs

```rust

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
```


### String :

*   strings.rs

```rust 
// Primiive str = Immutable fixed-lenght string somewhere in memory
// String = Growable, hea^p-allocated data structure - use when you need to modify or own string data 

pub fn run() {

    let mut hello = String::from("Hello");

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
    println!("Contains 'World' {}",hello.contains("World "));

    //Replace 
    println!("Replace: {}", hello.replace("World ", "There"));

    // Loop through string by whitespace :
    for word in hello.split_whitespace() {
        println!("{}", word);
    }

    println!("{}", hello);

}
```
### Tuples :

*   tuples.rs

```rust 
// Tuples groupe together valeus of different types
// Max 12 elements


pub fn run(){
    let person: (&str, &str, i8) = ("Brad","Mass", 37);

    println!("{} is from {} and is {}", person.0, person.1, person.2);

```

### Array :

*   arrays.rs

```rust
// Arrays - Fixed list where elements are the same data types

use::std::mem;

pub fn run() {
    let mut numbers: [i32; 4] = [1, 2, 3, 4];

    //Re-assign value
    numbers[2] = 20;

    println!("{:?}", numbers);

    // Get single val
    println!("Single Value: {}", numbers[0]);

    // Get Array lenght

    println!("Array lenght: {}", numbers.len());

    // Arrays are stack allocated 
    println!("Array occupies {} Bytes", mem::size_of_val(&numbers));

    // Get Slice
    let slice: &[i32] = &numbers[1..3];
    println!("Slice: {:?}", slice);
}


```



