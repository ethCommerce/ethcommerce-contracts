// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./Vendor.sol";

contract VendorNS {
    event VendorRegistered(bytes16 vendorName, address vendorAddress);

    mapping(bytes16 => address) vendorNames;
    address[] vendors;
    
    function registerVendor (bytes16 _name) public returns (address vendorAddress){
        require(vendorNames[_name] == address(0), "Vendor name already taken");

        Vendor vendor = new Vendor();
        vendorAddress = address(vendor);

        vendorNames[_name] = vendorAddress;
        vendors.push(vendorAddress);

        emit VendorRegistered(_name, vendorAddress);
    }
}