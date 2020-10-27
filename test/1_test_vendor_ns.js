const VendorNS = artifacts.require('VendorNS')

contract('VendorNS test', async accounts => {
    it('should register a vendor', async () => {
        this.vendorNS = await VendorNS.deployed()
    
        this.vendorTitle = 'Test Vendor 1'
        this.vendorName = 'testvendor1'
        this.vendorDescription = 'test vendor description'

        this.bytesVendorName = web3.utils.asciiToHex(this.vendorName)

        const res = await this.vendorNS.registerVendor(this.bytesVendorName, this.vendorTitle, this.vendorDescription)
        this.vendorAddress = res.logs[0].args.vendorAddress

        assert.equal(
            res.logs[0].event,
            'VendorRegistered',
            'No VendorRegistered event emitted'
        )
    })

    it('should resolve vendor name from vendorNames', async () => {
        assert.equal(
            await this.vendorNS.vendorNames.call(this.bytesVendorName),
            this.vendorAddress,
            "Failed resolving vendor name to contract address"
        )
    })
})