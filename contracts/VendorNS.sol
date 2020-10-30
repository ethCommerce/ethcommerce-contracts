// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;

import "./Vendor.sol";

contract VendorNS {
    event VendorRegistered(bytes16 vendorName, address vendorAddress);

    mapping(bytes16 => address) public vendorNames;
    address[] public vendors;
    
    function registerVendor (bytes16 _name, bytes32 _title, bytes32 _description) public returns (address vendorAddress){
        require(vendorNames[_name] == address(0), "Vendor name already taken");

        Vendor vendor = new Vendor(_title, _description);
        vendorAddress = address(vendor);

        vendorNames[_name] = vendorAddress;
        vendors.push(vendorAddress);
        vendor.transferOwnership(msg.sender);

        emit VendorRegistered(_name, vendorAddress);
    }
}