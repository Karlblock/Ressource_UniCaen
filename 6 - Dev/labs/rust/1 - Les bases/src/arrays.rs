// Arrays - Fixed list where elements are the same data types


use::std::mem;

pub fn run() {
    let mut numbers: [i32; 5] = [1,2,3,4,5];

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
    let slice: &[i32] = &numbers[0..5];
    println!("Slice: {:?}", slice);
}

