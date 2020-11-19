pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VendorProduct is Ownable {
    struct Product {
        bytes32 title;
        bytes32 description;
        bytes32 thumbnail;
        uint32 stock;
        uint256 price;
        bytes16[] tags;
    }

    Product[] public products;
    uint currentProductId;
    mapping (uint => uint) productToVendor; // productId to vendorId
    mapping (uint => uint[]) vendorToProducts;

    function isProductOwnedByVendor (uint _vendorId, uint _productId) public view returns (bool) {
        return productToVendor[_productId] == _vendorId;
    }

    function getVendorIdByProductId (uint _productId) public view returns (uint) {
        return productToVendor[_productId];
    }

    function getProductIdsByVendorId (uint _vendorId) public view returns (uint[] memory) {
        return vendorToProducts[_vendorId];
    }

    function create (
        uint _vendorId,
        bytes32 _title,
        bytes32 _description,
        bytes32 _thumbnail,
        uint32 _stock,
        uint256 _price,
        bytes16[] memory _tags
    ) public onlyOwner returns (uint) {
         Product memory product = Product({
             title: _title,
             description: _description,
             thumbnail: _thumbnail,
             stock: _stock,
             price: _price,
             tags: _tags
         });

        products[currentProductId] = product;
        vendorToProducts[_vendorId].push(currentProductId);

        currentProductId++;
        return currentProductId - 1;
    }

    function update () public {} //TODO: implement
}

contract VendorProductInterface {
    function isProductOwnedByVendor (uint _productId, uint _vendorId) public view returns (bool) {}

    function getVendorIdByProductId (uint _productId) public view returns (uint) {}
   
    function getProductIdsByVendorId (uint _vendorId) public view returns (uint[] memory) {}

    function create (
        uint _vendorId,
        bytes32 _title,
        bytes32 _description,
        bytes32 _thumbnail,
        uint32 _stock,
        uint256 _price,
        bytes16[] memory tags
    ) public {}
}