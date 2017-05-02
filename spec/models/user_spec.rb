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
    let!(:rubyist_3rd_degree) { create :user, name: 'Rubyist' }
    let!(:erlanger_2nd_degree) { create :user, name: 'Erlanger' }
    let!(:javascripter_3rd_degree) { create :user, name: 'Javascripter' }
    let!(:root_user) { create :user, name: 'Unskilled confirmer' }

    # Root User -> Javascripter -> Erlanger -> Rubyist

    let(:ruby_skill_claim) do
      create :skill_claim,
        name: 'Ruby',
        project_count: 1,
        user: rubyist_3rd_degree
    end
    let(:erlang_skill_claim) do
      create :skill_claim,
        name: 'Erlang',
        project_count: 1,
        user: erlanger_2nd_degree
    end
    let(:javascript_skill_claim) do
      create :skill_claim,
        name: 'Javascript',
        project_count: 1,
        user: javascripter_3rd_degree
    end

    before do
      create :confirmation,
        skill_claim_id: javascript_skill_claim.id,
        claimant: javascripter_3rd_degree,
        rating: 1,
        confirmer: root_user

      create :confirmation,
        skill_claim_id: erlang_skill_claim.id,
        claimant: erlanger_2nd_degree,
        rating: 1,
        confirmer: javascripter_3rd_degree

      create :confirmation,
        skill_claim_id: ruby_skill_claim.id,
        claimant: rubyist_3rd_degree,
        rating: 1,
        confirmer: erlanger_2nd_degree
    end

    it 'returns nothing with no skills found' do
      expect(root_user.search_trust_graph('Non-existent skill', depth: 3)).to eq([])
    end

    it 'finds a 1st degree skill' do
      expect(root_user.search_trust_graph('Erlang', depth: 3).pluck(:name)).to eq([erlanger_2nd_degree].map(&:name))
    end

    it 'find a 2nd degree skill' do
      expect(root_user.search_trust_graph('Ruby', depth: 3).pluck(:name)).to eq([rubyist_3rd_degree].map(&:name))
    end

    it 'find a 3rd degree skill' do
      expect(root_user.search_trust_graph('Javascript', depth: 3).pluck(:name)).to eq([javascripter_3rd_degree].map(&:name))
    end

    it 'does not find a 3rd degree skill if the depth is set to 2' do
      expect(root_user.search_trust_graph('Ruby', depth: 2)).to eq([])
    end

    describe 'returns multiple users with the skill' do
      before do
        ruby_skill_claim = create :skill_claim,
          name: 'Ruby',
          project_count: 1,
          user: javascripter_3rd_degree

        javascripter_3rd_degree.update name: 'Javascripter and Rubyist'

        create :confirmation,
          skill_claim_id: ruby_skill_claim.id,
          claimant: javascripter_3rd_degree,
          rating: 1,
          confirmer: root_user
      end

      specify do
        expect(root_user.search_trust_graph('Ruby').pluck(:name)).to eq([rubyist_3rd_degree, javascripter_3rd_degree].map(&:name))
      end
    end

    describe 'with multiple confirmations' do
      before do
        create :confirmation,
          skill_claim_id: ruby_skill_claim.id,
          claimant: rubyist_3rd_degree,
          rating: 1,
          confirmer: javascripter_3rd_degree

        create :confirmation,
          skill_claim_id: ruby_skill_claim.id,
          claimant: rubyist_3rd_degree,
          rating: 1,
          confirmer: root_user
      end

      it 'returns only one result' do
        expect(root_user.search_trust_graph('Ruby', depth: 3).pluck(:name)).to eq([rubyist_3rd_degree].map(&:name))
      end
    end
  end

  describe 'with circular confirmations' do
    let!(:rubyist_confirming_erlanger) { create :user, name: 'Rubyist' }
    let!(:erlanger_confirming_rubyist) { create :user, name: 'Erlanger' }

    # rubyist -> erlanger -> rubyist (loop)

    let(:ruby_skill_claim) do
      create :skill_claim,
        name: 'Ruby',
        project_count: 1,
        user: rubyist_confirming_erlanger
    end
    let(:erlang_skill_claim) do
      create :skill_claim,
        name: 'Erlang',
        project_count: 1,
        user: erlanger_confirming_rubyist
    end

    before do
      create :confirmation,
        skill_claim_id: ruby_skill_claim.id,
        claimant: rubyist_confirming_erlanger,
        rating: 1,
        confirmer: erlanger_confirming_rubyist

      create :confirmation,
        skill_claim_id: erlang_skill_claim.id,
        claimant: erlanger_confirming_rubyist,
        rating: 1,
        confirmer: rubyist_confirming_erlanger
    end

    it 'returns correct find only once' do
      expect(erlanger_confirming_rubyist.search_trust_graph('Ruby', depth: 6).pluck(:name))
        .to eq([rubyist_confirming_erlanger].map(&:name))
    end

    it 'excludes self in the search' do
      expect(rubyist_confirming_erlanger.search_trust_graph('Ruby', depth: 6).pluck(:name))
        .to eq([])
    end
  end
end
