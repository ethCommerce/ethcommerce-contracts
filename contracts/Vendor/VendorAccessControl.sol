pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VendorAccessControl is Ownable, ReentrancyGuard {
    mapping (uint => address) vendorOwner;
    uint public currentVendorId;

    function registerVendor (address _owner) public nonReentrant onlyOwner returns (uint) {
        vendorOwner[currentVendorId] = _owner;
        currentVendorId++;

        return currentVendorId - 1;
    }

    function changeOwner (uint _vendorId, address _newOwner, address _sender) public onlyOwner {
        require(_sender == vendorOwner[_vendorId]);

        vendorOwner[_vendorId] = _newOwner;
    }

    function isVendorOwnedByAddress (uint _vendorId, address _address) public view returns (bool) {
        return vendorOwner[_vendorId] == _address;
    }
}

contract VendorAccessControlInterface {
    function registerVendor (address _owner) public returns (uint) {}

    function changeOwner (uint _vendorId, address _newOwner, address _sender) public {}

    function isVendorOwnedByAddress (uint _vendorId, address _address) public view returns (bool) {}
}