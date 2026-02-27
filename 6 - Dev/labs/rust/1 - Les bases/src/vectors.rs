// Vectors - Resizable arrays


use::std::mem;

pub fn run() {
let mut numbers: Vec<i32> = vec![1, 2, 3, 4];

    //Re-assign value
    numbers[2] = 20;

    // Add on to vector
    numbers.push(5);
    numbers.push(6);

    // pop off last value
    numbers.pop();

    println!("{:?}", numbers);

    // Get single val
    println!("Single Value: {}", numbers[0]);

    // Get Vector lenght

    println!("Vector lenght: {}", numbers.len());
    
    // Arrays are stack allocated 
    println!("Vector occupies {} Bytes", mem::size_of_val(&numbers));
    
    // Get Slice
    let slice: &[i32] = &numbers[1..3];
    println!("Slice: {:?}", slice);

    //Loop trought vector value
    for x in numbers.iter() {
        println!("Number: {}", x);
    }

    // loop & mutate value
    for x in numbers.iter_mut() {
        *x *= 2;
    }
    println!("Numbers Vec: {:?}",numbers);
}


