require 'rails_helper'

RSpec.describe Confirmation, type: :model do
  describe 'validations' do
    let(:confirmation) { Confirmation.new.tap(&:valid?) }

    specify { expect(confirmation.errors[:skill_claim_id]).to eq(["can't be blank"]) }
    specify { expect(confirmation.errors[:confirmer_id]).to eq(["can't be blank"]) }
    specify { expect(confirmation.errors[:skill_claimant_id]).to eq(["can't be blank", "can't self confirm"]) }
    specify { expect(confirmation.errors[:rating]).to eq(["can't be blank"])  }
    specify { expect(confirmation.errors[:ipfs_reputon_key]).to eq(["can't be blank"]) }
  end

  describe 'no self confirmation' do
    let(:confirmation) { Confirmation.new(confirmer_id: 1, skill_claimant_id: 1).tap(&:valid?) }

    specify { expect(confirmation).not_to be_valid }
    specify { expect(confirmation.errors[:skill_claimant_id]).to eq(["can't self confirm"]) }
  end
end
