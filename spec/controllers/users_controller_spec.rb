require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    {uport_address: '0x123', name: 'Sofia Lee'}
  }
  # let!(:user) { User.create! valid_attributes }
  let!(:user) { create :user }

  let(:valid_session) { {} }

  describe "GET #index" do
    let(:json) { JSON.parse(response.body) }
    before { get :index, params: {}, session: valid_session }

    specify { expect(json.first["uport_address"]).to eq(valid_attributes[:uport_address]) }

    specify { expect(json.first["name"]).to eq(valid_attributes[:name]) }
  end

  describe "GET #show" do
    describe 'for user without skills' do
      let(:json) { JSON.parse(response.body) }
      before { get :show, params: {id: user.to_param}, session: valid_session }

      specify { expect(json).to eq({
                                       'uport_address' => '0x123',
                                       'name' => 'Sofia Lee',
                                       'skills' => []
                                   })
      }
    end

    xdescribe 'for user with skills' do
      let(:json) { JSON.parse(response.body) }
      before { get :show, params: {id: user.to_param}, session: valid_session }

      specify { expect(json).to eq({
                                       'uport_address' => '0x123',
                                       'name' => 'Sofia Lee',
                                       'skills' => [{'name' => 'Ruby on Rails',
                                                     'confirmations' => 3,
                                                     'projects' => 5,
                                                    },
                                                    {'name' => 'Elixer',
                                                     'confirmations' => 0,
                                                     'projects' => 0,
                                                    },
                                       ]
                                   })
      }
    end
  end
end
