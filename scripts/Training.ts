import { ethers } from "hardhat";

async function main() {
  const signer = (await ethers.getSigners())[0];
  const Training = await ethers.getContractFactory("Training", signer);
  const training = await Training.deploy();
  await training.deployed();

  // interaction
  const res = await training.main();
  console.log(res.toString());
}

main().catch((error) => {
  console.log(error);
  process.exitCode = 1;
});
