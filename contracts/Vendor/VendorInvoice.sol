pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/payment/PullPayment.sol";

contract VendorInvoice is Ownable, ReentrancyGuard, PullPayment {
    mapping(uint => Invoice) invoices;
    uint currentInvoiceId;

    enum Status {
        Created,
        Accepted,
        Paid,
        Sent,
        Received
    }

    struct Invoice {
        uint vendorId;

        Status status;
        uint[] productIds;
        uint[] quantities;

        uint productsCost;
        uint shippingCost;

        address clientAddress;
        string clientSshPublicKey;
    }

    function get (uint _invoiceId) public view returns (Invoice memory) {
        return invoices[_invoiceId];
    }

    function create (
        uint _vendorId,
        address _clientAddress,
        uint[] calldata  _productIds,
        uint[] calldata _quantities,
        bytes32 _deliveryAddressHash,
        string memory _clientSshPublicKey,
        uint _productsCost
    ) public onlyOwner {
        invoices[currentInvoiceId] = Invoice({
            vendorId: _vendorId,
            status: Status.Created,
            productIds: _productIds,
            quantities: _quantities,
            productsCost: _productsCost,
            shippingCost: 0,
            clientSshPublicKey: _clientSshPublicKey,
            clientAddress: _clientAddress
        });
    }

    function accept (uint _invoiceId, uint _shippingPrice) public nonReentrant onlyOwner {
        Invoice storage invoice = invoices[_invoiceId];
        require(invoice.status == Status.Created);

        invoice.shippingCost = _shippingPrice;
        invoice.status = Status.Accepted;
    }

    function pay (uint _invoiceId, address _vendorAddress) public payable nonReentrant onlyOwner {
        Invoice storage invoice = invoices[_invoiceId];
        require(invoice.status == Status.Accepted);

        uint totalPrice = invoice.productsCost + invoice.shippingCost;

        require(msg.value == totalPrice);

        _asyncTransfer(_vendorAddress, msg.value);

        invoice.status = Status.Paid;        
    }

    function send (uint _invoiceId, bytes32 _shipmentDataHash) public onlyOwner {
        Invoice storage invoice = invoices[_invoiceId];
        require(invoice.status == Status.Paid);

        invoice.shipmentDataHash = _shipmentDataHash;
        invoice.status = Status.Sent;
    }

    function received (uint _invoiceId, address _clientAddress) public onlyOwner {
        Invoice storage invoice = invoices[_invoiceId];

        require(invoice.clientAddress == _clientAddress);

        invoice.status = Status.Received;
    }
}

contract VendorInvoiceInterface {
    enum Status {
        Created,
        Accepted,
        Paid,
        Sent,
        Received
    }

    struct Invoice {
        uint vendorId;
        Status status;
        uint[] productIds;
        uint[] quantities;
        uint productsCost;
        uint shippingCost;
        address clientAddress;
        bytes32 clientPublicKeyHash;
    }

    function get (uint _invoiceId) public view returns (Invoice memory) {}

    function create (
        uint _vendorId,
        address _clientAddress,
        uint[] calldata  _productIds,
        uint[] calldata _quantities,
        bytes32 _deliveryAddressHash,
        bytes32 _clientPublicKeyHash
    ) public {}

    function accept (uint _invoiceId, uint _shippingPrice) public {}

    function pay (uint _invoiceId, address _vendorAddress) public payable {}

    function send (uint _invoiceId, bytes32 _shipmentDataHash) public {}

    function received (uint _invoiceId, address _clientAddress) public {}
}

