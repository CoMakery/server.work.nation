module Decentral
  class Reputon
    CONTRACT_ABI = JSON.parse %([{"constant":false,"inputs":[{"name":"claim","type":"string"}],"name":"getSigner","outputs":[{"name":"_signer","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_claim","type":"string"}],"name":"put","outputs":[{"name":"_success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"index","type":"uint256"}],"name":"getClaim","outputs":[{"name":"_claim","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"claimCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"claims","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"payable":false,"type":"fallback"}])
    REDIS = if ENV['REDISTOGO_URL']
      Redis.new(url: URI.parse(ENV['REDISTOGO_URL']))
    else
      Redis.new
    end

    def self.get_latest_reputons
      client = Ethereum::HttpClient.new(ENV['ETHEREUM_RPC_URL'])

      contract = Ethereum::Contract.create(
        name: 'Claim',
        abi: CONTRACT_ABI,
        address: '0x8cb4cb36e7cc72bb84f48daed7cb8071c3f55f8f',
        client: client,
      )

      claim_count = contract.call.claim_count
      known_claim_count = Integer(REDIS.get('known_claim_count') || -1)
      log "Max known claim in Ethereum: #{claim_count - 1}".green
      log "Max known claim in local db: #{known_claim_count}".green

      (known_claim_count + 1...claim_count).each do |claim_index|
        get_claim(claim_index, contract)
      end
    end

    def self.get_claim(claim_index, contract)
      log "\n"
      log "Claim ##{claim_index}".purple
      ipfs_key = contract.call.get_claim(claim_index)
      signer = contract.call.get_signer(ipfs_key)

      log ipfs_url = "https://ipfs.io/ipfs/#{ipfs_key}"
      response = HTTParty.get(ipfs_url)
      # puts response.body, response.code #, response.message, response.headers.inspect
      log response.code
      if response.code != 200
        # raise WorkNation::ReputonNotFound.new(), "Error fetching #{ipfs_url.inspect}: #{response.code.inspect}\n#{response.body}"
        raise ReputonNotFound, "Error fetching #{ipfs_url} -- #{response.body} -- #{response.code}"
      end

      reputons_envelope = JSON.parse(response.body)
      log reputons_envelope
      application = reputons_envelope['application']
      if application != 'skills'
        # raise ReputonInvalid.new("Expected application 'skills' but was: #{reputons_envelope['application']}"), Reputons: reputons_envelope
        raise ReputonInvalid, "Expected application 'skills' but was: #{reputons_envelope['application']}.\nReputons:\n#{JSON.pretty_unparse(reputons_envelope)}"
      end

      reputons_data = reputons_envelope['reputons']
      reputons_data.each do |reputon_data|
        begin
          reputon = Reputon.new(reputon_data, signer, ipfs_key)
          reputon.save!
        rescue ReputonError => e
          handle_error e
        end
      end
      log "SETTING known_claim_count: #{claim_index}".green
      REDIS.set('known_claim_count', claim_index)
    rescue ReputonError => e
      log "SETTING known_claim_count: #{claim_index}".green
      REDIS.set('known_claim_count', claim_index)
      handle_error e
    end

    def self.log(msg)
      Rails.logger.info msg
    end

    def self.handle_error(error, params = {})
      Rails.logger.error error.message.to_s.red
      Airbrake.notify error, params
    end

    def initialize(data, signer, ipfs_key)
      @data = data
      @signer = signer
      @ipfs_key = ipfs_key
    end

    def save!
      if address(@data['rater']) != address(@signer)
        raise ReputonSignatureInvalid, "Reputon rater: #{@data['rater'].inspect} should match transaction signer: #{@signer.inspect}.\nFull reputon:\n#{JSON.pretty_unparse(@data)}"
      end
      if @data['rater'] == @data['rated']
        save_skill!
      else
        save_confirmation!
      end
    end

    def save_skill!
      user = User.find_or_create_by(uport_address: @data['rater'])
      skill = user.skills.find_by(ipfs_reputon_key: @ipfs_key)
      return if skill.present?
      log user.skills.create!(
        name: @data['assertion'],
        ipfs_reputon_key: @ipfs_key,
      )
    end

    def save_confirmation!
      # TODO: reject conf if normal rating not 0.5

      confirmer = User.find_or_create_by(uport_address: @data['rater'])
      skill = Skill.find_by(ipfs_reputon_key: @data['rated'])
      if skill.blank?
        raise ReputonInvalid, "No skill found for [#{@data['rated']}].\nFull reputon:\n#{JSON.pretty_unparse(@data)}"
      end
      if address(confirmer.uport_address) == address(skill.user.uport_address)
        raise ReputonInvalid, "Attempting to self confirm, rejected.\nFull reputon:\n#{JSON.pretty_unparse(@data)}"
      end
      confirmation = Confirmation.find_by(ipfs_reputon_key: @ipfs_key)
      return if confirmation.present?
      log confirmer.confirmations.create!(
        user: confirmer,
        skill: skill,
        claimant: skill.user,
        rating: @data['rating'],
        ipfs_reputon_key: @ipfs_key,
      )
    end

    def address(candidate)
      candidate&.sub(/^0x/, '')
    end

    def log(msg)
      self.class.log(msg)
    end
  end

  class ReputonError < StandardError
  end

  class ReputonNotFound < ReputonError
  end

  class ReputonInvalid < ReputonError
  end

  class ReputonSignatureInvalid < ReputonError
  end
end
