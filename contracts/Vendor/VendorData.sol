pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VendorData is Ownable {
    struct Data {
        bytes32 publicKey;
        bytes32 title;
        bytes32 description;
        bytes32 thumbnail;
    }

    mapping(bytes32 => bool) isTitleRegistered;
    
    mapping (uint => Data) data;

    function getData (uint _vendorId) public view returns (Data memory) {
        return data[_vendorId];
    }

    function setPublicKey (uint _vendorId, bytes32 _publicKey) public onlyOwner {
        data[_vendorId].publicKey = _publicKey;
    }

    function setTitle (uint _vendorId, bytes32 _title) public onlyOwner {
        require(!isTitleRegistered[_title]);
        
        isTitleRegistered[data[_vendorId].title] = false;
        isTitleRegistered[_title] = true;
        data[_vendorId].title = _title;
    }

    function setDescription (uint _vendorId, bytes32 _description) public onlyOwner {
        data[_vendorId].description = _description;
    }

    function setThumbnail (uint _vendorId, bytes32 _thumbnail) public onlyOwner {
        data[_vendorId].thumbnail = _thumbnail;
    }
}

contract VendorDataInterface {
    struct Data {
        bytes32 publicKey;
        string title;
        bytes32 description;
        bytes32 thumbnail;
    }

    function getData (uint _vendorId) public view returns (Data memory _data) {}

    function setPublicKey (uint _vendorId, bytes32 _publicKey) public {}

    function setTitle (uint _vendorId, bytes32 _title) public {}

    function setDescription (uint _vendorId, bytes32 _description) public {}

    function setThumbnail (uint _vendorId, bytes32 _thumbnail) public {}
}
