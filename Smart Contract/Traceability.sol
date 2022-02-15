// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Traceability {

    event Trace(uint _itemID, uint _step, bool _halal);

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
        items[index].id = index;
        items[index].step = SupplyChainSteps.Step1;
        items[index].name = _name;
        items[index].halal = _halal;

        emit Trace(items[index].id, uint(items[index].step), items[index].halal);

        index++;
    }

    function step2(uint _itemID, bool _halal) public {
        require(uint(items[_itemID].step) == 0, "Item does not exist");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step2;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    
    function step3(uint _itemID, bool _halal) public {
        require(uint(items[_itemID].step) == 1, "Item hasn't reached this step yet");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step3;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    function step4(uint _itemID, bool _halal) public {
        require(uint(items[_itemID].step) == 2, "Item hasn't reached this step yet");
        require(items[_itemID].halal, "Item is not halal");

        items[_itemID].step = SupplyChainSteps.Step4;
        items[_itemID].halal = _halal;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal);
    }

    function isHalal(uint _itemID) public view returns(uint _steps, bool _halal){
        _steps = uint(items[_itemID].step);
        _halal = items[_itemID].halal;
    } 

    
}