const VendorNS = artifacts.require("VendorNS");

module.exports = function (deployer) {
  deployer.deploy(VendorNS);
};
