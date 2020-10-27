const truffleAssert = require('truffle-assertions');

const VendorNS = artifacts.require('VendorNS')

contract('VendorNS test', async accounts => {
    it('should register a vendor', async () => {
        this.vendorNS = await VendorNS.deployed()
    
        const vendorName = 'testvendor1'
        const bytesVendorName = web3.utils.fromAscii(vendorName)
        const res = await this.vendorNS.registerVendor(bytesVendorName)

        truffleAssert.eventEmitted(res, 'VendorRegistered', ev => {
            console.log(ev)
            console.log(web3.utils.hexToAscii(ev.vendorName))
            return web3.utils.hexToAscii(ev.vendorName) === vendorName
        })     
    })
})