// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Traceability {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    //modifier untuk mengecek owner
    modifier onlyOwner() {
        require(isOwner(), "You are not the owner!");
        _;
    }

    //function untuk mengecek apakah yang ingin memanggil function adalah owner
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    modifier itemHalal(uint _itemID) {
        require(isHalal(_itemID), "Item is not Halal! can't proceed!");
        _;
    }

    function isHalal(uint _itemID) public view returns(bool _halal){
        return items[_itemID].halal;
    } 

    
    event Trace(uint _itemID, uint _step, bool _halal, string verifiers, uint _time);
    
    enum SupplyChainSteps{Step1, Step2, Step3, Step4}


    //Struct untuk item yang akan dipantau
    struct Item{
        //Step supply chain berdasarkan traceability dari item
        Traceability.SupplyChainSteps step;

        //Id dari item
        uint id;

        //Nama dari item
        string name;

        //Status halal dari item
        bool halal;

        //Nama dari penginput data
        mapping(uint => string) verifiers;
    }

    //mapping untuk menyimpan informasi item;
    mapping(uint => Item) public items;

    //index sebagai id item;
    uint index;

    //function untuk membuat item
    function createItem(string memory _name, string memory _verifier, bool _halal) public onlyOwner{

        //function untuk menambahkan informasi item
        items[index].id = index;
        items[index].step = SupplyChainSteps.Step1;
        items[index].name = _name;
        items[index].halal = _halal;
        items[index].verifiers[0] = _verifier;


        emit Trace(items[index].id, uint(items[index].step), items[index].halal, items[index].verifiers[0], block.timestamp);
        index++;
    }

    function step2(uint _itemID, string memory _verifier ,bool _halal) public  onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah dibuat
        require(uint(items[_itemID].step) == 0, "Item does not exist");

        //mengupdate informasi item
        items[_itemID].step = SupplyChainSteps.Step2;
        items[_itemID].halal = _halal;
        items[_itemID].verifiers[1] = _verifier;

        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal, items[_itemID].verifiers[1], block.timestamp);
    }

    
    function step3(uint _itemID, string memory _verifier ,bool _halal) public onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah menjalankan proses sebelumnya
        require(uint(items[_itemID].step) == 1, "Item hasn't reached this step yet");

        //mengupdate informasi item
        items[_itemID].step = SupplyChainSteps.Step3;
        items[_itemID].halal = _halal;
        items[_itemID].verifiers[2] = _verifier;


        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal, items[_itemID].verifiers[2], block.timestamp);
    }

    function step4(uint _itemID, string memory _verifier ,bool _halal) public onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah menjalankan proses sebelumnya
        require(uint(items[_itemID].step) == 2, "Item hasn't reached this step yet");

        //mengupdate informasi item
        items[_itemID].step = SupplyChainSteps.Step4;
        items[_itemID].halal = _halal;
        items[_itemID].verifiers[3] = _verifier;


        emit Trace(items[_itemID].id, uint(items[_itemID].step), items[_itemID].halal, items[_itemID].verifiers[3], block.timestamp);
    }
    
}