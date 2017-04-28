require_relative '../lib/decentral'

class UpdateProfile
  include Sidekiq::Worker

  def perform(uport_address)
    user = User.find_or_create_by!(uport_address: uport_address)
    user.update_from_uport_profile!
  end
end
