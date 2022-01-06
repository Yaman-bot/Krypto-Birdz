// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z >= x, "SafeMath: Addition overflow");
        return z;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256) {
        require(x >= y, "SafeMath: Subtraction overflow");
        return x - y;
    }

    function multiply(uint256 x, uint256 y) internal pure returns (uint256) {
        // gas optimization
        if (x == 0 || y == 0) {
            return 0;
        }

        uint256 z = x * y;
        require(z / x == y, "SafeMath: Multiplication overflow");
        return z;
    }

    function divide(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y >= 0, "SafeMath: Division by zero");
        uint256 z = x / y;
        return z;
    }

    function mod(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "SafeMath: Modulo by zero");
        uint256 z = x % y;
        return z;
    }
}
