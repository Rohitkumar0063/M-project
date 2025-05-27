const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with the account:", deployer.address);

  // Ensure the contract name matches exactly as it appears in your Solidity file
  const Property = await ethers.getContractFactory("PropertyRegistry");
  const property = await Property.deploy();

  await property.deployed();

  console.log("Property contract deployed to:", property.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
