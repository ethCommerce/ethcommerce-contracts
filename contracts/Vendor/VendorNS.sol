pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VendorNS is Ownable {
    mapping (bytes32 => uint) nameToVendorId;

    function getVendorIdByName (bytes32 _name) public view returns (uint) {
        return nameToVendorId[_name];
    }

    function registerVendorName (uint _vendorId, bytes32 _name) public onlyOwner {
        nameToVendorId[_name] = _vendorId;
    }
}

contract VendorNSInterface {
    function getVendorIdByName (bytes32) public view returns (uint) {}

    function registerVendorName (uint _vendorId, bytes32 _name) public {}
}