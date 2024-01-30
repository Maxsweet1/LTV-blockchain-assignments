// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract HelloWorld {
// create a state variable to store the string
    string public myHelloWorld = 'hello world';

// function to retrieve the stored string
   function getHelloWorld() public view returns (string memory) {
        return myHelloWorld;
    }

}
