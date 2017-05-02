require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  specify do
    expect(user.as_json.keys).to match_array(%i[
                                               name
                                               uportAddress
                                               skill_claims
                                               avatar_image_ipfs_key
                                               banner_image_ipfs_key
                                             ])
  end

  describe '#search_trust_graph' do
    let!(:skilled_user) { create :user, name: 'Rubyist' }
    let!(:confirmer_1st_degree) { create :user, name: 'Erlanger' }
    let!(:confirmer_2nd_degree) { create :user, name: 'Javascripter' }
    let!(:confirmer_3rd_degree) { create :user, name: 'Unskilled confirmer' }

    let(:skill_claim) do
      create :skill_claim,
        name: 'Ruby',
        project_count: 1,
        user: skilled_user
    end
    let(:skill_claim2) do
      create :skill_claim,
        name: 'Erlang',
        project_count: 1,
        user: confirmer_1st_degree
    end
    let(:skill_claim3) do
      create :skill_claim,
        name: 'Javascript',
        project_count: 1,
        user: confirmer_2nd_degree
    end

    before do
      create :confirmation,
        skill_claim_id: skill_claim.id,
        claimant: skilled_user,
        rating: 1,
        confirmer: confirmer_1st_degree

      create :confirmation,
        skill_claim_id: skill_claim2.id,
        claimant: confirmer_1st_degree,
        rating: 1,
        confirmer: confirmer_2nd_degree

      create :confirmation,
        skill_claim_id: skill_claim3.id,
        claimant: confirmer_2nd_degree,
        rating: 1,
        confirmer: confirmer_3rd_degree
    end

    it 'returns nothing with no skills found' do
      expect(confirmer_3rd_degree.search_trust_graph('Non-existent skill')).to eq([])
    end

    it 'finds a 1st degree skill' do
      expect(confirmer_3rd_degree.search_trust_graph('Erlang').pluck(:name)).to eq([confirmer_1st_degree].map(&:name))
    end

    it 'find a 2nd degree skill' do
      expect(confirmer_3rd_degree.search_trust_graph('Ruby').pluck(:name)).to eq([skilled_user].map(&:name))
    end

    it 'find a 3rd degree skill' do
      expect(confirmer_3rd_degree.search_trust_graph('Javascript').pluck(:name)).to eq([confirmer_2nd_degree].map(&:name))
    end

    describe 'returns multiple users with the skill' do
      before do
        skill_claim = create :skill_claim,
          name: 'Ruby',
          project_count: 1,
          user: confirmer_2nd_degree

        confirmer_2nd_degree.update name: 'Javascripter and Rubyist'

        create :confirmation,
          skill_claim_id: skill_claim.id,
          claimant: confirmer_2nd_degree,
          rating: 1,
          confirmer: confirmer_3rd_degree
      end

      specify do
        expect(confirmer_3rd_degree.search_trust_graph('Ruby').pluck(:name)).to eq([skilled_user, confirmer_2nd_degree].map(&:name))
      end
    end

    describe 'with multiple confirmations' do
      before do
        create :confirmation,
          skill_claim_id: skill_claim.id,
          claimant: skilled_user,
          rating: 1,
          confirmer: confirmer_2nd_degree

        create :confirmation,
          skill_claim_id: skill_claim.id,
          claimant: skilled_user,
          rating: 1,
          confirmer: confirmer_3rd_degree
      end

      it 'returns only one result' do
        expect(confirmer_3rd_degree.search_trust_graph('Ruby').pluck(:name)).to eq([skilled_user].map(&:name))
      end
    end

    describe 'with circular confirmations' do
      before do
        create :confirmation,
          skill_claim_id: skill_claim2.id,
          claimant: confirmer_1st_degree,
          rating: 1,
          confirmer: skilled_user
      end

      it 'returns correct find only once' do
        expect(confirmer_1st_degree.search_trust_graph('Ruby').pluck(:name)).to eq([skilled_user].map(&:name))
      end

      it 'excludes self in the search' do
        expect(skilled_user.search_trust_graph('Ruby').pluck(:name)).to eq([])
      end
    end
  end
end
