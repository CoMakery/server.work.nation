let keythereum = require('keythereum')

const d = console.log

const params = keythereum.constants
d({params})
keythereum.create(params, (dk) => {
  d({dk})
  d(dk.privateKey.toString('hex'))
})

