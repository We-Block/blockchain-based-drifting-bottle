pragma solidity ^0.8.0;

import "./BottleLibrary.sol";
import "./ReplyLibrary.sol";
import "./Random.sol";
import "./MessageLibrary.sol";
import "./ProfileLibrary.sol";

contract DriftBottleChain {
    using BottleLibrary for BottleLibrary.Bottle;
    using MessageLibrary for MessageLibrary.Message;
    using ProfileLibrary for ProfileLibrary.Profile;

    BottleLibrary.Bottle[] private bottles;
    MessageLibrary.Message[] private messages;
    mapping(address => ProfileLibrary.Profile) private profiles;

    event BottleSent(address indexed sender, uint256 indexed bottleId);
    event BottleReceived(address indexed receiver, uint256 indexed bottleId);
    event BottleReplied(uint256 indexed bottleId, address indexed sender);
    event MessagePosted(address indexed sender, uint256 indexed messageId);
    event ProfileUpdated(address indexed user);
    event BottleCreated(uint256 indexed bottleId, address indexed sender);


    function sendBottle(string memory message) public {
        BottleLibrary.Bottle memory newBottle = BottleLibrary.createBottle(msg.sender, message, block.timestamp);
        bottles.push(newBottle);
        emit BottleSent(msg.sender, bottles.length - 1);
    }

    function receiveBottle() public returns (uint256, address, string memory, uint256) {
        require(bottles.length > 0, "No bottles available.");

        bytes32 seed = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));
        uint256 randomIndex = Random.generateRandomIndex(bottles.length, seed);
        BottleLibrary.Bottle memory receivedBottle = bottles[randomIndex];

        //Remove the bottle from the available list
        bottles[randomIndex] = bottles[bottles.length - 1];
        bottles.pop();

        emit BottleReceived(msg.sender, randomIndex);

        return (randomIndex, receivedBottle.sender, receivedBottle.message, receivedBottle.timestamp);
    }
    
     function replyBottle(uint256 bottleId, string memory message) public {
        require(bottleId < bottles.length, "Invalid bottle ID.");

        BottleLibrary.Bottle storage bottleToReply = bottles[bottleId];
        //bottleToReply.replies.push(ReplyLibrary.createReply(msg.sender, message, block.timestamp));  
        bottleToReply.replies.push(ReplyLibrary.Reply(msg.sender, message, block.timestamp)); 



        emit BottleReplied(bottleId, msg.sender);
    }



    function createBottle(string memory message) public {
        BottleLibrary.Bottle memory newBottle = BottleLibrary.createBottle(msg.sender, message, block.timestamp);
        bottles.push(newBottle);
        emit BottleCreated(bottles.length - 1, msg.sender);
}

    function getBottleReplyCount(uint256 bottleId) public view returns (uint256) {
        require(bottleId < bottles.length, "Invalid bottle ID.");
        BottleLibrary.Bottle storage bottle = bottles[bottleId];
        return bottle.replies.length;
    }

    function getBottleReply(uint256 bottleId, uint256 replyIndex) public view returns (address sender, string memory message, uint256 timestamp){
        require(bottleId < bottles.length, "Invalid bottle ID.");
        BottleLibrary.Bottle storage bottle = bottles[bottleId];
        require(replyIndex < bottle.replies.length, "Invalid reply index.");
        ReplyLibrary.Reply storage reply = bottle.replies[replyIndex];
        return (reply.sender, reply.message, reply.timestamp);
    }




    // Public message board functions
    function postMessage(string memory content) public {
        MessageLibrary.Message memory newMessage = MessageLibrary.createMessage(msg.sender, content, block.timestamp);
        messages.push(newMessage);
        emit MessagePosted(msg.sender, messages.length - 1);
    }

    function getMessage(uint256 messageId) public view returns (address, string memory, uint256) {
        require(messageId < messages.length, "Invalid message ID.");
        MessageLibrary.Message memory message = messages[messageId];
        return (message.sender, message.content, message.timestamp);
    }

    function getAllMessages() public view returns (MessageLibrary.Message[] memory) {
        return messages;
    }

    // Profile functions
    function updateProfile(string memory name, string memory bio) public {
        ProfileLibrary.Profile memory newProfile = ProfileLibrary.createProfile(msg.sender, name, bio);
        profiles[msg.sender] = newProfile;
        emit ProfileUpdated(msg.sender);
    }

    function getProfile(address userAddress) public view returns (string memory, string memory) {
        ProfileLibrary.Profile memory userProfile = profiles[userAddress];
        return (userProfile.name, userProfile.bio);
    }
}

