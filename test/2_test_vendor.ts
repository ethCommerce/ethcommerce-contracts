const VendorNS = artifacts.require('VendorNS')
const Vendor = artifacts.require('Vendor')

let vendorAddress = ''    
const vendorName = 'testvendor2'

contract('Vendor Test', async accounts => {
    it('should register a vendor', async () => {
        const vendorNS = await VendorNS.deployed()
    
        const vendorTitle = 'Test Vendor 2'

        const vendorDescription = 'test vendor description'

        const bytesVendorName = web3.utils.asciiToHex(vendorName)
        
        const res = await vendorNS.registerVendor(bytesVendorName, vendorTitle, vendorDescription)

        vendorAddress = res.logs[0].args.vendorAddress
    })

    it('should create product', async () => {
        const vendor = await Vendor.at(vendorAddress)

        const title = 'product1'
        const description = 'productdesc'
        const price = 1

        console.log(await vendor.createProduct(title, description, price))
    })
})