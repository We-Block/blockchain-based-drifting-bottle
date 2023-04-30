// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MessageLibrary {
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
    }

    function createMessage(
        address _sender,
        string memory _content,
        uint256 _timestamp
    ) internal pure returns (Message memory) {
        return Message({sender: _sender, content: _content, timestamp: _timestamp});
    }
}
