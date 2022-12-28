const { ethers } = require("hardhat")

async function main() {
  const candidates = [];
  const unmembers = [];
  let factory = await ethers.getContractFactory("VoterList");
  const contractVoterList = await factory.deploy();
  await contractVoterList.deployed();

  factory = await ethers.getContractFactory("Ballot");
  const contractBallot = await factory.deploy(
    contractVoterList.address,
    candidates,
    unmembers
  );
  await this.contractBallot.deployed();
  console.log(contractBallot.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
