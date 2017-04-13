class UpdateFromEthereumJob
  include Sidekiq::Worker

  def perform
    # client = Ethereum::HttpClient.new('https://ropsten.infura.io/7YRuqHoxzZfJhyGdvVq0')
    #
    # contract = Ethereum::Contract.create(
    #     file: '/Users/harlan/comakery/clients/cisco/contracts.work.nation/Claim.sol',
    #     address: "0x8cb4cb36e7cc72bb84f48daed7cb8071c3f55f8f",
    #     client: client
    # )
    # start = Time.now
    # p count = contract.call.claim_count
    # p contract.call.get_claim(count - 1)
    # finish = Time.now
    # p "#{(finish - start)} seconds"
  end
end

# curl -X POST \
#   -H "Content-Type: application/json" \
#   -H "Infura-Ethereum-Preferred-Client: geth" \
#   --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"0x8cb4cb36e7cc72bb84f48daed7cb8071c3f55f8f","data":"0x5aef24470000000000000000000000000000000000000000000000000000000000000000"},"latest"],"id":1}' \
#   "https://ropsten.infura.io/"
#
#
#
# curl 'https://testnet.etherscan.io/api?module=logs&action=getLogs&fromBlock=721852&toBlock=latest&address=0x507ed8305f7b4a0f055f9ed67b918cd5eba43736&topic0=0x3dd140993c0a7fb6bbb487c9a1d824fd18aa1e5d18e5db7eacc5ab069589e6ff&apikey=71AJB6FAV4HC6K3N81MRTDDUT9FDWEB787'
#
# curl 'https://testnet.etherscan.io/api?module=logs&action=getLogs&fromBlock=721852&toBlock=latest&address=0xbc9ea89a3f40963766be18199d71643d8d567062&topic0=0x3dd140993c0a7fb6bbb487c9a1d824fd18aa1e5d18e5db7eacc5ab069589e6ff&apikey=71AJB6FAV4HC6K3N81MRTDDUT9FDWEB787'
#
# curl 'https://testnet.etherscan.io/api?module=logs&action=getLogs&fromBlock=721852&toBlock=latest&address=0xbC9ea89A3f40963766be18199d71643D8d567062&topic0=0x3dd140993c0a7fb6bbb487c9a1d824fd18aa1e5d18e5db7eacc5ab069589e6ff&apikey=71AJB6FAV4HC6K3N81MRTDDUT9FDWEB787'
#
# # simple token example:
# curl 'https://testnet.etherscan.io/api?module=logs&action=getLogs&fromBlock=721852&toBlock=latest&address=0x21662c422FE3eF4a564eA7AD0Ee3d2A886e5AC43&topic0=0x58becdf9a931dd5ffd26ec2dde1ceab1683ffc0744ebd71f33267bc4406cc847&apikey=71AJB6FAV4HC6K3N81MRTDDUT9FDWEB787'
