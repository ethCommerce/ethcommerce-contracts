const VendorAccessControl = artifacts.require('VendorAccessControl')
const VendorData = artifacts.require('VendorData')
const VendorProduct = artifacts.require('VendorProduct')
const VendorInvoice = artifacts.require('VendorInvoice')
const Vendor = artifacts.require('Vendor')

module.exports = async function (deployer) {
    await deployer.deploy(VendorAccessControl)
    await deployer.deploy(VendorData)
    await deployer.deploy(VendorProduct)
    await deployer.deploy(VendorInvoice)
    await deployer.deploy(Vendor)

} as Truffle.Migration

export {}
