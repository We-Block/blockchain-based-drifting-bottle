// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ProfileLibrary {
    struct Profile {
        address userAddress;
        string name;
        string bio;
    }

    function createProfile(
        address _userAddress,
        string memory _name,
        string memory _bio
    ) internal pure returns (Profile memory) {
        return Profile({userAddress: _userAddress, name: _name, bio: _bio});
    }
}
