// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./Product.sol";
import "./Invoice.sol";

contract Vendor is Ownable {
    using SafeMath for uint;

    Product[] public products;
    Invoice[] public invoices;
    mapping(address => bool) public productExists;
    mapping(address => bool) public invoiceExists;

    event ProductCreated (address contractAddress);
    event InvoiceCreated (address contractAddress);

    struct Data {
        bytes publicKey;
        bytes32 title;
        bytes32 description;
        bytes32 thumbnail;
    }
    Data public data;

    constructor (bytes32 _title, bytes32 _description) {
        data.title = _title;
        data.description = _description;
    }

    function createProduct (string calldata _title, string calldata _description, uint _price) onlyOwner public {
        Product product = new Product(_title, _description, _price);

        products.push(product);
        productExists[address(product)] = true;

        emit ProductCreated(address(product));
    }

    function createInvoice (string calldata _publicKey, address[] calldata _products, uint[] calldata _quantities) public {
        require(_quantities.length == _products.length);

        for (uint i = 0; i < _products.length; i++) {
            require(_quantities[i] > 0);
            require(productExists[_products[i]]);
            require(Product(_products[i]).stock() >= _quantities[i]);
        }

        Invoice invoice = new Invoice(msg.sender, _publicKey, _products, _quantities);

        invoices.push(invoice);
        invoiceExists[address(invoice)] = true;

        emit InvoiceCreated (address(invoice));
    }

    function subtractStock (address _product, uint _boughtStock) public {
        require(invoiceExists[msg.sender]);

        Product product = Product(_product);

        require(product.stock() >= _boughtStock, "Out of stock");

        uint productStock = product.stock();
        uint stockToSubstract = productStock.sub(_boughtStock);

        product.updateStock(stockToSubstract);
    }
}