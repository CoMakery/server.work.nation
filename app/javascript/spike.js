import { Connect, Credentials, SimpleSigner } from 'uport-connect'
import * as $ from 'jquery'

const d = console.log

const appName = 'Work.nation'
const appPrivateKey = 'c7e02bbeca85822d515d37f8ad049a62b8d853d366268c624c20846f1c33605c'
const signer = SimpleSigner(appPrivateKey)
const connect1 = new Connect(appName)

// const web3 = connect.getWeb3()

let state = {
  userUportId: "",
  txHash: "",
  sendToAddr: "",
  sendToVal: ""};

const render = function () {
  $('#userUportId').innerHTML = state.userUportId
  $('#name').innerHTML = state.name
}

const uportConnect = () => {
  connect1.requestCredentials()
  .then((credentials) => {
    console.log(JSON.stringify(credentials, null, 4))
    state.userUportId = credentials.address
    state.name = credentials.name
    render()
    attest()
  }, console.err)
}

const attest = () => {

  const connect2 = new Connect(appName, {
    clientId: appPrivateKey,
    signer: signer
  })

  // const credentials = new Credentials({
  //   appName: 'Test App',
  //   address: '0xdb67cea13ef97b104dc80a72def566da03f5e999',
  //   signer: signer
  // })
  
  const params = {
    sub: state.userUportId,
    claim: {skill: 'Ruby'},
    // exp: new Date().getTime() + 2592000000  // expires in 30 days
  }

  d(222, params)

  connect2.attestCredentials(params)
  .then(res => {
    console.log(222, res)
  }).catch(err => {
    console.error(333, err)
  })

  // credentials.attest(params, (attestation) => {
  //   d(attestation)
  //   connect.showRequest(attestation) 
  // })

  // if (uport.pushToken) {
  //   window.alert('Your credentials were sent directly to your phone')
  // }
}

$(() => {
  $('#connectUportBtn').on('click', uportConnect)
})

