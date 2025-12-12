// This setup uses Hardhat Ignition to manage smart contract deployments.

// ignition/modules/factory.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const FactoryModule = buildModule("FactoryModule", (m) => {
  // get a parameter named "fee", with a default if not provided
  const fee = m.getParameter("fee", 100n); // default 100n if not passed

  const factory = m.contract("Factory", [fee]);

  return { factory };
});

export default FactoryModule;

