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
      specify do
        expect do
          described_class.parse(skill_claim_reputon, 'QmXXX', skill_claimant.uport_address)
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

      specify do
        expect do
          described_class.parse(confirmation_reputon, skill_claim.ipfs_reputon_key, confirmer.uport_address)
        end.to change { Confirmation.count }.by(1)
      end
    end

    specify 'invalid data' do
      expect do
        described_class.parse('content', 'QmXXX', '0x111')
      end.to(raise_error(Decentral::InvalidFormatError, /Expected JSON/))
    end
  end
end
