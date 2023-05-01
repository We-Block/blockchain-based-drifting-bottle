// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ReplyLibrary.sol";

library BottleLibrary {

    event BottleCreated(uint256 indexed bottleId, address indexed sender);


    struct Bottle {
        address sender;
        string message; 
        uint256 timestamp;
        ReplyLibrary.Reply[] replies;  
    }



    function createBottle(address sender, string memory message, uint256 timestamp) public pure returns (Bottle memory) {
        Bottle memory newBottle;
        newBottle.sender = sender;
        newBottle.message = message;
        newBottle.timestamp = timestamp;
        //newBottle.replies = new ReplyLibrary.Reply[](0);
        
        return newBottle; 
}




    
}
