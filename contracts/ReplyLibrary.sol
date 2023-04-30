// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ReplyLibrary {
    struct Reply {
        address sender;
        string message;
        uint256 timestamp;
    }

    function createReply(
        address _sender,
        string memory _message,
        uint256 _timestamp
    ) internal pure returns (Reply memory) {
        return Reply({sender: _sender, message: _message, timestamp: _timestamp});
    }

    function addReply(Reply[] storage replies, Reply memory newReply) internal {
        replies.push(newReply);
    }
}
