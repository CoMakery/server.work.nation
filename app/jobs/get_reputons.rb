require 'sidekiq-scheduler'

class GetReputons
  include Sidekiq::Worker

  def perform
    Worknation::Reputon.get_latest_reputons
  end
end
