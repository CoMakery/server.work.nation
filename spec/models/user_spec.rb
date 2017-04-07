require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  specify { expect(user.as_json.keys).to eq([:name, :uport_address, :skills]) }
end
