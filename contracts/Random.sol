// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Random {
    function generateRandomIndex(uint256 _range, bytes32 _seed) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_seed))) % _range;
    }
}
