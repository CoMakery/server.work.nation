require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_session) { {} }

  describe 'GET #index' do
    let(:json) { JSON.parse(response.body) }
    let!(:user) { create :user }

    before { get :index, params: {}, session: valid_session }

    specify { expect(json.first['uportAddress']).to eq(user.uport_address) }

    specify { expect(json.first['name']).to eq(user.name) }
  end

  describe 'GET #show' do
    before do
      allow(UpdateProfile).to receive(:perform_async) # don't kick off the job
    end
    describe 'for user without skills' do
      let!(:user) { create :user }

      let(:json) { JSON.parse(response.body) }

      before { get :show, params: { uport_address: user.to_param }, session: valid_session }

      specify do
        expect(json).to eq(
          'uportAddress' => user.uport_address,
          'name' => user.name,
          'avatarImageIpfsKey' => 'QmAVATARaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad',
          'bannerImageIpfsKey' => 'QmBANNERaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad',
          'skillClaims' => [],
        )
      end
    end

    describe 'for user with skills' do
      let!(:user) { create :user, :joe, :with_skill_claims }
      let(:data) { JSON.parse(response.body) }

      before { get :show, params: { uport_address: user.to_param }, session: valid_session }

      specify do
        data['skillClaims'].map! { |claim| claim.without('createdAt') } # difficult to test with creation time
        expect(data).to eq(
          'name' => user.name,
          'avatarImageIpfsKey' => 'QmAVATARaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae',
          'bannerImageIpfsKey' => 'QmBANNERaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae',
          'uportAddress' => user.uport_address,
          'skillClaims' => [
            {
              'name' => 'Ruby on Rails',
              'confirmationsCount' => 3,
              'projectCount' => 5,
              'ipfsReputonKey' => 'QmREPUTONaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab',
              'confirmations' => [
                {
                  'confirmerUportAddress' => '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaf',
                  'confirmerName' => 'Joe #2',
                  'rating' => 1.0,
                  'ipfsReputonKey' => 'QmREPUTONaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaac',
                },
                {
                  'confirmerUportAddress' => '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0',
                  'confirmerName' => 'Joe #3',
                  'rating' => 1.0,
                  'ipfsReputonKey' => 'QmREPUTONaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad',
                },
                {
                  'confirmerUportAddress' => '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1',
                  'confirmerName' => 'Joe #4',
                  'rating' => 1.0,
                  'ipfsReputonKey' => 'QmREPUTONaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae',
                },
              ],
            },
            {
              'name' => 'Elixir',
              'confirmationsCount' => 0,
              'projectCount' => 0,
              'ipfsReputonKey' => 'QmREPUTONaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaf',
              'confirmations' => [],
            },
          ],
        )
      end
    end
  end
end
