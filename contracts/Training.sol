// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Training {
    function main() public pure returns (uint256) {
        uint256 num = 1;
        assembly {
            let result := add(num, 2)
            mstore(0x0, result)
            return(0x0, 32)
        }
    }
}
