const VendorNS = artifacts.require('VendorNS')

const vendorName = 'testvendor1'
const bytesVendorName = web3.utils.asciiToHex(vendorName)

let vendorAddress = ''

contract('VendorNS test', async accounts => {
    it('should register a vendor', async () => {
        const vendorNS = await VendorNS.deployed()
        const vendorTitle = 'Test Vendor 1'
        const vendorDescription = 'test vendor description'

        const res = await vendorNS.registerVendor(bytesVendorName, vendorTitle, vendorDescription)
        console.log(res)
        vendorAddress = res.logs[0].args.vendorAddress

        assert.equal(
            res.logs[0].event,
            'VendorRegistered',
            'No VendorRegistered event emitted'
        )
    })

    it('should resolve vendor name from vendorNames', async () => {
        const vendorNS = await VendorNS.deployed()

        console.log(await vendorNS.vendorNames(bytesVendorName))
        assert.equal(
            await vendorNS.vendorNames.call(bytesVendorName),
            vendorAddress,
            "Failed resolving vendor name to contract address"
        )
    })
})