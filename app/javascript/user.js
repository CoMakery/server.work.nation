import { Connect, Credentials, SimpleSigner } from 'uport-connect'
import * as $ from 'jquery'

const d = (arg) => console.log(JSON.stringify(arg, null, 4))

const appName = 'Work.nation'
const clientId = '0xa517fa10cba16682664d54a5c8baa0d2604fe402'
const connect = new Connect(appName, { clientId })

class UportUser {
  static login(event) {
    event.preventDefault()
    event.stopPropagation()
    debugger

    event.target.parentElement.submit()

    connect.requestCredentials()
    .then((credentials) => {
      d(credentials)
      const form = $(event.target.parentElement)
      form.append('<input type="hidden" name="uport_user_id" value="' + credentials.address + '">')
      // credentials.name
      form.submit()
      return
    }).catch(console.error)
  }
}

$(() => {
  $('#uportLogin').on('click', UportUser.login)
})
