require('@nomiclabs/hardhat-waffle')

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: 'https://eth-rinkeby.alchemyapi.io/v2/i25UT5pGpbVjymVHNieaGgZNEs35IQ_f',
      accounts: ['94f9a85d0f2c8e07e54f693377443b64616dbe747eb45e6ce50acc9c36d14c1a'],
    },
  },
}
