// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Vendor/VendorAccessControl.sol";
import "./Vendor/VendorData.sol";
//import "./Vendor/VendorInvoice.sol";
import "./Vendor/VendorNS.sol";
import "./Vendor/VendorProduct.sol";

contract Vendor is Ownable {

    event VendorRegistered (uint vendorId, address owner);

    VendorAccessControlInterface public accessControl;
    //VendorNS public vendorNS;
    VendorDataInterface public data;
    //VendorInvoiceInterface public invoice;
    VendorProductInterface public product;

    /**
     * AccessControl contract implementation
     */

    function register () public {
        uint vendorId = accessControl.registerVendor(msg.sender);

        emit VendorRegistered (vendorId, msg.sender);
    }


    function changeOwner (uint _vendorId, address _newOwner) public {
        accessControl.changeOwner(_vendorId, _newOwner, msg.sender);
    }

    /**
     *  Data contract implementation 
     */

    function getData (uint _vendorId) public view returns (VendorDataInterface.Data memory) {
        return data.getData(_vendorId);
    }

    function setTitle (uint _vendorId, bytes32 _title) onlyVendorOwner(_vendorId) public {
        data.setTitle(_vendorId, _title);
    }

    function setDescription (uint _vendorId, bytes32 _description) onlyVendorOwner(_vendorId) public {
        data.setDescription(_vendorId, _description);
    }

    function setThumbnail (uint _vendorId, bytes32 _thumbnail) onlyVendorOwner(_vendorId) public {
        data.setThumbnail(_vendorId, _thumbnail);
    }

    modifier onlyVendorOwner (uint _vendorId) {
        require(accessControl.isVendorOwnedByAddress(_vendorId, msg.sender), "not permitted");
        _;
    }

    /*
     * Set contract helper
     */

    bool contractLock;

    function setContracts (
        address _accessControl,
        address _data,
        //address _invoice,
        address _product
    ) public onlyOwner {
        require(!contractLock);

        accessControl = VendorAccessControlInterface(_accessControl);
        data = VendorDataInterface(_data);
        product = VendorProductInterface(_product);
        
        contractLock = true;
    }
}