// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Vendor/VendorAccessControl.sol";
import "./Vendor/VendorData.sol";
import "./Vendor/VendorInvoice.sol";
import "./Vendor/VendorNS.sol";
import "./Vendor/VendorProduct.sol";

contract Vendor is Ownable {

    event VendorRegistered (uint vendorId, address owner);

    VendorAccessControlInterface public accessControl;
    VendorNSInterface public nameService;
    VendorDataInterface public data;
    VendorInvoiceInterface public invoice;
    VendorProductInterface public product;

    /**
     * VendorNS implementation
     */

    function getVendorIdByName (bytes32 _name) public view returns (uint) {
        return nameService.getVendorIdByName(_name);
    }

    function registerVendorName (uint _vendorId, bytes32 _name) public onlyVendorOwner(_vendorId) {
        nameService.registerVendorName(_vendorId, _name);
    }

    /**
     * AccessControl contract implementation
     */

    function register () public {
        uint vendorId = accessControl.registerVendor(msg.sender);

        emit VendorRegistered (vendorId, msg.sender);
    }

    function changeOwner (uint _vendorId, address _newOwner) public onlyVendorOwner(_vendorId) {
        accessControl.changeOwner(_vendorId, _newOwner, msg.sender);
    }

    modifier onlyVendorOwner (uint _vendorId) {
        require(accessControl.isVendorOwnedByAddress(_vendorId, msg.sender), "not permitted");
        _;
    }

    /**
     *  Product contract implementation 
     */

    event ProductCreated (uint productId);

    modifier onlyProductOwner (uint _vendorId, uint _productId) {
        require(product.isProductOwnedByVendor(_vendorId, _productId));
        _;
    }

    function getVendorIdByProductId (uint _productId) public view returns (uint) {
        return product.getVendorIdByProductId(_productId);
    }

    function getProductIdsByVendorId (uint _vendorId) public view returns (uint[]) {
        return product.getProductIdsByVendorId(_vendorId);
    }

    function createProduct (
        uint _vendorId,
        bytes32 _title,
        bytes32 _description,
        bytes32 _thumbnail,
        bytes32 _publicKey,
        uint32 _stock,
        uint256 _price
    ) public view onlyVendorOwner(_vendorId) {
        product.create(_vendorId, _title, _description, _thumbnail, _publicKey, _stock, _price);
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

    /**
     *  Data contract implementation 
     */

    function getInvoice (uint _invoiceId) public view returns (VendorInvoiceInterface.Invoice memory) {
        return invoice.get(_invoiceId);
    }

    function createInvoice (
        uint _vendorId,
        address _clientAddress,
        uint[] calldata  _productIds,
        uint[] calldata _quantities,
        bytes32 _deliveryAddressHash,
        bytes32 _clientPublicKeyHash
    ) public {
        require(_productIds.length == _quantities.length);

        for (uint i = 0; i < _productIds.length; i++) {
            
        }
    }

    /*
     * Set contract helper
     */

    bool contractLock;

    function setContracts (
        address _accessControl,
        address _nameService,
        address _data,
        address _invoice,
        address _product
    ) public onlyOwner {
        require(!contractLock);

        accessControl = VendorAccessControlInterface(_accessControl);
        nameService = VendorNSInterface(_nameService);
        data = VendorDataInterface(_data);
        invoice = VendorInvoiceInterface(_invoice);
        product = VendorProductInterface(_product);
        
        contractLock = true;
    }
}