pragma solidity ^0.4.21;
/// @title QRCodeTracking with delegation.
contract Owned {
    address owner;

    constructor() Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
}

contract QRCodeTracking is Owned {
    struct Location {
        address delegate;
        uint longitude;
        uint latitude;
        string name;
    }

    struct Item {
        string id;
        string name;
    }

    Item public item;

    Location[] public locations;
    Location public recentLocation;

    event itemInfo(
        uint longitude,
        uint latitude,
        string name
        );

    function QRCodeTracking(string id, string name) onlyOwner public {
        item = Item({id: id, name: name});
    }

    function saveLocation (
        uint longitude,
        uint latitude,
        string name
    ) public {

        locations.push(Location({
            delegate: msg.sender,
            longitude: longitude,
            latitude: latitude,
            name: name
        }));

        emit itemInfo(longitude, latitude, name);

    }

    function getLocationHistory(uint idx) constant
        returns (address delegate, uint longitude, uint latitude, string name) {

        Location storage loc = locations[idx];

        return (loc.delegate, loc.longitude, loc.latitude, loc.name);
    }

    function listLocations() public view returns(string p1, string p2, string p3, string p4){
        Location storage loc1 = locations[0];
        Location storage loc2 = locations[1];
        Location storage loc3 = locations[2];
        Location storage loc4 = locations[3];
        return (loc1.name, loc2.name, loc3.name, loc4.name);
    }

    function getLastLocation() public view
        returns (address delegate, uint longitude, uint latitude, string name) {
        recentLocation = locations[locations.length - 1];

        return (recentLocation.delegate, recentLocation.longitude, recentLocation.latitude, recentLocation.name);
    }
}