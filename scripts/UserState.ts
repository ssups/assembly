import { ethers } from "hardhat";

async function main() {
  const [owner, acc1, acc2] = await ethers.getSigners();
  let receipt;
  const UserState = await ethers.getContractFactory("UserState", owner);
  const userState = await UserState.deploy();
  await userState.deployed();

  // get owner
  let ownerAddr = await userState.getOwner();
  console.log(ownerAddr === owner.address);

  // set owner
  let setOwnerTx = await userState.connect(owner).setOwner(acc1.address);
  receipt = await setOwnerTx.wait();
  console.log(receipt.gasUsed);
  const newOwner = await userState.getOwner();
  console.log(newOwner === acc1.address);

  setOwnerTx = await userState.connect(acc1).setOwner(acc2.address);
  receipt = await setOwnerTx.wait();
  console.log(receipt.gasUsed);

  // get user by index
  const user = await userState.getUserByIndex(0);
  console.log(user == userState.address);

  // get users length
  const length = await userState.getUsersLength();
  console.log(length.toNumber() == 1);

  // add user
  let addUserTx = await userState.addUser(acc1.address);
  receipt = await addUserTx.wait();
  console.log(receipt.gasUsed);
  const newUser = await userState.getUserByIndex(1);
  console.log(newUser == acc1.address);

  addUserTx = await userState.legacyAddUser(acc2.address);
  receipt = await addUserTx.wait();
  console.log(receipt.gasUsed);

  const users = await userState.getUsers();
  console.log(users);
}

main().catch((error) => {
  console.log(error);
  process.exitCode = 1;
});
