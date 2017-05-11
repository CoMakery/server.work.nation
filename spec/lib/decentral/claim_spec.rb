require('rails_helper')

# require_relative '../../../app/lib/decentral'

describe(Decentral::Claim) do
  describe('.parse') do
    let(:skill_claimant) { create :user }
    let(:confirmer) { create :user }
    let(:project) { create :project }
    let(:skill_claim_reputon) do
      {
        "application": 'skills',
        "reputons": [
          {
            "assertion": 'sh',
            "generated": 1493341433,
            "project": project.permanode_id,
            "rater": skill_claimant.uport_address,
            "rated": skill_claimant.uport_address,
            "rating": 1,
            "sample-size": 1,
          },
        ],
      }.to_json
    end

    context 'user self-claims a skill' do
      let(:claim) do
        TrustGraph::Claim.new(
          content: skill_claim_reputon,
          ipfs_key: 'QmXXX',
          signer: skill_claimant.uport_address,
        )
      end

      specify do
        expect do
          described_class.parse(claim)
        end.to change { SkillClaim.count }.by(1)
      end
    end

    context 'confirming an existing skill claim' do
      let(:skill_claim) { create :skill_claim, user: skill_claimant }
      let(:confirmation_reputon) do
        {
          "application": 'skills',
          "reputons": [
            {
              "rater": confirmer.uport_address,
              "assertion": 'confirm',
              "rated": skill_claim.ipfs_reputon_key,
              "rating": 1,
              "normal-rating": 0.5,
              "sample-size": 1,
              "generated": 1492205002,
            },
          ],
        }.to_json
      end
      let(:claim) do
        TrustGraph::Claim.new(
          content: confirmation_reputon,
          ipfs_key: skill_claim.ipfs_reputon_key,
          signer: confirmer.uport_address,
        )
      end

      specify do
        expect do
          described_class.parse(claim)
        end.to change { Confirmation.count }.by(1)
      end
    end

    describe 'invalid data' do
      let(:invalid_claim) do
        TrustGraph::Claim.new(
          content: 'content',
          ipfs_key: 'QmXXX',
          signer: '0x111',
        )
      end

      specify do
        expect do
          described_class.parse(invalid_claim)
        end.to(raise_error(/Expected JSON/))
      end
    end
  end
end
