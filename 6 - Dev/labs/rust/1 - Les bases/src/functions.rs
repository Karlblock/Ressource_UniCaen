

pub fn run() {
    greeting("Hello", "Jane")
}

fn greeting(greet: &str, name: &str){
    println!("{} {}, nice to meet you", greet, name);
}

fn add(n1: i32, n2: i32) -> i32 {
    n1 + n2;
}