require 'sidekiq-scheduler'

class GetReputons
  include Sidekiq::Worker

  def perform
    Decentral::Reputon.get_latest_reputons
  end
end
