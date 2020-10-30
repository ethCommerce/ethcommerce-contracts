const VendorAccessControl = artifacts.require('VendorAccessControl')
const VendorData = artifacts.require('VendorData')
const VendorProduct = artifacts.require('VendorProduct')
const Vendor = artifacts.require('Vendor')

module.exports = async function (deployer) {
    await deployer.deploy(VendorAccessControl);
    await deployer.deploy(VendorData)
    await deployer.deploy(Vendor)
    await deployer.deploy(VendorProduct)

} as Truffle.Migration

export {}
