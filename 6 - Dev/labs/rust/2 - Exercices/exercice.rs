 fn main() {

    // print hello world dans la console 

    println!("");

    // print nom prenom
    println!("", , "");

    //positionner les arguments : 0 1 2 
    println!("{} is from {} and {} ", "Brad","Mass", "code");

    // Nommer les argurments et print
    println!("{name} Likes to play {activity}", name = "Jhon", activity = "baseball");

    // Placeholder traits
    println!("Binary: {:b} Hex: {:x} Octal: {:o}", 10, 10, 10);

    //placeholder for debug trait
    println!("{:?}", (12, true, "hello"));

    //Basic match
    println!("10 + 10 = {}", 10 + 10);

    //faire un variable string hello
    

    // afficher la taille de cette variable 
    

    // envoyez un character char "w"


    // envoyez string "orld" avec push_str
   

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

    //
    let person: (&str, &str, i8) = ("Brad","Mass", 37);

    println!("{} is from {} and is {}", person.0, person.1, person.2);

    // creer un tableau nommé numbers avec un type interger 32 de taille 4 avec 4 valeurs 10 11 40 30;
    



    //changer la valeur de la position 2 et mettre 100 et afficher ce nombre dans un print




    // affiche la taille du tableau dans un print




    // utilisez la librairis standard avec la function mem::size_of_val() pour affiche la taille en bite du tableau  


    
    // Get Slice
    let slice: &[i32] = &numbers[1..3];
    println!("Slice: {:?}", slice);
}

