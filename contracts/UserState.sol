// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract UserState {
    address private _owner;
    address[] private _users;

    constructor() {
        _owner = msg.sender;
        _users.push(address(this));
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function getOwner() external view returns (address owner) {
        assembly {
            owner := sload(0)
        }
    }

    function setOwner(address newOwner) external onlyOwner {
        assembly {
            sstore(0, newOwner)
        }
    }

    function setOwnerLegacy(address newOwner) external onlyOwner {
        _owner = newOwner;
    }

    function getUserByIndex(
        uint256 index
    ) external view returns (address user) {
        uint256 slot;

        assembly {
            slot := _users.slot // 1
        }

        // dynamic array가 저장된 sstore 위치
        // 해당 slot에는 array의 length가 저장되고
        // 해당 slot의 해시값 위치 + index 위치에 해당 index의 원소값이 저장된다
        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            user := sload(add(location, index))
        }
    }

    function getUsersLength() external view returns (uint256 length) {
        assembly {
            length := sload(1)
        }
    }

    function getUsers() external view returns (address[] memory) {
        return _users;
    }

    function addUser(address user) external {
        // location of _users array
        bytes32 location = keccak256(abi.encode(1));
        assembly {
            let length := sload(1)
            sstore(add(location, length), user)
            sstore(1, 2)
        }
    }

    function legacyAddUser(address user) external {
        _users.push(user);
    }
}
