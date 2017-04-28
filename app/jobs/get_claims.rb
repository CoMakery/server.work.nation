require 'sidekiq-scheduler'

class GetClaims
  include Sidekiq::Worker

  def perform
    Decentral::Claim.get_latest_claims
  end
end
