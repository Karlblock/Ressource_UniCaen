pragma solidity 0.8.9;

contract Whitelist {

    struct Person {
        string name;
        uint age;
    }

    Person[] public persons;

    function addPerson(string memory _name, uint _age) public  {

        Person memory person = Person(_name, _age);
        persons.push(person);
        
    }

    function removePerson() public {
        persons.pop();
    }
}
