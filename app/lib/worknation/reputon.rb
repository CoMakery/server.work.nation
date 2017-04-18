module Worknation
  class Reputon
    def self.get_latest_reputons(known_claim_count)
      errors = []
      client = Ethereum::HttpClient.new('https://ropsten.infura.io/7YRuqHoxzZfJhyGdvVq0')

      contract = Ethereum::Contract.create(
          file: '/Users/harlan/comakery/clients/cisco/contracts.work.nation/Claim.sol',
          address: '0x8cb4cb36e7cc72bb84f48daed7cb8071c3f55f8f',
          client: client
      )

      claim_count = contract.call.claim_count

      reputons = (known_claim_count + 1...claim_count).map do |claim_index|
        puts
        puts "Claim ##{claim_index}".purple
        ipfs_key = contract.call.get_claim(claim_index)
        signer = contract.call.get_signer(ipfs_key)

        p ipfs_url = "https://ipfs.io/ipfs/#{ipfs_key}"
        response = HTTParty.get(ipfs_url)
        # puts response.body, response.code #, response.message, response.headers.inspect
        p response.code
        if response.code != 200
          # raise WorkNation::ReputonNotFound.new(), "Error fetching #{ipfs_url.inspect}: #{response.code.inspect}\n#{response.body}"
          error "Error fetching #{ipfs_url}", response.body, response.code
          next
        end

        reputons_envelope = JSON.parse(response.body)
        ap reputons_envelope
        application = reputons_envelope['application']
        if application != 'skills'
          errors << ReputonInvalid.new("Expected application 'skills' but was: #{reputon['application']}.\nReputons:\n#{JSON.pretty_unparse(reputons_envelope)}")
        end

        reputons_data=reputons_envelope['reputons']
        reputons_data.each do |reputon_data|
          begin
            reputon = Reputon.new(reputon_data, signer, ipfs_key)
            reputon.save!
          rescue ReputonError => error
            errors << error
          end
        end
      end

      raise ReputonError.new(errors.map(&:message)) if errors.present?
      # reputons.flatten
    end

    def initialize(data, signer, ipfs_key)
      @data = data
      @signer = signer
      @ipfs_key = ipfs_key
    end

    def save!
      if address(@data['rater']) != address(@signer)
        raise ReputonSignatureInvalid.new(
            "Reputon rater: #{@data['rater'].inspect} should match transaction signer: #{@signer.inspect}.\nFull reputon:\n#{JSON.pretty_unparse(@data)}"
        )
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
      if skill.blank?
        user.skills.create!(
            name: @data['assertion'],
            ipfs_reputon_key: @ipfs_key
        )
      end
    end

    def save_confirmation!
      # TODO: reject conf if normal rating not 0.5

      confirmer = User.find_or_create_by(uport_address: @data['rater'])
      skill = Skill.find_by(ipfs_reputon_key: @data['rated'])
      if skill.blank?
        raise ReputonInvalid.new("No skill found for [#{@data['rated']}].\nFull reputon:\n#{JSON.pretty_unparse(@data)}")
      end
      if address(confirmer.uport_address) == address(skill.user.uport_address)
        raise ReputonInvalid.new("Attempting to self confirm, rejected.\nFull reputon:\n#{JSON.pretty_unparse(@data)}")
      end
      confirmation = Confirmation.find_by(ipfs_reputon_key: @ipfs_key)
      if confirmation.blank?
        confirmer.confirmations.create!(
            user: confirmer,
            skill: skill,
            claimant: skill.user,
            rating: @data['rating'],
            ipfs_reputon_key: @ipfs_key
        )
      end
    end

    def address(candidate)
      candidate&.sub(/^0x/, '')
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

  # def error(*args)
  #   args.each do |arg|
  #     puts arg.to_s.red
  #   end
  # end

end
