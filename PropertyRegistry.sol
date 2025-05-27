// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyRegistry {

    struct Property {
        string title;
        uint256 price;
        address owner;
        bool isListed;
    }

    mapping(uint256 => Property) public properties;
    uint256 public propertyCount;

    event PropertyListed(uint256 propertyId, string title, uint256 price, address owner);
    event PropertyUnlisted(uint256 propertyId);
    event PropertyTransferred(uint256 propertyId, address newOwner);
    event PropertyPurchased(uint256 propertyId, address from, address to, uint256 price);

    // Add new property
    function addProperty(string memory _title, uint256 _price) public {
        propertyCount++;
        properties[propertyCount] = Property({
            title: _title,
            price: _price,
            owner: msg.sender,
            isListed: true
        });

        emit PropertyListed(propertyCount, _title, _price, msg.sender);
    }

    // List property for sale
    function listProperty(uint256 _propertyId) public {
        require(properties[_propertyId].owner == msg.sender, "Only the owner can list this property");
        properties[_propertyId].isListed = true;
        emit PropertyListed(_propertyId, properties[_propertyId].title, properties[_propertyId].price, msg.sender);
    }

    // Unlist property
    function unlistProperty(uint256 _propertyId) public {
        require(properties[_propertyId].owner == msg.sender, "Only the owner can unlist this property");
        properties[_propertyId].isListed = false;
        emit PropertyUnlisted(_propertyId);
    }

    // Transfer ownership
    function transferProperty(uint256 _propertyId, address _newOwner) public {
        require(properties[_propertyId].owner == msg.sender, "Only the owner can transfer this property");
        properties[_propertyId].owner = _newOwner;
        emit PropertyTransferred(_propertyId, _newOwner);
    }

    // Get property details
    function getProperty(uint256 _propertyId) public view returns (string memory, uint256, address, bool) {
        Property memory p = properties[_propertyId];
        return (p.title, p.price, p.owner, p.isListed);
    }

    function buyProperty(uint256 _propertyId) public payable {
        Property storage p = properties[_propertyId];require(p.isListed, "Property is not listed for sale");
        require(p.owner != msg.sender, "Owner cannot buy their own property");
        require(msg.value >= p.price, "Insufficient Ether to purchase property");
        address previousOwner = p.owner;
        p.owner = msg.sender;
        p.isListed = false;

    payable(previousOwner).transfer(msg.value);

    emit PropertyPurchased(_propertyId, previousOwner, msg.sender, msg.value);
    }
}
