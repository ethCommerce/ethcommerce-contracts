pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VendorProduct is Ownable {
    struct Product {
        bytes32 title;
        bytes32 description;
        bytes32 thumbnail;
        bytes32 publicKey;
        uint32 stock;
        uint256 price;
    }

    Product[] public products;
    uint currentProductId;
    mapping (uint => uint) productToVendor; // productId to vendorId
    mapping (uint => uint[]) vendorToProducts;

    function isProductOwnedByVendor (uint _productId, uint _vendorId) public view returns (bool) {
        return productToVendor[_productId] == _vendorId;
    }

    function getVendorByProduct (uint _productId) public view returns (uint) {
        return productToVendor[_productId];
    }

    function getProductsByVendor (uint _vendorId) public view returns (uint[] memory) {
        return vendorToProducts[_vendorId];
    }

    function createProduct (
        uint _vendorId,
        bytes32 _title,
        bytes32 _description,
        bytes32 _thumbnail,
        bytes32 _publicKey,
        uint32 _stock,
        uint256 _price
    ) public onlyOwner {
         Product memory product = Product({
             title: _title,
             description: _description,
             thumbnail: _thumbnail,
             publicKey: _publicKey,
             stock: _stock,
             price: _price
         });

        products[currentProductId] = product;
        vendorToProducts[_vendorId].push(currentProductId);

        currentProductId++;
    }
}

contract VendorProductInterface {
    function isProductOwnedByVendor (uint _productId, uint _vendorId) public view returns (bool) {}

    function getVendorByProduct (uint _productId) public view returns (uint) {}
   
    function getProductsByVendor (uint _vendorId) public view returns (uint[] memory) {}

    function createProduct (
        uint _vendorId,
        bytes32 _title,
        bytes32 _description,
        bytes32 _thumbnail,
        bytes32 _publicKey,
        uint32 _stock,
        uint256 _price
    ) public {}
}