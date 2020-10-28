// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Invoice.sol";
import "./Vendor.sol";

contract Product {
    using SafeMath for uint;

    string public title;
    string public description;
    uint public price;
    uint32 public stock;

    event UpdatedTitle (string title);
    event UpdatedDescription (string description);
    event UpdatedPrice (string price);
    event UpdatedStock (uint32 stock);

    Vendor public vendor;

    constructor (string memory _title, string memory _description, uint _price) {
        title = _title;
        description = _description;
        price = _price;
        vendor = Vendor(msg.sender);
    }

    modifier onlyVendor () {
        require(vendor.owner() == msg.sender, "Reserved for the vendor");
        _;
    }

    function changeTitle (string calldata _title) public onlyVendor {
        title = _title;

        emit UpdatedTitle(_title);
    }

    function changeDescription (string calldata _description) public onlyVendor {
        description = _description;

        emit UpdatedDescription(_description);
    }

    function changePrice (uint _price) public onlyVendor {
        price = _price;

        emit UpdatedPrice(_price);
    }

    function updateStock (uint32 _stock) public  {
        require(vendor.owner() == msg.sender || address(vendor) == msg.sender, "No permission");

        stock = _stock;

        emit UpdatedStock(_stock);
    }
}