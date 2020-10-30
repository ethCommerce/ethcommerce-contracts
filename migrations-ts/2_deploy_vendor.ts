const VendorAccessControl = artifacts.require('VendorAccessControl')
const VendorData = artifacts.require('VendorData')
const VendorProduct = artifacts.require('VendorProduct')
const Vendor = artifacts.require('Vendor')

module.exports = async function (deployer) {
    const vendorAccessControl = await deployer.deploy(VendorAccessControl);
    const vendorData = await deployer.deploy(VendorData)
    const vendor = await deployer.deploy(Vendor)
    const vendorProduct = await deployer.deploy(VendorProduct)

    console.log(vendorAccessControl)

} as Truffle.Migration

export {}
