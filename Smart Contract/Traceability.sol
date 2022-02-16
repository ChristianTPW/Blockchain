// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Traceability {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => bool) public party1;
    mapping(address => bool) public party2;
    mapping(address => bool) public party3;
    mapping(address => bool) public party4;

    event Trace(uint _itemID, uint _step, bool _halal);
    event AddParty(address _address, bool _status);
    
    enum SupplyChainSteps{Step1, Step2, Step3, Step4}

    struct Item{
        Traceability.SupplyChainSteps step;
        uint id;
        string name;
        bool halal;
    }

    mapping(uint => Item) public items;
    uint index;

    function createItem(string memory _name, bool _halal) public{
        require(party1[msg.sender], "You are not allowed to use this function");

        items[index].id = index;
        items[index].step = SupplyChainSteps.Step1;
        items[index].name = _name;
        items[index].halal = _halal;

        emit Trace(items[index].id, uint(items[index].step), items[index].halal);

        index++;
    }

    function step2(uint _itemID, bool _halal) public {
        require(party2[msg.sender], "You are not allowed to use this function");
        require(uint(items[_itemID].step) == 0, "Item does not exist");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step2;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    
    function step3(uint _itemID, bool _halal) public {
        require(party3[msg.sender], "You are not allowed to use this function");
        require(uint(items[_itemID].step) == 1, "Item hasn't reached this step yet");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step3;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    function step4(uint _itemID, bool _halal) public {
        require(party4[msg.sender], "You are not allowed to use this function");
        require(uint(items[_itemID].step) == 2, "Item hasn't reached this step yet");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step4;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    function addParty1(address _party1) public {
        require(msg.sender == owner, "Only owner can add new party");
        party1[_party1] = true;

        emit AddParty(_party1, party1[_party1]);
    }

    function addParty2(address _party2) public {
        require(msg.sender == owner, "Only owner can add new party");
        party2[_party2] = true;

        emit AddParty(_party2, party2[_party2]);
    }

    function addParty3(address _party3) public {
        require(msg.sender == owner, "Only owner can add new party");
        party3[_party3] = true;

        emit AddParty(_party3, party3[_party3]);
    }

    function addParty4(address _party4) public {
        require(msg.sender == owner, "Only owner can add new party");
        party4[_party4] = true;

        emit AddParty(_party4, party4[_party4]);
    }

    function isHalal(uint _itemID) public view returns(uint _steps, bool _halal){
        _steps = uint(items[_itemID].step);
        _halal = items[_itemID].halal;
    } 

    
}