import { Connect, Credentials, SimpleSigner } from 'uport-connect'
import * as $ from 'jquery'

const web3 = Connect.getWeb3()

const d = (arg) => console.log(JSON.stringify(arg, null, 4))

// const harlan = '0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3'
// const appPrivateKey = '4894506ba6ed1a2d21cb11331620784ad1ff9adf1676dc2720de5435dcf76ac2'
// const alicePrivateKey = '49e8f08170d4a514beff75a30300290f6d79845a06abfeb6080e1b8327bcb172'
// const bobPrivateKey   = '85c4480b9a138dc67b0ed4f062bf4c7206e43b17d43287557771f67fec96639e'
const appName = 'Work.nation'
const clientId = '0xe2fef711a5988fbe84b806d4817197f033dde050'
// const signer = SimpleSigner(appPrivateKey)
const connect1 = new Connect(appName, { clientId })

let state = {
  userUportId: '',
  txHash: '',
  sendToAddr: '',
  sendToVal: '',
}

const attest = () => {
  const claimAbi = [{'constant': true, 'inputs': [], 'name': 'claim', 'outputs': [{'name': '', 'type': 'string'}], 'payable': false, 'type': 'function'}, {'constant': false, 'inputs': [{'name': '_target', 'type': 'address'}, {'name': '_claimId', 'type': 'string'}], 'name': 'attest', 'outputs': [], 'payable': false, 'type': 'function'}, {'anonymous': false, 'inputs': [{'indexed': true, 'name': '_from', 'type': 'address'}, {'indexed': true, 'name': '_target', 'type': 'address'}, {'indexed': false, 'name': '_claimId', 'type': 'string'}], 'name': 'ClaimMade', 'type': 'event'}]
  const claimContract = web3.eth.contract(claimAbi)
  const claim = claimContract.at('0xf9c7ce3e77f7cc56657d99b28b9c70248ae2b6d6')

  const target = '0x375c21b796facc074939e601c6320147d7344542'
  const claimId = '/ipfs/QmXr74i6cuBtFVD7idvRVs4dyZt7wy2Sqgp1FziphLTHCK'

  d('creating attestation...')

  claim.attest('0x375c21b796facc074939e601c6320147d7344542', text, function(error, txhash) {
    if (error) {
      console.log(error)
      return
    }
    $('#uport-status-txhash').text(txhash)
    $('#uport-status-txhash').attr('href', 'https://ropsten.io/tx/' + txhash)
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
