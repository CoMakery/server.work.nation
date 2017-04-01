import { Connect, Credentials, SimpleSigner } from 'uport-connect'
import * as $ from 'jquery'

const d = (arg) => console.log(JSON.stringify(arg, null, 4))

const harlan = '0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3'
// const appPrivateKey = '4894506ba6ed1a2d21cb11331620784ad1ff9adf1676dc2720de5435dcf76ac2'
// const alicePrivateKey = '49e8f08170d4a514beff75a30300290f6d79845a06abfeb6080e1b8327bcb172'
// const bobPrivateKey   = '85c4480b9a138dc67b0ed4f062bf4c7206e43b17d43287557771f67fec96639e'
const appName = 'Work.nation'
const contractAddress = '0xce1cce5af3d76e0eb4d49b3d625cbb6fceb744df'
const clientId = '0xa517fa10cba16682664d54a5c8baa0d2604fe402'
// const signer = SimpleSigner(appPrivateKey)
const connect1 = new Connect(appName, { clientId })

const web3 = connect1.getWeb3()

let state = {
  userUportId: '',
  txHash: '',
  sendToAddr: '',
  sendToVal: '',
}

const attest = () => {
  const claimAbi = [{"constant":false,"inputs":[{"name":"_claimId","type":"string"}],"name":"getClaimConfirmers","outputs":[{"name":"confirmers","type":"address[]"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"},{"name":"","type":"uint256"}],"name":"trusted","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_claimId","type":"string"},{"name":"claimant","type":"address"}],"name":"confirm","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"},{"name":"","type":"uint256"}],"name":"claims","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"whoami","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"peeps","type":"address[]"},{"name":"depth","type":"int8"}],"name":"getTrustedClaims","outputs":[{"name":"","type":"address[]"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_claimId","type":"string"}],"name":"claim","outputs":[],"payable":false,"type":"function"}]
  const claimContract = web3.eth.contract(claimAbi)
  const claims = claimContract.at(contractAddress)

  // const claimer = '0x375c21b796facc074939e601c6320147d7344542'
  // const confirmer = '0xca35b7d915458ef540ade6068dfe2f44e8fa733c'
  const claimId = 'QmXr74i6cuBtFVD7idvRVs4dyZt7wy2Sqgp1FziphLTHCK'  // is great at ROR

  d('creating claim...')
  d('Harlan:')

  claims.claim(claimId, (error, txhash) => {
    if (error) {
      console.log(error)
    } else {
      console.log('https://ropsten.io/tx/' + txhash)

      // d('Noah:')
      //
      // connect1.requestCredentials()
      // .then((credentials) => {
      //   console.log(JSON.stringify(credentials, null, 4))
      //   state.userUportId = credentials.address
      //   state.name = credentials.name
      //   $('#userUportId').val(state.userUportId)
      //   $('#name').val(state.name)
      //
      //   claims.confirm(claimId, harlan, (error, txhash) => {
      //     if (error) {
      //       console.log(error)
      //     } else {
      //       console.log('https://ropsten.io/tx/' + txhash)
      //       d('Anyone:')
      //       claims.getClaimConfirmers(claimId, (error, txhash) => {
      //         if (error) {
      //           console.log(error)
      //         } else {
      //           console.log('https://ropsten.io/tx/' + txhash)
      //         }
      //       })
      //     }
      //   })
      //   return
      // })
    }
  })
}

const uportConnect = () => {
  connect1.requestCredentials()
  .then((credentials) => {
    console.log(JSON.stringify(credentials, null, 4))
    state.userUportId = credentials.address
    state.name = credentials.name
    $('#userUportId').val(state.userUportId)
    $('#name').val(state.name)
    attest()
    return
  }).catch(console.error)
}

$(() => {
  $('#connectUportBtn').on('click', uportConnect)
})
