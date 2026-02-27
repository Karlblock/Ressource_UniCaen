pragma solidity 0.8.4;

contract Whitelist {

    struct Person {
        string name;
        uint age;
    }

    function addPerson(string memory _name, uint _age) public  {

        Person memory person;
        person.name  = _name;
        person.age = _age;
    }
}