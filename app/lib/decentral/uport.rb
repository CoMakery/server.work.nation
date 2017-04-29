require_relative 'claim'

module Decentral
  class Uport
    LEGACY_REGISTRY_CONTRACT_ABI = JSON.parse %([{"constant":true,"inputs":[{"name":"personaAddress","type":"address"}],"name":"getAttributes","outputs":[{"name":"","type":"bytes"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"version","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"previousPublishedVersion","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"ipfsHash","type":"bytes"}],"name":"setAttributes","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"ipfsAttributeLookup","outputs":[{"name":"","type":"bytes"}],"payable":false,"type":"function"},{"inputs":[{"name":"_previousPublishedVersion","type":"address"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_sender","type":"address"},{"indexed":false,"name":"_timestamp","type":"uint256"}],"name":"AttributesSet","type":"event"}])
    LEGACY_REGISTRY_CONTRACT_ADDRESSES = {
      ropsten: '0xb9C1598e24650437a3055F7f66AC1820c419a679',
    }.freeze
    LEGACY_REGISTRY_CONTRACT_NAME = 'UportRegistry'.freeze

    def self.log(msg)
      # Rails.logger.info JSON.pretty_generate msg
      Rails.logger.info msg
    end

    def self.legacy_profile(uport_address)
      client = Ethereum::HttpClient.new(ENV['ETHEREUM_RPC_URL'])

      contract = Ethereum::Contract.create(
        name: LEGACY_REGISTRY_CONTRACT_NAME,
        abi: LEGACY_REGISTRY_CONTRACT_ABI,
        address: LEGACY_REGISTRY_CONTRACT_ADDRESSES[:ropsten],
        client: client,
      )

      ipfs_key_bytes = contract.call.get_attributes(uport_address.sub(/^0x/, ''))
      ipfs_key_hex = ipfs_key_bytes.unpack('H*')
      ipfs_key_number = ipfs_key_hex.first.to_i(16)
      ipfs_key = Base58.encode ipfs_key_number, Base58::BTC_ALPHABET

      log ipfs_url = "https://ipfs.io/ipfs/#{ipfs_key}"
      response = HTTParty.get(ipfs_url)
      log response.code
      if response.code != 200
        raise Decentral::NotFoundError, "Error fetching #{ipfs_url} -- #{response.body} -- #{response.code}"
      end

      profile = JSON.parse(response.body)
      profile
    end
  end
end
