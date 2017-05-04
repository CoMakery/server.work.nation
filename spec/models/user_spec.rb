require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#as_json' do
    let(:user) { create :user }

    specify do
      expect(user.as_json(skills: true).keys).to match_array(%i[
                                                               name
                                                               uportAddress
                                                               skills
                                                               avatarImageIpfsKey
                                                               bannerImageIpfsKey
                                                               projects
                                                             ])
    end

    describe 'with one claim for a skill' do
      let!(:ruby_skill_claim_1) do
        create :skill_claim,
          name: 'Ruby',
          user: user
      end

      specify do
        expect(user.as_json(skills: true)).to match(name: user.name,
                                                    uportAddress: user.uport_address,
                                                    avatarImageIpfsKey: user.avatar_image_ipfs_key,
                                                    bannerImageIpfsKey: user.banner_image_ipfs_key,
                                                    projects: [ruby_skill_claim_1.project.name],
                                                    skills: [{ name: 'Ruby',
                                                               projectCount: 1,
                                                               confirmationsCount: 0,
                                                               ipfsReputonKeys: [/QmREPUTON[\w]+/],
                                                               confirmations: [] }])
      end
    end

    describe 'with 2 claims for the same skill no confirmations' do
      let!(:ruby_skill_claim_1) do
        create :skill_claim,
          name: 'Ruby',
          user: user
      end

      let!(:ruby_skill_claim_2) do
        create :skill_claim,
          name: 'Ruby',
          user: user
      end

      specify do
        expect(user.as_json(skills: true)).to match(name: user.name,
                                                    uportAddress: user.uport_address,
                                                    avatarImageIpfsKey: user.avatar_image_ipfs_key,
                                                    bannerImageIpfsKey: user.banner_image_ipfs_key,
                                                    projects: [ruby_skill_claim_1.project.name,
                                                               ruby_skill_claim_2.project.name],
                                                    skills: [{ name: 'Ruby',
                                                               projectCount: 2,
                                                               confirmationsCount: 0,
                                                               ipfsReputonKeys: [/QmREPUTON[\w]+/,
                                                                                 /QmREPUTON[\w]+/],
                                                               confirmations: [] }])
      end
    end

    describe 'with 2 claims for the same skill confirmations for both skill claims' do
      let(:rubyist) { create :user }
      let!(:confirmer1) { create :user }
      let!(:confirmer2) { create :user }
      let!(:confirmer3) { create :user }

      let!(:ruby_skill_claim_1) do
        create :skill_claim,
          name: 'Ruby',
          user: user
      end

      let!(:ruby_skill_claim_2) do
        create :skill_claim,
          name: 'Ruby',
          user: user
      end

      before do
        create :confirmation,
          skill_claim_id: ruby_skill_claim_1.id,
          claimant: rubyist,
          rating: 1,
          confirmer: confirmer1

        create :confirmation,
          skill_claim_id: ruby_skill_claim_1.id,
          claimant: rubyist,
          rating: 1,
          confirmer: confirmer2

        create :confirmation,
          skill_claim_id: ruby_skill_claim_2.id,
          claimant: rubyist,
          rating: 1,
          confirmer: confirmer3
      end

      specify do
        expect(user.as_json(skills: true)).to match(name: user.name,
                                                    uportAddress: user.uport_address,
                                                    avatarImageIpfsKey: user.avatar_image_ipfs_key,
                                                    bannerImageIpfsKey: user.banner_image_ipfs_key,
                                                    projects: [ruby_skill_claim_1.project.name,
                                                               ruby_skill_claim_2.project.name],
                                                    skills: [{ name: 'Ruby',
                                                               projectCount: 2,
                                                               confirmationsCount: 3,
                                                               ipfsReputonKeys: [/QmREPUTON[\w]+/,
                                                                                 /QmREPUTON[\w]+/],
                                                               confirmations: [] }])
      end
    end
  end

  describe '#search_trust_graph' do
    let!(:rubyist_3rd_degree) do
      create :user,
        name: 'Rubyist'
    end
    let!(:erlanger_2nd_degree) { create :user, name: 'Erlanger' }
    let!(:javascripter_3rd_degree) { create :user, name: 'Javascripter' }
    let!(:root_user) { create :user, name: 'Unskilled confirmer' }

    # Root User -> Javascripter -> Erlanger -> Rubyist

    let(:ruby_skill_claim) do
      create :skill_claim,
        name: 'Ruby',
        user: rubyist_3rd_degree
    end
    let(:erlang_skill_claim) do
      create :skill_claim,
        name: 'Erlang',
        user: erlanger_2nd_degree
    end
    let(:javascript_skill_claim) do
      create :skill_claim,
        name: 'Javascript',
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
        user: rubyist_confirming_erlanger
    end
    let(:erlang_skill_claim) do
      create :skill_claim,
        name: 'Erlang',
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
