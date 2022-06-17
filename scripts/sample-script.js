
const hre = require("hardhat");

async function main() {

  const PixelPrints = await hre.ethers.getContractFactory("PixelPrints");
  const pixelPrints = await PixelPrints.deploy("Minter, Mint");

  await pixelPrints.deployed();

  console.log("PixelPrints deployed to:", pixelPrints.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
