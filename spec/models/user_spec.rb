require_relative '../rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  specify do
    expect(user.as_json.keys).to match_array(%i[
                                               name
                                               uportAddress
                                               skills
                                               avatar_image_ipfs_key
                                               banner_image_ipfs_key
                                             ])
  end
end
