// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MessageLibrary.sol";

contract PublicMessageBoard {
    using MessageLibrary for MessageLibrary.Message;

    MessageLibrary.Message[] private messages;

    event MessagePosted(address indexed sender, uint256 indexed messageId);

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
}
