const main = async() => {
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("ass");
    await domainContract.deployed();

    console.log("Contract deployed to:", domainContract.address);

    let txn = await domainContract.register("mortal", {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain mortal.ass");

    txn = await domainContract.setRecord("mortal", "Mortal ass?");
    await txn.wait();
    console.log("Set record for mortal.ass");
    
    const address = await domainContract.getAddress("mortal");
    console.log("Owner of domain moral:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    }catch(error){
        console.log(error);
        process.exit(1);
    }
};

runMain();