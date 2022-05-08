const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Events", function () {
  it("Should mint ticket and transfer ticket to someone", async function () {
    const admin = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";

    const Event = await ethers.getContractFactory("Event");
    const event = await Event.deploy(admin);
    await event.deployed();

    const recipient = "0x23618e81e3f5cdf7f54c3d65f7fbc0abf5b21e8f";
    const metadataURI = "ipfs://QmPRhHP4AxxMVPUdM2ZwDrhpooPQ5BYKDMNLSUXurYus6A";

    let balance = await event.balanceOf(recipient);
    expect(balance).to.equal(0);

    const newlyMintedToken = await event.payToMintTicket(recipient, metadataURI, {value: ethers.utils.parseEther('10')});

    await newlyMintedToken.wait();

    prov = ethers.getDefaultProvider('http://localhost:8545');
    const moneyAdmin = await prov.getBalance(admin);
    const moneysender = await prov.getBalance(recipient);
    console.log(moneyAdmin);
    console.log(moneysender);

    balance = await event.balanceOf(recipient);
    expect(balance).to.equal(1);

    expect(await event.isTicketSold(metadataURI)).to.equal(true);

  });
});
