pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VendorData is Ownable {
    struct Data {
        bytes publicKey;
        bytes32 title;
        bytes32 description;
        bytes32 thumbnail;
    }

    constructor () {

    }
}