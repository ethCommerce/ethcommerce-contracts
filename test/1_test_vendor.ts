const VendorAccessControl = artifacts.require('VendorAccessControl')
const VendorData = artifacts.require('VendorData')
const VendorProduct = artifacts.require('VendorProduct')
const Vendor = artifacts.require('Vendor')

contract('Vendor', accounts => {
    it('should bind contracts', async () => {
        const vendorAccessControl = await VendorAccessControl.deployed()
        const vendorData = await VendorData.deployed()
        const vendorProduct = await VendorProduct.deployed()

        const vendor = await Vendor.deployed()
        
        await vendor.setContracts(vendorAccessControl.address, vendorData.address, vendorProduct.address)
    })
})