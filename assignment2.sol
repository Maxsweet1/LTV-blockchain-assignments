// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract HelloWorld {
    // State variable to store the greeting string
    string public  myHelloWorld = 'Hello World';
    address private owner; // State variable to store the owner's address


    // Event to log changes in the greeting string
    event StringChanged(string oldStr, string newStr);

    // Constructor to set the initial owner to the deployer of the contract
     constructor() {
     owner = msg.sender;

     }
     
    // Modifier to restrict access to the owner only
    modifier onlyOwner()  {
       require(msg.sender == owner, "Caller is not the owner");
       _; 

    }
    // Function to retrieve the stored greeting string
    function getmyHelloWorld() public view returns (string memory) {
        return myHelloWorld;

    }
    // Function to set a new greeting string
    function setmyHelloWorld(string memory newHelloWorld) public onlyOwner {
    // Should include error handling for empty strings  
        require(bytes(newHelloWorld).length > 0, "String cannot be empty");
        emit StringChanged(myHelloWorld, newHelloWorld); // Should emit an event logging the old and new strings
        myHelloWorld = newHelloWorld;

    }

    function confirmStringChange(string memory str) public view returns (bool) {
        return keccak256(abi.encodePacked(myHelloWorld)) == keccak256(abi.encodePacked(str));

    }
    
   
 
    
}
