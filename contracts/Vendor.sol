// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Product.sol";

contract Vendor is Ownable {
    Product[] products;

    constructor () {
    }

    function createProduct () onlyOwner public {
        
    }
}