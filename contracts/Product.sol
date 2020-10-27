// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Invoice.sol";
import "./Vendor.sol";

contract Product is Ownable {
    using SafeMath for uint;

    string public title;
    string public description;
    uint public price;

    Invoice[] public invoices;
    Vendor public vendor;

    constructor (string memory _title, string memory _description, uint _price) {
        title = _title;
        description = _description;
        price = _price;
        vendor = Vendor(msg.sender);
    }

    function changeTitle (string calldata _title) public {
        title = _title;
    }

    function changeDescription (string calldata _description) onlyOwner public {
        description = _description;
    }

    function changePrice (uint _price) onlyOwner public {
        price = _price;
    }

    function createInvoice (uint32 quantity) public {
        
    }
}