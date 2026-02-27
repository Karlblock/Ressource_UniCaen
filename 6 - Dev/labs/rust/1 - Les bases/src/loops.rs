// Loops - Used to iterate until a condition is met


pub fn run() {
    // let mut count = 0;

    // loop  {
    //     count += 1;
    //     println!("number: {}", count);

    //     if count == 20 {
    //         break;
    //     }
    // }

    // while loop

    // while count <= 100 {
    //     if count % 15 == 0 {
    //         println!("fizzbuzz");
    //     } else if count % 3 == 0 {
    //         println!("fizz");
    //     } else if count % 5 == 0 {
    //         println!("buzz");
    //     } else {
    //         println!("{}", count)
    //     }

    //     count += 1;
    // }

    // for rane 
    for x in 0..100 {
        if x % 15 == 0 {
            println!("fizzbuzz");
        } else if x % 3 == 0 {
            println!("fizz");
        } else if x % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", x)
        }
    }

}
