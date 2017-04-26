require 'sidekiq-scheduler'

class GetReputons
  include Sidekiq::Worker

  def perform
    Decentral::Claim.get_latest_claims
  end
end
