const { Wallet, Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const ethers = require("ethers");

async function main() {
  const provider = ethers.getDefaultProvider("https://sepolia.era.zksync.dev");
  const wallet = new Wallet("YOUR_PRIVATE_KEY", provider);
  const deployer = new Deployer(hre, wallet);

  const tokenAddress = "0x..."; // Address of the ERC20 token users will use for gas
  const artifact = await deployer.loadArtifact("ERC20Paymaster");

  const paymaster = await deployer.deploy(artifact, [tokenAddress]);
  console.log(`Paymaster deployed to: ${paymaster.address}`);

  // Fund the paymaster with ETH to pay for transactions
  await (await wallet.sendTransaction({
    to: paymaster.address,
    value: ethers.parseEther("0.05"),
  })).wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
