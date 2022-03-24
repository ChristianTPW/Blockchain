// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Traceability {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    //modifier untuk mengecek owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    modifier itemHalal(uint _itemID) {
        require(isHalal(_itemID), "Item is not Halal! can't proceed!");
        _;
    }

    function isHalal(uint _itemID) public view returns(bool _halal){
        return batches[_itemID].halal;
    } 

    
    event Trace(uint _itemID, uint _step, bool _halal, string verifiers, uint _time);
    
    enum SupplyChainSteps{Step1, Step2, Step3, Step4}


    //Struct untuk item yang akan dipantau
    struct Batch{
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
    mapping(uint => Batch) public batches;

    //index sebagai id item;
    uint index;

    //function untuk membuat item
    function createItem(string memory _name, string memory _verifier, bool _halal) public onlyOwner{

        //function untuk menambahkan informasi item
        batches[index].id = index;
        batches[index].step = SupplyChainSteps.Step1;
        batches[index].name = _name;
        batches[index].halal = _halal;
        batches[index].verifiers[0] = _verifier;


        emit Trace(batches[index].id, uint(batches[index].step), batches[index].halal, batches[index].verifiers[0], block.timestamp);
        index++;
    }

    function step2(uint _itemID, string memory _verifier ,bool _halal) public  onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah dibuat
        require(uint(batches[_itemID].step) == 0, "Item does not exist");

        //mengupdate informasi item
        batches[_itemID].step = SupplyChainSteps.Step2;
        batches[_itemID].halal = _halal;
        batches[_itemID].verifiers[1] = _verifier;

        emit Trace(batches[_itemID].id, uint(batches[_itemID].step), batches[_itemID].halal, batches[_itemID].verifiers[1], block.timestamp);
    }

    
    function step3(uint _itemID, string memory _verifier ,bool _halal) public onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah menjalankan proses sebelumnya
        require(uint(batches[_itemID].step) == 1, "Item hasn't reached this step yet");

        //mengupdate informasi item
        batches[_itemID].step = SupplyChainSteps.Step3;
        batches[_itemID].halal = _halal;
        batches[_itemID].verifiers[2] = _verifier;


        emit Trace(batches[_itemID].id, uint(batches[_itemID].step), batches[_itemID].halal, batches[_itemID].verifiers[2], block.timestamp);
    }

    function step4(uint _itemID, string memory _verifier ,bool _halal) public onlyOwner itemHalal(_itemID){
        //mengecek apakah item sudah menjalankan proses sebelumnya
        require(uint(batches[_itemID].step) == 2, "Item hasn't reached this step yet");

        //mengupdate informasi item
        batches[_itemID].step = SupplyChainSteps.Step4;
        batches[_itemID].halal = _halal;
        batches[_itemID].verifiers[3] = _verifier;


        emit Trace(batches[_itemID].id, uint(batches[_itemID].step), batches[_itemID].halal, batches[_itemID].verifiers[3], block.timestamp);
    }
    
}