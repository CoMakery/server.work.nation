import { Connect, Credentials, SimpleSigner } from 'uport-connect'
import * as $ from 'jquery'

const d = (arg) => console.log(JSON.stringify(arg, null, 4))

const harlan = '0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3'
const appPrivateKey = '4894506ba6ed1a2d21cb11331620784ad1ff9adf1676dc2720de5435dcf76ac2'
// const alicePrivateKey = '49e8f08170d4a514beff75a30300290f6d79845a06abfeb6080e1b8327bcb172'
// const bobPrivateKey   = '85c4480b9a138dc67b0ed4f062bf4c7206e43b17d43287557771f67fec96639e'
const appName = 'Work.nation'
const clientId = '0xe2fef711a5988fbe84b806d4817197f033dde050'
const signer = SimpleSigner(appPrivateKey)
const connect1 = new Connect(appName, { clientId })

// /////////////////////////////////////////////////////////////

const credentials = new Credentials({
  appName,
  address: harlan,
  signer
  // signer: SimpleSigner(alicePrivateKey)
})

// Requesting information from your users
// To request information from your user you create a Selective Disclosure Request JWT and present it to your user in the web browser.
//   The most basic request to get a users public uport identity details:
credentials.createRequest().then(token => {
  return d({token})  // eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJ0eXBlIjoic2hhcmVSZXEiLCJpc3MiOiIweDU3ZmFiMDg4YmUyZjhiZmQ1ZDRjYmY4NDljMjU2ODY3MmU0ZjNkYjMiLCJpYXQiOjE0OTA0MjYwMjI1MzZ9.oHyhhKmKKss8j40qq3gZ3mjk11cDhg_F6UD90cTLk63SuMwzOHljU9bEL1YyvuPGo67myJ4wXEk7XsrJmn3ACA

//   return credentials.receive(token) // ---> Error: Signature invalid for JWT <---

// }).then(profile => {
//   return d({profile})
})

// Creating an attestation
credentials.attest({
  sub: harlan,
    // exp: <future timestamp>, // If your information is not permanent make sure to add an expires timestamp
  claims: {skill: 'Ruby'}
}).then(attestation => {
  return d({attestation})  // eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJzdWIiOiIweDU3ZmFiMDg4YmUyZjhiZmQ1ZDRjYmY4NDljMjU2ODY3MmU0ZjNkYjMiLCJpc3MiOiIweDU3ZmFiMDg4YmUyZjhiZmQ1ZDRjYmY4NDljMjU2ODY3MmU0ZjNkYjMiLCJpYXQiOjE0OTA0MjYwMjI1NTd9.BVPPlKUbbLW7X5jt3GaBPK7B4fwYBo-qFXrZy-EifpdDtRSGxSuisZdraBrFoX30eRz-b-9RoR_wjaylbmf64w
})

// /////////////////////////////////////////////////////////////

let state = {
  userUportId: '',
  txHash: '',
  sendToAddr: '',
  sendToVal: '',
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

const attest = () => {
  d('Requesting attestation...')

  const connect2 = new Connect(appName, { clientId, signer })

  // const credentials = new Credentials({
  //   appName: 'Test App',
  //   address: '0xdb67cea13ef97b104dc80a72def566da03f5e999',
  //   signer: signer
  // })

  const params = {
    sub: state.userUportId,
    claim: {name: state.name},
    // claim: {skill: 'Ruby'},
    // exp: new Date().getTime() + 2592000000  // expires in 30 days
  }

  d(222, params)

  connect2.attestCredentials(params)
  .then(res => {
    console.log(222, res)
    return
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
