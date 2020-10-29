// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Product.sol";
import "./Invoice.sol";

contract Vendor is Ownable {
    Product[] public products;
    Invoice[] public invoices;
    mapping(address => bool) public productExists;
    mapping(address => bool) public invoiceExists;

    bytes public publicKey; //TODO: datatype
    string public title;
    string public description;
    bytes public thumbnail; //TODO: IPFS

    constructor (string memory _title, string memory _description) {
        title = _title;
        description = _description;
    }

    function createProduct (string calldata _title, string calldata _description, uint _price) onlyOwner public {
        Product product = new Product(_title, _description, _price);

        products.push(product);
        productExists[address(product)] = true;
    }

    function createInvoice (string calldata _publicKey, address[] calldata _products, uint32[] calldata _quantities) public {
        require(_quantities.length == _products.length, "Amount of quantities doesn't match amount of products");

        for (uint i = 0; i < _products.length; i++) {
            require(productExists[_products[i]], "Listed product contract is not a part of vendor");
            require(Product(_products[i]).stock() >= _quantities[i], "Product out of stock");
        }

        Invoice invoice = new Invoice(msg.sender, _publicKey, _products, _quantities);

        invoices.push(invoice);
        invoiceExists[address(invoice)] = true;
    }

    function subtractStock (address _product, uint32 _boughtStock) public {
        require(invoiceExists[msg.sender], "Caller is not an invoice");

        Product product = Product(_product);

        require(product.stock() >= _boughtStock, "Out of stock");

        product.updateStock(product.stock() - _boughtStock);
    }
}