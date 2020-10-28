// SPDX-License-Identifier: WTFPL

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/payment/PullPayment.sol";
import "./Product.sol";
import "./Vendor.sol";

contract Invoice is PullPayment {
    using SafeMath for uint;

    string public addressData;
    string public shipmentTrackingData;
    address public customer;
    string public customerPublicKey;
    Vendor public vendor;

    address[] public products;
    uint32[] public quantities;

    uint public totalPrice;
    uint public shippingCosts;

    enum Status { Created, ShippingCalculated, Paid, Sent, Received }
    Status public status;
    event StatusUpdate (string currentStatus);
    
    constructor (address _customer, string memory _customerPublicKey, address[] memory _products, uint32[] memory _quantities) {
        customer = _customer;
        customerPublicKey = _customerPublicKey;
        products = _products;
        quantities = _quantities;
        vendor = Vendor(msg.sender);

        uint _totalPrice;
        for (uint i = 0; i < products.length; i++) {
            uint productPrice = Product(products[i]).price();
            uint quantity = _quantities[i];
            uint totalProductsPrice = productPrice.mul(quantity);

            _totalPrice = _totalPrice.add(totalProductsPrice);
        }

        totalPrice = _totalPrice;
    }

    function addShippingCosts (uint _shippingCosts) isVendor public {
        require(status == Status.Created, "Shipping costs can't be changed");

        shippingCosts = shippingCosts.add(_shippingCosts);
        status = Status.ShippingCalculated;

        emit StatusUpdate("ShippingCalculated");
    }

    function pay () public payable isCustomer {
        require(status == Status.ShippingCalculated, "Contract can't be paid yet or has been paid");
        require(msg.value == (totalPrice + shippingCosts), "Paid value isn't the exact requested amount");

        _asyncTransfer(vendor.owner(), msg.value);
        status = Status.Paid;

        emit StatusUpdate("Paid");
    }

    function shipmentSent (string calldata _shipmentTrackingData) public payable isVendor {
        require(status == Status.Paid, "Awaiting payment or function already executed");
        status = Status.Sent;
        shipmentTrackingData = _shipmentTrackingData;

        emit StatusUpdate("Sent");
    }

    function shipmentReceived () public isCustomer {
        require(status == Status.Sent);
        status = Status.Received;

        emit StatusUpdate("Received");
    }

    modifier isVendor () {
        require(vendor.owner() == msg.sender, "Sender is not the vendor");
        _;
    }

    modifier isCustomer () {
        require(customer == msg.sender, "Sender is not the customer");
        _;
    }
}