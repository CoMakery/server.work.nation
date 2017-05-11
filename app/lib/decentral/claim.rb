require_relative 'log'

module Decentral
  class Claim
    extend Decentral::Log

    def self.get_latest_claims
      TrustGraph::Claim.get_latest_claims do |claim|
        parse(claim)
      end
    end

    def self.parse(claim)
      if claim.data.keys.sort == %w[application reputons]
        save_reputon(claim.data, claim.signer, claim.ipfs_key)
      elsif data['type'] == 'project'
        save_project(claim.data)
      elsif claim.data['type'] == 'permanode'
        log_info 'permanode:', claim.data
      else
        raise InvalidFormatError, "Could not determine claim type; claim.content: [[ #{claim.content[0...1000]} ]]"
      end
    rescue DecentralError => e
      Decentral.handle_error e
    end

    def self.save_project(params)
      # TODO
      # - fetch permanode
      # - compare permanode creator to permanode signer, raise if not same
      # - compare permanode creator to project profile signer, raise if not same
      # - store creator on Project#permanode_creator_uport_address
      # - compare permanode creator to signer, raise if not same

      skill_list = params['skills']
      params.deep_transform_keys!(&:underscore)
      project = Project.new params.without('type', 'timestamp', 'skills')
      project.skill_list = skill_list
      project.save!
    rescue => e
      raise InvalidFormatError, "Project saving failed from params: #{params.inspect} ( original params: #{orig_params.inspect} )
        \nFrom: #{e.inspect}"
      # {
      #     address: "",
      #     contact: "",
      #     imageUrl: "",
      #     permanodeId: "/ipfs/QmY6GV3ME9DYEtYYHTwnBB33VFXsLGF2K4JuJBam8eLXyf",
      #     skills: "",
      #     title: "",
      #     type: "project"
      # }
    end

    def self.save_reputon(reputons_envelope, signer, ipfs_key)
      log reputons_envelope
      application = reputons_envelope['application']
      if application != 'skills'
        raise ReputonFormatError, "Expected application 'skills' but was: #{reputons_envelope['application']}.\nReputons:\n#{JSON.pretty_unparse(reputons_envelope)}"
      end

      reputons_data = reputons_envelope['reputons']
      reputons_data.each do |reputon_data|
        begin
          if address(reputon_data['rater']) != address(signer)
            raise ReputonSignatureError, "Reputon rater: #{reputon_data['rater'].inspect} should match transaction signer: #{signer.inspect}.\nFull reputon:\n#{JSON.pretty_unparse(reputon_data)}"
          end

          if reputon_data['rater'] == reputon_data['rated']
            save_skill! reputon_data, ipfs_key
          else
            save_confirmation! reputon_data, ipfs_key
          end
        rescue DecentralError => error
          Decentral.handle_error error
        end
      end
    end

    def self.save_skill!(reputon_data, ipfs_key)
      user = User.find_or_create_by(uport_address: reputon_data['rater'])
      skill_claim = user.skill_claims.find_by(ipfs_reputon_key: ipfs_key)
      return if skill_claim.present?
      project = Project.find_or_create_by!(permanode_id: reputon_data['project']) # TODO: validate valid permanode
      log user.skill_claims.create!(
        name: reputon_data['assertion'],
        ipfs_reputon_key: ipfs_key,
        project_permanode_id: project.permanode_id,
      )
    end

    def self.save_confirmation!(reputon_data, ipfs_key)
      # TODO: reject conf if normal rating not 0.5

      confirmer = User.find_or_create_by(uport_address: reputon_data['rater'])
      skill_claim = SkillClaim.find_by(ipfs_reputon_key: reputon_data['rated'])
      if skill_claim.blank?
        raise ReputonFormatError, "No skill_claim found for [#{reputon_data['rated']}].\nFull reputon:\n#{JSON.pretty_unparse(reputon_data)}"
      end
      if address(confirmer.uport_address) == address(skill_claim.user.uport_address)
        raise ReputonFormatError, "Attempting to self confirm, rejected.\nFull reputon:\n#{JSON.pretty_unparse(reputon_data)}"
      end
      confirmation = Confirmation.find_by(ipfs_reputon_key: ipfs_key)
      return if confirmation.present?
      log confirmer.confirmations.create!(
        confirmer: confirmer,
        skill_claim: skill_claim,
        claimant: skill_claim.user,
        rating: reputon_data['rating'],
        ipfs_reputon_key: ipfs_key,
      )
    end

    def self.address(candidate)
      candidate&.sub(/^0x/, '')
    end
  end
end
